# echo "Loading liondesk environment..."
# os="$(uname -s)"
# case $os in
#     Linux)
#         # Use the ip command on Linux systems
#         export MY_IP=$(ip route | grep "default" | grep -oP "src (\d{1,3}\.){3}\d{1,3}" | awk '{print $2}')
#         keybase_folder="/keybase/"
#     ;;
#     Darwin)
#         # Use the ifconfig command on Mac systems
#         export MY_IP=$(ifconfig | grep "inet " | awk '{print $2}' | tail -n 1)
#         keybase_folder="/Volumes/Keybase"
#     ;;
# esac

# keybase_user=`keybase whoami`
# keybase_private_folder="$keybase_folder/private/$keybase_user"
# keybase_team_folder="$keybase_folder/team/lwcrm_local_dev"

# ln -sf  "$keybase_private_folder/gitlab_liondesk" "$HOME/.ssh/gitlab_liondesk"
# ssh-add "$HOME/.ssh/gitlab_liondesk" 2>/dev/null

# source "$keybase_team_folder/development-docker"
# source "$keybase_private_folder/`hostname`@`whoami`"
# source "$HOME/.dotfiles/zsh/nvm.zsh"

# alias cdld="cd ~/work/liondesk/ld"
# alias codeld="code ~/work/liondesk/ld"
# alias cdla="cd ~/work/liondesk/LionDeskAdmin"
# alias codela="code ~/work/liondesk/LionDeskAdmin"

# nvm use v10.18.1 --silent
# if [ -z "$(gvm list | grep 1.16.15)" ]; then
#     gvm install go1.16.15
# fi
# gvm use go1.16.15 --default

# echo "Loaded!"
# clear
