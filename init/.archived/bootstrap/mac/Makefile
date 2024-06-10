.POSIX:
.SUFFIXES:

TARGETS := dev-tools workflow-tools work-utilities

.PHONY: all $(TARGETS)

all: $(TARGETS)

dev-tools:
	@echo "Installing dev tools..."
	bash installations/node.sh
	@command -v node >/dev/null || { echo "node not found"; exit 1; }
	bash installations/python.sh
	@command -v python3 >/dev/null || { echo "python3 not found"; exit 1; }
	bash installations/go.sh
	@command -v go >/dev/null || { echo "go not found"; exit 1; }
	bash installations/docker.sh
	@command -v docker >/dev/null || { echo "docker not found"; exit 1; }

workflow-tools:
	@echo "Installing workflow tools..."
	bash installations/brave.sh
	@command -v brave-browser >/dev/null || { echo "brave-browser not found"; exit 1; }
	bash installations/tmux.sh
	@command -v tmux >/dev/null || { echo "tmux not found"; exit 1; }
	bash installations/syncthing.sh
	@command -v syncthing >/dev/null || { echo "syncthing not found"; exit 1; }
	bash installations/oh-my-zsh.sh
	@if [ ! -d ~/.oh-my-zsh ]; then echo "Oh My Zsh installation failed!"; exit 1; fi
	bash installations/dvc.sh
	@command -v dvc >/dev/null || { echo "dvc not found"; exit 1; }

work-utilities:
	@echo "Installing work utilities..."
	bash installations/neovim.sh
	@command -v nvim >/dev/null || { echo "nvim not found"; exit 1; }
	bash installations/keybase.sh
	@command -v keybase >/dev/null || { echo "keybase not found"; exit 1; }
	bash installations/pup.sh
	@command -v pup >/dev/null || { echo "pup not found"; exit 1; }
	bash installations/play-with-mpv.sh
	@command -v play-with-mpv >/dev/null || { echo "play-with-mpv not found"; exit 1; }
