jira-issue() {
    host="$1"
    issue="$2"
    protocol="${3:-https}"

    open "$protocol://$host/browse/$issue" 2>&1 > /dev/null
}

jira-board() {
    host="$1"
    project_id="$2"
    board_id="${3:-1}"
    protocol="${4:-https}"

    open "$protocol://$host/jira/software/projects/$project_id/boards/$board_id" 2>&1 > /dev/null
}

jira-chain() {
    jira-board "mind-chain.atlassian.net" "BA" "1"
}

jira-chain-issue() {
    jira-issue "mind-chain.atlassian.net" "$1"
}
