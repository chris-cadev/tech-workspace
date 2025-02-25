#!/bin/bash

LOG_FILE="$(mktemp /tmp/bob_install.XXXXXX.log)"
ERROR_OCCURRED=0

log() {
    local level="$1"
    shift
    local message="$*"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_FILE"
    
    # Print only INFO messages to the console
    if [[ "$level" == "INFO" ]]; then
        echo "[INFO] $message"
    fi
}

log "INFO" "Starting installation and setup script."

# --- Install Bob ---
log "INFO" "Checking if 'bob' command is installed..."
if ! command -v bob &>/dev/null; then
    log "WARNING" "'bob' not found. Installing from GitHub..."
    if cargo install --git https://github.com/MordechaiHadad/bob.git >>"$LOG_FILE" 2>&1; then
        log "INFO" "'bob' successfully installed."
    else
        log "ERROR" "Failed to install 'bob'."
        ERROR_OCCURRED=1
    fi
else
    log "INFO" "'bob' is already installed."
fi

# --- ZSH Completion ---
log "INFO" "Ensuring zsh completion directory exists..."
mkdir -p $HOME/.zfunc/completions || { log "ERROR" "Failed to create zsh completion directory."; ERROR_OCCURRED=1; }

log "INFO" "Checking if zsh completion for 'bob' is already installed..."
if ! grep -q "bob complete zsh" $HOME/.zfunc/_bob 2>/dev/null; then
    log "INFO" "Adding zsh completion for 'bob'..."
    if bob complete zsh > $HOME/.zfunc/_bob; then
        log "INFO" "zsh completion added."
    else
        log "ERROR" "Failed to add zsh completion."
        ERROR_OCCURRED=1
    fi
else
    log "INFO" "Zsh completion for 'bob' is already set up."
fi

# --- Zsh Completion ---
log "INFO" "Ensuring zsh completion directory exists..."
mkdir -p ~/.zfunc || { log "ERROR" "Failed to create zsh completion directory."; ERROR_OCCURRED=1; }

log "INFO" "Checking if zsh completion for 'bob' is up to date..."
if ! diff <(bob complete zsh) ~/.zfunc/_bob &>/dev/null; then
    log "INFO" "Updating zsh completion for 'bob'..."
    if bob complete zsh > ~/.zfunc/_bob; then
        log "INFO" "Zsh completion updated."
    else
        log "ERROR" "Failed to update zsh completion."
        ERROR_OCCURRED=1
    fi
else
    log "INFO" "Zsh completion for 'bob' is already up to date."
fi

# --- Install Latest Neovim Using Bob ---
log "INFO" "Checking if Neovim is installed..."
if command -v nvim &>/dev/null; then
    INSTALLED_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')
    log "INFO" "Installed Neovim version: $INSTALLED_VERSION"
else
    INSTALLED_VERSION="none"
    log "WARNING" "Neovim is not installed."
fi
AVAILABLE_VERSIONS=$(bob list-remote | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
if [[ -z "$AVAILABLE_VERSIONS" ]]; then
    log "ERROR" "No available Neovim versions found from Bob."
    ERROR_OCCURRED=1
else
    log "INFO" "Available Neovim versions: $(echo $AVAILABLE_VERSIONS | xargs)"
    
    # Loop through the versions (latest first)
    for VERSION in $(echo $AVAILABLE_VERSIONS); do
        log "INFO" "Attempting to install Neovim version $VERSION..."
        
        if bob install "$VERSION" >>"$LOG_FILE" 2>&1; then
            bob use "$VERSION" >>"$LOG_FILE" 2>&1
            log "INFO" "Neovim version $VERSION successfully installed and set as default."
            break
        else
            # Check for specific error message indicating version not found
            if grep -q "Error: Please provide an existing neovim version, Not Found" "$LOG_FILE"; then
                log "WARNING" "Version $VERSION not found. Trying the next version..."
            else
                log "ERROR" "An unexpected error occurred while trying to install Neovim version $VERSION."
                ERROR_OCCURRED=1
                break
            fi
        fi
    done
fi

log "INFO" "Script execution completed."

# If an error occurred, print the log file
if [[ "$ERROR_OCCURRED" -ne 0 ]]; then
    echo "[ERROR] An error occurred during the script execution. See details below:"
    cat "$LOG_FILE"
    exit 1
else
    rm -f "$LOG_FILE"  # Cleanup log file if no errors
fi
