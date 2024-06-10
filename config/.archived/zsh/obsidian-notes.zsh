NOTES_DIRECTORY="$HOME/.main/notes"

find_notes_media() {
    local notes_dir="$1"
    find "$notes_dir" \
    -name "*.png" \
    -o -name "*.jpg" \
    -o -name "*.jpeg" \
    -o -name "*.gif" \
    -o -name "*.pdf" \
    -o -name "*.csv" \
    -o -name "*.web*" \
    | grep -v -E ".+.dvc" \
    | grep -v -E ".+\.sync-conflict.+" \
    | grep -v -E ".stversions" \
    | grep -v -E ".stfolder" \
    | grep -v -E ".obsidian" \
    | grep -v -E ".trash"
}

update_notes_media() {
    local notes_dir=`realpath "$1"`
    if [ "`find "$notes_dir" -type d -name ".dvc" | wc -l`" != "0" ]
    then
        cd "$notes_dir"
        find_notes_media "$notes_dir" | xargs -d '\n' dvc add \
        && dvc push
        cd $OLDPWD
    fi
}

update_notes_repo() {
    local notes_dir=$1
    git -C "$notes_dir" fetch --all --prune --quiet
    local current_branch=`git -C "$notes_dir" rev-parse --abbrev-ref HEAD`
    if [ "`git -C "$notes_dir" status -s | wc -l`" != "0" ] || [ "`git -C "$notes_dir" diff "$current_branch" "origin/$current_branch"`" ]
    then
        update_notes_media "$notes_dir" \
        && git -C "$notes_dir" add . \
        && git -C "$notes_dir" commit --quiet -m "update from `whoami`@`hostname`" \
        && git -C "$notes_dir" pull --no-rebase --quiet \
        && git -C "$notes_dir" push \
        && echo "\n\n$notes_dir UPDATED!"
    else
        echo "$notes_dir does not need updates"
    fi
}

MULTI_VAULT_SYSTEM_DIRECTORY="$NOTES_DIRECTORY/SNTS/legacy/multi-vault-system"
alias cdnkn="cd $MULTI_VAULT_SYSTEM_DIRECTORY/knowledge"
alias cdnkb="cd $MULTI_VAULT_SYSTEM_DIRECTORY/kakeibo"
alias cdnpr="cd $MULTI_VAULT_SYSTEM_DIRECTORY/productivity"
alias cdnpe="cd $MULTI_VAULT_SYSTEM_DIRECTORY/people"
alias cdn="cd $NOTES_DIRECTORY/SNTS"

alias nkn-update="update_notes_repo $NOTES_DIRECTORY/knowledge"
alias nkb-update="update_notes_repo $NOTES_DIRECTORY/kakeibo"
alias npr-update="update_notes_repo $NOTES_DIRECTORY/productivity"
alias npe-update="update_notes_repo $NOTES_DIRECTORY/people"

alias notes-update="nkn-update; nkb-update; npr-update; npe-update"

install-notes() {
    local notes_directory=${1:-"$NOTES_DIRECTORY"}
    for repo_url in `cat ~/.dotfiles/homelab/.config/notes-repositories.txt`; do
        folder_name=$(basename $repo_url '.git')
        notes_folder="$notes_directory/$folder_name"
        if [[ ! -d "$notes_folder" ]]
        then
            git clone "$repo_url" "$notes_folder"
            continue
        fi
        echo "the folder '$notes_folder' is already in your system"
        if [[ "`git -C "$notes_folder" remote -v | wc -l`" == "0" ]]
        then
            echo "and does not have any remote repository connected"
            continue
        fi
        if [[ "`git -C "$notes_folder" remote -v | awk '{print $2}' | uniq`" != "$repo_url" ]]
        then
            echo "and it is connected to other remote url different to $repo_url"
            git -C "$notes_folder" remote -v
            continue
        fi
    done
}
