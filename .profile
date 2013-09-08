source ~/.alias
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH="$PATH:/usr/local/mysql/bin":$PATH
export PATH="$PATH:/Users/kevincobain2000/pear/bin/":$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/kevincobain2000/.profile file was backed up as /Users/kevincobain2000/.profile.macports-saved_2013-04-22_at_21:06:52
##

# MacPorts Installer addition on 2013-04-22_at_21:06:52: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/Users/pulkit.kathuria/pear/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PS1="[\W]\$ "
bind "set completion-ignore-case on"

if [ -f~/.git-completion.bash ]; then
. ~/.git-completion.bash
fi

parse_git_branch() {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="[\W]\[\033[32m\]\$(parse_git_branch)\[\033[00m\]"" "

