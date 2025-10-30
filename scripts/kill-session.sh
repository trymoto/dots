##!/bin/zsh
find ~/.local/share/nvim/sessions -maxdepth 1 | grep -E "$(pwd | sed 's/\//%/g')|$(pwd | sed 's/\//%2F/g')" | xargs rm

