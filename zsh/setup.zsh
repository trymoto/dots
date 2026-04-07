
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

export GOPATH=`go env GOPATH`
export PATH=$PATH:`go env GOPATH`/bin/
export PATH="$HOME/.local/bin:$PATH"

export PODMAN_COMPOSE_WARNING_LOGS=false
export TERM=xterm-256color
export KUBECONFIG="$HOME/.kube/config"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_RYUK_DISABLED=true

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export EDITOR="nvim"


COMPLETION_WAITING_DOTS="true"
ZSH_THEME="headline"
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/themes/headline.zsh-theme

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(pnpm completion zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(kubectl completion zsh)"
alias h="Hyprland"


