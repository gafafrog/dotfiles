# dotfiles

## Setup

### tmux

```bash
ln -s ~/repos/gafafrog/dotfiles/tmux/tmux.conf ~/.tmux.conf
```

### emacs

```bash
mkdir -p ~/.emacs.d
ln -s ~/repos/gafafrog/dotfiles/emacs/init.el ~/.emacs.d/init.el
```

`init.el` loads `me.el` from the same directory automatically.

### starship

```bash
ln -s ~/repos/gafafrog/dotfiles/starship/starship.toml ~/.config/starship.toml
```

### wezterm

```bash
mkdir -p ~/.config/wezterm
ln -s ~/repos/gafafrog/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

### zsh

```bash
ln -s ~/repos/gafafrog/dotfiles/zsh/.zshrc ~/.zshrc
```

`.zshrc` sources `me.zsh` (shared personal settings) and one of:
- `home.zsh` — home-specific settings
- `my_company.zsh` — work-specific settings
