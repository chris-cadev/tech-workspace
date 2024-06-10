.PHONY: start-services

generate-services: *.template
	bash ./generate-services.sh

load-services: generate-services
	bash ./load-services.sh

reload-daemon:
	bash ./reload-daemon.sh

start: generate-services load-services reload-daemon
	bash ./start.sh

restart-services:
	bash ./refresh-services.sh

install:
	bash ~/.dotfiles/boostrap/installer/install.play-with-mpv.sh
