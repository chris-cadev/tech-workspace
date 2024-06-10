#!/bin/bash -e

# Check if at least 2 arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <STATUS_EMOJI> <STATUS_MESSAGE> [STATUS_EXPIRATION_SECONDS]"
    echo "  STATUS_EMOJI: Emoji representing the status (e.g., :smile:)"
    echo "  STATUS_MESSAGE: Text message for the status"
    echo "  STATUS_EXPIRATION_SECONDS (optional): Expiration time for the status in seconds (default is set in .env)"
    exit 1
fi

# Set the current working directory and the path to the JSON file
CWD=$(dirname $(realpath "$0"))
PRECENCE_REQUEST_JSON="$CWD/request-set-presence.json"

# Check if the .env file exists
if ! [[ -f "$CWD/.env" ]]; then
    echo "$CWD/.env file does not exist"
    exit 1
fi

# Load environment variables from .env file
export $(grep -oE '\b\w+=.+\b' "$CWD/.env" | xargs)

# Assign values to variables
STATUS_EMOJI="$1"
STATUS_MESSAGE="$2"
STATUS_EXPIRATION_SECONDS="${3:-"$DEFAULT_STATUS_EXPIRATION_SECONDS"}"

# Create JSON data using jq
data=$(jq --arg status_text "$STATUS_MESSAGE" \
          --arg status_emoji "$STATUS_EMOJI" \
          --arg status_expiration "$STATUS_EXPIRATION_SECONDS" \
          '.profile.status_text = $status_text |
           .profile.status_emoji = $status_emoji |
           .profile.status_expiration = $status_expiration' \
          "$PRECENCE_REQUEST_JSON")

# Display the curl command (remove 'echo' to execute)
curl -s -X POST -H "Authorization: Bearer $SLACK_ACCESS_TOKEN" -H "Content-type: application/json" \
  --data "$data" \
  https://slack.com/api/users.profile.set \
  | jq

