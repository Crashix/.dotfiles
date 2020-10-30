USER := crashix
HOST := crashix
HOME := /home/$(USER)
OS   := nixos

# =========   Dotfiles with GNU Stow   =========

default: config dunst emacs git gtk i3 lf nixpkgs sh termite vim xorg zsh

all: config bash dunst emacs git gtk i3 isync lf readline sh termite vim xdg xorg zsh

audio: config
	stow audio

bash: config sh readline
	stow bash

bspwm: config
	stow bspwm
	chmod +x ${HOME}/.config/bspwm/bspwmrc

dunst: config
	stow dunst

emacs: config
	[ -d ~/.emacs.d ] || mkdir ~/.emacs.d
	stow emacs

git: config
	stow git

gtk: config
	stow gtk

i3: config
	stow i3

isync: config
	stow isync

lf: config
	stow lf

nixpkgs: config
    stow nixpkgs

nixos: config_root
	sudo stow ${HOST}

readline: config
	stow readline

sh: config
	stow sh

termite: config
	stow termite

vim: config
	[ -d ~/.vim ] || mkdir ~/.vim
	stow vim

xdg: config
	stow xdg

xorg: i3 config
	stow xorg

zsh: config sh
	stow zsh

config: .stowrc

config_root:
	echo "--target=/ --dir=${OS}" > .stowrc

.stowrc:
	echo "--target=${HOME}" > .stowrc


# =========   NixOS specific commands   =========
upgrade: update switch

update: 
	@sudo nix-channel --update

switch:
	@sudo nixos-rebuild switch

build:
	@sudo nixos-rebuild build

boot:
	@sudo nixos-rebuild boot

rollback:
	@sudo nixos-rebuild --rollback

dry:
	@sudo nixos-rebuild dry-build

gc:
	@nix-collect-garbage --delete-older-than 333d

vm:
	@sudo nixos-rebuild build-vm

clean:
	@rm -f result


# Convenience aliases
s: switch
up: upgrade
