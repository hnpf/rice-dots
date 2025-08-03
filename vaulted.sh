#!/bin/bash

# colors
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

echo -e "${CYAN}${BOLD}rei-chan's system setup starting...${RESET}"

# ask before continuing
read -p $'\e[33mdo you wanna continue? (y/n): \e[0m' confirm
[[ "$confirm" != "y" ]] && echo -e "${YELLOW}okay then bye~${RESET}" && exit 1

echo -e "${GREEN}updating system first...${RESET}"
sudo pacman -Syu --noconfirm

# install packages
echo -e "${CYAN}installing packages...${RESET}"
packages=(
  thunar
  breeze-icons
  cava
  dunst
  foot
  gtk3
  gtk4
  neofetch
  neovim
  nwg-look
  pulseaudio
  qt5ct
  ranger
  rofi
  spicetify-cli
  swaylock
  waybar
  wlogout
  zsh
  xfce4-settings
  simple-update-notifier
  sublime-text
)

for pkg in "${packages[@]}"; do
  echo -e "${YELLOW}installing: $pkg${RESET}"
  sudo pacman -S --noconfirm --needed "$pkg"
done

# create config directories if they don't exist
echo -e "${CYAN}copying config files...${RESET}"
mkdir -p ~/.config

configs=(
  breeze-rose-pine-dawn
  cava
  dunst
  foot
  gtk-3.0
  gtk-4.0
  hypr
  neofetch
  nvim
  nwg-look
  pulse
  qt5ct
  ranger
  rofi
  session
  shell
  simple-update-notifier
  spicetify
  swaylock
  waybar
  wlogout
  zsh
)

for dir in "${configs[@]}"; do
  if [[ -d "$dir" ]]; then
    echo -e "${GREEN}copying $dir -> ~/.config/${RESET}"
    cp -r "$dir" ~/.config/
  else
    echo -e "${YELLOW}skipped $dir (not found)${RESET}"
  fi
done

# special ones that go directly to home
[[ -f ".zshrc" ]] && cp .zshrc ~/.zshrc && echo -e "${GREEN}added .zshrc${RESET}"

# sublime-text user config
if [[ -d "sublime-text/Packages/User" ]]; then
  mkdir -p ~/.config/sublime-text/Packages
  cp -r sublime-text/Packages/User ~/.config/sublime-text/Packages/
  echo -e "${GREEN}sublime-text config copied${RESET}"
fi

# xfce4 settings
if [[ -d "xfce4/xfconf/xfce-perchannel-xml" ]]; then
  mkdir -p ~/.config/xfce4/xfconf/
  cp -r xfce4/xfconf/xfce-perchannel-xml ~/.config/xfce4/xfconf/
  echo -e "${GREEN}xfce4 settings copied${RESET}"
fi

# finishing up
echo -e "${CYAN}changing shell to zsh...${RESET}"
chsh -s $(which zsh)

echo -e "${GREEN}${BOLD}setup complete~ reboot if needed :3${RESET}"
