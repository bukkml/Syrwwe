#!/bin/bash

#debug
set -x

# fail on error
set -e

#Include 
source "progs.sh"

install="pacman -S --noconfirm -q"

# ####################### #
# Important Starting Deps #
# ####################### #

# ##### #
# Setup #
# ##### #

sudo pacman -Syu --noconfirm -q

# install yay | requires manual password input
sudo pacman -S --needed git base-devel
cd && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# GitHub config
git config --global user.email mak.kurlovich@gmail.com
git config --global user.name bukk
git config --global core.editor nvim

# My prefered folders
mkdir -p ~/Applications ~/Downloads ~/Pictures ~/.local/bin ~/.config ~/development

# ################ #
# Package Download #
# ################ #

for package in ${programs[@]}; do
  sudo $install $package
  if [ $? -ne 0 ]; then
    echo "Package $package Failed"
    exit 1
  fi
done


# Install tofi
yay -S --noconfirm tofi

# Install Zen browser
yay -S --noconfirm zen-browser-bin

# nerdfonts
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz && \
mkdir -p $HOME/.local/share/fonts && \
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec mv {} $HOME/.local/share/fonts \; 
rm -rf ./ryanoasis-nerd-fonts-*

# PxPlus font
git clone https://github.com/bukkml/PxPlus_IBM_VGA8_Nerd.git
mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf ~/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd

# Cursor theme
curl -LO https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz
tar -xf Bibata-Modern-Classic.tar.xz
mkdir -p ~/.local/share/icons/
mv Bibata-* ~/.local/share/icons/
rm -rf Bibata-Modern-Classic.tar.xz

# ############# #
# Configuration #
# ############# #

git clone git@github.com:bukkml/bukkConfig .config/nvim

systemctl enable ly.service

# Move dotfiles to their respective places, adopts existing files then overrides them to what they should be 
stow . --adopt
git restore .
