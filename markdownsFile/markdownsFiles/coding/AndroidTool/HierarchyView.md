# 目录

[TOC]



# HierarchyView APP

越过各种权限：

HierarchyView APP    ------>   socket  -------->  wms侧viewServer   ------>     wms执行viewServerWindowCommand   ------->  通过binder  IWindow，找到应用窗口具体执行   -----> ViewRootImpl侧： dispatchCommand

TODO:

> HierarchyView APP工具 和 sh脚本，也是用户端，体现

参考：

> https://www.cnblogs.com/carlo/p/4798250.html      HierarchyView的实现原理和Android设备无法使用HierarchyView的解决方法