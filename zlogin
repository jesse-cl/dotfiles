
# check for gpg-agent info
# if [ -f "${HOME}/.gpg-agent-info" ]; then
#   source  "${HOME}/.gpg-agent-info"
#   export GPG_AGENT_INFO
#   export SSH_AUTH_SOCK
#   export SSH_AGENT_PID
# fi

# run keychain
if [[ -x $(which keychain) ]];then
#    eval $(keychain --lockwait 60 --eval id_rsa jah_id_ecdsa jph_bebo_id_ecdsa)
    eval $(keychain --lockwait 60 --eval  jph_bebo_id_ecdsa jah_id_ecdsa id_rsa)
fi

export SSH_AUTH_SOCK
export SSH_AGENT_PID

# disable flow control
stty -ixon
#
#eval $(ssh-agent)

function cleanup {
    echo "Killing SSH-Agent"
        kill -9 $SSH_AGENT_PID
    }

trap cleanup EXIT

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
