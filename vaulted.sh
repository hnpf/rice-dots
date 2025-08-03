#!/bin/bash

# colors
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"
echo -e "${CYAN}${BOLD}system setup starting~${RESET}"
read -p $'\e[33mcontinue? (y/n): \e[0m' confirm
[[ "$confirm" != "y" ]] && echo -e "${YELLOW}okay then bye~${RESET}" && exit 1

# install yay
if ! command -v yay &>/dev/null; then
  echo -e "${CYAN}installing yay...${RESET}"
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd ~
else
  echo -e "${GREEN}yay already installed${RESET}"
fi

cd ~
echo -e "${CYAN}moved back to home directory${RESET}"

# system update
echo -e "${GREEN}updating system...${RESET}"
yay -Syu --noconfirm

# install main packages
echo -e "${CYAN}installing Jetbrains-Mono...${RESET}"
yay -S --noconfirm nerd-fonts-jetbrains-mono
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
  plymouth
  gtk-theme-rose-pine-moon
  tela-circle-icon-theme-git
  breezeX-cursor-theme
)
for pkg in "${packages[@]}"; do
  echo -e "${YELLOW}installing: $pkg${RESET}"
  yay -S --noconfirm --needed "$pkg"
done

# config copy
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

[[ -f ".zshrc" ]] && cp .zshrc ~/.zshrc && echo -e "${GREEN}added .zshrc${RESET}"

if [[ -d "sublime-text/Packages/User" ]]; then
  mkdir -p ~/.config/sublime-text/Packages
  cp -r sublime-text/Packages/User ~/.config/sublime-text/Packages/
  echo -e "${GREEN}sublime-text config copied${RESET}"
fi

if [[ -d "xfce4/xfconf/xfce-perchannel-xml" ]]; then
  mkdir -p ~/.config/xfce4/xfconf/
  cp -r xfce4/xfconf/xfce-perchannel-xml ~/.config/xfce4/xfconf/
  echo -e "${GREEN}xfce4 settings copied${RESET}"
fi

# set shell to zsh
echo -e "${CYAN}setting default shell to zsh...${RESET}"
chsh -s $(which zsh)

# theme setup
echo -e "${CYAN}setting GTK theme...${RESET}"
gsettings set org.gnome.desktop.interface gtk-theme 'rose-pine-moon-gtk'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-black'
gsettings set org.gnome.desktop.interface cursor-theme 'BreezeX-RosePine'

echo -e "${GREEN}theme set: gtk + icons + cursor${RESET}"

# boot config
echo -e "${CYAN}editing bootloader config for splash...${RESET}"
read -p $'\e[33msystemd-boot? (y/n): \e[0m' usesd

if [[ "$usesd" == "y" ]]; then
  echo -e "${GREEN}editing systemd-boot config...${RESET}"
  for entry in /boot/loader/entries/*.conf; do
    if ! grep -q "quiet" "$entry"; then
      sudo sed -i '/^options/s/$/ quiet splash/' "$entry"
      echo -e "${GREEN}added quiet splash to $entry${RESET}"
    else
      echo -e "${YELLOW}$entry already has quiet/splash${RESET}"
    fi
  done
elif command -v grub-install &>/dev/null; then
  echo -e "${GREEN}using grub... editing grub config${RESET}"
  sudo sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 quiet splash"/' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  echo -e "${GREEN}grub config updated with quiet splash${RESET}"
else
  echo -e "${YELLOW}no bootloader config updated${RESET}"
fi

# plymouth theme
echo -e "${CYAN}setting plymouth theme...${RESET}"
sudo plymouth-set-default-theme -R breeze-rose-pine-dawn
echo -e "${GREEN}plymouth theme set to breeze-rose-pine-dawn${RESET}"

# done
echo -e "${BOLD}${CYAN}all done! reboot if needed (for shell/theme/boot stuff)${RESET}"
