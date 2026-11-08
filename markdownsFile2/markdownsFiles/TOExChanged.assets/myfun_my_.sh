#!/bin/bash


# 循环执行命令的增强函数
loop_command_my_() {
    local command=""
    local count=0
    local delay=1
    local quiet=false

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--count)
                count="$2"
                shift 2
                ;;
            -d|--delay)
                delay="$2"
                shift 2
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            --)
                shift
                command="$*"
                break
                ;;
            -*)
                echo "未知参数: $1"
                return 1
                ;;
            *)
                command="$*"
                break
                ;;
        esac
    done

    # 检查必需参数
    if [ -z "$command" ]; then
        echo "用法: loop_command [选项] <命令>"
        echo "选项:"
        echo "  -c, --count NUM   循环次数 (0表示无限循环，默认: 0)"
        echo "  -d, --delay SEC   执行间隔秒数 (默认: 1)"
        echo "  -q, --quiet       静默模式，不显示执行信息"
        echo "  --                命令分隔符"
        echo ""
        echo "示例:"
        echo '''  loop_command -c 10 -d 2 "adb shell input keyevent 120" '''
        echo "    loop_command -c 5 -- adb shell ls /system"
        return 1
    fi

    # 静默模式下不显示详细信息
    if [ "$quiet" = false ]; then
        echo "开始循环执行命令: $command"
        echo "循环次数: $count (0表示无限循环)"
        echo "间隔时间: ${delay}秒"
        echo "按 Ctrl+C 停止执行"
    fi

    local counter=1
    while true; do
        # 如果指定了循环次数且已达到，则退出
        if [ $count -gt 0 ] && [ $counter -gt $count ]; then
            if [ "$quiet" = false ]; then
                echo "执行完成，共执行 $count 次"
            fi
            break
        fi

        # 显示执行信息（非静默模式）
        if [ "$quiet" = false ]; then
            echo "第 $counter 次执行: $command"
        fi

        # 执行命令
        eval "$command"

        # 检查执行结果
        if [ $? -ne 0 ]; then
            if [ "$quiet" = false ]; then
                echo "警告: 命令执行失败"
            fi
        fi

        # 增加计数器并等待
        counter=$((counter + 1))

        # 如果不是最后一次循环，则等待
        if [ $count -eq 0 ] || [ $counter -le $count ]; then
            sleep $delay
        fi
    done
}

# 压缩文件夹，pull出来
function adb_pull_my_() {
  local source=$1
  local myTmpPath="/bin/myTmp/"
  local tmpTar="/bin/myTmp/tmp.tar"
  #
  adb shell mkdir -p $myTmpPath
  adb shell "tar -cvf $tmpTar $source"
  adb pull $tmpTar .
  adb shell rm $tmpTar
  tar -xvf tmp.tar
}

# 压缩文件夹，push进去
function adb_push_my_() {
  local source=$1
  local myTmpPath="/bin/myTmp/"
  local tmpTar="/bin/myTmp/tmp.tar"
  # 压缩本地目录
  tar -cvf tmp.tar $source
  # 推送压缩文件到手机
  adb shell mkdir -p /bin/myTmp  # 在手机上创建临时目录
  adb push tmp.tar $tmpTar
  adb shell "tar -xvf $tmpTar -C  $myTmpPath"
  adb shell "chmod -R 777 /bin/myTmp/"
  # 删除手机上的压缩文件
  #adb shell rm $tmpTar
  # 删除本地压缩文件
  rm tmp.tar
}

# 压缩文件夹，push进去
function adb_push_tarfile_my_() {
  local source=$1
  local myTmpPath="/bin/myTmp/"
  local tmpTar="/bin/myTmp/tmp.tar"

  # 推送压缩文件到手机
  adb shell mkdir -p /bin/myTmp  # 在手机上创建临时目录
  adb push $source $tmpTar
  adb shell "tar -xvf $tmpTar -C  $myTmpPath"
  # 删除手机上的压缩文件
  #adb shell rm $tmpTar
}

function cp_my_() {
     rsync -v -r -h --progress "$1" "$2"     
     #- -----------> 变为 my_cp dir1 des2
}



function rm_my_() {
     mv  "$2"  ~/.local/share/Trash/files
     #//alias rm='mv --target-directory=~/.local/share/Trash/files'
}

function find_my_() {
     find "$1" "$2" "$3" -exec ls -la -h {} \;
     #//find "$1" -name "$2" -exec ls -la -h {} \;
     #// find  ./ -name "libmpfr.so.6"  -exec ls -la -h {} \;
}

function find_rm_my_() {
  find "$1" "$2" "$3" -exec rm -rf  {} \;
}

function tar_my_() {
    tar -cvf "$1".tar  "$1"
}

function untar_my_() {
    tar -xvf "$1"
}

function ls_my_() {
    ls -la -h
}

function du_my_()  {  #查看目录大小
    du -h --max-depth=1
}

function start_my_()
{
    ./myStart.bat
    echo ""
}

function sleep_pc_my_()
{
    rundll32.exe powrprof.dll,SetSuspendState 0,1,0
    echo ""
}

function restart_pc_my_()
{
    {
      docker pause my_container && \
      docker stop $(docker ps -a -q) && \   #全关
      echo "docker 关闭成功"
    } ||  {
      echo "docker 关闭失败"
    }
    sleep 4

    shutdown -r now   #立刻重启
    echo ""
}

function pause_my_()
{
    docker pause my_container2 
}

function unpause_my_()
{
    docker unpause my_container2 
}

function adb_win_my_()
{
    cp /drives/d/Users/Administrator/AppData/Local/Android/Sdk/adb.exe /drives/d/Users/Administrator/AppData/Local/Android/Sdk/platform-tools/adb.exe
}

function adb_linux_my_()
{
    rm -rf /drives/d/Users/Administrator/AppData/Local/Android/Sdk/platform-tools/adb.exe
}

function win2linuxPath_my_()
{
    # usage: my_win2linux_path "C:\Users\asus\Anaconda3"

    win_path=$1 # 脚本的第一个参数就是windows路径
    #win_path="C:\Users\asus\Anaconda3" # 一个示例路径

    tmp_path=${win_path/:/} # 将冒号删掉
    tmp_path=${tmp_path//\\/\/} # 将\\替换为/

    disk_id=${tmp_path:0:1} # 取出第一个字母，也就是C盘的C，冒号后面第一个0指的是从下标为0的地方开始提取，第二个冒号后面的1表示提取一个字母
    disk_id=$(echo $disk_id | tr [:upper:] [:lower:]) # 大写转小写
    #echo $disk_id

    other_path=${tmp_path:1} # 路径中除了磁盘以外的部分

    linux_path="/drives/"${disk_id}${other_path} # 需要将/mnt/接在路径最前方
    echo "windows path is "${win_path}
    echo "linux path is "${linux_path}
}

function linux2winPath_my_()
{
    #当前linux路径转win  #比如："./my_Command"
    curr_path=$(pwd)
    Input_path=$1  #
    echo $Input_path
    cd $Input_path

    explorer.exe .  #核心：通过explorer.exe 转换linux路径到win
    cd $curr_path
}

function sourceMappath_my_()
{
    # usage: my_win2linux_path "C:\Users\asus\Anaconda3"

    win_path=$1 # 脚本的第一个参数就是windows路径
    #win_path="C:\Users\asus\Anaconda3" # 一个示例路径
    echo $win_path
    python myOpenWinPath.py $win_path
    #python myOpenWinPath.py "I:\working_pan\Demo\AOSPsourceCode2_win\sourceroot\packages\apps\Launcher3\iconloaderlib\src\com\android\launcher3\icons\BaseIconFactory.java"
}


function tmux_history_my__()
{
    tmux capture-pane -pS -10000 > ~/tmux_history.txt && tmux clear-history
}


# 极其优秀：左侧：1、模糊搜索 2、提供搜索大纲 
#          右侧：3、高亮匹配  4、匹配结果绝对居中 5、无限大上下文（shift+上键可以完整浏览） 6、回车一键跳转 Vim 编辑
function grep_my_() {
    local target_file="${1:-$HOME/myfun_win.sh}"

    if [[ ! -f "$target_file" ]]; then
        echo "❌ 错误：找不到文件 '$target_file'"
        return 1
    fi

    export MYF_TARGET="$target_file"

    # 1. 把 fzf 的执行结果（你回车选中的那一行）存进变量 selected_line
    local selected_line=$(cat -n "$MYF_TARGET" | fzf --with-nth=2.. \
                               --preview-window='right:60%:wrap:+{1}-/2' \
                               --preview 'batcat --color=always --style=numbers --highlight-line {1} "$MYF_TARGET"')

    # 2. 判断用户是否真的选中了内容（防误触：如果用户按 Esc 或 Ctrl+C 退出，变量为空）
    if [[ -n "$selected_line" ]]; then
        # 3. 使用 awk 提取出隐藏在最前面的第一列内容（即纯数字的行号）
        local line_num=$(echo "$selected_line" | awk '{print $1}')
        
        # 4. 召唤 Vim，并利用 +行号 参数，瞬间瞬移到目标位置！
        vim +${line_num} "$MYF_TARGET"
    fi
}


# ==========================================
# 极客安全工具：高级混淆加密打包与解包 
# 特性：AES-256 强加密 + 终端内输入 + 零密码缓存 + 安全粉碎
# ==========================================

secure_pack_my_() {
    echo "linux 图形下shell环境执行"
    local TARGET_DIR="$1"
    # 如果提供了第二个参数就用第二个参数，否则默认名为 system_update.bin
    local OUTPUT_FILE="${2:-system_update.bin}"

    if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR" ]; then
        echo "❌ 错误：请提供一个有效的目录路径。"
        echo "用法: secure_pack <目录名> [输出文件名(可选)]"
        return 1
    fi

    echo "🔒 正在将 [$TARGET_DIR] 打包并使用 AES-256 强加密..."
    echo "⚠️  接下来 GPG 会在下方直接提示您输入密码，请输入并回车（输入时密码不可见）："

    # 执行打包和加密（加入了 loopback 强制终端输入 和 no-symkey-cache 禁用缓存）
    if tar -czf - "$TARGET_DIR" | gpg -c --pinentry-mode loopback --no-symkey-cache --cipher-algo AES256 -o "$OUTPUT_FILE"; then
        echo "✅ 加密并成功伪装为: $OUTPUT_FILE"
        echo "🗑️ 正在安全擦除原文件 (覆写 3 次)..."
        
        # 深度粉碎并删除原文件
        find "$TARGET_DIR" -type f -exec shred -uz -n 3 {} +
        rm -rf "$TARGET_DIR"
        
        echo "✅ 任务完成！原文件已彻底粉碎并删除。"
    else
        echo "❌ 致命错误：加密过程失败！已中止操作，原文件安全未动。"
        return 1
    fi
}

secure_unpack_my_() {
    local INPUT_FILE="$1"

    if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
        echo "❌ 错误：请提供一个有效的加密文件路径。"
        echo "用法: secure_unpack <加密的文件>"
        return 1
    fi

    echo "🔓 正在尝试解密并恢复 [$INPUT_FILE]..."
    echo "⚠️  请输入您打包时设置的密码（输入时密码不可见）："

    # 执行解密并解包（同样禁用了密码缓存）
    if gpg -d --pinentry-mode loopback --no-symkey-cache "$INPUT_FILE" | tar -xzf -; then
        echo "✅ 解压恢复成功！您的文件已重现。"
    else
        echo "❌ 解密失败。请检查文件是否损坏，或密码是否正确。"
        return 1
    fi
}

