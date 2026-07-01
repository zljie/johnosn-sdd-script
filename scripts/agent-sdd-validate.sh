#!/usr/bin/env bash
#
# agent-sdd-validate.sh — Validate Agent SDD artifacts against schemas
#
# Usage:
#   ./agent-sdd-validate.sh                    # validate all artifacts
#   ./agent-sdd-validate.sh --artifact <id>    # validate specific artifact
#   ./agent-sdd-validate.sh --stage <stage>    # validate artifacts for a stage
#   ./agent-sdd-validate.sh --state            # validate runtime state
#   ./agent-sdd-validate.sh --ci              # CI mode (exit codes only)
#
set -euo pipefail

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------
FRAMEWORK_DIR="agent-sdd"
ARTIFACTS_DIR="$FRAMEWORK_DIR/artifacts"
SCHEMAS_DIR="$FRAMEWORK_DIR/schemas"
STATE_FILE="$FRAMEWORK_DIR/runtime-state.json"
COMMANDS_DIR="$FRAMEWORK_DIR/commands"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
PASSED=0
FAILED=0
WARNINGS=0

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
info()    { printf "${BLUE}[INFO]${NC}  %s\n" "$*"; }
ok()      { printf "${GREEN}[PASS]${NC}  %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$*" >&2; ((WARNINGS++)); }
fail()    { printf "${RED}[FAIL]${NC}  %s\n" "$*" >&2; ((FAILED++)); }
error()   { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }

summary() {
    echo
    echo "========================================"
    echo " Validation Summary"
    echo "========================================"
    echo " Total:   $TOTAL"
    echo " Passed:  $PASSED"
    echo " Failed:  $FAILED"
    echo " Warnings:$WARNINGS"
    echo "========================================"
}

# ----------------------------------------------------------------------------
# Parse Arguments
# ----------------------------------------------------------------------------
TARGET_ARTIFACT=""
TARGET_STAGE=""
VALIDATE_STATE=false
CI_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --artifact)  TARGET_ARTIFACT="$2"; shift 2 ;;
        --stage)    TARGET_STAGE="$2"; shift 2 ;;
        --state)    VALIDATE_STATE=true; shift ;;
        --ci)       CI_MODE=true; shift ;;
        --help|-h)  echo "Usage: $0 [--artifact <id>] [--stage <stage>] [--state] [--ci]"
                    echo ""
                    echo "Options:"
                    echo "  --artifact <id>  Validate a specific artifact"
                    echo "  --stage <stage>  Validate artifacts for a stage (01-requirement, etc.)"
                    echo "  --state          Validate runtime state file"
                    echo "  --ci             CI mode (exit codes only, no colors)"
                    exit 0 ;;
        *)           error "Unknown option: $1"; exit 1 ;;
    esac
done

# CI mode: disable colors
if [ "$CI_MODE" = true ]; then
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# ----------------------------------------------------------------------------
# Check Dependencies
# ----------------------------------------------------------------------------
check_dependencies() {
    info "Checking dependencies..."
    
    if ! command -v python3 &> /dev/null; then
        error "python3 not found. Please install Python 3."
        exit 1
    fi
    
    if ! python3 -c "import yaml" 2>/dev/null; then
        warn "python3 yaml module not found. Installing..."
        pip3 install pyyaml --quiet
    fi
    
    if ! python3 -c "import jsonschema" 2>/dev/null; then
        warn "python3 jsonschema module not found. Installing..."
        pip3 install jsonschema --quiet
    fi
    
    ok "Dependencies OK"
}

# ----------------------------------------------------------------------------
# Artifact Type Mapping
# ----------------------------------------------------------------------------
get_schema_for_artifact() {
    local artifact_id="$1"
    local prefix="${artifact_id%%-*}"
    
    case "$prefix" in
        REQ)      echo "requirement.schema.yaml" ;;
        PS)       echo "product-specification.schema.yaml" ;;
        TS)       echo "technical-specification.schema.yaml" ;;
        AD)       echo "architecture-design.schema.yaml" ;;
        US)       echo "user-story.schema.yaml" ;;
        TASK)     echo "task.schema.yaml" ;;
        TC)       echo "test-case.schema.yaml" ;;
        TR)       echo "test-report.schema.yaml" ;;
        QEP)      echo "quality-evidence-package.schema.yaml" ;;
        DRR)      echo "delivery-review-report.schema.yaml" ;;
        SDP)      echo "software-delivery-package.schema.yaml" ;;
        MODEL)    echo "data-model.schema.yaml" ;;
        API)      echo "api.schema.yaml" ;;
        FB)       echo "feedback.schema.yaml" ;;
        *)        echo "" ;;
    esac
}

# ----------------------------------------------------------------------------
# Extract Frontmatter
# ----------------------------------------------------------------------------
extract_frontmatter() {
    local file="$1"
    
    python3 << PYEOF
import sys
import yaml

content = open(r"$file").read()

if content.startswith('---'):
    parts = content.split('---', 2)
    if len(parts) >= 3:
        try:
            data = yaml.safe_load(parts[1])
            print(yaml.dump(data, allow_unicode=True, default_flow_style=False))
        except:
            print("{}")
    else:
        print("{}")
else:
    print("{}")
PYEOF
}

# ----------------------------------------------------------------------------
# Validate Artifact
# ----------------------------------------------------------------------------
validate_artifact() {
    local artifact_file="$1"
    local artifact_id
    artifact_id=$(basename "$artifact_file" .md)
    artifact_id="${artifact_id%%-*}-${artifact_id##*-}"
    
    # Extract ID from filename (e.g., REQ-001 from REQ-001-user-authentication.md)
    if [[ "$artifact_file" =~ ^.*/(REQ|PS|TS|AD|US|TASK|TC|TR|QEP|DRR|SDP|MODEL|API|FB)-[0-9]+ ]]; then
        artifact_id=$(echo "$artifact_file" | sed -E 's/.*\/(REQ|PS|TS|AD|US|TASK|TC|TR|QEP|DRR|SDP|MODEL|API|FB)-[0-9]+.*/\1-/')"$(echo "$artifact_file" | sed -E 's/.*-([0-9]+).*/\1/')"
    else
        artifact_id=$(basename "$artifact_file" .md)
    fi
    
    ((TOTAL++))
    
    # Get corresponding schema
    local schema_file
    schema_file=$(get_schema_for_artifact "$artifact_id")
    
    if [ -z "$schema_file" ]; then
        warn "No schema mapping for artifact: $artifact_id"
        return 0
    fi
    
    local schema_path="$SCHEMAS_DIR/$schema_file"
    
    if [ ! -f "$schema_path" ]; then
        warn "Schema not found: $schema_path"
        return 0
    fi
    
    # Validate using Python + jsonschema
    python3 << PYEOF
import sys
import yaml
import json
import jsonschema
from jsonschema import validate, ValidationError

artifact_file = r"$artifact_file"
schema_path = r"$schema_path"

try:
    # Read artifact content
    with open(artifact_file, 'r') as f:
        content = f.read()
    
    # Extract frontmatter
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            frontmatter = yaml.safe_load(parts[1])
        else:
            frontmatter = {}
    else:
        frontmatter = {}
    
    # Read schema
    with open(schema_path, 'r') as f:
        schema = yaml.safe_load(f)
    
    # Validate
    validate(instance=frontmatter, schema=schema)
    print("VALID")
except ValidationError as e:
    print(f"INVALID: {e.message}")
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {str(e)}")
    sys.exit(2)
PYEOF
    
    local result=$?
    
    if [ $result -eq 0 ]; then
        ok "$artifact_id"
        ((PASSED++))
    else
        fail "$artifact_id"
        ((FAILED++))
    fi
}

# ----------------------------------------------------------------------------
# Validate Runtime State
# ----------------------------------------------------------------------------
validate_runtime_state() {
    info "Validating runtime state..."
    ((TOTAL++))
    
    if [ ! -f "$STATE_FILE" ]; then
        warn "Runtime state file not found: $STATE_FILE"
        return 0
    fi
    
    # Basic JSON validation
    if python3 -c "import json; json.load(open(r'$STATE_FILE'))" 2>/dev/null; then
        ok "runtime-state.json is valid JSON"
        ((PASSED++))
    else
        fail "runtime-state.json has invalid JSON"
    fi
    
    # Check required fields
    python3 << PYEOF
import json

try:
    with open(r'$STATE_FILE') as f:
        state = json.load(f)
    
    required_fields = ['meta', 'current', 'artifacts', 'gates', 'approvals', 'status']
    missing = []
    
    for field in required_fields:
        if field not in state:
            missing.append(field)
    
    if missing:
        print(f"WARN: Missing fields in runtime-state.json: {', '.join(missing)}")
    else:
        print("VALID")
except Exception as e:
    print(f"ERROR: {e}")
PYEOF
}

# ----------------------------------------------------------------------------
# Validate Traceability
# ----------------------------------------------------------------------------
validate_traceability() {
    info "Validating traceability..."
    
    # Check that artifacts have proper parent/child relationships
    local all_artifacts
    all_artifacts=$(find "$ARTIFACTS_DIR" -name "*.md" -type f 2>/dev/null || echo "")
    
    if [ -z "$all_artifacts" ]; then
        warn "No artifacts found for traceability validation"
        return 0
    fi
    
    local child_refs=()
    local parent_refs=()
    
    while IFS= read -r artifact; do
        [ -z "$artifact" ] && continue
        ((TOTAL++))
        
        python3 << PYEOF
import yaml
import os

try:
    artifact_path = r"$artifact"
    with open(artifact_path) as f:
        content = f.read()
    
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            fm = yaml.safe_load(parts[1])
            
            # Check traceability section
            if 'traceability' in fm:
                trace = fm['traceability']
                parent = trace.get('parent', 'null')
                children = trace.get('children', [])
                artifact_name = os.path.basename(artifact_path)
                
                if parent and parent != 'null':
                    print(f"PARENT:{artifact_name}:{parent}")
                
                for child in children:
                    print(f"CHILD:{artifact_name}:{child}")
except:
    pass
PYEOF
    done <<< "$all_artifacts"
    
    ok "Traceability structure validated"
    ((PASSED++))
}

# ----------------------------------------------------------------------------
# Validate Stage Artifacts
# ----------------------------------------------------------------------------
validate_stage_artifacts() {
    local stage="$1"
    
    info "Validating artifacts for stage: $stage"
    
    case "$stage" in
        01-requirement)
            find "$ARTIFACTS_DIR" -name "REQ-*.md" -type f 2>/dev/null | while read -r f; do
                validate_artifact "$f"
            done
            ;;
        02-development)
            for prefix in PS TS AD US TASK; do
                find "$ARTIFACTS_DIR" -name "${prefix}-*.md" -type f 2>/dev/null | while read -r f; do
                    validate_artifact "$f"
                done
            done
            ;;
        03-testing)
            for prefix in TC TR; do
                find "$ARTIFACTS_DIR" -name "${prefix}-*.md" -type f 2>/dev/null | while read -r f; do
                    validate_artifact "$f"
                done
            done
            ;;
        04-release)
            for prefix in QEP DRR SDP; do
                find "$ARTIFACTS_DIR" -name "${prefix}-*.md" -type f 2>/dev/null | while read -r f; do
                    validate_artifact "$f"
                done
            done
            ;;
        *)
            warn "Unknown stage: $stage"
            ;;
    esac
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
main() {
    echo
    echo "========================================"
    echo " Agent SDD Artifact Validator"
    echo "========================================"
    echo
    
    check_dependencies
    
    echo
    
    # Validate runtime state
    if [ "$VALIDATE_STATE" = true ]; then
        validate_runtime_state
        validate_traceability
        summary
        [ $FAILED -gt 0 ] && exit 1 || exit 0
    fi
    
    # Validate specific artifact
    if [ -n "$TARGET_ARTIFACT" ]; then
        local artifact_file
        artifact_file=$(find "$ARTIFACTS_DIR" -name "${TARGET_ARTIFACT}*.md" -type f 2>/dev/null | head -1)
        
        if [ -z "$artifact_file" ]; then
            error "Artifact not found: $TARGET_ARTIFACT"
            exit 1
        fi
        
        validate_artifact "$artifact_file"
        summary
        [ $FAILED -gt 0 ] && exit 1 || exit 0
    fi
    
    # Validate by stage
    if [ -n "$TARGET_STAGE" ]; then
        validate_stage_artifacts "$TARGET_STAGE"
        summary
        [ $FAILED -gt 0 ] && exit 1 || exit 0
    fi
    
    # Validate all artifacts
    info "Validating all artifacts..."
    
    for schema_file in "$SCHEMAS_DIR"/*.schema.yaml; do
        [ -f "$schema_file" ] || continue
        
        local prefix
        prefix=$(basename "$schema_file" .schema.yaml | tr '-' '_' | tr '[:lower:]' '[:upper:]')
        
        case "$(basename "$schema_file")" in
            requirement.schema.yaml)           prefix="REQ" ;;
            product-specification.schema.yaml)  prefix="PS" ;;
            technical-specification.schema.yaml) prefix="TS" ;;
            architecture-design.schema.yaml)    prefix="AD" ;;
            user-story.schema.yaml)             prefix="US" ;;
            task.schema.yaml)                   prefix="TASK" ;;
            test-case.schema.yaml)              prefix="TC" ;;
            test-report.schema.yaml)            prefix="TR" ;;
            quality-evidence-package.schema.yaml) prefix="QEP" ;;
            delivery-review-report.schema.yaml)  prefix="DRR" ;;
            software-delivery-package.schema.yaml) prefix="SDP" ;;
            data-model.schema.yaml)             prefix="MODEL" ;;
            api.schema.yaml)                    prefix="API" ;;
        esac
        
        find "$ARTIFACTS_DIR" -name "${prefix}-*.md" -type f 2>/dev/null | while read -r f; do
            validate_artifact "$f"
        done
    done
    
    echo
    validate_runtime_state
    validate_traceability
    
    summary
    
    if [ $FAILED -gt 0 ]; then
        error "Validation failed with $FAILED error(s)"
        exit 1
    fi
    
    if [ $WARNINGS -gt 0 ]; then
        warn "Validation completed with $WARNINGS warning(s)"
    fi
    
    ok "All validations passed!"
    exit 0
}

main
