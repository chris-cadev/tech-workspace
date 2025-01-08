#!/bin/sh

###############################################################################
# check_remote_merge.sh
#
# Usage:
#   check_remote_merge.sh <branch_to_be_merged> [OPTIONS]
#
# Required:
#   <branch_to_be_merged>                 The branch to check if merged.
#
# Options (with aliases):
#   -t, --target <target_branch>          Target branch to check (default: 'release').
#   -m, --message <extra_message>         Optional message or link in the alert.
#   -r, --remote <remote>                 Remote name (default: 'origin').
#   -s, --sleep <sleep_time>              Seconds between checks (default: 30).
#   -d, --dir <repo_directory>            Path to the Git repo (default: '.').
#   -h, --help                            Show usage/help.
#
# Description:
#   Continuously checks (every 'sleep_time' seconds) whether 'branch_to_be_merged'
#   is merged into 'target_branch' on 'remote' within a specified repository
#   directory. Once merged, displays a macOS alert and exits.
###############################################################################

show_usage() {
    echo ""
    echo "Usage: $0 <branch_to_be_merged> [OPTIONS]"
    echo ""
    echo "Required:"
    echo "  <branch_to_be_merged>                 The branch to check if merged."
    echo ""
    echo "Options (with aliases):"
    echo "  -t, --target <target_branch>          Target branch to check (default: 'release')."
    echo "  -m, --message <extra_message>         Optional message or link in the alert."
    echo "  -r, --remote <remote>                 Remote name (default: 'origin')."
    echo "  -s, --sleep <sleep_time>              Seconds between checks (default: 30)."
    echo "  -d, --dir <repo_directory>            Path to the Git repo (default: '.')."
    echo "  -h, --help                            Show usage."
    echo ""
    exit 1
}

###############################################################################
# Default values for optional flags
###############################################################################
branch_to_be_merged=""
target_branch="release"
extra_message=""
remote="origin"
sleep_time="300"
repo_directory="."

###############################################################################
# Check for at least one argument (the branch_to_be_merged or --help)
###############################################################################
if [ $# -lt 1 ]; then
    show_usage
fi

###############################################################################
# Parse arguments manually (POSIX-friendly; no built-in long opts in POSIX getopts)
###############################################################################
while [ $# -gt 0 ]; do
    case "$1" in
        # Short or long option for target branch
        -t|--target)
            shift
            target_branch="$1"
            ;;

        # Short or long option for extra message
        -m|--message)
            shift
            extra_message="$1"
            ;;

        # Short or long option for remote
        -r|--remote)
            shift
            remote="$1"
            ;;

        # Short or long option for sleep time
        -s|--sleep)
            shift
            sleep_time="$1"
            ;;

        # Short or long option for repo directory
        -d|--dir)
            shift
            repo_directory="$1"
            ;;

        # Help
        -h|--help)
            show_usage
            ;;

        # If it's not one of the recognized flags, it should be the required branch
        *)
            if [ -z "$branch_to_be_merged" ]; then
                branch_to_be_merged="$1"
            else
                # If branch_to_be_merged is already set, any other unknown argument is invalid
                echo "Error: Unrecognized argument '$1'"
                show_usage
            fi
            ;;
    esac
    shift
done

###############################################################################
# Validate the required parameter
###############################################################################
if [ -z "$branch_to_be_merged" ]; then
    echo "Error: Missing required <branch_to_be_merged>."
    show_usage
fi

###############################################################################
# Validate repository directory
###############################################################################
if [ ! -d "$repo_directory" ]; then
    echo "Error: Repository directory '$repo_directory' does not exist."
    exit 1
fi

if ! git -C "$repo_directory" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: '$repo_directory' is not a valid Git repository."
    exit 1
fi

###############################################################################
# Fetch latest changes from the specified remote to ensure up-to-date info
###############################################################################
git -C "$repo_directory" fetch --quiet "$remote"

###############################################################################
# Check if both the branch to be merged and the target branch exist on the remote
###############################################################################
if ! git -C "$repo_directory" ls-remote --heads "$remote" "$branch_to_be_merged" >/dev/null; then
    echo "Error: Branch '$branch_to_be_merged' does not exist on remote '$remote'."
    exit 1
fi

if ! git -C "$repo_directory" ls-remote --heads "$remote" "$target_branch" >/dev/null; then
    echo "Error: Target branch '$target_branch' does not exist on remote '$remote'."
    exit 1
fi

###############################################################################
# Helper function: check if the branch is merged
###############################################################################
is_merged() {
    # Re-fetch to keep local info updated
    git -C "$repo_directory" fetch --quiet "$remote"

    # If the commit hash of branch_to_be_merged is found in target_branch's log, it's merged
    if git -C "$repo_directory" log "$remote/$target_branch" --oneline \
       | grep -q "^$(git -C "$repo_directory" rev-parse "$remote/$branch_to_be_merged")\$"; then
        return 0  # merged
    else
        return 1  # not merged
    fi
}

###############################################################################
# Main loop: check if merged; if not, wait and retry
###############################################################################
echo "Checking if '$branch_to_be_merged' is merged into '$target_branch' on remote '$remote' in repo '$repo_directory'..."
while true; do
    if is_merged; then
        # Once merged, display alert and exit
        osascript -e "display alert \"Branch Already Merged\" \
message \"The branch '$branch_to_be_merged' is now merged into '$target_branch' on remote '$remote'. $extra_message\" \
as critical buttons {\"OK\"} default button \"OK\""
        exit 0
    else
        echo "Not merged yet. Checking again in $sleep_time seconds..."
        sleep "$sleep_time"
    fi
done
