alias gcplist="gcloud auth list && gcloud config configurations list"

alias rng="ranger ./ ./"
alias lg="lazygit"
alias ld="lazydocker"
alias fman="compgen -c | fzf | xargs man"
alias love='echo "♥" | tee >(wl-copy)'
alias time='date +%s000 | tee >(wl-copy)'
alias fl='fzf --preview="bat --color=always {}"'
alias meta="cd ~/obsidian/meta && nvim"
alias usb="sudo mount /dev/$1 /mnt/usb"

alias nuke-docker='docker stop $(docker ps -a -q) && docker container prune -f && docker volume rm $(docker volume ls -q)'
alias kill-session="~/.config/scripts/kill-session.sh"

alias t="tmux"
alias ta="tmux attach -t"
alias tls="tmux ls"
alias tn="tmux new -s"
alias h="Hyprland"

alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

alias k="kubectl"
alias kgp="kubectl get pods"

bindkey '^[[20~;' autosuggest-accept

alias cors="docker run -d -p 8080:8080 --name cors redocly/cors-anywhere"
alias stop="docker stop $(docker ps -aq) && docker rm $(docker ps -aq)"

alias sleep='systemctl suspend'
alias shutdown='sudo systemctl poweroff'
alias reboot='sudo systemctl reboot'

alias open='xdg-open'

jsontocsv() {
  jq -r '(.[0] | keys_unsorted) as $keys | $keys, map([.[ $keys[] ]])[] | @csv'
}

function token() {
  gcloud auth print-identity-token | wl-copy
  echo "gcloud auth print-identity-token | wl-copy"
}

