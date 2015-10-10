if [[  -d /opt/local/ ]]; then
    path=(/opt/local/bin /opt/local/sbin $path)
fi

# GO
if [[  -d /usr/local/opt/go/libexec/bin ]]; then
    path=(/usr/local/opt/go/libexec/bin $path)
fi
if [[ -d ~/go ]]; then
    export GOPATH=$HOME/go
fi

path=(/usr/local/bin /usr/local/sbin $path)

manpath=($manpath /opt/local/man /usr/share/man)

cdpath=(~ ~/git)

