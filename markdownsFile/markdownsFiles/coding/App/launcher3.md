

# 目录

[TOC]



# 启动流程--launcher3

见 《启动流程---AMS》



# Launcher3

https://blog.csdn.net/dingfengnupt88/article/details/51800057?spm=1001.2014.3001.5502

**loadAllApps()流程：**

```
  // 获取需要显示在Launcher上的activity列表
 List<LauncherActivityInfoCompat> apps = mLauncherApps.getActivityList(null, user);  // 其中，mLauncherApps是系统服务(即：mLauncherApps = mApp.getContext().getSystemService(LauncherApps.class);)
 
 
 // 获取图标icon
 mBgAllAppsList.add(new AppInfo(app, user, quietMode), app);// This builds the icon bitmaps. // 创建应用图标对象，
 ----->  mIconCache.getTitleAndIcon
    ----->  cacheLocked  ---> ........ ----->  PackageInfo info = mPackageManager.getPackageInfo(packageName, flags);//最终追溯到PackageManager 或者 <https://juejin.cn/s/android%20%E8%8E%B7%E5%8F%96%E5%BA%94%E7%94%A8%E5%9B%BE%E6%A0%87>
            applyCacheEntry
 
 
 // 启动是因为对每个icon设置了监听
 icon.setOnClickListener(mLauncher);
 icon.setOnLongClickListener(this);
```

**已经验证：**

```
    <https://juejin.cn/s/android%20%E8%8E%B7%E5%8F%96%E5%BA%94%E7%94%A8%E5%9B%BE%E6%A0%87>

    此外，Android11之后, 需要加:
    AndroidManifest.xml
    <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"
         tools:ignore="QueryAllPackagesPermission" />;
```

**一些问题：**

> 1、Linux侧启动的应用 ：安卓launcher3没有参与任务栈   ----->  后续AMS 管理任务栈，会不会有问题？
>
> --------->  应该还好
>
> 2、launcher3 设置为透明：那么launcher3 需要运行的意义在哪里？是否可以干掉？（如果不干掉，是不是有大部分功能可以干掉？）
>
> ---------> 感觉可以干掉

参考系列：

> 1、https://blog.csdn.net/dingfengnupt88/article/details/51799392?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-51799392-blog-132246995.235^v38^pc_relevant_sort_base1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-51799392-blog-132246995.235^v38^pc_relevant_sort_base1&utm_relevant_index=2             Launcher3--初识Launcher3
>
> 2、https://blog.csdn.net/dingfengnupt88/article/details/51800057?spm=1001.2014.3001.5502

