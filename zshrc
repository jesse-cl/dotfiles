
if [[ -x `which mdfind` ]]; then
    function mdhere() {
        mdfind -onlyin . $*
    }
    function mdloc () {
      mdfind "kMDItemFSName == '$*'wc"
    }
fi

function not_run_from_ssh () {
    ps x|grep "${PPID}.*sshd"|grep -v grep
    echo $?
}

if [[ $OSTYPE[1,6] == "darwin" ]]; then
    function manp () {
        man -t $* | ps2pdf - - | open -f -a Preview
    }
fi

hs () { if [[ ! -z $1 ]];then history 0 | grep --color "$*";fi }

if [[ -f /etc/debian_version ]]; then
    pkgs () { if [[ ! -z $1 ]]; then dpkg -l "*$1*" | grep -E \^\[hi\]i | tr -s " " | grep $1; fi }
fi

if [[ -x `which git` ]]; then
    alias g=git
    function git-branch-name () {
        git branch 2> /dev/null | grep '^\*' | sed 's/^\*\ //'
    }
    function git-dirty () {
        git status 2> /dev/null | grep "nothing to commit (working directory clean)"
        echo $?
    }
    function gsrb () {
        branch=$(git-branch-name)
        git checkout master
        git svn rebase
        git checkout "${branch}"
        git rebase master
    }
    function git-prompt() {
        gstatus=$(git status 2> /dev/null)
        branch=$(echo $gstatus | head -1 | sed 's/^# On branch //')
#        dirty=$(echo $gstatus | sed 's/^#.*$//' | tail -2 | noglob grep 'nothing to commit (working directory clean)'; echo $?)
        dirty=$(echo $gstatus | sed 's/^#.*$//' | tr -d ',()' | tail -2 | noglob grep 'nothing to commit working directory clean'; echo $?)
        if [[ x$branch != x ]]; then
            dirty_color=$fg[cyan]
            if [[ $dirty = 1 ]] { dirty_color=$fg[magenta] }
            [ x$branch != x ] && echo "[%{$dirty_color%}$branch%{$reset_color%}]"
        fi
    }
    function git-scoreboard () {
        git log | grep Author | sort | uniq -ci | sort -r
    }
    function git-track () {
        branch=$(git-branch-name)
        git config branch.$branch.remote origin
        git config branch.$branch.merge refs/heads/$branch
        echo "tracking origin/$tracking"
    }
    function github-init () {
        git config branch.$(git-branch-name).remote origin
        git config branch.$(git-branch-name).merge refs/heads/$(git-branch-name)
    }
    function github-url () {
        git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
    }

    function github-url () {
        git config remote.origin.url | sed -En 's/git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'
    }

    # Seems to be the best OS X jump-to-github alias from http://tinyurl.com/2mtncf
    function github-go () {
        open $(github-url)
    }
    function nhgk () {
        nohup gitk --all &
    }
fi

if [[ -x `which vim` ]]; then
    EDITOR="vim"
elif [[ -x `which nano` ]]; then
    EDITOR=nano
elif [[ -x `which pico` ]]; then
    EDITOR=pico
else
    EDITOR=vi
fi

if [[ $TERM_PROGRAM == "Apple_Terminal" ]]; then
    stty erase 
fi

if [[ -x `which lesspipe.sh` ]]; then
    export LESS="-R -M --shift 5"
    export LESSOPEN="|lesspipe.sh %s"
    export LESSCOLOR=1
fi

# make sure colors and highlighting work in tmux
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;016m\E[48;5;220m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#GPG_TTY=$(/usr/bin/tty)

export EDITOR
export NVIM_TUI_ENABLE_TRUE_COLOR=1
#export GPG_TTY

#if [[ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]]; then
#   source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
#else
#   source $mydir/default_zkbd
#fi

alias cp='nocorrect cp'       # no spelling correction on cp
alias d='dirs -v'
alias h=history
alias j=jobs
#alias grep='grep --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias mv='nocorrect mv'       # no spelling correction on mv
alias po=popd
alias pu=pushd
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
alias fd=pushd
alias sd=popd


alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'
alias -g L='|less'


# git aliases
alias gitp='git push'
alias gitd='git diff'
alias gits='git status'
alias gitl='git pull'
alias gitc='git commit -a -m'

case $OSTYPE {
    linux*)
        if [[ -f ~/.dircolors ]]; then
            eval `/usr/bin/dircolors ~/.dircolors 2> /dev/null`
        else
            eval `dircolors`
        fi
        alias ls="ls --color=tty -N -F"
    ;;
    darwin*)
        alias ls='ls -G'
        alias qt='top -ocpu -O+rsize -s 5 -n 20'
        alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
# set colors for LS (man ls for color list)
        export LSCOLORS="gxfxcxdxbxegedabagacad"
    ;;
}

if [[ -x `which irssi` ]]; then
    alias irc='screen -r -d irc || screen -S irc irssi'
fi

for s in txt c cc cxx cpp; do
    alias -s $s=$EDITOR
done

if [[ $OSTYPE[1,6] == "darwin" ]]; then
    for s in mp3 wav aac \
        avi mp4 m4v mov qt mpg mpeg \
        jpg png psd bmp gif tif tiff \
        ps pdf html dmg; do
        alias -s $s=open
    done
fi

if [[ -x `which ggrep` ]]; then
    alias rgrep=`which grep`
    alias grep='ggrep --color'
fi


fignore=(DS_Store $fignore)

HISTSIZE=20480
SAVEHIST=10240

HISTFILE=~/.zsh_history
#setopt append_history
#setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
setopt autopushd


case $TERM in (*xterm*|ansi)
    function settab { print -Pn "\e]1;%n@%m: %~\a" }
    function settitle { print -Pn "\e]2;%n@%m: %~\a" }
    function chpwd { settab; settitle }
    settab; settitle
    ;;
esac
#bindkey "${key[Home]}" beginning-of-line
#bindkey "${key[End]}" end-of-line

bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward

# disable flow control so we can use ctrl-s
stty -ixon

autoload -U promptinit

setopt prompt_subst
#PROMPT='%{$reset_color%}`git-prompt`%# '

promptinit
if [[ -f /usr/local/share/liquidprompt ]]; then
    source /usr/local/share/liquidprompt
elif [ -f ${HOME}/.liquidz/init.zsh ]; then
   . ${HOME}/.liquidz/init.zsh
else
    prompt bart
fi

# set up a mysql prompt
export MYSQL_PS1="\\u@$HOST:\\d> "

# set local environment to localtime
export TZ=PST8PDT

# set up zmv
autoload -U zmv
alias mmv='noglob zmv -W'

# function to "re-agent" when we get detached from tmux
ssh-reagent () {
  for agent in /tmp/ssh-*/agent.*; do
    export SSH_AUTH_SOCK=$agent
    if ssh-add -l 2>&1 > /dev/null; then
      echo Found working SSH Agent:
      ssh-add -l
      return
    fi
  done
  echo Cannot find ssh agent - maybe you should reconnect and forward it?
}

# http://zshwiki.org/home/examples/compquickstart
# make sure we use completion
zmodload zsh/complist
autoload -U compinit && compinit

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

# ssh completion
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

# sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
