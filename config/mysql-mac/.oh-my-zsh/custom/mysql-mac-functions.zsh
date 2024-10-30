function mysqlrm() {
  OLD_VERSION=$1
  # Remove current mysql
  brew services stop $OLD_VERSION
  sleep 10
  sudo killall mysqld
  brew unlink $OLD_VERSION
  brew unpin $OLD_VERSION
  brew uninstall $OLD_VERSION
  brew cleanup
  # Remove remaining config
  sudo rm /opt/homebrew/etc/my.cnf
  sudo rm /opt/homebrew/etc/my.cnf.d
  sudo rm -rf /opt/homebrew/var/mysql
  sudo rm -rf /opt/homebrew/var/log/mysql*
  sudo rm -rf /opt/homebrew/var/mysql*
  sudo rm -rf /opt/homebrew/Cellar/mysql
  sudo rm -rf /opt/homebrew/Cellar/mysql-client
  sudo rm -rf /opt/homebrew/opt/mysql
  sudo rm -f /Library/LaunchAgents/*mysql*
  sudo rm -f /Library/LaunchDaemons/*mysql*
  sudo rm -f /private/etc/mysql*
  # remove any simlinks that point to old mysql
  cd /opt/homebrew/opt
  ls -latr mysql*
  cd -
}

function mysqladd() {
    NEW_VERSION=$1
    # Update and install new
    brew update
    brew install $NEW_VERSION
    brew link --force $NEW_VERSION
    brew pin $NEW_VERSION
    brew services start $NEW_VERSION
    sleep 10
    brew services list
}

function mysqlreplace() {
    OLD_VERSION=$1
    NEW_VERSION=$2
    # Remove current mysql
    mysqlrm $OLD_VERSION
    # Update and install new
    mysqladd $NEW_VERSION
}

# How to call
# mysqlreplace "mysql" "mysql@8.x"