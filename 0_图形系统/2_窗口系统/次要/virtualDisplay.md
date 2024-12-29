[【Android】VirtualDisplay创建流程及原理_createvirtualdisplay-CSDN博客](https://linduo.blog.csdn.net/article/details/133841331?spm=1001.2101.3001.6650.6&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-6-133841331-blog-119785457.235^v43^pc_blog_bottom_relevance_base7&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~Rate-6-133841331-blog-119785457.235^v43^pc_blog_bottom_relevance_base7&utm_relevant_index=12)

-   -----------> TODO:

（1） 如何创建？

（2）哪里渲染的？底层渲染有什么区别？

通过它创建VirtualDisplayDevice + LogicalDisplay来管理虚拟屏幕。

### virtual display

virtual display id 是hwc 上报给android 的，我们会一开始create 几条virtual display 出来