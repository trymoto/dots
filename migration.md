# Arch → macOS Config Migration Notes

## Zsh / Oh-My-Zsh
Third-party plugins are not bundled with oh-my-zsh and must be cloned manually:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/lukechilds/zsh-better-npm-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
```

## Pygments
Required by oh-my-zsh for URL encoding in some themes. Not available by default on macOS:
```bash
brew install pygments
```

## Tmux
TPM and plugins must be reinstalled:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then inside tmux: `prefix + I` to install all plugins.

## Key Repeat
macOS caps key repeat speed via UI. Override via terminal for faster repeat:
```bash
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
```
Log out and back in to apply.
