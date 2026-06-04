# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


#source ~/.myfunction.sh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#-----------------------------------------------add by chen----------------------------------------------------
# Add user's local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
# for weston build
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig

#for flutter 
export PATH=$PATH:/home/chengang/workingspace_disk2/flutter/flutter-elinux/bin

#flutter-engine
export PATH=/home/chengang/workingspace_disk2/flutter-engine/depot_tools:$PATH



# # 历史记录增强
# export HISTSIZE=10000
# export HISTFILESIZE=10000
# # ignoreboth 包含了 ignorespace(空格开头的命令不记录) 和 ignoredups(忽略连续重复)
# # erasedups 清除整个历史中的重复项
# export HISTCONTROL=ignoreboth:erasedups 
# shopt -s histappend  # 追加模式
# # 终极同步与去重方案：
# # 1. history -a: 追加新命令到文件
# # 2. history -c: 清空当前内存中的历史
# # 3. history -r: 重新从文件中读取历史（这样能保证多窗口实时同步，配合去重）
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# 基础历史记录配置
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# 定义一个严格去重的函数
strict_history_dedup() {
    # 1. 将刚刚执行的单条新命令追加到磁盘历史文件中
    history -a
    
    # 2. 使用 mktemp 创建临时文件，防止多窗口并发写入冲突
    local tmp_file=$(mktemp)
    
    # 3. 核心物理去重：
    # tac: 倒序读取文件（从最新到最旧）
    # awk: 利用数组 seen 记录是否见过这一行，没见过的才输出（只保留最新的）
    # tac: 再次倒序，恢复正常的执行顺序
    tac ~/.bash_history | awk '!seen[$0]++' | tac > "$tmp_file" && mv "$tmp_file" ~/.bash_history
    
    # 4. 清空当前内存历史，并重新从完美去重后的磁盘文件中读取
    history -c
    history -r
}
# 挂载到 PROMPT_COMMAND，每次回车后自动执行
PROMPT_COMMAND="strict_history_dedup; $PROMPT_COMMAND"


# add for net
export https_proxy=http://192.168.2.226:7897
export http_proxy=http://192.168.2.226:7897
export all_proxy=socks5://192.168.2.226:7897


# ==========================================
# Tmux 交互式智能挂载菜单
# ==========================================
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
    # 检查当前是否有运行中的 tmux session
    if tmux ls > /dev/null 2>&1; then
        echo -e "\n\033[1;36m🎯 检测到存活的 Tmux 工作现场，请选择恢复：\033[0m"
        
        # 获取所有 session 的名字和窗口数量
        mapfile -t sessions < <(tmux ls -F "#{session_name}  [包含 #{session_windows} 个窗口]")
        
        # 手动打印菜单列表
        for i in "${!sessions[@]}"; do
            echo "$((i+1))) ${sessions[$i]}"
        done
        
        # 循环等待有效输入
        while true; do
            echo -e -n "\n👉 请输入序号恢复 (输入 \033[1;32mn\033[0m 新建, 直接按 \033[1;33m回车\033[0m 跳过): "
            read -r choice
            
            if [[ -z "$choice" ]]; then
                echo "已跳过，进入普通终端。"
                break
            elif [[ "$choice" == "n" ]]; then
                read -p "📝 给新工作现场起个名字 (如: flutter_debug): " new_name
                if [[ -n "$new_name" ]]; then
                    tmux new-session -s "$new_name"
                else
                    tmux new-session
                fi
                break
            # 正则检查输入是否为数字，且在有效范围内
            elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice > 0 && choice <= ${#sessions[@]} )); then
                # 提取纯 session 名字并挂载
                target=$(echo "${sessions[$((choice-1))]}" | awk '{print $1}')
                tmux attach-session -t "$target"
                break
            else
                echo -e "\033[1;31m❌ 无效的输入，请重新输入。\033[0m"
            fi
        done
    else
        echo -e "\n\033[1;33m✨ 当前没有活动的 Tmux 工作现场。\033[0m"
        read -p "是否立刻新建一个？(y/n) [回车默认 n]: " create_new
        if [[ "$create_new" == "y" || "$create_new" == "Y" ]]; then
            read -p "📝 给新工作现场起个名字: " new_name
            if [[ -n "$new_name" ]]; then
                tmux new-session -s "$new_name"
            else
                tmux new-session
            fi
        fi
    fi
fi
