

# profiler之 火焰图：

## 为什么要有火焰图？

systrace不能用嘛？ ----------->  systrace没有每一个函数的调用时间（只是打标签的一段）



## 获取

火焰图：    [性能优化---启动优化 Debug.startMethodTracing_debug.startmethodtracing()-CSDN博客](https://blog.csdn.net/chuyouyinghe/article/details/131719609)    https://blog.csdn.net/chuyouyinghe/article/details/131719609

官网：

> https://developer.android.google.cn/studio/profile/generate-trace-logs?hl=zh-cn

```java
Debug.startMethodTracing("sample")

Debug.stopMethodTracing();

多次循环时：
SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd_MM_yyyy_hh_mm_ss", Locale.getDefault());
String logDate = dateFormat.format(new Date());
// Applies the date and time to the name of the trace log.
Debug.startMethodTracing(
        "sample-" + logDate);
```

- ------------------> 技巧： 不知道什么时候结束的时候，用计时器10s后，抛到主线程

TODO: ZHAOPIAN



参考： 

 https://developer.android.google.cn/studio/profile/generate-trace-logs#java           Generate Trace Logs by Instrumenting Your App

https://developer.android.google.cn/studio/profile/record-traces   Record traces

https://developer.android.google.cn/studio/profile/inspect-traces             Inspect traces  分析

https://zhuanlan.zhihu.com/p/511224713    android studio profiler 性能分析   --------->  **好文**

https://www.jianshu.com/p/596b2ef68342       性能优化工具（十一）-Android Profiler    ---->  **结构**



## 读火焰图-----TODO

好文：

[如何读懂火焰图？ 实例讲解程序性能优化 | HeapDump性能社区](https://heapdump.cn/article/3486818)           https://heapdump.cn/article/3486818



### 分析 之 性能问题点：

> 平顶山：  火焰图就是看顶层的哪个函数占据的宽度最大。只要有"平顶山"，就表示该函数可能存在性能问题。
>
> 倒T 型： 如果A方法本身就慢呢？通过火焰图也是可以看出来的，这种底层栈的宽度很宽，但是建立在其撒花姑娘的调用链线条都很窄，火焰图呈现“┻”型，那么我们基本可以确定，栈底方法本身就存在性能问题。

https://www.qinglite.cn/doc/468764776cec22698





## linux火焰图 



https://www.qinglite.cn/doc/468764776cec22698     调优利器-火焰图使用图鉴



## 常见耗时（火焰图上很直观）

1、打印调用栈（支付宝代码里就有）  ------> 该死, 非常耗时

2、Log耗时非常小------>  Log耗时，可以忽略

> 在5us作用，也就是说打印200个log，才1ms



**规定，性能验证：**

> 开发完任何需求，主要流程，抓一下火焰图！！！！！



**TODO:** 开发验证

> 功能性验证：异常场景
>
> 性能验证 ：火焰图
>
> 开发稳定性验证：Top28应用验证



## 参考：





