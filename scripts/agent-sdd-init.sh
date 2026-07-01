#!/usr/bin/env bash
#
# agent-sdd-init.sh — Bootstrap Agent SDD into a new or existing project.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/zljie/johnosn-sdd-script/main/scripts/agent-sdd-init.sh | bash -s -- --cursor --spec-kit
#   ./agent-sdd-init.sh                     # interactive
#   ./agent-sdd-init.sh --force             # non-interactive, overwrite without prompting
#   ./agent-sdd-init.sh --no-ci             # skip CI workflow prompt
#   ./agent-sdd-init.sh --spec-kit         # non-interactive, add SPEC-KIT integration
#   ./agent-sdd-init.sh --cursor          # non-interactive, also wire Cursor IDE
#   ./agent-sdd-init.sh --repo <git-url>  # override framework repo
#   ./agent-sdd-init.sh --dir agent-sdd     # override target directory
#
set -euo pipefail

# ----------------------------------------------------------------------------
# Defaults & flag parsing
# ----------------------------------------------------------------------------
REPO="https://github.com/zljie/johnosn-sdd-script.git"
FRAMEWORK_DIR="agent-sdd"
FORCE=false
ADD_CI=false
NO_CI=false
ADD_SPEC_KIT=false
ADD_CURSOR=false

usage() {
    sed -n '3,15p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force|-f)         FORCE=true; shift ;;
        --ci)               ADD_CI=true; shift ;;
        --no-ci)            NO_CI=true; shift ;;
        --spec-kit)         ADD_SPEC_KIT=true; shift ;;
        --cursor)           ADD_CURSOR=true; shift ;;
        --repo)             REPO="$2"; shift 2 ;;
        --dir)              FRAMEWORK_DIR="$2"; shift 2 ;;
        --help|-h)          usage 0 ;;
        *)                  echo "[WARN] Unknown flag: $1"; shift ;;
    esac
done

# Cross-platform sed in-place (-i differs between GNU and BSD/macOS)
sedi() {
    if sed --version >/dev/null 2>&1; then
        sed -i "$@"          # GNU
    else
        sed -i '' "$@"       # BSD/macOS
    fi
}

# Cross-platform "today" date (YYYY-MM-DD), no locale dependency
today() {
    date +%Y-%m-%d
}

TMP_DIR=$(mktemp -d)
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
prompt_yes_no() {
    # Returns 0 on yes, 1 on no. Honors FORCE (always yes).
    local question="$1"
    if [ "$FORCE" = true ]; then
        echo "[AUTO] ${question} -> yes (--force)"
        return 0
    fi
    # Pipe/redirect execution: no TTY means we cannot read input
    if [ ! -t 0 ]; then
        echo "[AUTO] ${question} -> yes (non-interactive, no TTY)"
        return 0
    fi
    printf "%s (y/n) " "$question"
    local ans
    read -r ans || ans=""
    [[ "$ans" =~ ^[Yy]$ ]]
}

note()  { printf "    %s\n" "$*"; }
ok()    { printf "[OK]   %s\n" "$*"; }
warn()  { printf "[WARN] %s\n" "$*" >&2; }
err()   { printf "[ERROR] %s\n" "$*" >&2; }

# ----------------------------------------------------------------------------
# 1. Environment check
# ----------------------------------------------------------------------------
echo "==> Agent SDD Initialization"
echo "    Repo:    $REPO"
echo "    Target:  $FRAMEWORK_DIR/  (in $(pwd))"
echo "    Checking environment..."

# Essential tools
for tool in git cp mkdir find; do
    command -v "$tool" >/dev/null 2>&1 || { err "'$tool' is required but not found."; exit 1; }
done

if [ ! -d .git ]; then
    warn "Not a git repository root."
    prompt_yes_no "Continue anyway?" || exit 1
fi

# ----------------------------------------------------------------------------
# 2. Fetch framework (shallow clone)
# ----------------------------------------------------------------------------
echo "==> Fetching Agent SDD framework..."
if ! git clone --depth 1 "$REPO" "$TMP_DIR/framework" 2>/dev/null; then
    err "Failed to clone framework. Check network or set --repo <url>."
    exit 1
fi

# Verify the clone actually contains the expected layout
SRC="$TMP_DIR/framework"
for required in AGENTS.MD INDEX.md loop agents workflows artifacts schemas templates; do
    if [ ! -e "$SRC/$required" ]; then
        err "Cloned repo is missing '$required'. Is --repo pointing at the right project?"
        exit 1
    fi
done
ok "Framework fetched and verified."

# ----------------------------------------------------------------------------
# 3. Analyze existing project
# ----------------------------------------------------------------------------
echo "==> Analyzing existing project..."

# Language / framework detection (first match wins)
detect_language() {
    [ -f package.json ]      && { echo "nodejs";  return; }
    [ -f requirements.txt ] || [ -f pyproject.toml ] || [ -f setup.py ] && { echo "python";  return; }
    [ -f go.mod ]            && { echo "go";      return; }
    [ -f pom.xml ] || [ -f build.gradle ] || [ -f build.gradle.kts ] && { echo "java";   return; }
    [ -f Cargo.toml ]        && { echo "rust";    return; }
    [ -f composer.json ]     && { echo "php";     return; }
    [ -f Gemfile ]           && { echo "ruby";    return; }
    [ -f *.csproj ] 2>/dev/null && { echo "dotnet";  return; }
    echo "generic"
}
LANG=$(detect_language)
note "Detected language/framework: $LANG"

# Scan for candidate docs (limit depth & count to keep output manageable)
SCANNED_DOCS=$(find . -maxdepth 3 -type f \
    \( -name "*.md" -o -name "*.rst" -o -name "*.txt" \) \
    ! -path "./.git/*" \
    ! -path "./node_modules/*" \
    ! -path "./$FRAMEWORK_DIR/*" \
    ! -path "./vendor/*" \
    2>/dev/null | head -40 || true)
DOC_COUNT=$(echo "$SCANNED_DOCS" | grep -c . 2>/dev/null || echo 0)
note "Found $DOC_COUNT candidate document(s) to map."

# ----------------------------------------------------------------------------
# 4. Deploy framework directory
# ----------------------------------------------------------------------------
echo "==> Deploying Agent SDD structure into $FRAMEWORK_DIR/ ..."

if [ -d "$FRAMEWORK_DIR" ]; then
    warn "$FRAMEWORK_DIR/ already exists."
    if prompt_yes_no "Backup existing and overwrite?"; then
        BACKUP="${FRAMEWORK_DIR}.backup.$(date +%s)"
        mv "$FRAMEWORK_DIR" "$BACKUP"
        ok "Existing copy backed up to $BACKUP"
    else
        echo "Aborted by user."
        exit 0
    fi
fi

mkdir -p "$FRAMEWORK_DIR"
# Core entry files
cp "$SRC/AGENTS.MD" "$FRAMEWORK_DIR/"
cp "$SRC/INDEX.md"  "$FRAMEWORK_DIR/"
# Structural directories
for subdir in loop agents workflows artifacts schemas templates; do
    cp -r "$SRC/$subdir" "$FRAMEWORK_DIR/$subdir"
done
ok "Framework files deployed."

# Project-level config
cat > "$FRAMEWORK_DIR/agent-sdd.yaml" <<YAML
# Agent SDD Project Configuration
# Generated by agent-sdd-init.sh on $(today)
version: "1.0"
project:
  name: $(basename "$(pwd)")
  type: ${LANG}
  language: ${LANG}
loop:
  start_stage: 01-requirement
  feedback_enabled: true
integrations:
  speckit: false      # set true if spec-kit is used
  ci_validation: ${NO_CI:-false}
YAML
ok "Project config written to $FRAMEWORK_DIR/agent-sdd.yaml"

# ----------------------------------------------------------------------------
# 5. Generate existing-docs → artifact mapping
# ----------------------------------------------------------------------------
echo "==> Generating documentation mapping..."

MAPPING_FILE="$FRAMEWORK_DIR/existing-artifacts-mapping.md"
{
    echo "# Existing Project Artifacts Mapping (Auto-generated)"
    echo
    echo "Generated: $(today)"
    echo "Project:   $(basename "$(pwd)")  ($LANG)"
    echo
    echo "## How to use this mapping"
    echo "Below are suggested mappings from your existing documents to Agent SDD artifacts."
    echo "Review and adjust, then wrap each document in the matching template under"
    echo "\`agent-sdd/templates/\` to produce a conforming artifact."
    echo
    echo "## Scanned Documents"
} > "$MAPPING_FILE"

# Heuristic mapping (artifact family by filename keyword)
map_doc() {
    local d="$1"
    local low
    low=$(printf "%s" "$d" | tr '[:upper:]' '[:lower:]')
    if [[ "$low" == *"prd"* || "$low" == *"requirement"* || "$low" == *"需求"* ]]; then
        echo "REQ (Requirement) — templates/requirement.md"
    elif [[ "$low" == *"user-story"* || "$low" == *"product"* || "$low" == *"spec"* ]]; then
        echo "PS (Product Specification) — templates/product-specification.md"
    elif [[ "$low" == *"tech"* || "$low" == *"design"* || "$low" == *"architecture"* || "$low" == *"adr"* ]]; then
        echo "TS/AD (Technical Specification / Architecture Design) — templates/technical-specification.md, architecture-design.md"
    elif [[ "$low" == *"api"* ]]; then
        echo "API — templates/api.md"
    elif [[ "$low" == *"data-model"* || "$low" == *"schema"* || "$low" == *"ddl"* ]]; then
        echo "MODEL (Data Model) — templates/data-model.md"
    elif [[ "$low" == *"test"* || "$low" == *"qa"* || "$low" == *"spec"* ]]; then
        echo "TC/TR/QEP (Test Case / Report / Quality Evidence) — templates/test-case.md, test-report.md, quality-evidence-package.md"
    elif [[ "$low" == *"release"* || "$low" == *"changelog"* || "$low" == *"deploy"* ]]; then
        echo "DRR/SDP (Delivery Review / Software Delivery Package) — templates/delivery-review-report.md, software-delivery-package.md"
    else
        echo "(unknown) — review manually"
    fi
}

if [ -n "$SCANNED_DOCS" ]; then
    while IFS= read -r doc; do
        [ -z "$doc" ] && continue
        target=$(map_doc "$doc")
        echo "- **${doc}** → ${target}" >> "$MAPPING_FILE"
    done <<< "$SCANNED_DOCS"
else
    echo "- (no candidate documents found)" >> "$MAPPING_FILE"
fi

{
    echo
    echo "> Next: After reviewing, wrap these documents in the Agent SDD artifact"
    echo "> format using templates in \`agent-sdd/templates/\`."
} >> "$MAPPING_FILE"
ok "Mapping written to $MAPPING_FILE ($DOC_COUNT document(s))"

# ----------------------------------------------------------------------------
# 6. Optional CI/CD integration
# ----------------------------------------------------------------------------
CI_FILE=".github/workflows/agent-sdd-validate.yml"
if [ "$NO_CI" = false ] && [ "$ADD_CI" = false ]; then
    echo "==> Optional: CI validation with GitHub Actions"
    if prompt_yes_no "Add a validation workflow to check artifacts on push?"; then
        ADD_CI=true
    fi
fi

# ----------------------------------------------------------------------------
# 6b. Optional SPEC-KIT integration
# ----------------------------------------------------------------------------
if [ "$ADD_SPEC_KIT" = false ] && [ "$NO_CI" = false ]; then
    echo "==> Optional: SPEC-KIT integration"
    if prompt_yes_no "Install SPEC-KIT and run 'specify init . --integration agent-sdd'?"; then
        ADD_SPEC_KIT=true
    fi
fi

if [ "$ADD_CI" = true ]; then
    mkdir -p "$(dirname "$CI_FILE")"
    # Note: 'EOF' (quoted) disables variable expansion so $refs stay literal
    cat > "$CI_FILE" <<'EOF'
name: Agent SDD Artifact Validation
on:
  push:
    paths:
      - 'agent-sdd/artifacts/**'
      - 'agent-sdd/schemas/**'
  pull_request:
    paths:
      - 'agent-sdd/artifacts/**'
      - 'agent-sdd/schemas/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.x'

      - name: Install JSON Schema validator
        run: pip install jsonschema pyyaml

      - name: Validate Agent SDD artifacts
        run: |
          set -e
          python3 - <<'PY'
          import glob, json, re, sys
          import yaml
          from jsonschema import Draft202012Validator, ValidationError

          errors = 0
          schema_files = glob.glob('agent-sdd/schemas/*.yaml')
          schemas = {}
          for sf in schema_files:
              with open(sf) as f:
                  s = yaml.safe_load(f)
              schemas[s.get('title', sf)] = (sf, s)

          artifact_files = glob.glob('agent-sdd/artifacts/*.md')
          if not artifact_files:
              print('ℹ️  No artifacts to validate yet.')
              sys.exit(0)

          frontmatter_re = re.compile(r'^---\n(.*?)\n---', re.DOTALL)
          for af in artifact_files:
              with open(af) as f:
                  content = f.read()
              m = frontmatter_re.search(content)
              if not m:
                  print(f'⚠️  {af}: no YAML frontmatter, skipping')
                  continue
              meta = yaml.safe_load(m.group(1))
              schema_title = meta.get('schema') or meta.get('artifactType')
              print(f'✓ {af}: schema hint = {schema_title}')
          print('Validation complete.')
          PY
EOF
    ok "Workflow created at $CI_FILE"
    sedi "s/ci_validation: .*/ci_validation: true/" "$FRAMEWORK_DIR/agent-sdd.yaml"
fi

# ----------------------------------------------------------------------------
# 7. Optional SPEC-KIT installation
# ----------------------------------------------------------------------------
if [ "$ADD_SPEC_KIT" = true ]; then
    echo "==> Installing SPEC-KIT..."
    if ! command -v uv >/dev/null 2>&1; then
        warn "'uv' is not installed. Skipping SPEC-KIT."
        warn "Install uv first: https://github.com/astral-sh/uv"
    else
        if uv tool install specify-cli --from git+https://github.com/github/spec-kit.git 2>/dev/null; then
            ok "specify-cli installed."
        else
            warn "Failed to install specify-cli via uv."
            warn "Try manually: uv tool install specify-cli --from git+https://github.com/github/spec-kit.git"
        fi
        if command -v specify >/dev/null 2>&1; then
            if specify init . --integration agent-sdd 2>/dev/null; then
                ok "SPEC-KIT initialized with agent-sdd integration."
            else
                warn "SPEC-KIT init may have failed. Run 'specify init . --integration agent-sdd' manually."
            fi
        else
            warn "'specify' command not found after install. Is the uv toolchain on your PATH?"
        fi
    fi
    sedi "s/speckit: .*/speckit: true/" "$FRAMEWORK_DIR/agent-sdd.yaml"
fi

# ----------------------------------------------------------------------------
# 8. Optional Cursor IDE integration
# ----------------------------------------------------------------------------
CURSOR_SCRIPT="./scripts/agent-sdd-cursor-init.sh"
if [ "$ADD_CURSOR" = false ] && [ "$NO_CI" = false ]; then
    echo "==> Optional: Cursor IDE integration"
    if prompt_yes_no "Wire Agent SDD rules into the Cursor IDE (.cursor/rules/)?"; then
        ADD_CURSOR=true
    fi
fi

if [ "$ADD_CURSOR" = true ]; then
    if [ -f "$CURSOR_SCRIPT" ]; then
        echo "==> Running Cursor IDE integration..."
        CURSOR_FLAGS="--dir $FRAMEWORK_DIR"
        if [ "$ADD_SPEC_KIT" = true ]; then
            CURSOR_FLAGS="$CURSOR_FLAGS --spec-kit"
        fi
        # shellcheck disable=SC2086
        if bash "$CURSOR_SCRIPT" $CURSOR_FLAGS; then
            ok "Cursor IDE integration complete."
        else
            warn "Cursor IDE integration failed. Run '$CURSOR_SCRIPT' manually."
        fi
    else
        warn "Cursor script not found at '$CURSOR_SCRIPT'."
        warn "To install Cursor rules via curl, run:"
        warn "  curl -sSL https://raw.githubusercontent.com/zljie/johnosn-sdd-script/main/scripts/agent-sdd-cursor-init.sh | bash -s -- --dir $FRAMEWORK_DIR${ADD_SPEC_KIT:+" --spec-kit"}"
    fi
fi

# ----------------------------------------------------------------------------
# 9. .gitignore hint for backups
# ----------------------------------------------------------------------------
if [ -f .gitignore ]; then
    if ! grep -q "${FRAMEWORK_DIR}.backup" .gitignore; then
        printf "\n# Agent SDD init backups\n%s.backup.*\n" "$FRAMEWORK_DIR" >> .gitignore
        ok "Added backup pattern to .gitignore"
    fi
else
    printf "# Agent SDD init backups\n%s.backup.*\n" "$FRAMEWORK_DIR" > .gitignore
    ok "Created .gitignore with backup pattern"
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
echo
echo "=============================================="
echo " ✅ Agent SDD framework initialized!"
echo "=============================================="
echo
echo "Next steps:"
echo "  1. Explore the manifest:        $FRAMEWORK_DIR/INDEX.md"
echo "  2. Review existing doc mapping: $FRAMEWORK_DIR/existing-artifacts-mapping.md"
echo "  3. Edit project config:         $FRAMEWORK_DIR/agent-sdd.yaml"
echo "  4. Start the first loop:        $FRAMEWORK_DIR/loop/01-requirement.md"
echo
echo "Optional integrations:"
if [ "$ADD_SPEC_KIT" = false ]; then
    echo "  • spec-kit:   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git"
    echo "                 specify init . --integration agent-sdd"
fi
if [ "$ADD_CURSOR" = false ]; then
    echo "  • cursor-ide: ./scripts/agent-sdd-cursor-init.sh --dir $FRAMEWORK_DIR"
fi
echo "  • validate:   pip install jsonschema pyyaml && see $CI_FILE"
echo
echo "Happy delivering! 🚀"
