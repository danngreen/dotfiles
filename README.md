## Install:

```bash
cd ~
git clone git@github.com:danngreen/dotfiles

mkdir -p .config
cd .config
ln -s ../dotfiles/.config/nvim ./
ln -s ../dotfiles/.config/iterm2 ./
ln -s ../dotfiles/.config/zsh ./
ln -s ../dotfiles/.config/lazygit ./

cd ..
ln -s dotfiles/.zshrc ./
ln -s dotfiles/.gitignore-global ./
```


## Config git

Tell git to use the global excludes file like this:

```
git config --global core.excludesfile ~/.gitignore-global
```

