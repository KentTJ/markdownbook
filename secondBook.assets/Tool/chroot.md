# Linux 命令：chroot

--<font color='red'>本质：</font>

> 1、隔离文件系统，类似于  Namespace
>
> 2、

好处：

> 基于 **隔离文件系统** --------> 自然：安全性：~~新根下将访问不到旧系统的根目录结构和文件，这样就增强了系统的安全性~~



## 例子

语法：



## 参考：

好文：

> https://blog.csdn.net/jiaoyangwm/article/details/130308127   【Linux 命令】chroot
>
> ----------------->  从最基本chroot来构建一个文件系统



其他：

https://blog.csdn.net/IT8343/article/details/130570144           使用chroot定制系统



# Linux 系统启动过程

https://blog.csdn.net/m0_65541699/article/details/127944130  Linux 系统启动过程



# linuxdeploy 

linuxdeploy 的原材料可以是iso，img等

比如：

```java
linuxdeploy -arch arm -v ubuntu -f ext4 -p /sdcard/ubuntu.img
```



参考： 

 https://www.python100.com/html/89007.html



https://hunter1024.blog.csdn.net/article/details/128718170?spm=1001.2101.3001.6650.16&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-16-128718170-blog-112281860.235%5Ev38%5Epc_relevant_sort_base1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-16-128718170-blog-112281860.235%5Ev38%5Epc_relevant_sort_base1&utm_relevant_index=22&ydreferer=aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NzA0NjQwL2FydGljbGUvZGV0YWlscy8xMTIyODE4NjA%3D    

------》 验证ok

https://blog.csdn.net/qq_41709234/article/details/128570505    Debian系统--从零开始自制linux掌上电脑

https://www.cnblogs.com/twzy/p/15160824.html    [小白自制Linux开发板 五. Debian文件系统制作,以及WIFI配置、交换分区配置 ](https://www.cnblogs.com/twzy/p/15160824.html)

-------》 验证ok

https://zhuanlan.zhihu.com/p/623363577   使用debootstrap手动安装debian系统



https://github.com/meefik/linuxdeploy-cli    

# 源码：

https://github.com/meefik/linuxdeploy-cli

# 背后的背后 



# 抛开chroot