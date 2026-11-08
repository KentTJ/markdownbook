









# 目录





recv、select和epoll都是阻塞方法。阻塞方法，不占CPU！！！





# 多个客户端对一个服务端-------多线程实现方式（cpp）

实现方式：  为每个客户端安排一个线程

> ~~通过在服务器端建立两个线程，主线程用来监听客户端的接入，当有新的客户端接入时，服务器为新的客户端建立服务线程，通过服务线程来实现服务器与客户端的通信~~



https://blog.csdn.net/m0_67391521/article/details/124164855?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-124164855-blog-129757444.235^v38^pc_relevant_anti_t3&spm=1001.2101.3001.4242.1&utm_relevant_index=3        C++SOCKET多线程网络编程实现多个客户端与服务器通信



# 多个客户端对一个服务端------epoll实现方式

https://blog.csdn.net/youaremyalllove/article/details/128508470      从socket开始讲解网络模式（epoll）

------------->  **好文:**  代码       +    图片



补充：？   https://blog.csdn.net/CHNIM/article/details/130891045           linux上的epoll如何使用，并用C++实现多客户端服务器





https://zhuanlan.zhihu.com/p/658504209   TCP Socket性能优化秘籍：掌握read、recv、readv、write、send、sendv的最佳实践

------------------------------>  性能调优



# TODO: 更底层----socket阻塞的唤醒





https://zhuanlan.zhihu.com/p/366365883   linux网络编程之带你了解epoll的本质（内部实现原理）

--------------------> TODO： <font color='red'>好文！！！！解释了为啥epoll如此高效：</font>

![img](socket.assets/v2-10c5936545f0adabfc9f45510b8328cc_720w.webp)

# 面试题：

https://blog.csdn.net/weixin_44844089/article/details/115655642           操作系统面试题：进程如何阻塞？进程阻塞为什么不占用CPU？

https://blog.csdn.net/Shangxingya/article/details/112427967    操作系统~复习线程状态转换的过程, 对比租阻塞和挂起的区别, 以及上下文切换消耗什么资源

-------------------->  

阻塞与挂起的**区别:**

> 一个被动，一个主动

**相同点：**

> 线程都放弃CPU的使用



https://blog.csdn.net/wang_Bo_JustOne/article/details/51597671       关于线程阻塞的问题，留着看了

---------------->  结论：

1、 非阻塞模式的使用并不普遍，因为**非阻塞模式会浪费大量的CPU资源**。 

2、I/O多路复用 非常好。时间复杂度O（1）



# TODO：

https://blog.csdn.net/qq_41872247/article/details/125211491  Zygote  为啥用的是poll？一对一呀