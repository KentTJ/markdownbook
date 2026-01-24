

# 源码下载

```
repo init -u https://gitee.com/openharmony/manifest -b OpenHarmony-3.2-Release --no-repo-verify
repo init -u https://gitee.com/openharmony/manifest -b OpenHarmony-4.0-Release --no-repo-verify
repo sync -c
repo forall -c 'git lfs pull'
```





参考：

> https://blog.51cto.com/harmonyos/6687138     **【OpenHarmony下载和编译源码】详解下载和编译OpenHarmony源码以及烧录工具，MobaXTerm的基本使用**
>
> https://ost.51cto.com/posts/24526    从OpenHarmony原码下载开始学习repo及manifest原码

# OpenHarmony源码解析之多模输入子系统(一)

https://ost.51cto.com/posts/22632     OpenHarmony源码解析之多模输入子系统(一)

https://ost.51cto.com/posts/8392    OpenHarmony 源码解析之多模输入子系统（事件派发流程）

https://ost.51cto.com/posts/14326    多模输入事件分发机制详解

https://www.seaxiang.com/blog/53cce2a751e04ca790fdca7dfb26f84b   harmony 鸿蒙多模输入子系统

# 分布式

https://blog.csdn.net/weixin_41559503/article/details/128849514?spm=1001.2014.3001.5502   分布式

```java
 private static final int SHOW_KEYBOARD_DELAY = 800;
```

https://blog.csdn.net/weixin_41559503/article/details/128851385?spm=1001.2014.3001.5502    js渲染框架