Managed by [Chezmoi](https://www.chezmoi.io/)

# Quick Start
```bash
sudo snap install chezmoi --classic
chezmoi init --apply abb00717
```

# Install
Some other things you should install on your own
- [vim-plug](https://github.com/junegunn/vim-plug)
- [Neovim](https://neovim.io/doc2/install/)
- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)
- [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)

```bash
sudo apt update && sudo apt upgrade

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo apt install -y neovim gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza npm
sudo npm install -g npm

## Optional
- [Nerd-Fonts](https://www.nerdfonts.com/font-downloads)

```bash
sudo apt update && sudo apt install openssh-client
```
