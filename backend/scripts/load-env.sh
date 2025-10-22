#!/bin/bash

# Load environment variables from .dev.vars
# This script can be sourced by other scripts to get environment variables

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Path to .dev.vars file
DEV_VARS_FILE="$PROJECT_ROOT/.dev.vars"

# Function to load environment variables from .dev.vars
load_dev_vars() {
    if [ -f "$DEV_VARS_FILE" ]; then
        echo "📁 Loading environment variables from .dev.vars..."
        
        # Export variables from .dev.vars (skip comments and empty lines)
        while IFS= read -r line; do
            # Skip comments and empty lines
            if [[ ! "$line" =~ ^[[:space:]]*# ]] && [[ -n "$line" ]]; then
                # Export the variable
                export "$line"
            fi
        done < "$DEV_VARS_FILE"
        
        echo "✅ Environment variables loaded"
        return 0
    else
        echo "❌ .dev.vars file not found at: $DEV_VARS_FILE"
        echo ""
        echo "Please run setup-env.sh first to create .dev.vars"
        return 1
    fi
}

# Function to check if required variables are set
check_required_vars() {
    local missing_vars=()
    
    if [ -z "$SUPABASE_URL" ]; then
        missing_vars+=("SUPABASE_URL")
    fi
    
    if [ -z "$SUPABASE_ANON_KEY" ]; then
        missing_vars+=("SUPABASE_ANON_KEY")
    fi
    
    if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
        missing_vars+=("SUPABASE_SERVICE_ROLE_KEY")
    fi
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo "❌ Missing required environment variables:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        echo ""
        echo "Please run setup-env.sh to create .dev.vars with proper values"
        return 1
    fi
    
    return 0
}

# Function to display current environment (for debugging)
show_env() {
    echo "🔧 Current Environment:"
    echo "  SUPABASE_URL: ${SUPABASE_URL:0:50}..."
    echo "  SUPABASE_ANON_KEY: ${SUPABASE_ANON_KEY:0:20}..."
    echo "  SUPABASE_SERVICE_ROLE_KEY: ${SUPABASE_SERVICE_ROLE_KEY:0:20}..."
    echo "  ENVIRONMENT: $ENVIRONMENT"
}

# Auto-load if this script is sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    load_dev_vars
fi