#!/bin/bash

cd ~
LOCALDEV_PATH=/localdev/hshah
mkdir -p $LOCALDEV_PATH/.local/share
mkdir -p ~/.local
mkdir -p ~/.config

if [ -e "~/.local/share" ] && [ ! -L "~/.local/share"]; then
    # Path exists but it isn't a symlink
    mv ~/.local/share/* $LOCALDEV_PATH/share
    rm -rf ~/.local/share
fi

ln -snf $LOCALDEV_PATH/.local/share ~/.local/share

if [ ! -e "$LOCALDEV_PATH/nvim" ]; then
    git clone git@github.com:hshahTT/kickstart.nvim.git $LOCALDEV_PATH/nvim
else
    cd $LOCALDEV_PATH/nvim
    git pull
    cd ~
fi

ln -snf $LOCALDEV_PATH/nvim ~/.config/nvim

rm nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

if ! grep -Fxq 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' ~/.bashrc; then
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
fi
sudo apt install ripgrep fd-find unzip xclip -y
rm tree-sitter-cli-linux-x64.zip
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.7/tree-sitter-cli-linux-x64.zip
unzip tree-sitter-cli-linux-x64.zip
chmod +x tree-sitter
sudo mv tree-sitter /opt/nvim-linux-x86_64/bin

# lazygit
rm -f lazygit.tar.gz lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
chmod +x lazygit
sudo mv lazygit /opt/nvim-linux-x86_64/bin
rm -f lazygit.tar.gz

