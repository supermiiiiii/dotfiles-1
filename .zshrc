# ----------------------------------------------------------------------------
# ------------------------------ SOURCES -------------------------------------
source ~/Dropbox/dotfiles/extras/oh-my-zsh
source ~/Dropbox/scripts/localAlias
source ~/Dropbox/dotfiles/extras/globrc

# ----------------------------------- ALIASES --------------------------------
alias -s pdf="okular"
alias -s epub="okular"
alias -s docx="/usr/lib/libreoffice/program/soffice.bin --writer"
alias -s ppt="/usr/lib/libreoffice/program/soffice.bin --impress"
alias -s png="imv"
alias -s pcx="imv"
alias -s jpg="imv"
alias -s jpeg="imv"
alias -s git="git clone"
alias -s djvu="djview"

alias -g @@="&> /dev/null & disown"
alias -g X="&& exit"

# -------------------------------- FUNCTIONS ---------------------------------

# Starts ssh-agent automatically
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

# precmd() { eval "$PROMPT_COMMAND" }
# # orig_command_not_found ---> command_not_found_handle
# # http://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
# command_not_found_handler() {
#     GREP=$(grep -s "^$1$SEP" "./.localaliases")
#     if LocalAlias $1 "$GREP" "${@:2}"; then
#           :
#     fi
# }