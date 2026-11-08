#!/bin/bash

# 2024年7月21日

# source ~/myfun_win.sh   加入.bashrc文件

echo -e "hello,cg! this is myfunction.sh"
echo -e "please Enter： my_reStartVnc
                sync_myfunction_sh"


#################################独有部分####################################################




##################################独有部分######################################################
function command_he_() 
{
	# 获取当前脚本的文件名
	script_name="/home/chen.gang42/myfun_win.sh"

	# 使用 grep 和正则表达式查找函数定义，并打印函数名
	grep -E '^\s*function\s+\w+\s*\(\)' "$script_name" | while read -r line; do
	    # 提取函数名
	    function_name=$(echo "$line" | sed -E 's/^\s*function\s+(\w+)\s*\(\).*/\1/')
	    echo "$function_name"
	done		
}

function my_reStartVnc() 
{
        vncserver -kill :1
        vncserver -kill :2
        vncserver -kill :3
        rm -rf /tmp/.X1-lock
        vncserver :1 -localhost no -geometry=1920x1080
}

function my_he_2() 
{

    echo "
    	全局搜索：cat myfun_win.sh | grep obsi  ---->  更快，不用一级一级搜索
    "
    
   echo -e "=============sync relative:======================== \n
      sync_development_aosp12
      sync_development_aosp10"

	#  cmd window tracing start adb shell an root service call SurfaceFlinger 1025 132-1 &   screenrecord --time-limit-fi/sdo
	#  cmd window tracing stop s adb-shell su root service call Surfaceringer 1025-132 0
	#adb pull-/data/misc/wmtrace/wm trace.Winscope wil trace.winscope & adb purl /data/misc/umtrace/layers trace.winscope layers trace, winscope i
	#echo " =虚拟用:
	#  settings put global overlay display devices "1920x1080/320, secure"   am start display 4 com.example.myapplication/MainActivity 4diaplay Dr   dumpsys display I findet: "1000"
	#  input d 4 tap 250-300"
	#Bl  pm create-user profileof-0--managed-fenshen   to remove user 10
	#:   pm list users id:  am start-user-10-
	#DA:   am start user 20-display "com.example.myapplication/ MainActivity" #u10:   dumpays package com.tengent.mt findste installed-
	#9   dumpsys package com.tencent..at findstr installed-"
	#echo

	# #pid   ps-findst fly   pAT p 7209 pidi Tad shell pa AT F
	#动态标记(联合操作识别),线程维度:
	#  top-top: Shift+< El Shift+s Fl

}

function gdb_he_()
{
    echo -e ' # 保证特殊符号不被转译
        =========================so 加载============================
        1、add-symbol-file   ~/weston_install/lib/x86_64-linux-gnu/libweston-14/gl-renderer.so
        2、（优）在gdb环境外部加载so与file（目的：充分利用linux shell的 命令的模糊匹配）：
            gdb weston  \
                -ex "set confirm off" \
                -ex "add-symbol-file /usr/lib64/libweston-12/gl-renderer.so" \
                -ex "add-symbol-file /usr/lib64/libweston-12/drm-backend.so" \
                -ex "add-symbol-file /usr/lib64/libweston-12/wayland-backend.so"  \
                -ex "set args --config=/home/weston/tmp/weston.ini" \
                -ex "dir /home/weston/tmp/weston-12.0.2/libweston"  \
                -ex "dir /home/weston/tmp/weston-12.0.2/libweston/renderer-gl"  \  
                -ex "dir /home/weston/tmp/weston-12.0.2/libweston/backend-drm"  
                       
            sudo gdb attach 68374  \
                    -ex "set confirm off" \
                    -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/gl-renderer.so" \
                    -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/drm-backend.so" \
                    -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/wayland-backend.so"  \
                    
                    -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston"  \
                    -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/renderer-gl"  \  
                    -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/backend-drm" 

        3、所有so---加载某一路径下所有so（同时关闭确认对话）：
                SO_DIR="$HOME/weston_install/lib/x86_64-linux-gnu/libweston-12"  \
                GDB_CMDS="gdb weston -ex \"set args --config=/home/chen.gang42/weston_install/weston.ini\" -ex \"set confirm off\""  \
                for so_file in "$SO_DIR"/*.so; do    \
                    GDB_CMDS="$GDB_CMDS -ex \"add-symbol-file $so_file\""     \
                done    \
                eval $GDB_CMDS

        4、所有文件：
              gdb weston  \
                    -ex "shell find /home/chen.gang42/workingspace/wayland_code/wayland/src -type d -exec echo directory {} \; > /tmp/gdb_dirs.txt"  \
                    -ex "source /tmp/gdb_dirs.txt"
                    
        '

    echo -e '''
        =========================gdb命令大全============================
        线程相关：
               attach 7180    ---> detach
            1.查看进程：(gdb)info inferiors
            2.查看线程：(gdb)info threads           (lldb) thread list
              查看当前线程：                        (lldb) thread info
            3.查看线程栈结构：bt                    (lldb) 同
            4.切换线程：thread n（n代表第几个线程） (lldb) t 3 -------> thread select 3  
        查看指针指向的是具体基类实例(子类):  
                set p obj on     // 按照虚函数调用的规则显示输出
                set p pretty on  // pertty ----> 按照层次打印结构体
                p *this   打印对象                  (lldb) 同
        查看源代码： (gdb) l -------> list          (lldb) 同

        =========================控制============================
        启动：法一：先启动，再attach pid
	            法一_2:启动过程， 函数无法及时断点问题-----双断点： （1）代码中加入断点： raise(SIGSTOP)    #include <signal.h>
		                                                        （2）运行，大概率被各种 SIGSTOP   ---------> 止住
									（3）止住的情况下，加入 函数断点  --------> // 【】 优
									（4） handle SIGSTOP nostop
									（5）继续
              法二：1、gdb weston 2、设置断点 3、r
        设置断点：(gdb) b android::MediaPlayerService::Client::start       (lldb)b  android::renderengine::gl::GLESRenderEngine::drawLayersInternal  或者   breakpoint set -n   ...........
                        break myfile.c:25
                条件断点：b ../libweston/compositor.c:3650 if (buffer->width==250)

        查看所有断点：(gdb) i b   --> info breakpoints                   (lldb) breakpoint list
        删除断点：(gdb) d 2                                              (lldb) breakpoint delete 1
        使能断点：                                                      (lldb) breakpoint enable 1          disable 
        
        继续执行：(gdb)c  ---> continue              (lldb) 同
        继续执行100次：(gdb)c 100                    (lldb) 无？？？？
        
        执行下一行: (gdb)n ---> next                 (lldb) 同
                    (gdb) n 5  执行5行
        步入函数内部： (gdb)s  ---> step             (lldb) 同
        步出函数：     (gdb)f  ---> finish           (lldb)finish  ----->  thread step-out

        重复上一个命令：(gdb)Enter键                 (lldb) 同
        模糊匹配之前命令: ctrl + R
	
	某些信号，不终止程序  (gdb) handle SIGINT nostop
					SIGSTOP
					SIGSEGV   ------>  Segmentation fault 段错误
					SIGABRT   ------>  错误
        设置值：print x=4
        主动调用函数：(gdb) call function(args...)

        退出gdb:        (gdb)q                       (lldb) q  -----> quit
        参考：https://www.jianshu.com/p/80825b658f19
        
        
         =========================so 符号表============================
         so文件，符号信息查询：readelf -s example.so
    '''

   echo -e "=============aosp10进入gdb========================
        环境：source build/envsetup.sh  && lunch  aosp_redfin-userdebug
        linux adb连接手机: win: adbkit usb-device-to-tcp -p 7788 FA6930305260 
                         linux: adb connect host.docker.internal:7788

        手机必须： adb root && adb remount -------> 因为py脚本有copy东西到手机
        search PID: adb shell ps -ef | grep mediaserver
        linux侧: adb forward tcp:12345 tcp:12345 && adb shell gdbserver :12345 --attach pid1 （手机侧待调试的pid） or  gdbserver64  
                 gdbclient.py --port 12345 -p pid1
        breakpoint:  (gdb) b android::MediaPlayerService::Client::start  ------> 注意加namespace
        breakpoint:  (gdb) b  frameworks/av/media/libmediaplayerservice/MediaPlayerService.cpp:1072
      "
    echo -e "=============aosp14进入lldb========================

        手机必须： adb root && adb remount -------> 因为py脚本有copy东西到手机

        linux侧: adb forward tcp:12345 tcp:12345 
        手机上： adb shell "./data/local/tmp/lldb-server  platform --listen *:12345 --server" （其中，lldb-server来自./prebuilts/clang/host/linux-x86/clang-r450784e/runtimes_ndk_cxx/aarch64/lldb-server）
        linux侧：gdbclient.py --port 12345 -p pid1
      "
}


function gdb_(){
	# so路径
	SEARCH_PATH=/home/chengang/workingspace_disk2/westonProject/weston_install
	#源码路径
	DIR=/home/chengang/workingspace_disk2/westonProject/weston
	#GDB_CMDS="gdb weston -ex \"set args --config=/home/chengang/workingspace_disk2/westonProject/weston_install/weston.ini\" -ex \"set confirm off\"" 
	#执行的命令,可以是 gdb weston/  gdb attach /gdb ................
	GDB_CMDS="gdb $1 $2 $3 $4  -ex \"set confirm off\" " 
	
	
	SPECIAL_DIR=" -ex \"shell find $DIR -type d -exec echo directory {} \; > /tmp/gdb_dirs.txt\"  -ex \"source /tmp/gdb_dirs.txt\" "
	#echo $SPECIAL_DIR
	
	temp_file=$(mktemp)  # Create a temporary file to store the updated GDB_CMDS
	
	# 递归查找所有的 .so 文件
	find "$SEARCH_PATH" -type f -name "*.so" | while read -r so_file; do
	# 获取文件的绝对路径
	abs_path=$(realpath "$so_file")
	# 打印绝对路径
	echo "   -ex \" add-symbol-file $abs_path\""
	#GDB_CMDS="$GDB_CMDS -ex \"add-symbol-file $abs_path\""
	# 在gdb中添加符号文件
	#echo "$GDB_CMDS"
	done > "$temp_file"
	echo "$=========================="
	ADD_SO=$(cat "$temp_file")
	end_cmd="$GDB_CMDS$ADD_SO$SPECIAL_DIR"
	echo $end_cmd
	eval $end_cmd
}

#使用条件：因为环境变量冲突，只能分别起（即只能用attach方式）
function gdb_arm(){  
	# so路径
	SEARCH_PATH=/bin/myTmp/weston_install/weston_install
	#源码路径
	DIR=/bin/myTmp/weston-12.0.2
	#DIR=/bin/myTmp/weston-10.0.0
	#GDB_CMDS="gdb weston -ex \"set args --config=/home/chengang/workingspace_disk2/westonProject/weston_install/weston.ini\" -ex \"set confirm off\"" 
	#执行的命令,可以是 gdb weston/  gdb attach /gdb ................
	GDB_CMDS="gdb $1 $2 $3 $4  -ex \"set confirm off\" " 
	
	#生成源码目录文件
	find $DIR -type d -exec echo directory {} \; > /bin/myTmp/gdb_dirs.txt
	SPECIAL_DIR=" -ex \"source /bin/myTmp/gdb_dirs.txt\" "
	#echo $SPECIAL_DIR
	
	temp_file=$(mktemp)  # Create a temporary file to store the updated GDB_CMDS
	
	# 递归查找所有的 .so 文件
	find "$SEARCH_PATH" -type f -name "*.so" | while read -r so_file; do
	# 获取文件的绝对路径
	abs_path=$(realpath "$so_file")
	# 打印绝对路径
	echo "   -ex \" add-symbol-file $abs_path\""
	#GDB_CMDS="$GDB_CMDS -ex \"add-symbol-file $abs_path\""
	# 在gdb中添加符号文件
	#echo "$GDB_CMDS"
	done > "$temp_file"
	echo "$=========================="
	ADD_SO=$(cat "$temp_file")
	end_cmd="$GDB_CMDS$ADD_SO$SPECIAL_DIR"
	echo $end_cmd
	eval $end_cmd
}


function docker_he_()
{
    echo "=========================docker============================
        startDocker.bat
        my_start; my_sleep_pc; my_restart_pc
        my_pause
        my_unpause
        docker_build_save_load.bat

        docker images -a
        docker rmi ee7cbd482336
        docker ps -l
        docker pause 2619ca372120
        docker commit  7a0d4b22ae06 chengang/ubuntu16.04_aosp1200_r28:vnc_ok
        docker load -i  F:\VirtualMachine\Docker\ubuntu.tar

        docker_build_save_load.bat 替代:
            docker save  chengang/ubuntu16.04_aosp1000_r17:vnc_ok  -o  H:\docker_jarFiles\ubuntu16.04_aosp1000_r17_vnc_20221026.jar
            docker build --squash -t  chengang/ubuntu16.04_aosp1200_r28:as_ok2 .
    "
}

function pms_he_()
{
    echo '''=========================pms============================
    	   查---全部信息： dumpsys package com.byd.btsetting
		   查---安装包目录: dumpsys package com.demo.test | grep codePath  通过包名
		   查---某APP全部的activity： dumpsys package  | grep mediacenter | grep ctivity
		        同理：service、provider等
	  改：pm uninstall <package_name>
    '''
}

function android_he_()
{
   echo '''--------------真机环境信息------------------
           dumpsys activity activities | findstr Resumed
           getprop 文件：TODO
           编译时间：  getprop | findstr date 
           getprop ro.build.type --------> userdebug
           getprop ro.build.version.release  安卓版本14
           getprop ro.build.version.sdk
           cpu:  cat  /proc/cpuinfo     CPU的架构、cpu的名称、核心数
		'''

    echo '''=========================hwc dump(mtk)==============================
		adb shell mkdir /data/SF_dump && adb shell chmod 777 /data/SF_dump && adb shell setenforce 0
		adb shell setprop vendor.debug.hwc.dump_buf 1 && adb shell dumpsys SurfaceFlinger
		adb pull /data/SF_dump .  
    '''
	
	echo '''=========================SF级（合成级别）=============================
		改---强制SurfaceFliner全部走GPU合成： 法一：  禁止HWC合成： service call SurfaceFlinger 1008 i32 1   （仅限于mtk？）  允许：1->0
						      法二： 开发者选项 "禁用HW叠加"
						      -------> 反馈：dumpsys SurfaceFlinger --hwclayers 没有device
		查---layers dump：
			        dumpsys SurfaceFlinger | grep -A 40 "HWC layers"   
				或 dumpsys SurfaceFlinger --hwclayers
		查---高斯区域大小：dumpsys SurfaceFlinger | grep blurRegions
		查---合成类型：adb shell dumpsys SurfaceFlinger | grep "Display 0 HWC layers" 
		查---android 帧率：
			dumpsys SurfaceFlinger > dumpsf.log       在dumpsf.log中搜 FPS ring buffer
    '''

	echo '''=========================display级别=============================
	        屏幕尺寸：um size
		查看物理屏的像素密度dpi：
				dumpsys display | grep basedisplayinfo    -----> density 320 (160.0 x 160.0) dpi

		
		查---	display：dumpsys display
	       		数字id(根据大小): dumpsys display | grep mSupportedModesByDisplay -A 20       --------->    8 -> [{id=7, width=5120, height=1600,  ->  前面这个8是id！！！！！ 
			hash id(根据数字id)：         dumpsys SurfaceFlinger --display-id
			名字：dumpsys SurfaceFlinger --HWC | grep name
		TODO: dumpsys display > display.txt, DisplayDeviceinto. displayld

		虚拟display：
		    settings put global overlay_display_devices "1920x1080/320,secure" 
			am start --display 4 com.example.myapplication/.MainActivity (查diaplay1D:   dumpays display | findstr "1080" )
			input -d 4 tap 250 300
			bos的虚拟display：dumpsys bosdisplayservice --bosdislay
	  
		查---截图display：screencap -p /sdcard/app.png && adb pull /sdcard/app.png
			     指定display: screencap -p -d  4627039422300187648  /sdcard/app.png &&  adb pull /sdcard/app.png  <---dumpsys SurfaceFlinger --display-id 获取id
		查---录屏display：
			 adb shell screenrecord --display-id 4627039422300187648  --time-limit 6 /sdcard/demo.mp4 && adb pull /sdcard/demo.mp4 screenRecord.mp4  <---dumpsys SurfaceFlinger --display-id 获取id
			                        --bugreport 带时间（时间对齐）
				
    '''

    echo '''=========================am级（activity）==============================
		改---start/stop:
			am start com.byd.yunnian/com.byd.yunnain.MainActivity        关：am force-stop com.byd.yunnian
		
		查----栈顶： dumpsys activity activities | findstr Resumed
		查----am的栈（包括各个display上的）：
			am stack list

		查---所有服务：dumpsys activity  services   | findstr  ServiceRecord
                                     | findstr 包名   查看service绑定关系(搜对应包名或者service名)
		查----dumpsys activity  | findstr  LRU   ----> LRU顺序
    '''
	
	echo '''=========================wm级（window）==============================
		查 ---窗口touch区域： dumpsys window windows > windows.txt,   Window #, touchableRegion
		查 ---焦点窗口：dumpsys window | grep mCurrentFocus
		查 ---窗口各种属性 & 变化：winscope
    '''

	echo '''=========================控件级=========================
        控件dump：
	        法一： uiautomator dump -d 0  --compressed /data/local/tmp/uidump.xml & adb pull /data/local/tmp/uidump.xml
		法二： Layout Inspector --------> 比较好的AS版本： Android studio Flamingo 2022.2.1
	'''

    echo "=========================adb==============================
        
        查看服务：   service 1ist
        Di6切ivi:   switchadb *#9352*232#*
        Di6切ivi:   switchadb *#9352*232#* -s 0

        python systrace.py -t 5 -o mynewtrace.html sched freq idle am wm view binder_driver hal dalvik camera input res
        

        
        #adb shell cmd window tracing start &  -su-root service call Surfaceplinger 1025 i32 1 &&  

        # aub shell and window tracing stop's   no-coot service call Surfaceringer 1025 132 0
        #edb-poll /data/misc/umt.rece/vm trace winscope vm trace winscope & adh pull /data/misc/wmtrace/layers trace.winscope layers trace.wingcope & a
    "


    echo '''=========================dalvik=============================
    androidstudio断点调试，不显示进程：
    	adb shell setprop persist.debug.dalvik.vm.jdwp.enabled 1  ----> 设置这个属性默认开启虚拟机jdwp调试
    '''

	echo '''=========================分身=============================
		创建：  pm create-user --profileOf 0 --managed fensten ;   pm remove-user 10
		所有用户：  pm list users
		激活：  am start-user 10
		分身应用启动：  am start --user 10 --display 2 -n "com.example.myapplication/.MainActivity"
		维测：
			 ps -ef | grep u10   查看u10新增的进程有哪些？-----> 进程结构
    '''
}


function pms_he_()
{
    echo "=========================ime============================
        dumpsys package com.tencent.mm 或    | findstr SystemUI   或    | findstr apk 安装路径
    "
}

function sqlite_he_()
{
    echo "=========================launcher3的数据库(应用级别)：============================
    	进入数据库 sqlite3 /data/data/com.android.launcher3/databases/launcher.db
	查：
           列出所有表：  .tables   ----> 比如 Favorites 表
	   查看所有字段（表的结构）：  .schema Favorites
	   查看特定字段appWidgetId： SELECT appWidgetId FROM favorites  -------> 之后Ctrl +D 打印查询结果
	删：
	   删除 appWidgetId 为 131 的项：DELETE FROM Favorites WHERE appWidgetId = 131;  反馈（确认删除）： SELECT * FROM Favorites WHERE appWidgetId = 131;
    "
}

function animation_he_()
{
  关闭安卓动画：adb shell settings put global window_animation_scale 0; settings put global transition_animation_scale 0; settings put global animator_duration_scale 0
}

function log_he_()
{
    echo '''=========================安卓：logcat============================
		改-----缓存区大小: logcat -G 256MB
	                  查反馈:logcat -g
		改---Protolog开关: 
				wm logging enable-text WM_DEBUG_ORIENTATION

    	        查---异常日志： 
				logcat -b crash
				grep AndroidRuntim            或 FATAL
				grep "AnrManager: ANR"      ANR关键日志            


		查---进程过滤： logcat --pid=9388
		
		查---调用栈:  Log.e("longjing",Log.getStackTraceString(new NullPointerException()));

		查---events日志，wms ams:  logcat -b events | findstr "am_ wm_"  ----> 应用的生命周期 & window的周期

		注意点： adb shell "logcat | grep CHEN" ----> 而不是 adb shell logcat | grep CHEN，外部grep，会造成日志输出的实时性差！！！！
	=========================linux：journalctl============================
		 yocto 日志即用的 journalctl日志
			 journalctl -f _PID=
		 开机日志：
				 journalctl -b > boot.log
				 journalctl -o verbose > verbose.log    包含更多字段的日志（含systemd 启动服务的日志）
		 ms级别时间戳：  -o short-precise
	'''
}

function ime_he_()
{
    echo '''=========================ime============================
	改：
	    ime set com.sohu.inputmethod.sogouoem/.SogouIME       # 设置输入法
		ime enable com.sohu.inputmethod.sogouoem/.SogouIME   ---> disable   # 启用输入法
		ime reset       # 重置为默认输入法
	查：
		ime list -a -s    # 列出所有输入法服务
		settings get secure default_input_method  # 从设置获取默认输入法
		dumpsys activity  services          | findstr  ServiceRecord | findstr sogo  #获取运行时的输入法服务，确认有没有
		dumpsys input_method      #输入法的dump
		dumpsys window | grep -i input  # 获取输入法的窗口状态信息
		dumpsys SurfaceFlinger    # 获取输入法的窗口层级信息
    '''
}

function appWidget_he_()
{
    echo "=========================appWidget============================
	查看provider、widgets、host信息： dumpsys appwidget
	
	appwidgets.xml查看：
		abx2xml /data/system/users/0/appwidgets.xml /data/system/users/0/appwidgets-read.xml
	
	 // 赋予bindAppWidgetIdIfAllowed权限
	 appwidget grantbind --package   com.example.widgethostdemo --user 0
 
	 // revoke权限
	  appwidget revokebind --package   com.example.widgethostdemo --user 0
    "
    
}


            
function adb_he_() {
   echo -e "=============adb relative:======================== 
            win: adbkit usb-device-to-tcp -p 7788 FA6930305260 
            linux: adb connect host.docker.internal:7788
        
        wifi连接：0、局域网  1、手机侧：adb tcpip 5555 2、linux：  adb connect phoneIp:5555 

        只上传新的文件(对比文件的时间戳和大小)（Platform-Tools 29+）:
	         adb push --sync    .            /sdcard/Documents/note/doc_my
				  local_doc_my            remote_doc_my
	
	"
}

function linux_he_()
{
    echo "=========================环境信息=============================
	    内核版本： uname -r ; uname -a     Ubuntu version:   cat /etc/issue
	    shell获取当前进程pid: $$  
	    df  -a; df -T    /dev/cpu    显示文件系统类型
	    mount /dev/sdb1 /mnt/data        挂载文件系统
    "
    echo "=========================busybox=============================
    	adb  push  busybox    /bin/
    "
    echo '''=========================nohup============================
    	nohup /bin/sh -c 'source data/wayland_env_file && 2d-compositor' &
	nohup /bin/sh -c ' source /data/wayland_env_file  && export WAYLAND_DISPLAY=wayland-1  &&  weston-simple-egl' &
    '''


    echo "=========================重启=============================
	    机器级：reboot
	    用户级(进程所属的用户)：sudo pkill -KILL -u chen.gang42
	    服务级：sudo systemctl restart xrdp.service
    "
    
    echo "=========================包管理=============================
	    查询已安装的软件包：dpkg -l 
	                      apt list --installed
	    查询包管理有的包：apt-cache search kwin
    "

    echo "=========================fd=============================
	进程->所有fd(socket、buf、input节点)：  ------------> 可以查看fd泄漏
	    	法一：/proc/37374/fd/
	   	 法二：lsof -p 37374
    "

    echo "=========================Obsidian=============================
	    // # Obsidian 安装
	      flatpak install flathub md.obsidian.Obsidian
	      flatpak run md.obsidian.Obsidian
    "
}

function ps_he_()
{
    echo "=========================ps：process=============================
    进程树：  /system/bin/busybox pstree -p 0     内核进程+用户进程
    ps -ef  查看所有进程（其中C，cpu占比；TIME 进程使用的CPU时间；CMD：调用进程的命令）
    查看某一进程所有线程：实时 top -H -p PID       非实时：ps -T -p PID
        		
    	top       top -d 1   1秒刷新
    	ps -ef | grep weston | grep -v grep | awk '{print \$2}' | xargs kill -9    #查找并杀死

    实时top:
          top -H -p <PID> 查看某个进程<PID>显示的所有线程 （top 查看线程，H切换是否显示线程）
	  htop
	  
    根据进程名kill
    	# # Find and kill all processes
	pkill -f backend=virtual   kill掉 进程名含有 backend=virtual的所有进程

 	killall -s KILL  kwin_wayland_wrapper
 	killall -s KILL  weston
	
    启动： 
    	1、 .sh并行执行多条命令 && 防止shell关闭，启动的进程关闭
    	nohup /bin/sh -c 'cd /data/hubdemo/ && ./AVMDemo' &
    	nohup /bin/sh -c 'cd /data/pixeldemo/ && ./AVMDemo' &
	2、防止shell关闭，法二：Tmux
   优先级：
   	改： 1、启动时 nice -n -20 command  # -20 是最高优先级
	     2、运行时修改：
	                  renice -20 -p PID  # 为指定 PID 的进程设置最高优先级
			  renice -20 -u chen.gang42  # 为指定用户的所有进程设置优先级 --------> 可以偷资源！！！！
        查：top
   调度策略：
        查  chrt -p 18842   -----> policy: SCHED_RR   priority: 20
        改  .service: RT线程：CPUSchedulingPolicy=rr + CPUSchedulingPriority=20
                      普通分时调度：Nice=-20
   cpu 绑核:
          查：设置结果 taskset -cp 12412
	      运行时：进程的 ps    -p 12412 -o pid,psr,cpu,comm
	              进程所有线程的：ps -T -p 12412 -o pid,tid,psr,cpu,comm
          
   "
}

function input_he_()
{
    echo "=========================android=============================
	查---触摸区域：dumpsys input > input.txt     | findstr touchableRegion
	改---模拟输入（where--framework层注入）
		input -d 4 tap 250 300 
		input keyevent 26    -------> KEYCODE_POWER 休眠唤醒
	        input swipe <x1> <y1> <x2> <y2>	

    	查（A & L）：getevent
	维测log：
		dumpsys input > input.txt     | findstr touchableRegion
	查---轨迹线：尤其多指：
		settings put system pointer_location 1  //打开触摸指针功能
		settings put system show_touches 1      //打开触摸点功能	
	查---最近十个点inputFlinger的分发:   dumpsys input

    "

    echo "=========================linux=============================
	查（A & L）：getevent  -l   或者  getevent
	模拟输入：写节点 
	维测log:
	维测工具，尤其多指
		weston-simple-simpletouch -x XXX -y XXX  -w xxx -h xxx  -l 4  //启动到对应的测试屏幕上
    "
}

function secure_he_()
{
    echo '''=========================安卓Selinux：============================
		改-----禁止: setenforce 0
	                  查反馈:getenforce
		
		
			=========================linux apparmor：============================
		改-----策略的禁止：mount -o remount,rw /  && systemctl disable apparmor

		改-----：vim etc/apparmor.d/weston  ------> apparmor_parser -r /etc/apparmor.d/weston  更新规则 
			查反馈---是否生效：apparmor_status
			参考的提交： http://10.8.9.113/c/yocto-spm/meta/meta-mediatek-mt8678/+/538336
	'''
}

function disk_he_()
{
    echo '''========================= 路径文件大小  =============================
          du -sh *     文件大小  du -sh workingSpace
	  du_ 
    '''
    echo '''========================= 远程挂载sshf =============================
            增：
	    	                                                                                              local:
	    	sudo sshfs -p 2002 -o cache=yes,allow_other chen.gang42@10.8.9.141:/data/chen.gang42  /home/chen.gang42/workingSpace/chengang141/
	   	sudo sshfs -p 22 -o cache=yes,allow_other chen.gang42@10.82.254.8:/home/chen.gang42/workingSpace /home/chengang/workingSpace/chengang_station
		sudo sshfs -p 22 -o cache=yes,allow_other chen.gang42@10.82.254.169:/mnt/disk1/chen.gang42/ /home/chen.gang42/workingspace/workingspace_169

	    	virtualBox共享磁盘：sudo mount -t vboxsf  ubuntuShare  /home/chengang/workingSpace/AOSP
	    
	    	mount:    sudo mount  /dev/nvme0n1  /mnt/disk2
	    	umount:   umount /media/chen.gang42/disk2
	            如果busy时，  lsof  /media/chen.gang42/disk2
	    查： du -sh *
    '''

    echo '''===================== 磁盘->文件系统 =================================
        硬件磁盘查看： lsblk 
	挂载：mount /dev/sdb1 /test  把设备挂载到文件系统上
	
	
	查看目录对应的磁盘：
	     （1） mount | grep /tmp
	          tmpfs on /tmp type tmpfs (rw,nosuid,nodev,size=4403956k,nr_inodes=1048576) // tmpfs内存
	
	      （2） mount | grep /data/ 
	           /dev/sdc76 on /data/share/ type ext4 (rw,noatime,nodelalloc,noauto_da_alloc,data=ordered,inode_readahead_b  // ext4 --> 硬盘分区的类型
	ks=4096)
    '''

    echo '''======================== 镜像img ->文件系统 =============================
		增 sudo mount yocto_system.img system_test/        删    rm
		查    df -h
    '''
}

function mem_he_()
{
   echo '''========================  =============================
   查----RES（RSS）: top -b -n 1 -w 512 | grep -E "PID|split|weston|remotepre|virtual"
         PSS: dumpsys meminfo | grep -E "PID|split|weston"
	 RES把共享内存 全部都算给每一个process， 通常查看PSS 会比较准确
	 SHR内存:top -b -n 1 -w 512 | grep -E "PID|split|weston|remotepre|virtual"
         
	 swap: free -h
	 dma: cat /proc/dma_heap/all_heaps |  head -n 50
	 dma(查看特定应用具体使用情况)：cat /proc/dma_heap/all_heaps | grep splitscreen
   
   查 --- 堆、栈、共享库等内存占用情况（Android & Linux）
       procmem ---进程的：procmem pid
       procrank---系统的：


   '''
}

function cpu_he_()
{
    
    echo '''=============CPU基础信息===========================
    	 查看CPU型号和基本架构信息: lscpu   ------ Architecture:aarch64 ----> ARM 64位架构
	                                           On-line CPU(s) list: 0,1,4,5 ---> 当前在线CPU核心编号为0、1、4、5
						   Vendor ID: ARM ---> CPU厂商为ARM
						   Cortex-A510  ---> cpu型号
	 查 大小核：                 lscpu --extended     ----> MAXMHZ大的是大核

    '''
    echo "========================================
           显示进程消耗kdmips:  pmonitor 
	   显示CPU占用： top + 1   或者htop
        "

    echo "====================应该D300特有的=====================
    	目前我们CPU有8个核，默认是 3+5， Linux3个核（0/1/4） ，Android（2/3/5/6/7）
        cat /sys/devices/system/cpu/cpu*/online  可以看当前系统哪些CPU被使用（0是下线，1是上线）

	echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 设置CPU为性能模式 
	cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor  查： 看当前CPU的调度模式
	
	cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq 可以看当前核的最大频率
	cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq 看当前核的当前工作频率
	
	散热有问题CPU会强制降频
        "

    echo "====================双系统CPU向linux倾斜 & CPU performance=====================
	安卓侧关：
	echo 0 > /sys/devices/system/cpu/cpu2/online  &&  echo 0 > /sys/devices/system/cpu/cpu6/online


	linux侧开：
	echo 1 > /sys/devices/system/cpu/cpu2/online && echo 1 > /sys/devices/system/cpu/cpu6/online && echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor && echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor && echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor && echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
	systemctl stop vehicle
        "
    echo "====================单系统内，进程绑定大核=====================

        "
	
}

function gpu_he_()
{
    echo "====================Android=====================
    	adb shell dumpsys SurfaceFlinger | grep GLES        ------> GLES环境：GLES: Google (ARM), Android Emulator OpenGL ES Translator, OpenGL ES 3.0
	
	gpu信息： dumpsys | grep GLES   比如：GLES: Qualcomm, Adreno (TM) 530, OpenGL ES 3.2 V@384.0 (GIT@4a00b69, I4e7e888065) (Date:04/09/19)

	adb shell dumpsys gpu    gpu负载
        "

    echo "====================linux_MTK=====================
    	改：gpu定最高频: echo 0 >/proc/gpufreqv2/fix_target_opp_index   最高频988MHZ
    	
	查：GPU利用率:  cat /proc/mtk_mali/gpu_utilization
	    gpu loading: cat /proc/gpu_mali/gpu_loading
        "
	
    echo "====================linux_x86=====================
    	lspci | grep -i vga   ------->  17:00.0 VGA compatible controller: NVIDIA Corporation Device 1ff2 (rev a1)
							https://admin.pci-ids.ucw.cz/read/PC/10de/2208 -----> 输入 1ff2，显示T400，即是型号
	                             参考：https://blog.csdn.net/qq_28790663/article/details/123741068
        "

}

function network_he_()
{
    echo "=========================开启hotspot============================mv=
	    sudo sudo nmcli device wifi hotspot
    "
    echo '''=====================网络===============================mv==
    	开启hotspot: sudo sudo nmcli device wifi hotspot
	设置代理：1、能ping通 代理IP
	          2、Terminal配置：
			declare -x ALL_PROXY=\\"socks://192.168.1.4:10812/ \\"
			declare -x HTTPS_PROXY=\\"<http://192.168.1.4:10813/> \\"
			declare -x HTTP_PROXY=\\"<http://192.168.1.4:10813/> \\"
			declare -x all_proxy=\\"socks://192.168.1.4:10812/ \\"
			declare -x http_proxy=\\"<http://192.168.1.4:10813/> \\"
			declare -x https_proxy=\\"<http://192.168.1.4:10813/> \\"
	测试 HTTP 端点是否可访问:
	      curl -I http://hub.byd.com:9081/
    '''
}

function vim_he_(){
   echo '''======================== vim_he_ =============================
         改：i
	 查：/  -------> 1、enter 2、n(next)
         复制 & 粘贴：1、v 模式 2、y 复制(yy复制一行) 3、p 粘贴 
   '''
}

function systemctl_he_()
{
    echo '''=========================即Service=============================
	    service配置文件定义的目录：sudo cp -r connectA.service /lib/systemd/system/

	    重新加载服务文件 ---> 修改service配置文件后，要重新加载
	    	sudo systemctl daemon-reload

	    设置：
	    	手动启动服务：systemctl start service_name     停止stop    重启restart
	    	开机自启设置：systemctl enable service_name      禁止开机自启disable

	    查看：
	    	系统上已安装的服务 systemctl list-unit-files  
	    	开机启用的服务  systemctl list-unit-files | grep enabled       禁用disabled

	    查看运行时：
	    	显示所有已启动的服务（运行时） systemctl list-units --type=service   
	    	查询某服务状态（运行时）：systemctl status service_name   --->  1、启动是否成功 2、会有启动失败的原因
	    
	    启动失败,查看原因：
	        systemctl status service_name  or  journalctl -xeu baios_gausswallpaper.service
		真正的错误日志: journalctl -u baios_splitscreen --no-pager -n 100
	    
	    日志过滤：_PID=  pid过滤
	              -u baios_splitscreen  --------> 优：按照服务过滤！！！！重启进程也没关系！
                      -o short 类似默认，更紧凑
		      -o short-precise 
                      -o verbose 显示所有字段，调试神器
                      -o verbose | grep -E "(MESSAGE|_TID)"  显示TID


    '''
}

function tmux_he_()
{
    echo '''=========================会话session（类似shell）=============================
	    新建：     tmux new -s s1    
	    查看所有会话： tmux ls 

	    attach上： tmux  a -t s1       
	    退出会话：Ctrl+b d   ------->  注意：进入shell后，会话还在运行
	    kill会话： tmux kill-session -t  my_S 

    
    ========================= 窗口内操作=============================
	    新建窗口： ctrl+b  c
	    切换窗口：ctrl+b  1    ----> 切换窗口是会话级的!!!(所有shell一起变！！！)
	    列出所有会话 Ctrl+b s
	    切换会话：              + 上下键

    
    ========================= 窗格plane（分屏，优秀！！！）=============================
	    ctrl+b %  划分左右两个窗格
	    ctrl+b \"  划分上下两个窗格
	    kill-plane 命令：Ctrl + b，然后按 x
	    
	    ctrl+b Up|Down|Left|Right  切换pane （ctrl+b按一次）
	    ctrl+b Up|Down|Left|Right  调整pane大小 （ctrl+b长按）
	    文本复制模式： ctrl+b [    上下左右键来滚动查看历史输出信息！（完全同shell）
	    		退出查看模式，按下q/esc即可
    '''
}

function file_he_()
{

    echo "=========================zip=============================
       压缩：
	    zip： zip -r -y local_E/aosp_android1200_r28.zip aosp_android1200_r28
	    unzip local_E/aosp_android1200_r28.zip  -d  .   

	    7z a  -p myfolder.7z   laji2/
	    7z x  myfolder.7z
 
	    tar -cvf  tmp.tar  ./dir1
	    tar -xvf tmp.tar  解压缩

	    
	    unrar x Imagine_820804.rar  解

	    mv 移动：mv old_name new_name/    ----> new_name/old_name
	    改名：mv old_name new_name     ----> 本质，也是移动，覆盖式移动
	        -----> 不需要消耗时间

	    文件转换：dos2unix "$file"
	             （优）转换当前目录下所有文件：find . -type f -exec dos2unix {} \;
		     
		.tar.gz  解压:tar -xzvf filename.tar.gz -----> windows同样命令
				 压缩：tar -cvzf file_name.tar.gz "path"
			
		查 ---- 唯一标识: md5sum  file
		改----拆分&组合：
			   split -b 100m large_.zip large_part_
			   cat large_archive_part_* > combined_large_archive.zip

    "
    
    echo '''=========================查找 & 显示文件=============================
    	按照文件名查找：find
	查找所有文件（文件夹） find ./ -type f                  find ./ -type d
	查找内容：grep --color  或者 vim中/
	              #双过滤: | grep 7209 | grep Render
                      -v ：反向选择
		      -E "A|B|C"  正则，同时匹配多个
		      md 文档的结构：tree ./ -L 4 | grep -E -v "png|assets|webp|txt" > dagang.txt
        实时监控文件增长：  tail -f  log.txt  ——> 极优：非常适合输出日志（实时性）            可以解决看不到tty下的日志
	               多个文件同时监视：tail -f file1 file2
	显示文件 cat
	清除文件内容： > log.txt       （极优）  避免直接删除，因为重新创建是另一个文件了（notePad++会出错）
	
	查找后，删除：
	    find ./ -name "*.rej"  -exec rm -rf {} \;
    '''
    
    
    echo '''=========================匹配文件内容=============================
    grep -A 30 "HWC layers"        ------>  针对性强（且有上下文！！！！）  A---after

    '''
    
    echo '''=========================软链接=============================
    ln  -s   /home/chengang/workingspace/andriod1400_r28/out    /home/chengang/workingspace_disk2/out_andriod1400_r28
    	           真实                                                     软链接

    '''
    
    echo "=========================正则=============================
    同时含有字符串：  ^.*sendAccessibilityEvent.*event.*$
    查找：grep   “baidu*”  -nr  ./       ----> 注意：搜索so内容： 必须是字符串常量（不可搜代码的变量名）！！！！！比如log里的内容
          find  ./   -name  "View*"
    "
    echo "=========================so文件=============================
    	strings   libweston.so  |  grep   bos  ----> 注意：搜索so内容： 必须是字符串常量（不可搜代码的变量名）！！！！！比如log里的内容
	查找加载的so: lsof -p pid
	
    "
    
    echo "=========================so文件=============================
    	strings   libweston.so  |  grep   bos  ----> 注意：搜索so内容： 必须是字符串常量（不可搜代码的变量名）！！！！！比如log里的内容
	查找加载的so: lsof -p pid
	
    "
    
    echo "=========================fd=============================
		查---进程使用的fd(比如：socket使用的、mmp使用、dma使用的)：
				ls -la  /proc/8546/fd    8546进程号
    "

    echo "=========================传输=============================
	 ftp下载2（Linux）---优： 
		1、登录：lftp -u ftpread ftp://10.8.9.220
		  密码:dpcread@126
		2、cd DiLink300F/SOC/denza/gas
		寻找对应版本61.1.1.2601190.1
		find . | grep "61.1.1.2601190.1"
		3、下载（直接将其下载到当前的本地目录）
		cd /DiLink300F/SOC/denza/gas/1for3/Dev/user/Di300F_USER_SIGN_D0767_202601190108/61.1.1.2601190.1/FLASH_BIN
		lftp:/> get Di300F_USER_SIGN_D0767_202601190108_Q0001.tar.gz
	ftp下载1（Linux）：
		wget ftp://ftpread:dpcread%40126@10.8.9.121/DiLink300/U8L/D300/ZK/Feature/dev-1015/user/Di300_S0119_USER_SIGN_202410240257/FLASH_BIN/Di300_USER_SIGN_S0119_202410240046_Q0441.zip
    		其中，%40代表 @
	from --> 2   (local -> remote):
	    scp -r Dli.tar  nong.jingxin@10.82.254.194:/home/nong.jingxin/code/chengang      
            scp -r   EM_code.tar    chen.gang42@10.8.9.141:/data1/chen.gang42/workingspace
	from --> 2   (remote->local):
	    scp -r chen.gang42@10.82.254.8://home/chen.gang42/workingspace/versions/Di300_S0193_USERDEBUG_SIGN_202412300108  ./
	    scp -r wang.yanhui7@10.82.254.8://mnt/disk2/wang.yanhui7/auto8678p1_64_hyp_yocto_alps_20241212-152709  ./ 
    "
 
    echo "=========================大文件============================
    	1、截取:
	截取前10MB（前100行.......）： head -c 10485760 largefile.txt > first_10M.txt        10MB =  10*1024*1024 = 10485760
	
	截取后10MB： dd if=largefile.txt of=last_10M.txt bs=1M skip=2303    --------> 减去10，便是读的起点
									2313M 的获取： stat -c "%s" test.log | awk '{print $1/1024/1024 "M"}'
  
	2、split 大文件:
           split -b 100m large_archive.zip large_archive_part_	
	   cat large_archive_part_* > combined_large_archive.zip
									
									
   "
}

function project_he_()
{
    echo '''-------------------------------ST2-------------------------------------------- 
         git push ssh://chen.gang42@10.8.9.113:29418/platform/frameworks/native  local_push:refs/for/D300/g-14/sqc1/dev
    '''
  
    echo '''-------------------------------8676, B-------------------------------------------- 
         cd /mnt/disk1/chen.gang42/MT8676/alps && source build/envsetup.sh && export OUT_DIR=out_sys && lunch sys_mssi_auto_64_cn_armv82_car_wifi_vm-userdebug && make surfaceflinger
    '''
    echo "-------------------------------DI5.1：MTK_D9000，aosp13(方程豹腾势) -------------------------------------------- " 
    echo "python vendor/mediatek/proprietary/scripts/releasetools/split_build_he_lper.py --ota  --run full_spm8673p1_64-userdebug --vf-path ../ap_vendor/ --fission-system 1for3 --byd-car-series denza " 
    echo "source build/envsetup.sh && export OUT_DIR=out_sys && lunch sys_mssi_spm_64_cn_armv82-userdebug && make update-api -j64  && make framework-minus-apex"  
    
    echo "-------------------------------di5:Qualcomm_7325，安卓12()-------------------------------------------- 
        repo init -u ssh://chen.gang42@10.8.9.113:29418/Di5.0/manifest -b dilink5.0_android12_dev -m manifest_dev_other.xml;repo sync -c -j32
        source build/envsetup.sh;lunch qssi-userdebug  denza;make update-api;./build.sh dist --qssi_only && 删除oat，arm，arm64
        ftp://10.8.9.121/Qualcomm_7325_Di5.0/Release_to_XA/Release/dilink5.0_android12_dev/denza/Di5.0_S3410_20230620/canfd/"
    echo "-------------------------------di6: Qualcomm_8475,安卓12(U8)-------------------------------------------- "
    echo "     repo init -u ssh://chen.gang42@ghydpc-gerrit-slave.byd.com:29418/Di6.0/manifest -b dilink6.0_dev -m manifest_dev_other.xml"
    echo "     source build/envsetup.sh && lunch qssi-userdebug && repo sync -c -j16  &&  cd ap_target  &&  ./di6_ap_build.sh -s all -nosign  && cd ./.."
    echo "     ftp://ghydpc-ftp.byd.com/Qualcomm_8475_Di6.0/Release_to_XA/Release/dilink6.0_dev/1for2/Di6.0_S0192_20230626 " 
    echo "-------------------------------di6-fse:rk_3588，主机同di5 fse安卓12(U8副驾)-------------------------------------------- " 
    echo "     source build/envsetup.sh  && lunch rk3588_s-userdebug yangwang LOCAL
               ftp://10.8.9.121/rk3588_Di6/Release_to_XA/Release/fse6.0_mp230526_dev/Di6.0_FSE_S2068_20230904/canfd/
               " 
    echo "-------------------------------di6-r4:Qualcomm_8475，安卓12(U9,u9没有副驾)-------------------------------------------- " 
    echo "     source build/envsetup.sh  && lunch qssi-userdebug R4
               ftp://10.8.9.121/Qualcomm_8475_Di6.0/Release_to_XA/Release/dilink6.0_multi_display_user_dev/" 
    echo "-------------------ries_main_dev,aosp12 + rk3588: ---------------------------------------"
    echo "     repo init -u ssh://chen.gang42@ghydpc-gerrit-slave.byd.com:29418/rk3588/manifest -b ries_main_dev -m manifest_dev_other.xml"
    echo "     source build/envsetup.sh && lunch rk3588_s-userdebug LOCAL && make update-api  && ./build.sh -AUCKuom
              ftp://10.8.9.121/rk3588_RIES/Release_to_XA/Release/ries_main_dev/yangwang/RIES_S0138_20230906/canfd/
            "
    echo "-------------------fse5.0主干  aosp12 + rk3588_main_dev: ---------------------------------------"
    echo "     ftp://10.8.9.121/rk3588_Di5/Release_to_XA/Release/rk3588_main_dev/denza/Di5.0_FSE_S1039_20230628/canfd/"
    echo "-------------------fse5.0_mp230606_uxe_dev编译: ---------------------------------------"
    echo "     全编：source build/envsetup.sh;lunch rk3588_s-userdebug denza LOCAL;make update-api;./build.sh -AUCKuo Di5"
    echo "source build/envsetup.sh && lunch rk3588_s-userdebug denza LOCAL"
    echo "ftp://10.8.9.121/rk3588_Di5/Release_to_XA/Release/fse5.0_mp230606_uxe_dev/denza/Di5.0_FSE_S2002_20230615/canfd/"  
    echo "编译结果：out/target/product/rk3588_s/system/framework/"  
    echo "-------------------应用编译: make -j MediaCenter ---------------------------------------"
    echo "-------------------Bos---------------------------------------
	  单编安卓： source build/envsetup.sh && export OUT_DIR=out_sys && lunch sys_mssi_auto_64_cn_armv82-userdebug

            "

    echo "-------------------Bos---------------------------------------
            repo init -u ssh://chen.gang42@10.8.9.109:29418/BOS/MT8678/bos/manifest -b Di300 -m bos_Di300.xml   -----> git fetch切换dev分支
            git push bos HEAD:refs/for/Di300
            git push bos HEAD:refs/for/dev 
            "

    echo "各种jar：make framework-minus-apex -j32  && make services -j32 && 删除oat，arm，arm64  && make SystemUI"
    echo "         make framework-res -j16"
    echo "         cd ./frameworks/base/packages/SystemUI && mm
                   cd ./frameworks/native/libs/gui && mm     ----> libgui.so
                   "

    echo -e "=============aosp relative:========================
      clion cmakelist:  export SOONG_GEN_CMAKEFILES=1  && export SOONG_GEN_CMAKEFILES_DEBUG=1
      aosp10: source build/envsetup.sh  && lunch  aosp_sailfish-userdebug
      aosp12: source build/envsetup.sh  && lunch  aosp_redfin-userdebug && make framework-minus-apex -j64 && make services -j64
      aosp12: source build/envsetup.sh  && lunch sdk_x86_64
      emulator_X86：python ./../local_E/aosp_android1200_r28/frameworks/copyLocal2remote.py && source build/envsetup.sh && lunch sdk_x86_64 && make framework-minus-apex -j18 && make services -j18
             cp out/target/product/emulator_x86_64/system/framework/framework.jar ./../local_E/push_framework/ && cp out/target/product/emulator_x86_64/system/framework/services.jar ./../local_E/push_framework/
      emulator模拟器：emulator  -writable-system -memory 8000
      arm: python ./../local_E/aosp_android1200_r28/frameworks/copyLocal2remote.py && source build/envsetup.sh  && lunch  aosp_redfin-userdebug && make framework-minus-apex -j18 && make services -j18 && cp out/target/product/redfin/system/framework/framework.jar ./../local_E/push_framework/ && cp out/target/product/redfin/system/framework/services.jar ./../local_E/push_framework/
      cp -r frameworks/base/* ./../local_E/aosp_android1200_r28/frameworks/base/
      "
    echo -e "=============更改编译输出目录========================
        方一： export OUT_DIR=/home/chengang/workingspace/andriod1400_r28/out2  -----> 缺点：只能编译aosp；只能在工程目录下
        方二（万能）：ln -s    /home/chengang/workingspace/andriod1400_r28/out    /home/chengang/workingspace_disk2/out_andriod1400_r28
    "
}

function kwin_he_()
{
    echo 
        "
    =========================ps：process status=============================
    plasma版本：plasmashell --version
    effects: adb push kwin4_effect_open_close_kinetic  /usr/share/kwin/effects/

    qdbus命令大全： https://gist.github.com/srithon/3cd297bdfdd157c0a7e00ff1aeb2690c
    窗口信息： qdbus  org.kde.KWin   /KWin   queryWindowInfo  同时点击窗口
    qdbus org.kde.KWin /ShapeCornersEffect
        method QString org.kde.kwin.ShapeCornersEffect.get_window_titles()  ----> 所有窗口
        signal void org.freedesktop.DBus.Properties.PropertiesChanged(QString interface_name, QVariantMap changed_properties, QStringList invalidated_properties)
        method QDBusVariant org.freedesktop.DBus.Properties.Get(QString interface_name, QString property_name)
        method QVariantMap org.freedesktop.DBus.Properties.GetAll(QString interface_name)
        method void org.freedesktop.DBus.Properties.Set(QString interface_name, QString property_name, QDBusVariant value)
        method QString org.freedesktop.DBus.Introspectable.Introspect()
        method QString org.freedesktop.DBus.Peer.GetMachineId()
        method void org.freedesktop.DBus.Peer.Ping()
        
    启动应用：su kde
             kstart5  plasma-settings   （resourceName来源：qdbus  org.kde.KWin /KWin queryWindowInfo中的resourceName）
             
    effects列表：qdbus  org.kde.KWin   /Effects   org.kde.kwin.Effects.listOfEffects
    动效开启配置：kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled true   // -----> 来源于metadata.json或者环境中查询
                 qdbus org.kde.KWin /KWin reconfigure 
                持久化： /home/kde/.config/kwinrc 
    其他动效： kwriteconfig5 --file kwinrc --group Plugins --key kde-tiling-on-dragEnabled true 

    //plasmashell临时干掉的方法：
        方法一：修改执行命令，干掉进程 mv /usr/bin/plasmashell /usr/bin/plasmashell_bos   
        方法二（优）：plasmashell --replace  以及  cTRL+ c
                plasmashell --replace   恢复    
    "
}

function git_he_()
{
    echo '''
     ====================repo=====================
        统一切换分支：repo start <branch_name> --all  
        从某个分支，拉取用新分支：  git checkout -b branch2 branchOrigin
  
     ====================git=====================
        clone:  
	      git clone ssh://chen.gang42@10.8.9.109:29418/bos/frameworks/window/windowmanager
	                参数：-b dev  --single-branch   只下载一个分支（大量省磁盘）
			       --depth 1    只保留一个git记录（大量省磁盘）
        #获得某个分支所对应的远程分支
        git rev-parse --abbrev-ref --symbolic-full-name @{u}
        export a=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
	
	git branch --set-upstream-to=remotes/bos/dev  local/tmp_dev  将一分支跟踪到 某个远程分支

        git fetch -v --progress "origin"
        git log-graph
        git rev-parse --abbrev-ref--symbolic-full-name @{u}
        dos2unix unix2dos filename
        git clean -d -fx
        git checkout -b feature/master_enterprise2 remotes/origin/master
        push： git push -u origin feature/master_local:main -f; 本地分支：远程分支获取：git branch -a
               git push origin HEAD:master
	

      =========同步远程代码===============
        git branch -a 看不到有些分支时：git pull
        git pull --rebase   --> 优：先同步远程节点，再apply本地新增的commit（挪后）  （类似于repo sync 的同步）
        git pull （非优：本地有commit节点时，会自动有merge的一个节点）
        git fetch（只获取，没有merge）
        
      =============报错===============
        1、 ERROR: commit 1fd241d: missing Change-Id in message footer
	       gitdir=$(git rev-parse --git-dir) && scp -p -P 29418 chen.gang42@10.8.9.109:hooks/commit-msg ${gitdir}/hooks/
         

          =========解决冲突， pull、 am 、 pick===============
   	始终保证自己的代码在最后一个节点：（1） commit本地修改 （2）reset到HEAD^ (3) git pull (4)pick回自己的修改

        查看冲突状态： git branch -a  ------> 查看分支是不是rebase、am、pick状态
	              git status
	
	强制保留：  git checkout --ours fileName      保留本地
	           git checkout --theirs fileName     
   	解决完冲突后： git add  + git commit
	
        
     ===============commit===============
        git commit   ----> 冲突解除后，操作
        git commit -m "TraceNo.:REQ20220"
        git commit --amend --no-edit ----->   不会弹出commit message (reusing the previous one)
        本地无分支：git push ssh://chen.gang42@10.8.9.113:29418/rk3588 HEAD:refs/for/rk3588_main_dev
	git remote set-url origin ssh://10.8.9.113:29418/yocto-spm/src/kernel/linux/v6.6_mt8678/co_device_module
	git push origin HEAD:refs/for/D300/y-5/sqc4/dev

        本地有分支：git push ssh://chen.gang42@10.8.9.113:29418/rk3588 feature/push_branch_0:refs/for/rk3588_main_dev
                    git push ssh://chen.gang42@10.8.9.113:29418/yocto-spm/meta/meta-mediatek-mt8678  local_D300_y-5_sqc4_dev_2:refs/for/D300/y-5/sqc4/dev
		    本地无分支：git push ssh://chen.gang42@10.8.9.113:29418/yocto-spm/prebuilt/graphics/mali/valhall HEAD:refs/for/mt8676/y-5/dev
	删除某个commit: git rebase -i 9fd15a8880fc41290d7dc^  修改pick为drop
         commit: git rebase -i HEAD~4 s
        任意调整 commit顺序、任意合并: git rebase -i commitID, id之后的所有commit（不含）  https://www.jianshu.com/p/e6350f0e9639
			             （1） squash操作： 第一个pick不修改；修改其他pick为squash 或 s
				     （2） 任意调整 commit顺序：调整pick的顺序  
				     (3) d, drop   
	
     ===============patch & apply===============
        git format-patch commit_id -x   [, commit_id]  向前数x个
        git format-patch ID1^..ID2   ---> [ID1, ID2]            默认多个文件
                                   --stdout > all_patches.patch     一个文件

        git apply --stat 0001-CR-double-RIES-3190.patch
        git apply --check 0001-CR-double-RIES-3190.patch
        
	 
	git am失败，查看具体哪里冲突 + 合入无冲突的：
		git apply --reject 0001-CR-double-RIES-3190.patch （次之，git am --signoff 0001-CR-double-RIES-3190.patch）
		注意：需要在git 根目录 apply！！！！  <----- 查询：git rev-parse --git-dir
	解决冲突后： git add   file1 ；   git am  --continue
	apply 与 am 区别：am 会自动创建提交记录(apply 不会)

	改变git仓的根：git apply --reject --directory=source/weston-12.0.2/ ./../0040-refine-screenrecord-server-and-background-transparent.patch
	
     ===============cherry-pick===============
        git cherry-pick  ID1 ID2
        git cherry-pick ID1^..ID2   ---> [ID1, ID2]
	
     ==============技巧===============
        技巧：差异多用 分支去承载
	'''
}

function weston_he_()
{
    echo '''====================push so && code=====================
        # so 
        adb push ./12.0.2/image/usr/lib64/libweston-12.so.0.0.2  /usr/lib64/  && \
        adb push ./12.0.2/image/usr/lib64/libweston-12/*  /usr/lib64/libweston-12/  && \
        adb push ./12.0.2/image/usr/lib64/weston/*  /usr/lib64/weston/ && \
        # source code 
        adb shell mkdir -p  /home/weston/tmp/      && \
        adb push ./12.0.2/weston-12.0.2  /home/weston/tmp/   && \
        adb push  ~/out/weston.ini  /home/weston/tmp/
        '''

    echo '''====================gdb=====================
       gdb weston  \
            -ex "set confirm off" \
            -ex "add-symbol-file /usr/lib64/libweston-12/gl-renderer.so" \
            -ex "add-symbol-file /usr/lib64/libweston-12/drm-backend.so" \
            -ex "add-symbol-file /usr/lib64/libweston-12/wayland-backend.so"  \
            -ex "set args --config=/home/weston/tmp/weston.ini" \
            -ex "dir /home/weston/tmp/weston-12.0.2/libweston"  \
            -ex "dir /home/weston/tmp/weston-12.0.2/libweston/renderer-gl"  \  
            -ex "dir /home/weston/tmp/weston-12.0.2/libweston/backend-drm"  


        gdb weston  \
            -ex "set confirm off" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/gl-renderer.so" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/drm-backend.so" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/wayland-backend.so"  \
            
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston"  \
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/renderer-gl"  \  
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/backend-drm"  
        
        sudo gdb attach 68374  \
            -ex "set confirm off" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/gl-renderer.so" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/drm-backend.so" \
            -ex "add-symbol-file /home/chen.gang42/weston_install/lib/x86_64-linux-gnu/libweston-12/wayland-backend.so"  \
            
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston"  \
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/renderer-gl"  \  
            -ex "dir /home/chen.gang42/workingspace/wayland_code/weston/libweston/backend-drm" 
            
            
            -ex "set args --config=/home/weston/tmp/weston.ini" \
	    
	arm环境中：
	gdb  weston  \
		-ex "set confirm off" \
		-ex "add-symbol-file /usr/lib64/libweston-12/gl-renderer.so" \
		-ex "add-symbol-file /usr/lib64/libweston-12/drm-backend.so" \
		-ex "add-symbol-file /usr/lib64/libweston-12/wayland-backend.so"  \
		-ex "set args --modules=systemd-notify.so  --log=/tmp/weston.log --debug --logger-scopes=log,drm-backend" \
		-ex "dir /bin/myTmp/12.0.2/git/libweston"  \
		-ex "dir /bin/myTmp/12.0.2/git/libweston/renderer-gl"  \
		-ex "dir /bin/myTmp/12.0.2/git/libweston/backend-drm"	    
       
        '''
        
        
    echo "====================环境变量=====================
    	环境信息：  getprop | grep date
        export   WAYLAND_DISPLAY="wayland-1"
	
	配置： vi /etc/xdg/weston/weston.ini
        "
	
        
    echo '''====================debug=====================
    	
        run:  rm -rf log.txt && weston --idle-time=0 --debug --log=log.txt
        drm日志： --logger-scopes=log,drm-backend       修改 vi /usr/lib/systemd/system/weston.service
	--idle-time=0 设置为 0 意味着禁用空闲时间，即不会进入空闲状态

	避免导入so后，重启机器：
	   sync && /usr/bin/weston --modules=systemd-notify.so --socket=wayland-0  --log=/tmp/weston.log  --logger-scopes=log,drm-backend
	日志动态开关：echo 0x00000008 > /data/weston/.local/weston_log_sign    0x00000008 drm-backend日志    0x00000020  scene-graph日志
	             #define ENABLE_TRACE 						0x00010000
		     #define ENABLE_SCOPE_DRM_BACKEND		                 	0x00000008
                      render                                                            0x00000080
		     组合 0x00010008
        weston-debug scene-graph   ----> dump  surfaceFlinger
                     scene-graph

        export WAYLAND_DEBUG=1   -----> 非常有用：能看到client连weston的过程（client侧日志）
	
	测试demo： weston-simple-bossurface -n "1" -l 2 -R 100       l:   2 below  3 normal  4 above  5 top  6 top_ui  7 lock
	          weston-terminal
		  
    	connector处录屏：  modetest -c  （1）查看connect 34 （2） 宽高  https://eservice.mediatek.com/eservice-portal/issue_manager/update/142608836
	    """ 中控：gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true ! "video/x-raw,format=BGRA,width=1728,height=1888,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4  """
	    """ 仪表：gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen50 do-timestamp=true ! "video/x-raw,format=BGRA,width=3840,height=720,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_bitrate=8000000,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4  """
	
	截屏：
	    GPU截屏：weston-screenshooter           weston-screenshooter -d DSI-1   
	    """ connector处截屏：gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true num-buffers=1 ! "video/x-raw,format=BGRA,width=1920,height=1080" ! queue ! videoconvert ! video/x-raw,format=RGB ! jpegenc ! filesink location=/tmp/rgb.jpg """ 
	    """ afbc下截屏: gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true num-buffers=1 ! "video/x-raw,format=MCB8,width=1728,height=1888" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg	""" 
                 录屏："""gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true ! "video/x-raw,format=MCB8,width=1728,height=1888,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4 """ 
	
		屏幕width <= 2048时用AFBC format，gst中对应format是MCB8
		## 录屏 format MCB8 ##
		""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true ! "video/x-raw,format=MCB8,width=1920,height=1080,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4 """
		## 截图 format MCB8##
		""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true num-buffers=1 ! "video/x-raw,format=MCB8,width=1920,height=1080" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg """


		屏幕width > 2048时用BGRA format，gst中对应format是BGRA
		## 录屏 format BGBRA ##
		  """ gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true ! "video/x-raw,format=BGRA,width=800,height=1280,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4 """ 
		## 截图 format BGBRA ##
		  """ gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true num-buffers=1 ! "video/x-raw,format=BGRA,width=800,height=1280" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg """ 
	
	--------> 具体：
		【中控】
		录屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true ! "video/x-raw,format=MCB8,width=1728,height=1888,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4  """
		截屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen34 do-timestamp=true num-buffers=1 ! "video/x-raw,format=MCB8,width=1728,height=1888" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg              """
		【仪表】
		录屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen50 do-timestamp=true ! "video/x-raw,format=BGRA,width=3840,height=720,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4 """
		截屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen50 do-timestamp=true num-buffers=1 ! "video/x-raw,format=BGRA,width=3840,height=720" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg       """
		【副驾】
		录屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen46 do-timestamp=true ! "video/x-raw,format=BGRA,width=3840,height=720,framerate=60/1" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=NV12,colorimetry=bt601 ! v4l2h264enc output-io-mode=dmabuf-import capture-io-mode=mmap extra-controls="cid,sequence_header_mode=1,video_gop_size=30" ! video/x-h264,profile="(string)high",level="(string)5" ! h264parse ! mp4mux ! filesink location=/tmp/h264.mp4   """
		截屏：""" gst-launch-1.0 -e unixfdsrc socket-path=/tmp/screen46 do-timestamp=true num-buffers=1 ! "video/x-raw,format=BGRA,width=3840,height=720" ! queue ! v4l2convert disable-passthrough=true output-io-mode=dmabuf-import capture-io-mode=dmabuf ! video/x-raw,format=YUY2,colorimetry=bt601 ! v4l2jpegenc ! filesink location=/tmp/yuy2.jpg       """



	
 	gst播放视频：source /data/wayland_env_file;gst-launch-1.0 filesrc location=/data/out.mp4 ! qtdemux name=demux demux.video_0 ! h264parse ! v4l2mtkvpudec capture-io-mode=dmabuf-import ! v4l2convert output-io-mode=dmabuf-import capture-io-mode=dmabuf disable-passthrough=true propose-allocation=3 ! video/x-raw,format=RGB,width=1920,height=1080 ! waylandsink render-rectangle="<0,300,1920,1080>"	
    '''
	
	
    echo '''====================build=====================
    	rm -rf build && meson build/ --prefix=$WLD    -Dbackend-vnc=false && ninja -C build/ install
	
        ps -ef | grep weston | grep -v grep | awk '{print \$2}' | xargs kill -9
	 /usr/bin/killall -s KILL weston
	 
	export BB_NO_NETWORK=1 && \
	export TARGET_BUILD_VARIANT=userdebug && \
	export TEMPLATECONF=/home/chen.gang42/workingspace/D300_0724/yocto/meta/meta-mediatek-mt8678/conf/templates/auto8678p1_64_hyp && \
	source meta/poky/oe-init-build-env
	 
	 编译weston: bitbake -f -c clean  weston   &&  bitbake weston -c compile -f && bitbake weston -c build
	 编译kernel：   bitbake -f -c clean  virtual/kernel  &&  bitbake virtual/kernel  -c compile -f
	             bitbake vsomeip -c clean -f && bitbake vsomeip -c compile -f  && bitbake  vsomeip  -c build
        '''
	
    echo '''====================切换安卓=====================
	// 双adb方法：
		adb shell nohup autodualadb & 
		adb forward tcp:7777 tcp:6666 
		adb connect 127.0.0.1:7777
	
	kill Android：  nbl_vm_ctl stop 
        '''
	
        echo '''====================so=====================
		adb shell mount -o remount,rw /     ------> read write
		adb shell mount -o remount,ro /     ------> read only
        '''
}

function display_he_() 
{
        echo '''====================so=====================
		打pattern：
			四周边框：
			adb shell "echo gce_wr:0x324c0100,0x161,0xffffffff > /sys/kernel/debug/mtkfb"
			七彩色：
			adb shell "echo gce_wr:0x324c0100,0x141,0xffffffff > /sys/kernel/debug/mtkfb"
		
		pattern的方法：
			DSI0/1/2：
			adb shell "echo gce_wr:0x32490230,0xc41,0xffffffff > /sys/kernel/debug/mtkfb"
			adb shell "echo gce_wr:0x324A0230,0xc41,0xffffffff > /sys/kernel/debug/mtkfb"
			adb shell "echo gce_wr:0x324B0230,0xc41,0xffffffff > /sys/kernel/debug/mtkfb"
			DP0/1:
			adb shell "echo gce_wr:0x32430f00,0x41,0xffffffff > /sys/kernel/debug/mtkfb"
			adb shell "echo gce_wr:0x32440f00,0x41,0xffffffff > /sys/kernel/debug/mtkfb"
			EDP:
			adb shell "echo gce_wr:0x324c0100,0x141,0xffffffff > /sys/kernel/debug/mtkfb"
		恢复： 中间值改为0
        '''
}


function python_he_()
{
    echo '''=========================pip没有配置环境变量情况下使用============================
    	python -m pip install pyautogui
    '''
}

function D300_he_() 
{
        echo "====================双系统=====================
		禁止安卓启动:systemctl disable nbl_vm_srv
		stop安卓: nbl_vm_ctl  stop
		进入安卓: nbl_vm_ctl  shell
        "
	
	echo "====================虚拟服务=====================
	安卓virtualDisplay大小设置：
		setenforce 0
		setprop persist.vendor.debug.hwc.proxy_display_width "800 800" # 这三个值要同时设置，单独设置一个不生效
		setprop persist.vendor.debug.hwc.proxy_display_height "800 800"
		setprop persist.vendor.debug.hwc.proxy_display_fps "60 60"
	显示密度：wm density 320 -d 1
        "
	
	echo "====================启动应用=====================
		# 启动设置
		   am start --display 2 com.byd.carsettings/.MainActivity
		# 启动音乐
		  am start --display 2  com.byd.mediacenter/com.byd.mediacenter.main.MediaActivity
		# 启动地图
		  am start --display 1 com.byd.launchermap/com.byd.automap.activity.MainActivity
		# 启动爱奇艺
		  am start --display 2 com.byd.videoplay/com.byd.business.activity.HomeActivity
		  
		视频目录：
			副驾视频位置  /mnt/user/10/emulated/10/Movies
			中控视频位置  /mnt/user/0/sdcard0/Movies
        "
	echo "====================启动应用=====================
		关键应用的check： /private/data/boot_comp_checker
        "
	echo "====================build=====================
        	./build.sh yocto -S dynasty --union-display ivi_fse
	"
}
