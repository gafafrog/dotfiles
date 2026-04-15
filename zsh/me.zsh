# me.zsh — personal shell preferences

export AWS_PAGER=''

export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$PATH:$(go env GOPATH)/bin

alias showcert='openssl x509 -text -noout -in'

# ls aliases
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Completion: substring/fuzzy matching
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'l:|=* r:|=*'

# zsh plugins (homebrew)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
  && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
  && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
bindkey -e  # emacs mode
export WORDCHARS=''
