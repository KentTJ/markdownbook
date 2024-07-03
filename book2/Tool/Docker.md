# 目录



# **docker**

官方文档是学习一门新技术的灯塔

官方用户手册

https://docs.docker.com/docker-for-windows/#file-sharing

## ~~**docker**账号：~~

ID chen85   账号
1519........

## 目前使用的版本

### images版本

每个版本增加什么功能！！！！！



### docker版本

原始安装版本以及更新后的版本：
![image-20220724161653731](Docker.assets/image-20220724161653731.png)

docker version



~~2021年10月：~~

 ![image-20221109224037856](Docker.assets/image-20221109224037856.png)





2022年11月：

![image-20221110005749324](Docker.assets/image-20221110005749324.png)





## **docker安装配置**

### Docker Desktop 安装

**分为WSL2方式和 Hyper-v方式**

注意：install required windows components for WSL 2   **不要勾选**

![image-20221109224528945](Docker.assets/image-20221109224528945.png)



原因在于：上面勾选了WSL 2, 后面 setting中配置 resources只能用  .wslconfig 文件来配置了

​                  1、不勾选 WSL 2   --->使用的是Hyper-V   ---> 界面配置：

![image-20221109225048661](Docker.assets/image-20221109225048661.png)

​				

  2、勾选  --->  使用的是WSL 2  --->    .wslconfig 文件配置



### <font color='red'> 安装后，修改docker的镜像目录 </font>

跟版本有关！！！！！！！

![img](Docker.assets/clipboard.png)

其他版本可能可以用：

mklink /J "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"  E:\docker\Hyper-V



docker的配置文章：

https://www.it610.com/article/1290832596699258880.htm

https://www.runoob.com/docker/docker-mirror-acceleration.html

https://blog.csdn.net/whatday/article/details/86770609

https://www.cnblogs.com/brock0624/p/9792203.html

### 源的配置---> 可选

![image-20220912172121827](Docker.assets/image-20220912172121827.png)

```java
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "registry-mirrors": [
  "https://registry.docker-cn.com",
  "http://hub-mirror.c.163.com",
  "https://docker.mirrors.ustc.edu.cn"
  ],
  "debug": true,
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
```

## 教程链接

https://yeasy.gitbook.io/docker_practice/image/build  docker入门到实践



https://docs.docker.com/engine/reference/commandline/image_build/  官方文档，包括所有命令参数
https://docs.docker.com/desktop/



## docker  代理配置



### 法一： Ubuntu内部设置代理 

（与宿主win无关）

```shell
docker run  ^
-p  127.0.0.1:10000:22  ^
-p 127.0.0.1:15901:5901  ^
--cap-add SYS_ADMIN --device /dev/fuse ^
-t -i  -v   I:\dockerSharedFiles:/home/cg, /workingSpace/local ^
-v   H:\dockerSharedFiles_Gpan\dockerSharedFiles_Gpan:/home/cg/workingSpace/local2    %imagesId%  /bin/bash
 
 
 
 //  --cap-add SYS_ADMIN --device /dev/fuse 作用：
 qv2ray会使用到fuse，见 
https://stackoverflow.com/questions/48402218/fuse-inside-docker
https://stackoverflow.com/questions/51263555/riofs-fuse-device-not-found
```



教程：<font color='red'>TODO:  完善自己的</font>

```
https://bwfish.xyz/archives/linux%E4%B8%AD%E5%8F%AF%E7%94%A8%E7%9A%84%E6%9C%BA%E5%9C%BA%E5%B7%A5%E5%85%B7qv2ray.
https://www.zsxcool.com/7137.html
```

#### 方法一步骤

##### 配置核心执行文件

![image-20221218110708766](Docker.assets/image-20221218110708766.png)



##### 订阅配置

![image-20221218115152333](Docker.assets/image-20221218115152333.png)

![QQ截图20220207133027](Docker.assets/S8dHMiZbsOuGhAC.png)



##### 最终结果：

![image-20221218114954741](Docker.assets/image-20221218114954741.png)

![image-20221120173835150](Docker.assets/image-20221120173835150.png)




注意：**方法一的关键点**：ping的时间在100ms左右。否则，打开Google非常卡，有时候打不开；Clion用不了

![image-20221120192030500](Docker.assets/image-20221120192030500.png)



##### 遇到的问题：

脚本执行后，卡在这个位置

![image-20221218114611928](Docker.assets/image-20221218114611928.png)



解决办法：新开一个terminal，

再次执行：

```shell
sudo ./Qv2ray-v2.7.0-linux-x64.AppImage

# if clinet UI does apper, try sudo ./Qv2ray-v2.7.0-linux-x64.AppImage again
```



有时候遇到界面没有跳出来，需要手动点开：

![image-20230707000916699](Docker.assets/image-20230707000916699.png)



#### 基于方法一，给Ubuntu配置系统全局代理---一个终端(临时)

todo： 是不是clion和浏览器就不用配置了？-----> 测试浏览器不是

参考：Ubuntu设置全局socks代理  https://blog.csdn.net/weixin_45033342/article/details/118075525?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-118075525-blog-128040047.pc_relevant_3mothn_strategy_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-1-118075525-blog-128040047.pc_relevant_3mothn_strategy_recovery&utm_relevant_index=2

```
export ALL_PROXY='socks5://127.0.0.1:1089'

//验证
curl http://www.baidu.com
curl http://www.google.com
curl https://www.google.com

取消设置的代理
unset ALL_PROXY
```

![image-20221120190657401](Docker.assets/image-20221120190657401.png)

#### 基于方法一，给Ubuntu配置系统全局代理---持久化



\# 配置代理
编辑vi  ~/.bashrc，增加代理配置  ---->  <font color='red'>持久化</font>

```cpp
export http_proxy="127.0.0.1:8889"
export https_proxy="127.0.0.1:8889"
    
或
export ALL_PROXY='socks5://127.0.0.1:1089'
```

**注意：**
此处在bashrc中配置了HTTP代理，但它可能会影响那些需要访问本地网络的bash命令行工具的使用。譬如：kubernetes集群客户端工具kubectl。在开启代理的情况下，kubectl无法顺利连接到APIServer，需要unset http_proxy和https_proxy两个环境变量，才可恢复正常。



#### 基于方法一，Ubuntu下浏览器链接代理

![image-20221218004112916](Docker.assets/image-20221218004112916.png)

![image-20221120191310971](Docker.assets/image-20221120191310971.png)

#### 基于方法一，Ubuntu下clion链接代理



![image-20221120190306304](Docker.assets/image-20221120190306304.png)

### 法二： 宿主win给 Ubuntu共享代理网络

 ----> TODO:  不知道怎么用的

VMware是成功了的，见相关章节



## **docker命令**

### **docker启动：**

docker images -a



暂时不用：
docker run -t -i    eca1757c6d5c   /bin/bash   

### **挂载磁盘**

主机F:\shareFiles挂载到/home/chen目录下

docker run -t -i  -v   F:\shareFiles:/home/chen/workingSpace/local   f2bab1877e15    /bin/bash

前提：

![img](Docker.assets/clipboard-1605373146599.png)



 <font color='red'> 下面命令，包括：挂载，以及ssh </font> ------------>常用链接

需修改： <font color='red'> 13874e71186c </font>

docker run   -p   10000:22   -t -i  -v    G:\dockerSharedFiles:/home/chen/workingSpace/local  -v     H:\dockerSharedFiles_Gpan\dockerSharedFiles_Gpan:/home/chen/workingSpace/local2       403c641a0264 /bin/bash
---->目前：10000需要改成20000



注意：需设置

![img](Docker.assets/clipboard-1605373411779.png)



### ssh链接

关于ssh链接：

> https://blog.csdn.net/Leo_csdn_/article/details/96150534?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.channel_param
>
> https://blog.csdn.net/qq_37955980/article/details/83044482   docker学习之ssh连接
>
> https://blog.csdn.net/vincent2610/article/details/52490397?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param   ssh远程连接docker中的container
>

主机端口：10000    <-----上面命令导致的



**使用MobaXterm远程连接步骤：**

（1）进入容器并重新开启ssh  ---->   每次都需要

[root@68e7598797d7 /]  #         /usr/sbin/sshd -D &

![image-20210306200055100](Docker.assets/image-20210306200055100.png)

（2）使用MobaXterm远程连接

通过xshell或者其他连接工具进行远程连接了，**记住，ip是宿主机的IP地址，端口号宿主机上的端口，**=即上面端口映射命令中的10000 ！

注意:主机ip很容易变动！！！！

![image-20201115011406102](Docker.assets/image-20201115011406102.png)

MobaXterm设置：框内是主机的ip，即是IPV4

![img](Docker.assets/clipboard-1605373856628.png)



### 账号

user：cheng

密码：151937Cgkent.

root账号密码：151937Cgkent.

注意：<font color='red'>最初cmd窗口就是root</font>
![image-20220109204739135](Docker.assets/image-20220109204739135.png)

### docker commit（禁止使用）

docker ps -l

![img](Docker.assets/1605374123405.png)

docker commit  7a96e91   newName: v2

![img](Docker.assets/1605374190736.png)

Ubuntu镜像

规定提交的格式为：
1、 docker tag 1be049d70e93  chen85/ubuntu16.04_aosp1000_r17:v1
--->这个是docker hub push识别的格式
2、或：docker commit  7a96e91 chen/ubuntu16.04_aosp1000_r17:v1



**禁止原因：**

> `docker commit` 制作镜像，以及后期修改的话，每一次修改都会让镜像更加臃肿一次，所删除的上一层的东西并不会丢失，会一直如影随形的跟着这个镜像，即使根本无法访问到。这会让镜像更加臃肿

### Dockerfile 定制镜像 

docker build使用 Dockerfile 定制镜像

---> 防止image臃肿



```c
#H:\docker_anzhuang2\Dockerfile
FROM chen85/ubuntu16.04_aosp1000_r17:v1
RUN echo '这是一个本地构建的nginx镜像' > /home/chen/index.html
```

![image-20220731115615101](Docker.assets/image-20220731115615101.png)

在 `Dockerfile` 文件所在目录执行：

```
 docker build -t chen85/ubuntu16.04_aosp1000_r17:v2 .
```

#### 关于Dockerfile详细说明：

概念：

![img](Docker.assets/modb_20220429_cfcd8976-c752-11ec-82c6-38f9d3cd240d.png)

技巧：用一个RUN命令替代多个 ---> 产生一个层

```shell
FROM debian:stretch

RUN apt-get update
RUN apt-get install -y gcc libc6-dev make wget
RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz"
RUN mkdir -p /usr/src/redis
RUN tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1
RUN make -C /usr/src/redis
RUN make -C /usr/src/redis install
```

正确：

```shell
FROM debian:stretch

RUN set -x; buildDeps='gcc libc6-dev make wget' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && rm -rf /var/lib/apt/lists/* \
    && rm redis.tar.gz \
    && rm -r /usr/src/redis \
    && apt-get purge -y --auto-remove $buildDeps
```


到这一组命令的最后添加了清理工作的命令，清理了所有下载、展开的文件，并且还清理了apt 缓存文件





### 合并镜像层 squash



```c
--squash    -->  Squash newly built layers into a single new layer
```

优点：1、把Image多层变成一层，合并多个commit，有效减小体积！

```cpp
 docker build --squash -t chen85/ubuntu16.04_aosp1000_r17:v4 .
```

--->默认使用了Dockerfile，需要修改

![image-20221121005402258](Docker.assets/image-20221121005402258.png)

 2、docker history  076f7dad0851 信息并没有减



查看层数：

![image-20220731145005969](Docker.assets/image-20220731145005969.png)



-<font color='red'>注意： squash 能生效是有前提的：</font>

至少：

```java
  "experimental": true,

    "buildkit": true
```

![image-20230915004242984](Docker.assets/image-20230915004242984.png)



对应设置界面：





### Docker 容器连接的优化：

原始：

```shell
docker run  ^
-p  10000:22  ^
-p 15901:5901  ^
-t -i  -v   G:\dockerSharedFiles:/home/cg, /workingSpace/local ^
-v   H:\dockerSharedFiles_Gpan\dockerSharedFiles_Gpan:/home/cg, /workingSpace/local2    4753178ab18f  /bin/bash
```

MobaXterm链接时的ip使用主机的：
![image-20221101185509314](Docker.assets/image-20221101185509314.png)

对应运行的

![image-20221101185358120](Docker.assets/image-20221101185358120.png)



**优化：**

```shell
docker run  ^
-p  127.0.0.1:10000:22  ^
-p 127.0.0.1:15901:5901  ^
-t -i  -v   G:\dockerSharedFiles:/home/cg, /workingSpace/local ^
-v   H:\dockerSharedFiles_Gpan\dockerSharedFiles_Gpan:/home/cg, /workingSpace/local2    4753178ab18f  /bin/bash
```

MobaXterm链接时的ip使用主机的127.0.0.1，<font color='red'>固定！！！！</font>

`相当于有一层代理，具体使用时，不用管具体ip是多少`

![image-20221101185718576](Docker.assets/image-20221101185718576.png)

对应运行的

![image-20221101185635895](Docker.assets/image-20221101185635895.png)



### 远端

#### docker账号登录：docker login

chen85

#### docker push

```
docker push tag 1be049d70e93  chen85/ubuntu16.04_aosp1000_r17:v1
```

见：https://www.cnblogs.com/kevingrace/p/9599988.html    [通过容器提交镜像（docker commit）以及推送镜像（docker push）笔记](https://www.cnblogs.com/kevingrace/p/9599988.html)  下载





### 根据镜像id修改镜像tag名

修改镜像tag：

```java
docker tag $IMAGE_ID <NEW_IMAGE_NAME>:<NEW_TAG>
    
docker tag 194d8716 cg, /ubuntu16.04_aosp1200_r28:last
```



### docker网站，

类似gitHub

```
https://hub.docker.com/
```

### 下载别人的镜像

```c
docker pull wangshibo/myubuntu:v1
```

### **镜像保存成jar到本地**

https://blog.csdn.net/qq_37797234/article/details/103660748

保存镜像到本地！！！！

```shell
docker save  ubuntu16.04_0902  -o  E:\docker\ubuntu16.04_0902.jar
docker save  cheng/ubuntu16.04_aosp1000_r17:vnc_ok  -o  H:\docker_jarFiles\ubuntu16.04_aosp1000_r17_vnc_20221026.jar
```

 加载本地镜像

```shell
C:\Users\xixi>docker load -i  F:\VirtualMachine\Docker\ubuntu.jar
```



### **镜像保存成tar到本地**



```java
docker save  ubuntu16.04_0902  -o  E:\docker\ubuntu16.04_0902.tar
docker save  cheng/ubuntu16.04_aosp1000_r17:vnc_ok  -o  H:\docker_jarFiles\ubuntu16.04_aosp1000_r17_vnc_20221026.tar
```

 加载本地镜像

```java
C:\Users\xixi>docker load -i  F:\VirtualMachine\Docker\ubuntu.tar
```



#### 优化之 保存jar

规定（<font color='red'>优</font>）： 

1、在物理磁盘小的情况下，build+ 保存jar，先删除源码   --------> 节省最终存储jar的空间

2、保存jar时，如果出现no space。见《build或者保存jar，no space>







## 优化

### 配置修改优化

原则：

1、从**配置文件修改（优）**，而不是界面操作  < --------- 界面化操作需要先进入，然后重启

​                                                                                    没启动docker时，从配置文件修改，只需要启动一次

比如：

```java
"dataFolder": "D:\\programFiles\\dockerDesktop\\DockerDesktop",

```

![image-20230915003554954](Docker.assets/image-20230915003554954.png)

对应设置：

> ![image-20230915004242984](Docker.assets/image-20230915004242984.png)
>



对应设置界面：



### 突破docker的swap大小

问题：

1、 settings中最大4GB

![image-20240414150120459](Docker.assets/image-20240414150120459.png)

2、无法在Ubuntu容器内 扩展 swap分区：

>  ----------------------> 用dd 和 swapn命令，不能应用于overlay类型文件！！！！
>
>  ```cpp
>  $ df -h
>  Filesystem      Size  Used Avail Use% Mounted on
>  overlay         1.2T  291G  867G  26% /     -----> overlay!!!!!
>  tmpfs            64M     0   64M   0% /dev
>  
>  ```
>
>  



解决办法：

> 从配置文件中修改： C:\Users\Administrator\AppData\Roaming\Docker\settings.json
>
> ```
> "swapMiB": 4096,
> ------->  "swapMiB": 32768,
> ```

参考：  https://stackoverflow.com/questions/60325478/how-to-increase-swap-size-on-docker-for-windows



## CPU使用率优化 **docker pause**

```
docker pause/unpause <container-id>
```

不用时，docker puase  ---> sleep 容器内所有进程

------> 极大的降低CPU使用率



## 文件系统过大优化



### 优化之  只保存系统文件到 jar

**规定：**

1、导出jar时，<font color='red'>只保存系统，不保存代码</font>       ------->  背后思想，提取重复

方法：squash过程中删除代码

![image-20230916003538219](Docker.assets/image-20230916003538219.png)



2、<font color='red'>代码+系统的演进，仍然用squash之前的</font>  ------>  **因为包含代码**

​     squash后的img导出jar后，就删除！



关系如图：

> 演进的始终是一个东西
>
> 版本只是一个时间点的快照

![image-20230916003820830](Docker.assets/image-20230916003820830.png)

大大减小了系统版本快照大小。且不影响 演进

![image-20231014030319612](Docker.assets/image-20231014030319612.png)



### 保存到tar文件

---------> 可以给wsl使用



### 时间优化之 两份aosp同时解压

基于《优化之  只保存系统文件到 jar》 ---------> aosp用压缩包解压策略：

> 可以两份同时解压，但cpu也只用到了10%
>
> ![image-20231014025859380](Docker.assets/image-20231014025859380.png)

### 时间优化之 build squash 时，容器可用

实际上，只有commit时，容器不能用，其他都可以

------>  所以，基于容器角度，<font color='red'>结论：</font>

**build squash以及保存jar等，不影响我们的正常工作（在容器内）**

### 优化之  任何差异保存到window路径下----减少commit

-<font color='red'>极优</font>

目的：减少commit  



步骤：

> 1、 <font color='red'>把变化保存在windows里，不进行commit</font>
>
> 比如 .myfunction.sh  .my_start.sh
>
> 2、在启动时候，从win复制过去
>
> ![image-20230916012925941](Docker.assets/image-20230916012925941.png)



---------------------->  **此方法问题：**

如果改动在越来越多文件里扩散，就比较麻烦

**总结：**

> 在常用的文件里可以如此改动
>
> **减少commit，可以用squash方法替代**

### 镜像优化之合并镜像层 squash

方法见上

**<font color='red'>优点：</font>**

> 1、**压缩到一层**：减小
>
> 2、**独立性：** 压缩后的镜像不依赖其他镜像，其他可删

### docker rmi  删除镜像

方法一：通过imageID： docker rmi       ee7cbd482336



删除镜像难以删除的情况：
1、一个ImageID 对应多个   repositories：

![image-20220731152848039](Docker.assets/image-20220731152848039.png)

![image-20220731152939515](Docker.assets/image-20220731152939515.png)

删除方法（<font color='red'>**优**</font>）：  `注意：不能在cmd下运行`

```
 docker rmi chen85/ubuntu16.04_aosp1000_r17:v1
```



2、<font color='red'>被正在运行的容器关联了</font>： container 368027944f2e is using its referenced image
![image-20220731153210469](Docker.assets/image-20220731153210469.png)

方法：删除所有容器，再删image

```shell
 docker stop $(docker ps -a -q)   #全关
 docker rm $(docker ps -a -q)   #删除全部容器
 docker rmi ubuntu16.04_aosp1000_r17:latest   #删除image
```



### **磁盘overlay满了**  docker system prune  

docker system prune 
 ----> <font color='red'>已经验证，十分有用</font>： 清除不用的镜像和<font color='red'>缓存</font>

https://www.cnblogs.com/wswang/p/10736726.html



例子：

> 
>
> ![image-20231014022142307](Docker.assets/image-20231014022142307.png)
>
> docker system prune  之后：
>
> ![image-20231014023947830](Docker.assets/image-20231014023947830.png)
>
> ![image-20231014024658623](Docker.assets/image-20231014024658623.png)

（3)删？？？？‪

![img](Docker.assets/clipboard-1605374444293.png)

(2)

https://segmentfault.com/q/1010000020545464

https://www.jianshu.com/p/9174914ec07d



### img优化 &  DockerDesktop.vhdx优化 --------><font color='red'> docker的最大难题</font>

img大小（即保存的jar大小） ------ >  可以由squash优化压缩

-**DockerDesktop.vhdx 大小  一般会大于 最大img大小（即使只有一个img）** <font color='red'> 根本原因：</font> .vhdx 大小  是<font color='red'>历史上最大</font>的文件系统（即使后面删除很多文件，也不会减小）



-------------------------> 针对于docker这些特性：  

（1）在linux侧，不保存差异

（2）差异保存在win侧：**每次启动**的  img都一样，DockerDesktop.vhdx 大小 也都一样（即**<font color='red'>保证永远不会恶化</font>**）

​      即： <font color='red'>重启一致性</font>

（3）**观察df  -h，avail的存储指标**。小，则会报错no space

![image-20230927034334031](Docker.assets/image-20230927034334031.png)

（4）**优化df  -h**：  长时间没有关闭linux，这个很容易被用完。`利用重启一致性，来恢复avail 区域大小`

​     ---------------> <font color='red'> 这反而成为docker的优点</font>

### 优化之 复制 DockerDesktop.vhdx----->save jar的保底

目的：

1、尽管减少commit，但是随着演进，img越来越大。最终导致磁盘太小，<font color='red'>无法save jar，需要挪盘----->save jar的保底</font>

2、做备份



![image-20230916084702048](Docker.assets/image-20230916084702048.png)

-<font color='red'>移动文件需要everyone权限</font>

> ![image-20220722223854271](Docker.assets/image-20220722223854271.png)
>

### 优化之  保存jar 与 进入容器使用 并行

这个两个 可以并行：docker 与 容器内，可以并行

-----> 节省时间



### 积木化思想

ubuntu纯净系统： 

>   ----->  squash时，删除aosp代码
>
> 优点： 保存的jar包很小

经常变化的文件：

> 存储于win文件系统。开机后，sync过去

aosp代码：

> 过大，可以以zip压缩形式，存储于win。然后解压到linux中



------------------->  总结：

积木化思想



### 总结所有优化

docker容器内文件系统过大表现：

> （1）容器内部看：overlay used很大
>
> ![image-20231014022839601](Docker.assets/image-20231014022839601.png)
>
> （2）从win来看：
>
> ![image-20231014022928865](Docker.assets/image-20231014022928865.png)

-------------------->   overlay used<font color='red'>很大根因：</font>

> （1）文件系统包括了 aosp代码   -------->  没必要保存，squash时+ 保存jar 时，删掉
>
> （2）即使没有aosp代码，有时候也很大  ------>  因为<font color='red'>历史镜像最大值</font> + <font color='red'>缓存</font>造成的
>
> ​                                     a. squash压缩得到一个新的独立镜像 ------>  <font color='red'>因为独立，可以删除其他所有镜像</font>
>
> ​                                     b. docker system prune 清除缓存
>
> ​      -<font color='red'>技巧：</font>
>
> > ​     先删除大文件，比如aosp，然后docker system prune 清除缓存





时间优化， 总结： 

> 1、
>
> 2、



## 技巧之保存 每个特性代码





## error

### ~~**docker报错:**图标变红  方法1：~~

cmd报错：open //./pipe/docker_engine: The system cannot find the file specified.

解决方法：  

> 重置配置，，，，再重启电脑
>
> ![img](Docker.assets/clipboard-1605374501667.png)
>

~~reset to factory defaults~~   ---->  `规定：后面不准用这种方法，会造成setting改变`


### 启动异常报错-->方法2:

运行docker出现System.InvalidOperationException错误

![image-20210714075640590](Docker.assets/image-20210714075640590.png)



解决办法：
1.管理员方式运行cmd
2.输入命令：netsh winsock reset
![在这里插入图片描述](Docker.assets/20210126212610700.png)

3.重新启动Docker
4.重新switch to Linux Containers
5.成功

 **技巧，特别注意：**
此时，应该所有的image都没有了。尽量不要重新load image，应该把这个文件复制到setting目录下面

![image-20220109195305006](Docker.assets/image-20220109195305006.png)

![image-20220109195422495](Docker.assets/image-20220109195422495.png)



移动文件需要everyone权限

![image-20220722223854271](Docker.assets/image-20220722223854271.png)

### 启动异常报错  方法3:（优）

~~reset to factory defaults仍然报错~~   ---->  `规定：后面不准用这种方法，会造成setting改变`

--->技巧：不要重新装docker软件
关闭docker，重启win，删除DockerDesktop.vhdx，启动docker ---->docker会自动生成

优点：**不用重新装docker，setting不会变**

### 启动异常报错  方法4:（极优）

1、备份好的DockerDesktop.vhdx

2、基于方法3，恢复环境

3、copy  .vhdx至目录下，重启    ---->  优化了load  jar的时间



TODO: 以后备份都用.vhdx？ 而不是jar？



### build或者保存jar，no space

报错：

```java
Error response from daemon: write /var/lib/docker/tmp/docker-export-1172560351/26512da3e9ed0583440e8dee1123b7548cef5b82a5cc9954ba36e354a 3db6e57/layer.tar: no space left on device
```

![image-20230915223615835](Docker.assets/image-20230915223615835.png)



问题根因：

> 这里给docker的空间小了（相比于已经存在的img）
>
> ![image-20230915224728576](Docker.assets/image-20230915224728576.png)
>
> ![image-20230915224716660](Docker.assets/image-20230915224716660.png)

办法：

> 设置扩大diskSizeMiB
>
> -------------->  如果物理磁盘不够了，就挪动到其他盘。方法，见《docker优化之 复制 DockerDesktop.vhdx>





参考：

https://devpress.csdn.net/cloud-native/645cf29477f0ca41cb317090.html?dp_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NDUyNjk2LCJleHAiOjE2OTUzMTIzMDQsImlhdCI6MTY5NDcwNzUwNCwidXNlcm5hbWUiOiJ3ZWl4aW5fMzgxOTkzODEifQ.xIBvzCJnk72YDqUIB6k1ZsDN6yx0IlPq-bCs7XSvrr0 

## docker连 主机pc连的安卓设备

1、宿主为windows：
https://testerhome.com/topics/8049     https://blog.csdn.net/qq_42693848/article/details/109505849
         使用方法

​        **宿主windows侧：**起服务

1.  安装 nodejs

    推荐使用 nvm 安装： http://events.jianshu.io/p/5db570f53e6a      `win10中使用nvm安装nodejs遇到的坑整理`    ------> ==很好的教程==

2.  安装 adbkit

    ```
    $ npm i -g adbkit
    ```

3.  启动 usb 转 tcp 服务

    ```
    $ adbkit usb-device-to-tcp -p $port $serial
    // serial是手机序列号
    
    比如：adbkit usb-device-to-tcp -p 7788 FA6930305260
    ```

    **docker侧：**连接服务

4.  在docker侧（装有 adb 的机器上）进行设备的连接

    假设启动 adbkit 服务的机器 ip 是 10.0.0.1 端口是 15555 ----> ip试了HOST的真实ip，以及

    ```
    $ adb connect 10.0.0.1:7788
    ```

​                 -<font color='red'>万能方法</font>：  为了方便docker提供了专门的标志表示母机的ip：host.docker.internal
​           见：https://blog.csdn.net/qq_42693848/article/details/109505849

```CPP
adb connect host.docker.internal:$port

 adb connect host.docker.internal:7788  
```

  **其他注意事项**

adb连接手机默认使用的是5037，母机与容器交互的接口无法在使用该端口，需要选择其他端口。

 

2、宿主linux：https://stackoverflow.com/questions/29563183/connecting-to-a-usb-android-device-in-a-docker-container-via-adb



## docker容器安装图形桌面

VNC远程win： tigervncserver -vncClient



参考： https://blog.csdn.net/lxyoucan/article/details/121679346

视频教程：https://www.bilibili.com/video/BV1mL41177Av



**总之，使用**：

```shell
 docker run  ^
 -p  10000:22  ^
 -p 15901:5901  ^
 -t -i  -v   G:\dockerSharedFiles:/home/chen/workingSpace/local ^
 -v   H:\dockerSharedFiles_Gpan\dockerSharedFiles_Gpan:/home/chen/workingSpace/local2   8ea41f5aa2f9 /bin/bash
 
:: /usr/sbin/sshd -D &
::  -p  10000:22  用于ssh登录 --->使用win ip  + 10000 ： 192.168.1.4:10000 
:: -p 15901:5901  用于VNC界面登录 --->使用win 的Ethernet adapter ip  + 15901: 172.18.28.1:15901
                                                                   或  127.0.0.1::15901 ----> 永恒不变
```



**注意点：**

1、关于vnc链接的ip ： <font color='red'>使用win 的Ethernet adapter ip</font>

![image-20221026004429896](Docker.assets/image-20221026004429896.png)

![image-20221026004536110](Docker.assets/image-20221026004536110.png)

登录：
![image-20221026011422272](Docker.assets/image-20221026011422272.png)



![image-20221026004338396](Docker.assets/image-20221026004338396.png)



### 问题1：VNC连不上的

报错：connection closed
操作方法：

```shell
// 1、重启一下服务试试
vncserver -kill :1
vncserver -kill :2
vncserver -kill :3
vncserver -kill :4
vncserver :1 -localhost no -geometry=1920x1080


// 2、如果上述不行，看有没有提示：
Warning: 4fcb1df56031:1 is taken because of /tmp/.X1-lock   ---->删掉这个文件
Remove this file if there is no X server 4fcb1df56031:1
```

![image-20221026225716419](Docker.assets/image-20221026225716419.png)



### 关于VNC 客户端的选择

1、TurboVNC Viewer（<font color='red'>优</font>）

![image-20230107001518272](Docker.assets/image-20230107001518272.png)

可以双屏



全屏切换快捷键   ALT + Enter



2、集成了TurboVNC Viewer的 MobaXterm

~~有些问题：必须全屏 + stay on TOP  有些快捷键才生效~~； 复制粘贴 偶现问题

![image-20230107001356052](Docker.assets/image-20230107001356052.png)



## 剪切板复制 docker与win

https://zhuanlan.zhihu.com/p/518188941    VNC 复制粘贴中文乱码问题及解决方案



https://unix.stackexchange.com/questions/35030/how-can-i-copy-paste-data-to-and-from-the-windows-clipboard-to-an-opensuse-clipb

![image-20221028232748568](Docker.assets/image-20221028232748568.png)

结合两个帖子：

```
vim ~/.vnc/xstartup

#加入：
# win --> docker
vncconfig  -nowin &

vncconfig -iconic &
autocutsel -fork&
```



注意：

1、重启一个vnc服务



### 报错与解决办法

vnc:   failed to open clipboard    https://blog.csdn.net/qq_39590599/article/details/116228624

![image-20221127105159908](Docker.assets/image-20221127105159908.png)

![img](Docker.assets/202104281044288.png)





## 一些环境规定：

`docker 命令必须在bash环境下执行`，不能用cmd（除了启动的）





## 关于docker网络的几个概念区分：

1、使用的网络类型是bridge，桥接的宿主网络(组成局域网)
（1）在容器外使用时：
moba连接时，用的127.0.0.1，为啥？ ----->   因为原先用的宿主的ip，宿主ip对于寄生的docker就是127.0.0.1
（2）在容器内使用时：
必须用宿主机的绝对ip，不能是127.0.0.1？----->   因为在内部，相对ip172是其自己
2、使用--network=host，这样的话使用 -p 参数映射端口就没用了， 即所有端口都是开放和宿主机共享的
（2）在容器内使用时：
能用127.0.0.1  -----> 因为127是自己 ，也是host，共享的端口



代理软件：
本地 关系：AS对win是本地的关系; AS对docker 容器
           moba对win是本地的关系
		   
局域网关系：
  docker内部对win

 

## 优化

自动保存 DockerDesktop.vhdx 脚本  ：vhdx_backup.bat   --->  **不影响docker  容器unbuntu正常工作的，可以白天经常做**

自动build、save、load脚本：docker_build_save_load.bat    ---> 必须晚上





## docker目前存的的问题与不便

1、docker不能直接挂载其他硬盘，作为其文件系统一部分 -------> linux 识别 linux文件系统，很快

docker与win只能共享文件夹（传输效率极低）



问题：

> 造成docker安装在D盘，文件系统不能放在其他大的硬盘里 ----->  难以实现：  **<font color='red'>系统 与  文件系统  分离到两个盘上</font>**

2、docket安装到**移动硬盘**上，会**经常发生start failed**     ------->  **很奇怪，需要一个固定的盘**

![image-20210714075640590](Docker.assets/image-20210714075640590.png)

------------> 

**与1,矛盾：**

>  2 需要将docker安装到 固定的d盘
>
>  但是因为文件系统过大，需要1，分离 docker安装与文件系统盘





3、暂时不能用samba

4、难以直接连手机？？？

5、每次新增文件，都要**commit 系统**-------> 浪费时间

6、docker挂载 ------> 文件IO速度慢： 



## docker挂载解决IO速度慢的问题

TODO：待验证

https://www.kancloud.cn/luke8327/phpwolf/3121911    【Windows Docker】docker挂载解决IO速度慢的问题

https://blog.just4test.net/performance-loss-of-docker-desktop-bind-mounts     Docker Desktop的挂载性能损失



## 共享之  docker 内配置samba ----> TODO: 未成功

**可能：**

方法1？：一个适配器绑定多个IP

> 参考“：
>
> https://blog.csdn.net/m0_37902494/article/details/128322049?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-128322049-blog-132381489.235%5Ev40%5Epc_relevant_rights_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-128322049-blog-132381489.235%5Ev40%5Epc_relevant_rights_sort&utm_relevant_index=9    windows10环境下宿主机无法打通到容器ip
>
> https://blog.csdn.net/qq_42362605/article/details/124898062   
>
> https://qinfeng.blog.csdn.net/article/details/132609787?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-132609787-blog-108300589.235%5Ev40%5Epc_relevant_rights_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-132609787-blog-108300589.235%5Ev40%5Epc_relevant_rights_sort&utm_relevant_index=9   win10 ping不通 Docker ip(解决截图)
>
> https://zhuanlan.zhihu.com/p/656521191?utm_id=0&wd=&eqid=d2260df60001fa10000000036575d6fa     Win11系统同一网卡设置使用多个IP地址的方法教程
>
> 
>
> ```java
> # 添加一个网卡
> netsh interface ip add address "vEthernet (WSL)" 192.168.50.93 255.255.255.0
> ```
>
> 
>
> ```java
> netsh interface ip show config  ---》 OK，查看当前所有適配器配置
> 
> 
> netsh interface ip add address "vEthernet (WSL (Hyper-V firewall))" 172.17.0.2  255.255.240.0   ----》 ok
> netsh interface ip delete address "vEthernet (WSL (Hyper-V firewall))" address=172.17.0.2    ----》 ok 
>     
>     
> // smbd启动
> service smbd  status
> sudo service smbd  start
> 
> ```



方法2？：增加路由

> 
>
> ```
>  route add 172.17.0.2 mask 255.255.0.0 192.168.137.1
>  
>  route add 172.17.0.2 mask 255.255.0.0  192.168.137.1
>  
>  
>  route print  路由表
> ```
>
> 参考： https://blog.csdn.net/m0_60861848/article/details/132381489?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-132381489-blog-132609787.235%5Ev40%5Epc_relevant_rights_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-132381489-blog-132609787.235%5Ev40%5Epc_relevant_rights_sort&utm_relevant_index=6
>
> https://blog.csdn.net/zhongliang415/article/details/108300589?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-108300589-blog-124612501.235%5Ev40%5Epc_relevant_rights_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-2-108300589-blog-124612501.235%5Ev40%5Epc_relevant_rights_sort&utm_relevant_index=5        windows宿主机访问docker容器ip无法ping通



好像就是不OK：

> https://docs.docker.com/desktop/networking/          xplore networking features on Docker Desktop
>
> https://blog.csdn.net/qq_45380083/article/details/124612501?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-124612501-blog-108582185.235%5Ev40%5Epc_relevant_rights_sort&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-3-124612501-blog-108582185.235%5Ev40%5Epc_relevant_rights_sort&utm_relevant_index=6
>
> 
>
> https://forums.docker.com/t/unable-to-access-my-first-container-on-172-17-0-2/54106         [Unable to access my first container (on 172.17.0.2) - General Discussions - Docker Community Forums](https://forums.docker.com/t/unable-to-access-my-first-container-on-172-17-0-2/54106)



补充知识：

https://blog.csdn.net/2302_77582029/article/details/132106721          Docker网络模式详解







### 进展：

docker对应的是   "vEthernet (WSL (Hyper-V firewall))"  适配器：！！！！！！！！

![image-20240114234916011](Docker.assets/image-20240114234916011.png)

此时容器内部：

![image-20240114235137077](Docker.assets/image-20240114235137077.png)

下面切到了window Containers

![image-20240115000628113](Docker.assets/image-20240115000628113.png)



## 共享之  利用  sshfs挂载远程文件夹

**<font color='red'>实在搞不定的问题，就想办法绕过去</font>！！！！！！！！**（既然samba 一直以来在window dcoker里无法配置成功）



见《linux挂载到win-------sshfs（**效果类似于samba**）》章节





# wsl

## wsl 安装到e盘

http://www.huazhaox.com/article/7981    把WSL安装到指定目录下的简易完美方法

## 使用wsl安装ubuntu

安装指定版本ubuntu

```java
wsl --list --online    //查看线上有哪些版本

wsl --install -d  Ubuntu-22.04 // 安装指定版本
```



启动 & 关闭：

```java
wsl -l -v   // 查看已经安装

wsl -d Ubuntu-22.04  // 启动
    
wsl -t Ubuntu-22.04   //关闭
```

参考：https://www.cnblogs.com/AJun816/p/16214924.html#%E8%BF%81%E7%A7%BB%E5%88%B0%E6%8C%87%E5%AE%9A%E7%9B%AE%E5%BD%95   



删除已经安装的ubuntu：

> wsl -l -v   // 查看已经安装
>
> wsl --unregister Ubuntu-18.04  



## wsl挂载  硬盘（硬件接在win上）

### 步骤

参考： https://zhuanlan.zhihu.com/p/557082235    在Windows11上利用WSL挂载 linux硬盘

​        https://learn.microsoft.com/en-us/windows/wsl/wsl2-mount-disk      [Get started mounting a Linux disk in WSL 2 | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/wsl2-mount-disk)        



**1、powershell中查看硬盘信息**

```java
GET-CimInstance -query "SELECT * from Win32_DiskDrive"
```

输出：

```java
PS C:\Users\scelt> GET-CimInstance -query "SELECT * from Win32_DiskDrive"

DeviceID           Caption              Partitions Size          Model
--------           -------              ---------- ----          -----
\\.\PHYSICALDRIVE1 Force MP600          4          1000202273280 Force MP600
\\.\PHYSICALDRIVE0 WDC WD80EFZX-68UW8N0 1          8001560609280 WDC WD80EFZX
```

**2、裸挂载（可以显示该盘但还不能访问）**

```java
wsl --mount \\.\PHYSICALDRIVE0 --bare
```

转到WLS终端：

```powershell
lsblk
```

My output:

```java
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  256G  0 disk
sdb      8:16   0  256G  0 disk /
sdc      8:32   0  7.3T  0 disk
└─sdc1   8:33   0  7.3T  0 part
```

其中的sdc1就是我们需要挂载的设备了

**3、 识别文件系统**

WLS终端：

```text
blkid /dev/sdc1
/dev/sdc1: UUID="ce35a569-9e17-4a83-b468-9d14fea9983e" TYPE="ext4" PARTLABEL="part1" PARTUUID="bb1a9b80-27d9-4b32-8cd1-51f71cb48252"
```

其中的 TYPE=“ext4”就告诉了我们这是一块ext4格式的硬盘。

> 如果用blkid回车后没有任何输出，可以尝试加上sudo后重试。我当时就疑惑了久为什么它没有任何输出……

**4. 真·挂载（可以访问内容了）**

**方法一：已验证ok**

在ubuntu内部mount：

```java
sudo  mount   /dev/sdc2   /home/chenjinke/workingspace/yingpan
    
    151937Cgkent.
    
---------->  验证ok：
lsblk
```





方法二：

> 注意，此时又要回到Powershell中进行操作：
>
> ```powershell
> wsl --mount \\.\PHYSICALDRIVE0 --partition 1 --type ext4
> ```
>
> 此时该硬盘会自动挂载到WSL系统中的`/mnt/wsl`目录中。
>
> 如果想从资源管理器访问，可以在地址栏输入`\\wsl$\Ubuntu-20.04\mnt\wsl\`。
>
> > 记得替换`Ubunto-20.04` 为实际使用的版本。如果不确定也可以先输入`wsl$`打开WSL目录逐级进入。

**5、卸载**

在powershell中操作：

```text
wsl --unmount \\.\PHYSICALDRIVE0
```



### win下如何看linux磁盘(ext4)文件？

上面方法

## 在win资源管理器访问wsl中Ubuntu------类似于samba

```java
\\wsl$\Ubuntu-22.04\mnt\wsl\

\\wsl$\Ubuntu-22.04
```



## wsl从tar安装ubuntu

tar来源：

1、可以是docker保存的  

2、也可以是wsl之前保存的：

```java
wsl --export debian e:\debian.tar
```



导入tar：

```java
wsl --import ubuntu18.04_fromDocker E:\programFiles\wsl_ubuntu\ubuntu_18_fromDocker  E:\docker_install\docker_jarFiles_backup\ubuntu18.04_aosp1200_r28_0923_2023_10_14.tar
```



```java

   --import <Distro> <InstallLocation> <FileName> [选项]
       将指定的 tar 文件作为新分发版导入。
       文件名可以是 - for stdin。

       选项:
           --version <版本>
               指定要用于新分发的版本。

           --vhd
               指定所提供的文件是 .vhdx 文件，而不是 tar 文件。
               此操作在指定的安装位置创建 .vhdx 文件的副本。

   --import-in-place <Distro> <FileName>
       将指定的 .vhdx 文件作为新分发版导入。
       必须使用 ext4 文件系统类型设置此虚拟硬盘的格式。
```



参考：   http://www.huazhaox.com/article/7981     把WSL安装到指定目录下的简易完美方法

## 其他认知

windows是无法识别ext4

格式的硬盘的(ext4是linux文件系统格式)

## WSL2 使用相关  参考

https://blog.csdn.net/justforacm/article/details/130614760     WSL2 使用相关    ------->  好文

图形化：

> https://mp.weixin.qq.com/s/42R7vn8mA0nX3Ipg8Zt5Iw     
>
> https://blog.csdn.net/Jasonkun_3/article/details/119135374



## 当前wsl账号:

> cheng....
>
> 151..........







# VirtualBox 

先安装 VirtualBox

参考：

> [使用VirtualBox安装Ubuntu系统-CSDN博客](https://blog.csdn.net/abc6368765/article/details/125819966)    



## VirtualBox安装Debian11/Ubuntu

在 VirtualBox 中构建 Debian11 虚拟电脑 :

> ```http
> https://blog.csdn.net/ForestK/article/details/125198556?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-2-125198556-blog-127320725.235^v38^pc_relevant_sort_base1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-2-125198556-blog-127320725.235^v38^pc_relevant_sort_base1&utm_relevant_index=5
> ```
>
> ----------------->  验证ok。注意：系统镜像可以是ubuntu的iso



使用VirtualBox安装Ubuntu系统:

> https://blog.csdn.net/abc6368765/article/details/125819966  







## VirtualBox Ubuntu无法复制粘贴以及无法安装增强功能：

> 方法一：
>
> > https://blog.csdn.net/subtitle_/article/details/132032433?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2~default~YuanLiJiHua~Position-2-132032433-blog-131377973.235^v38^pc_relevant_sort_base1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~YuanLiJiHua~Position-2-132032433-blog-131377973.235^v38^pc_relevant_sort_base1&utm_relevant_index=5
>
> -----------------> 验证有效
>
> 方法二：
>
> > 安装nvc，通过MobaXterm查看图形界面。自然，可以复制粘贴





## VitrualBox中备份Ubuntu

https://blog.csdn.net/mo_sss/article/details/132856647

------> 验证ok





## VirtualBox 扩容

1、添加磁盘

https://blog.csdn.net/xiaoxiangzi520/article/details/111291634?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-111291634-blog-120908556.235^v39^pc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-111291634-blog-120908556.235^v39^pc_relevant_anti_vip&utm_relevant_index=2

```
 :://查看虚拟磁盘空间信息，确认确实是需要扩容的虚拟硬盘。
 "D:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" showhdinfo "D:\\Program Files\\ubuntu\\ubuntu\\ubuntu.vdi"
 :://计算要扩容的空间大小，我这里是要扩展到100G(1024*1024*1024*100)。
 set/a 1024*1024*1024
 
 
 :://扩展虚拟硬盘空间，最后的数字替换成上面计算出的硬盘空间大小。
 
 "D:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" modifymedium "D:\\Program Files\\ubuntu\\ubuntu\\ubuntu.vdi" --resizebyte 386547056640
 
 pause
```

进入虚拟机：

```
 sudo fdisk -l
```

-------------> 查看有磁盘

2、分区扩容（纳入新磁盘）可视化工具

[Linux系统sda1分区扩容_linux扩容sda1-CSDN博客](https://blog.csdn.net/hgchshs/article/details/131900472)    https://blog.csdn.net/hgchshs/article/details/131900472

 ----------> 验证ok： **可视化工具，合并分区**

```
 gparted
```



## ~~del_VirtualBox 扩容  反操作：~~

**VirtualBox 释放虚拟磁盘文件的大小:**

问题：

> ubuntu.vdi 会动态增大，但不会动态减小

办法：

> 参考：https://blog.csdn.net/ai2000ai/article/details/122988211
>
> -------------> 验证ok
>
> ```
>  sudo   dd if=/dev/zero of=/EMPTY bs=1M  && rm -f /EMPTY
>  
>  C:\\Users\\lenovo>vboxmanage modifyhd E:\\install\\VM\\ubuntu20.04.vdi --compact
>  0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
> ```

是否生效：

> ubuntu.vdi 的大小 是否变小

其他参考：

> https://blog.csdn.net/qq_35743870/article/details/122914298?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-122914298-blog-122988211.235^v43^pc_blog_bottom_relevance_base7&spm=1001.2101.3001.4242.1&utm_relevant_index=3



## VirtualBox共享目录

1、设置共享文件夹

- 1 选择路径
- 2 填写自定义的共享名称（在后面需要与挂载路径相对应）
- 3 设置自动挂载/固定分配

```powershell
 D:\\Program Files\\ubuntu\\ubuntuShare
 ubuntuShare
 /home/chenjinke/workingSpace/AOSP
```

**注意：无需重启VirtualBox （或ubuntu）**

2、挂载共享文件夹：参考： [详解VirtualBox中与主机共享文件夹的方法（图文）-云搜网 (27ka.cn)](https://www.27ka.cn/120058.html)        https://www.27ka.cn/120058.html

```
 sudo mount -t vboxsf  ubuntuShare  /home/chenjinke/workingSpace/AOSP
```

## virtualbox中ubuntu 磁盘满了，无法开机

-----> 只是图形界面进不去

https://www.jianshu.com/p/9e0214059487    下数据硬盘满，无法启动（Ubuntu）处理



总结一句话：

> ctrl + F2 进入命令行界面
>
> 清理磁盘

## virtualbox中ubuntu启动失败

参考：

> https://blog.csdn.net/beihuanlihe130/article/details/122728594   How To Fix Busybox Initramfs Error On Ubuntu

启动后，问题：

```java
1
BusyBox v1.30.1 (Ubuntu 1:1.30.1-4ubuntu6.1) built-in shell (ash)2
Enter 'help' for a list of built-in commands.3
4
(initramfs)
```

问题原因：

```java
1
(initramfs) exit2
/dev/sda1 contains a file system with errors, check forced. // ----------> /dev/sda1文件系统出了问题3
Inode 4326476 extent tree (at level 1) could be narrower, IGNORED.4
/dev/sda1: Inode 4326843 extent tree (at level 1) could be narrower, IGNORED.5
/dev/sda1: Inode 4327012 extent tree (at level 1) could be narrower, IGNORED.6
/dev/sda1: Inode 4329004 extent tree (at level 1) could be narrower, IGNORED.7
/dev/sda1: Inodes that were part of a corrupted orphan linked list found.8
9
/dev/sda1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.10
        (i.e., without -a or -p options)11
fsck exited with status code 4.12
The root filesystem on /dev/sda1 requires a manual fsck.13
14
BusyBox v1.30.1 (Ubuntu 1:1.30.1-4ubuntu6.1) built-in shell (ash)15
Enter 'help' for a list of built-in commands.16
17
(initramfs)
```

修复repair the filesystem：

```java
(initramfs) fsck /dev/sda1 -y
(initramfs) reboot
```

------> 不限于 virtualbox



## 如何配置virtualbox 处理器核心数？

virtualbox 在设置里给虚拟机开的处理器核心数，不要大，1个就好 ------> 多了反而不流畅。。1个很流畅



## virutualBox快捷键

1、退出全屏：  右ctrl  + F

注意：需要在桌面内使用（不能在AS内使用，被AS识别消费了）   https://blog.csdn.net/qq_15138049/article/details/125666050



## **ubuntu设置分辨率**

参考： https://blog.51cto.com/u_15057807/4126233

```
 sudo xrandr --newmode "1920x1080" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
 sudo xrandr --addmode Virtual1 "1920x1080"
 xrandr -s 1920x1080  // 设置
```

-----> 验证ok



## Windows无法ssh连接Virtualbox（VMware）

参考：

> https://blog.csdn.net/XASDASDAS/article/details/136690427?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-136690427-blog-127801394.235%5Ev43%5Econtrol&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-4-136690427-blog-127801394.235%5Ev43%5Econtrol&utm_relevant_index=9

-------------------> 已验证OK

做到的功能：

> （1）Virtualbox内部可以访问外网（百度） --------> NAT网络保证：
>
> ![image-20240403225151637](Docker.assets/image-20240403225151637.png)
>
> （2）外部网络可以访问Virtualbox内部：
>
> ​        **方法：端口转发**：win的端口与ubuntu端口映射      --------->  登录时，通过前者
>
> ![image-20240403225331342](Docker.assets/image-20240403225331342.png)
>
> 其中：win侧ip：
>
> ![image-20240403225613313](Docker.assets/image-20240403225613313.png)
>
> linux侧ip：
>
> ```java
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>        valid_lft forever preferred_lft forever
>     inet6 ::1/128 scope host
>        valid_lft forever preferred_lft forever
> 2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
>     link/ether 08:00:27:e1:35:ec brd ff:ff:ff:ff:ff:ff
>     inet 10.0.2.15/24 metric 100 brd 10.0.2.255 scope global dynamic enp0s3 ----------> //【】这里
>        valid_lft 85251sec preferred_lft 85251sec
>     inet6 fe80::a00:27ff:fee1:35ec/64 scope link
>        valid_lft forever preferred_lft forever
> ```
>
> 最终：ssh登录，用 Host的IP + Host的 port



## Virtualbox 网络连接----很优

-<font color='red'>同时设置多网卡，同时多个用途：</font>

>   网卡1设置： 网络地址转换NAT ------> 端口转发（教程：Windows无法ssh连接Virtualbox） --------> win ssh访问 linux
>
>   缺点： **win无法ping通 网卡1的ip！！！！**
>
>   用途：
>
>   >   访问外网
>   >
>   >   ssh
>
>   网卡2设置：仅主机（Host-only）网络。。。。。
>
>   用途：
>
>   >   win通过samba访问Linux
>   >
>   >   ssh直连

效果：

```java
1
$ ip addr2
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 10003
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:004
    inet 127.0.0.1/8 scope host lo5
       valid_lft forever preferred_lft forever6
    inet6 ::1/128 scope host7
       valid_lft forever preferred_lft forever8
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 10009
    link/ether 08:00:27:a0:df:fc brd ff:ff:ff:ff:ff:ff10
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3 //  ------>  网卡1 （win无法ping通）11
       valid_lft 86077sec preferred_lft 86077sec12
    inet6 fe80::b5c6:64da:44a1:4e83/64 scope link noprefixroute13
       valid_lft forever preferred_lft forever14
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 100015
    link/ether 08:00:27:83:07:ad brd ff:ff:ff:ff:ff:ff16
    inet 192.168.56.103/24 brd 192.168.56.255 scope global dynamic noprefixroute enp0s8   ------>  网卡217
       valid_lft 576sec preferred_lft 576sec18
    inet6 fe80::ec6a:eacd:7014:66d4/64 scope link noprefixroute19
       valid_lft forever preferred_lft forever20
```



## virutualBox 连手机

https://www.cnblogs.com/manmande/p/17329504.html   虚拟机Virtualbox 识别不到USB设备 的解决办法



# virtualbox安装 macOS

视频参考：

> VirtualBox7中安装macOS Big Sur，在windows10&11上【保姆级教程】哔哩哔哩bilibili    https://www.bilibili.com/video/BV1nY411d7Di/?spm_id_from=333.337.search-card.all.click&vd_source=3eebd10b94a8a76eaf4b78bee8f23884

文字教程：

> https://www.bilibili.com/read/cv20248224/      VirtualBox7中安装macOS big sur，在windows10&11上【保姆级教

## 步骤：

1、安装virtualBox

2、镜像下载：https://www.freedidi.com/6584.html

3、安装教程：https://www.bilibili.com/read/cv20248224/      **VirtualBox7中安装macOS big sur，在windows10&11上【保姆级教**

**关键步骤0（已经确认）：**

> 安装virtualBox Extension扩展包 ：
>
> 工具------> 安装

**关键步骤1（已经确认）：**

```java
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage modifyvm "macOS" --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "iMac11,3"
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage setextradata "macOS" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Iloveapple"
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage setextradata "macOS" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
 D:\\Program Files\\Oracle\\VirtualBox>VBoxManage setextradata "macOS" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 0
```

**关键步骤2（已经确认）：**

> cpu核数和内存配置不能过高 ---------->**<font color='red'>已经验证，cpu最多4个是根本原因</font>：**         

中间有看到log里有VirtualBox VT-x is not available，尝试过 关闭Hyper-V （已经验证，跟这个无关）

> （1）启用或关闭windows功能里关闭
>
> （2）bcdedit /set hypervisorlaunchtype off
>
> 参考：https://blog.csdn.net/weixin_42140580/article/details/103235619/

TODO:  bcdedit 是一个启动选项编辑工具，用来管理启动设置。

TODO:  win10下[docker](https://so.csdn.net/so/search?q=docker&spm=1001.2101.3001.7020)和虚拟机无法同时启动时问题：

> 启动虚拟机时，需要把hypervisorlaunchtype改为off          bcdedit /set hypervisorlaunchtype off
>
> 启动docker时，需要把hypervisorlaunchtype改为on         bcdedit /set hypervisorlaunchtype on
>
> bcdedit /set hypervisorlaunchtype auto
>
> 参考： https://blog.csdn.net/qiling_70/article/details/115341957?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-115341957-blog-123500614.235^v43^pc_blog_bottom_relevance_base7&spm=1001.2101.3001.4242.1&utm_relevant_index=3

先抹除磁盘，之后才在磁盘上安装系统



调整分辨率：

```java
cd "C:\Program Files\Oracle\VirtualBox\"

VBoxManage setextradata "macOS big sur" CustomVideoMode1 1900x1200x32
VBoxManage setextradata "macOS big sur" VBoxInternal2/EfiGraphicsResolution 1900x1200 
    
VBoxManage setextradata "macOS" CustomVideoMode1 1920x1080x32
VBoxManage setextradata "macOS" VBoxInternal2/EfiGraphicsResolution 1920x1080
// 参考：https://www.bilibili.com/read/cv20248224/ 出处：bilibili
```



## 关键问题：

启动时：

（1）刷屏日志卡住了

（2）屏幕报错

```
 bootstrap path:path = Library/Apple/Syste/Library/LaunchDa
 Failed to bootstrap path: path =/System/Library/LaunchDaemons/com.apple
 
```

（3）日志

```
 // macOS\\macOS\\Logs\\VBox.log.1
 00:00:03.822918 ERROR [COM]: aRC=VBOX_E_IPRT_ERROR (0x80bb0005) aIID={6ac83d89-6ee7-4e33-8ae6-b257b2e81be8} aComponent={ConsoleWrap} aText={The VBoxGuestPropSvc service call failed with the error VERR_HGCM_SERVICE_NOT_FOUND}, preserve=false aResultDetail=-2900  //【】 ERROR [COM]: aRC=VBOX_E_IPRT_ERROR
 00:00:03.958945 TM: GIP - u32Mode=3 (Invariant) u32UpdateHz=93 u32UpdateIntervalNS=10741500 enmUseTscDelta=2 (Practically Zero) fGetGipCpu=0x1b cCpus=20
 00:00:03.958967 TM: GIP - u64CpuHz=2 688 011 164 (0xa037cb9c)  SUPGetCpuHzFromGip => 2 688 011 164
 00:00:03.958971 TM: GIP - CPU: iCpuSet=0x0 idCpu=0x0 idApic=0x0 iGipCpu=0x1 i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.958974 TM: GIP - CPU: iCpuSet=0x1 idCpu=0x1 idApic=0x1 iGipCpu=0x2 i64TSCDelta=0 enmState=3 u64CpuHz=2688001900(*) cErrors=0
 00:00:03.958976 TM: GIP - CPU: iCpuSet=0x2 idCpu=0x2 idApic=0x8 iGipCpu=0xc i64TSCDelta=0 enmState=3 u64CpuHz=2688011157(*) cErrors=0
 00:00:03.958978 TM: GIP - CPU: iCpuSet=0x3 idCpu=0x3 idApic=0x9 iGipCpu=0x10 i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.958980 TM: GIP - CPU: iCpuSet=0x4 idCpu=0x4 idApic=0x10 iGipCpu=0xa i64TSCDelta=0 enmState=3 u64CpuHz=2688011096(*) cErrors=0
 00:00:03.958982 TM: GIP - CPU: iCpuSet=0x5 idCpu=0x5 idApic=0x11 iGipCpu=0x13 i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.958984 TM: GIP - CPU: iCpuSet=0x6 idCpu=0x6 idApic=0x18 iGipCpu=0xd i64TSCDelta=0 enmState=3 u64CpuHz=2688011146(*) cErrors=0
 00:00:03.958986 TM: GIP - CPU: iCpuSet=0x7 idCpu=0x7 idApic=0x19 iGipCpu=0x7 i64TSCDelta=0 enmState=3 u64CpuHz=2688011112(*) cErrors=0
 00:00:03.958988 TM: GIP - CPU: iCpuSet=0x8 idCpu=0x8 idApic=0x20 iGipCpu=0xb i64TSCDelta=0 enmState=3 u64CpuHz=2688011168(*) cErrors=0
 00:00:03.958990 TM: GIP - CPU: iCpuSet=0x9 idCpu=0x9 idApic=0x21 iGipCpu=0xf i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.958992 TM: GIP - CPU: iCpuSet=0xa idCpu=0xa idApic=0x28 iGipCpu=0x4 i64TSCDelta=0 enmState=3 u64CpuHz=2688010864(*) cErrors=0
 00:00:03.958994 TM: GIP - CPU: iCpuSet=0xb idCpu=0xb idApic=0x29 iGipCpu=0x8 i64TSCDelta=0 enmState=3 u64CpuHz=2688011138(*) cErrors=0
 00:00:03.958996 TM: GIP - CPU: iCpuSet=0xc idCpu=0xc idApic=0x30 iGipCpu=0x5 i64TSCDelta=0 enmState=3 u64CpuHz=2688010939(*) cErrors=0
 00:00:03.958998 TM: GIP - CPU: iCpuSet=0xd idCpu=0xd idApic=0x32 iGipCpu=0x11 i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.959000 TM: GIP - CPU: iCpuSet=0xe idCpu=0xe idApic=0x34 iGipCpu=0x12 i64TSCDelta=0 enmState=3 u64CpuHz=2688016583(*) cErrors=0
 00:00:03.959002 TM: GIP - CPU: iCpuSet=0xf idCpu=0xf idApic=0x36 iGipCpu=0xe i64TSCDelta=0 enmState=3 u64CpuHz=2688011164(*) cErrors=0
 00:00:03.959004 TM: GIP - CPU: iCpuSet=0x10 idCpu=0x10 idApic=0x38 iGipCpu=0x6 i64TSCDelta=0 enmState=3 u64CpuHz=2688011075(*) cErrors=0
 00:00:03.959006 TM: GIP - CPU: iCpuSet=0x11 idCpu=0x11 idApic=0x3a iGipCpu=0x3 i64TSCDelta=0 enmState=3 u64CpuHz=2688010559(*) cErrors=0
 00:00:03.959009 TM: GIP - CPU: iCpuSet=0x12 idCpu=0x12 idApic=0x3c iGipCpu=0x0 i64TSCDelta=0 enmState=3 u64CpuHz=2688011164(*) cErrors=0
 00:00:03.959014 TM: GIP - CPU: iCpuSet=0x13 idCpu=0x13 idApic=0x3e iGipCpu=0x9 i64TSCDelta=0 enmState=3 u64CpuHz=2688011187(*) cErrors=0

 .................
 00:00:01.720624 CPUM: No hardware-virtualization capability detected //【】
```

**解决办法：**

```java
 On a Windows host I would recommend reducing VM RAM to 6GB (6144MB). On a MacOS host... I'm not entirely sure how much free RAM it likes, but you can certainly start with 6GB.
 Reduce CPU cores to 2 as well.
 // 减少cpu和mem

 // 参考： https://forums.virtualbox.org/viewtopic.php?t=107319&start=45
```

TODO:

> **为啥配置cpu核数多，不行呢？**      （1）英语英语英语 （2）安装软件的log！！！！！！(3) difficult Problem只能英语解决！！！！



## 系统快照----备份

控制---生成备份



## 共享目录/共享剪切板

------------------->  **以上两者都没搞定**

-<font color='red'>万能方法：</font>

> ssh登录（共享）

~~具体步骤：~~

> 
>
> （1）保证window宿主能ping容器
>
> ​     桥接网络
>
> ![image-20240219004033454](Docker.assets/image-20240219004033454.png)
>
> （2）参考：https://support.apple.com/zh-cn/guide/mac-help/mchlp1066/13.0/mac/13.0   ssh登录mac
>
> ![image-20240219003752476](Docker.assets/image-20240219003752476.png)





## 其他参考

https://leon1741.blog.csdn.net/article/details/80910244?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-4-80910244-blog-129246509.235^v43^pc_blog_bottom_relevance_base7&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-4-80910244-blog-129246509.235^v43^pc_blog_bottom_relevance_base7&utm_relevant_index=9&ydreferer=aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzE5NzMxNTIxL2FydGljbGUvZGV0YWlscy8xMjkyNDY1MDk%3D

https://blog.csdn.net/jimmyleeee/article/details/114627727  

https://blog.csdn.net/lb245557472/article/details/103565752

# wmWare

## wmWare优缺点：

wmWare优点十分明显：

1、比docker： 

> （1）<font color='red'>可以动态化挂载物理硬盘</font>  
>
> ​         **可以挂多个硬盘！！！**
>
> ​        SSD  + 普通硬盘   -------->  快慢相宜
>
> （2）文件系统可以是split files ----------> copy快很多
>
> （3）不需要每次修改都要commit！！！！！

2、virtualBox性能太差

## wmWare联网

联网: 

>   >   (1) 外网baidu
>   >
>   >   (2) 主机网
>   >
>   >   参考：
>   >
>   >   https://blog.csdn.net/zhangxm_qz/article/details/122612605    vmware虚拟机三种网络模式及配置详解   ----> 好文，图文原理详解
>
>   其中 NaT模式 -----> 验证ok
>
>   其中：Ubuntu配置DHCP配置： https://blog.csdn.net/dacming/article/details/121188742
>
>   ```java
>   # Let NetworkManager manage all devices on this system
>   network:
>     version: 2
>     renderer: NetworkManager
>     ethernets:
>       enp4s0:
>         dhcp4: true
>   ```



## wmWare下ubuntu 访问外网（宿主win 代理网络）

### 结构：

>   ![image-20240601202053400](Docker.assets/image-20240601202053400.png)
>
>   图：《VMWareNet.eddx》

### win侧设置：

1、win为 局域网内其他设备代理，开启：

![image-20240601200648209](Docker.assets/image-20240601200648209-1720024368511.png)

用户名、密码不填



会新增：

![image-20240601202449595](Docker.assets/image-20240601202449595.png)

>   win软件的代理都是走的：  **本地**， 127.0.0.1：10810
>
>   vMware软件走的代理是：**局域网** ， winIP:10813

### Ubuntu设置:

1、全局代理设置：



ip即win的ipv4：

![image-20240601203359393](Docker.assets/image-20240601203359393.png)

![image-20240601203440590](Docker.assets/image-20240601203440590.png)

2、配置浏览器

**很奇怪，每个软件需要单独配置？？？？**

![image-20240601203704516](Docker.assets/image-20240601203704516.png)

---------------> 验证：可以打开youtube网站



3、给Terminal配置(可能需要)：

在全局代理设置后，看一下Terminal环境变量，是否有：

```java
$ export
declare -x ALL_PROXY="socks://192.168.1.4:10812/"
declare -x HTTPS_PROXY="http://192.168.1.4:10813/"
declare -x HTTP_PROXY="http://192.168.1.4:10813/"
declare -x all_proxy="socks://192.168.1.4:10812/"
declare -x http_proxy="http://192.168.1.4:10813/"
declare -x https_proxy="http://192.168.1.4:10813/"
```

-----------> OK

 没有的话，需要配置环境变量：

临时：

```java
$ export http_proxy=http://192.168.1.4:10813
$ export https_proxy=http://192.168.1.4:10813
```



4、Android studio配置代理

![image-20240601210047083](Docker.assets/image-20240601210047083.png)

5、 git软件配置代理   --------> 没验证

```java
git config --global http.proxy 'socks5://127.0.0.1:1080'  
git config --global https.proxy 'socks5://127.0.0.1:1080'
```



6、SNAP使用代理 --------> 没验证

```java
snap set system proxy.http="http://<proxy_addr>:<proxy_port>"
snap set system proxy.https="http://<proxy_addr>:<proxy_port>"
```

7、APT使用代理  --------> 没验证  **TODO:  这个应该非常有用！！！**

```java
vim /etc/apt/apt.conf.d/proxy.conf
Acquire::http::Proxy "http://username:password@proxy-IP-address:proxyport";
Acquire::https::Proxy "http://username:password@proxy-IP-address:proxyport";
```

参考： [Linux配置代理的方法](https://blog.csdn.net/m0_37132242/article/details/104553302)



### 参考：

[VMware虚拟机使用主机代理](https://blog.csdn.net/yuxi_xi/article/details/135783037?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-135783037-blog-138069939.235^v43^control&spm=1001.2101.3001.4242.1&utm_relevant_index=3)

## wmWaressh

前提：wmWare联网

>   其他同正常ssh登录

## wmWare 挂载 物理硬盘（物理分区）-----扩容

---------------------->  wmWare 非常大的优点：动态化扩容

```powershell
lsblk
sudo mount -t ext4 /dev/sdb2 /home/chengang/workingspace_disk2       -----> 注意，必须指定类型，否则失败！！！！！
```



**步骤：**

> 1、win格式化出一个分区出来（<font color='red'>最好是Ext4，linux格式，linux下读写快！！！</font>）
>
> ![image-20240416004343285](Docker.assets/image-20240416004343285.png)
>
> 2、<font color='red'>以管理员方式打开</font>  VMware Workstation Pro应用
>
> 3、设置
>
> ![image-20240416004358388](Docker.assets/image-20240416004358388.png)
>
> ![image-20240416003450080](Docker.assets/image-20240416003450080.png)









扩展：TODO： 

>  整个硬盘，不同的磁盘分区，容器都能看到 ----------> 意味着可以看到所有的win下所有路径
>
> ![image-20240416003538023](Docker.assets/image-20240416003538023.png)





如果看不到新增的物理磁盘，重启Linux



## adb连手机

https://blog.csdn.net/lspqq10086/article/details/127447126?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-127447126-blog-123850238.235%5Ev38%5Epc_relevant_anti_t3&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-127447126-blog-123850238.235%5Ev38%5Epc_relevant_anti_t3&utm_relevant_index=2

## ssh远程连接到VMware虚拟主机

https://blog.csdn.net/lsgzn/article/details/130199569   实现局域网内ssh远程连接到VMware虚拟主机

 -----> 验证 ok



关键步骤：

> win转 容器
>
> > ![image-20240416004934428](Docker.assets/image-20240416004934428.png)
>
> 
>
> win下ssh连 容器linux：
>
> > 容器ip（ip add） + 容器内22



## **虚拟机和主机共享文件夹步骤**：

1.1右键虚拟机--设置---选项--共享文件夹--选择总是启用---添加一个盘

1.2ubuntu中进入/mnt/hgfs/目录查看是否有共享文件夹（也可以放在home目录下自己创建一个文件夹如/home/feng/work）

1.3 若没有hgfs存在则按以下步骤操作：

**sudo apt-get install open-vm-tools**

**cd /mnt/**

**sudo passwd root**

**su root**

**mkdir hgfs**

**sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other**

或**sudo vmhgfs-fuse .host:/ /home/feng/work -o allow_other**

其中/mnt/hgfs/文件夹目录可以自行修改

再到/mnt/下看就会有 hgfs文件夹了，里面有共享文件夹目录存在

这里是有个空格的







**解决   虚拟机和主机共享文件夹 <font color='red'>失败问题：</font>**

> 方法一（**验证OK**）：
>
> ```
> sudo chmod 777 /mnt/hgfs
> vmhgfs-fuse .host:/ /mnt/hgfs
> ```
>
> 
>
> 方法二（**验证OK**）：
>
> ```
> 解决重启后共享文件夹失效 
> sudo vim /etc/fstab 在最后添加一行： 
> .host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0 
> ```
>
> ----------> 以后重启都会自动挂载
>
> 
>
> 参考：https://juejin.cn/post/7249297734867943479        Ubuntu 20.04 /mnt/hgfs/下不显示共享文件夹的处理办法





## 扩容

https://blog.csdn.net/qq_37140721/article/details/125619393





## 一些问题 & 报错

### linux adb连接手机报错：

adb 出现 insufficient permissions for device: user in plugdev group； are your udev rules wrong?

 no permissions (user in plugdev group; are your udev rules wrong?)

解决方法：https://blog.csdn.net/witch23333/article/details/131107097       ------------------------->  验证OK



### “拍摄快照”  无法使用

![image-20240601213613351](Docker.assets/image-20240601213613351.png)

 办法：先移除，之后再添加：

>   ![image-20240601213434730](Docker.assets/image-20240601213434730.png)

