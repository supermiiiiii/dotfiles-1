#!/bin/bash

###############################
#  XDG Environment Variables  #
###############################
export XDG_CONFIG_HOME="$HOME"/.config

################################
#  PATH Environment Variables  #
################################
function join_path {
    local IFS=":"
    printf "$*"
}

extra_path_dirs=(
    "/usr/local/bin"
    "$(ruby -e 'print Gem.user_dir')/bin"
    "/home/bryan/.local/bin"
    "/sbin"
    "/usr/sbin"
)

export MATLABPATH=$HOME/.matlab
export PATH="$(join_path ${extra_path_dirs[@]}):$PATH"
export LIBRARY_PATH=/usr/local/lib:${LIBRARY_PATH}
export QT_QPA_PLATFORMTHEME="qt5ct"  # Fixes: missing okular icons

#########################################
#  Miscellaneous Environment Variables  #
#########################################
export SHELLCHECK_OPTS="-e SC1091 -e SC1117 -e SC2001 -e SC2059 -e SC2129 -e SC2162"
export RECENTLY_EDITED_FILES_LOG=/home/bryan/Dropbox/var/recently_edited_files.log
export PYTHONPATH='/usr/local/lib/python'

#######################
#  virtualenvwrapper  #
#######################
export WORKON_HOME=~/.virtualenvs
[ -f /usr/bin/virtualenvwrapper_lazy.sh ] && source /usr/bin/virtualenvwrapper_lazy.sh

###########################
#  Start X Window System  #
###########################
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]] && [[ "$(id -u)" != 0 ]]; then
    exec startx
else
    map_file=/home/bryan/.Caps2Ctrl.map
    sudo dumpkeys | head -1 > "${map_file}"
    sudo printf "\n%s\n" "keycode 58 = Control" >> "${map_file}"
    sudo loadkeys "${map_file}"
fi
