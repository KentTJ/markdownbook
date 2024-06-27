# 目录



# 参考：

 https://blog.csdn.net/u010351988/article/details/131061566

# 前台服务

应用侧配置：

> ```
>  startForeground()
>  
>  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
> ```
>
> 启动前台服务的时候，需要发送一个前台的通知  ------------>  TODO:  这个才是真正的约束？（startForeground不是真正的约束，因为应用可以无条件使用）
>
> 真正的约束：一定是要**有代价的**  限制
>
> 比如，需要用户手动确认给权限

# 借助广播唤醒

参考： https://www.jianshu.com/p/647a50447bac