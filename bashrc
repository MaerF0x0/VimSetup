# don't put duplicate lines in the history. See bash(1) for more options
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


function php_check(){
    for i in $(svn st  | grep -o "[^ ]\{1,\}\.\(php\|phtml\)"); do
        php -l $i
    done
}

function super() {
            grep -i "$1" $(find ./ -name "*.php")
}

function super_case() {
            grep  "$1" $(find ./ -name "*.php")
}

function superlist() {
            grep  -l "$1" $(find ./ -name "*.php")
}

function ff() {
    grep "function $1" $(find ./ -name "*.php")
}

function fc() {
    grep "class $1" $(find ./ -name "*.php")
}
 
function php_check_all() {
    for i in $(find ./ -name "*.php"); do
        msg=`php -l $i`
        if [ "$?" != "0" ]; then
            echo $msg;
        fi
    done
}

alias vi='vim -p'
alias gitx='open -a GitX .'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# via https://coderwall.com/p/pn8f0g
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"


function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

function get_jobs {
	echo "${COLOR_BLUE}[\\j]"
}


PS1="{\[$(tput setaf 5)\]\w\[$(tput sgr0)\]}" # [pwd]
PS1+="\[\$(git_color)\]\$(git_branch)" # colored git branch name
#PS1+="\[$(tput setaf 6)\]{\j}\[$(tput sgr0)\]"
PS1+=$(get_jobs)
PS1+="\[$(tput setaf 1)\] \\$ \[$(tput sgr0)\]" # red " $ " or " # "
export PS1

export HISTSIZE=''
export HISTFILESIZE=''
export PROMPT_COMMAND='history -a'

MONGO_URL=mongodb://localhost:27017

function deploy_time {
  cd $CODE_HOME/fabulaws && workon fabulaws && fab -l;
}

function goto {
  if [ "$#" -ne 1 ]; then
    echo "usage: goto <project dir>";
    return -1;
  fi

  DIR="${CODE_HOME}/${1}"
  if [ -d "$DIR" ]; then 
    cd ${DIR};
  else
    echo "${DIR} is not a directory"
    return -2;
  fi
}

function _goto_autocomplete {
  local cur prev opts

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=`ls ${CODE_HOME}`

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _goto_autocomplete goto
