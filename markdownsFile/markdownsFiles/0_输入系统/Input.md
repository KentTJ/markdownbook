

# 目录

# Input知识点大纲

![img](Input.assets/1b6fcc7e16a431137daecc8e440a3362.png)

# input系统

## 0层结构



%accordion%参考的0层图%accordion%

> ![image-20221209010804487](Input.assets/image-20221209010804487.png)
>
> --------------------->  方向比较好，上下方向；但是没有关系连线！
>
> %/accordion%















![image-20221211113522996](Input.assets/image-20221211113522996.png)

![img](Input.assets/08123040_648159703e94a61081.png)

[图来源](https://blog.51cto.com/u_16099334/6439040#:~:text=%E5%85%88%E7%9C%8B%E4%B8%AA%E5%A4%A7%E6%A6%82%EF%BC%8C-,%E4%BB%A5%E5%90%8E%E4%BC%9A%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D%E5%8F%82%E4%B8%8E%E5%85%B6%E4%B8%AD%E7%9A%84%E5%90%84%E4%B8%AA%E7%BB%84%E4%BB%B6,-%EF%BC%9A)

### 结构之线程角度

IMS线程结构：

```
 IMS.start(启动)
     nativeStart
         InputManager.start
             InputReaderThread->run
             InputDispatcherThread->run
```

------------->结论： IMS下是两个线程：读取和分发

启动的类顺序：

```
 InputManagerService(初始化)
     nativeInit
         NativeInputManager
             EventHub
             InputManager
                 InputDispatcher
                     Looper
                 InputReader
                     QueuedInputListener
                 InputReaderThread
                 InputDispatcherThread
```

InputDispatch线程结构：

补充，参考：

> Input系统—事件处理全过程 - Gityuan博客 | 袁辉辉的技术博客
>
> 交互过程图---socket

[android input 点击 android input系统*mob6454cc7966b9的技术博客*51CTO博客](https://blog.51cto.com/u_16099334/6439040)

--------> 0层结构、1层结构用这里的！！！！





## 1层流程



%accordion%参考的gityuan的input分发流程图：%accordion%

> ![input_summary](Input.assets/input_summary.jpg)
>
> ~~图见： http://gityuan.com/2016/12/31/input-ipc/~~
>
> -----------------> TODO: 流程图画的不好: 
>
>  (1) 没有基于结构图！！！！ (2) 方向不是事件的上下方向
>
> %/accordion%

## raw motion event -----> MOTION_DOWN

InputReader 处理 raw motion event ，会生成 MOTION_DOWN, MOTION_MOVE, MOTION_UP 这样的高级事件

## TouchEvent事件分发的点

参考：https://juejin.cn/post/7202537103934177338#heading-2  InputDispatcher 分发触摸事件

事件分发的**总入口：**

```java
std::vector<InputTarget> InputDispatcher::findTouchedWindowTargetsLocked(
        nsecs_t currentTime, const MotionEntry& entry, bool* outConflictingPointerActions,
        InputEventInjectionResult& outInjectionResult) {
        
链接：https://juejin.cn/post/7202537103934177338
```



### ACTION DOWN的分发

inputDispatcher 分发到哪个窗口：

代码：sp<WindowInfoHandle> InputDispatcher::findTouchedWindowAtLocked

日志：

```java
 ALOGD("debug_magic_input pos:[%d,%d], deviceId:%d, displayId:%d, pid:%d, %s",
     x, y, touchState ? touchState->deviceId : -1, displayId,
 windowInfo->ownerPid, windowInfo->name.c_str());
```

调用栈：TODO:





inputDispatcher 怎么知道窗口信息的？



一句话总结：

>   down事件的分发，其实是根据 x,y 坐标寻找触摸的窗口



###  ~~ACTION MOVE的分发~~

```java
std::vector<InputTarget> InputDispatcher::findTouchedWindowTargetsLocked(
        nsecs_t currentTime, const MotionEntry& entry, bool* outConflictingPointerActions,
        InputEventInjectionResult& outInjectionResult) {
    // ...

    const TouchState* oldState = nullptr;
    TouchState tempTouchState;
    if (const auto it = mTouchStatesByDisplay.find(displayId); it != mTouchStatesByDisplay.end()) {
        oldState = &(it->second);
        // tempTouchState 保存了 action down 的触摸的窗口
        tempTouchState = *oldState;
    }

    // ...

    // true
    const bool wasDown = oldState != nullptr && oldState->isDown();
    // false
    const bool isDown = (maskedAction == AMOTION_EVENT_ACTION_DOWN) ||
            (maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN && !wasDown);

    // ...

    if (newGesture || (isSplit && maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN)) {
        
    } else {
        // ...

        // 处理滑出窗口的情况
        if (maskedAction == AMOTION_EVENT_ACTION_MOVE && entry.pointerCount == 1 &&
            tempTouchState.isSlippery()) {
            // ...
        }

        // 本文不讨论多手指的 split touch
        if (!isSplit && maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN) {
           
        }
    }

    // ...


    for (const TouchedWindow& touchedWindow : tempTouchState.windows) {
        if (touchedWindow.pointerIds.none() && !touchedWindow.hasHoveringPointers(entry.deviceId)) {
            continue;
        }
        
        // 把 tempTouchState.windows 中保存的 touched window 保存到 targets
        addWindowTargetLocked(touchedWindow.windowHandle, touchedWindow.targetFlags,
                              touchedWindow.pointerIds, touchedWindow.firstDownTimeInTarget,
                              targets);
    }

    // ...

    // 返回找到的触摸窗口
    return targets;
}
链接：https://juejin.cn/post/7202537103934177338
```

一句话总结：

>   ACTION MOVE 的触摸窗口，仍然是 ACTION DOWN 的触摸窗口

### ACTION UP的分发

```java
std::vector<InputTarget> InputDispatcher::findTouchedWindowTargetsLocked(
        nsecs_t currentTime, const MotionEntry& entry, bool* outConflictingPointerActions,
        InputEventInjectionResult& outInjectionResult) {
    // ...

    const TouchState* oldState = nullptr;
    TouchState tempTouchState;
    if (const auto it = mTouchStatesByDisplay.find(displayId); it != mTouchStatesByDisplay.end()) {
        oldState = &(it->second);
        // tempTouchState 保存的仍然是 ACTION DOWN 的 touched window
        tempTouchState = *oldState;
    }

    // ...

    // true
    const bool wasDown = oldState != nullptr && oldState->isDown();
    // false
    const bool isDown = (maskedAction == AMOTION_EVENT_ACTION_DOWN) ||
            (maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN && !wasDown);
   
    // ...


    if (newGesture || (isSplit && maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN)) {
        
    } else {
        // ...
        
        // 处理滑出窗口的情况
        if (maskedAction == AMOTION_EVENT_ACTION_MOVE && entry.pointerCount == 1 &&
            tempTouchState.isSlippery()) {
            // ...
        }

        // 本文不讨论多手指 split touch
        if (!isSplit && maskedAction == AMOTION_EVENT_ACTION_POINTER_DOWN) {
            
        }
    }

    // ...

    // Output targets from the touch state.
    for (const TouchedWindow& touchedWindow : tempTouchState.windows) {
        if (touchedWindow.pointerIds.none() && !touchedWindow.hasHoveringPointers(entry.deviceId)) {
            continue;
        }

        // 把 tempTouchState.windows 保存的 touched window 保存到 targets
        addWindowTargetLocked(touchedWindow.windowHandle, touchedWindow.targetFlags,
                              touchedWindow.pointerIds, touchedWindow.firstDownTimeInTarget,
                              targets);
    }


    // ...

    if (isHoverAction) {
        
    } else if (maskedAction == AMOTION_EVENT_ACTION_UP) {
        // Pointer went up.
        // 移除手指id对应的 touched window
        tempTouchState.removeTouchedPointer(entry.pointerProperties[0].id);
    } else if (maskedAction == AMOTION_EVENT_ACTION_CANCEL) {
        
    } else if (maskedAction == AMOTION_EVENT_ACTION_DOWN) {
       
    } else if (maskedAction == AMOTION_EVENT_ACTION_POINTER_UP) {
       
    }

    // ...

    // tempTouchState 此时已经没有 touched window，因此移除 tempTouchState 数据
    if (tempTouchState.windows.empty()) {
        mTouchStatesByDisplay.erase(displayId);
    }

    // 返回寻找到的触摸窗口
    return targets;
}

链接：https://juejin.cn/post/7202537103934177338

```

一句话总结：

>   ACTION up 的触摸窗口，仍然是 ACTION DOWN 的触摸窗口

## KeyEvent事件

### APP侧分发：

InputDispatcher::dispatchKeyLocked    -------> 找具体的进程

对于输入法，back键 KeyEvent走：

### 疑问：

TODO:

真正的分发点在哪里？上图，已经进入进程了

是否消费，即 event.dispatch 返回给了谁？

与硬件键盘事件，是一个

IMS为啥要有两个线程？一个·线程从模型结构上看，有啥缺陷嘛？

### 处理

KeyEvent.java:

```java
     public final boolean dispatch(Callback receiver, DispatcherState state,
             Object target) {
         switch (mAction) {
             case ACTION_DOWN: {
                 mFlags &= ~FLAG_START_TRACKING;
                 if (DEBUG) Log.v(TAG, "Key down to " + target + " in " + state
                         + ": " + this); //关键日志
```

关键日志：

对于输入法，处理：

```java
 public boolean onKeyDown(int keyCode, KeyEvent event) {
     if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
         final ExtractEditText eet = getExtractEditTextIfVisible();
         if (eet != null && eet.handleBackInTextActionModeIfNeeded(event)) {
             return true;
         }
         if (handleBack(false)) {  // 这里去doHideWindow()了
             event.startTracking();
             return true;
         }
         return false;
     }
     return doMovementKey(keyCode, event, MOVEMENT_DOWN);
 }
```

## **Touch目标窗口的确定：**

--------------------------> **简言之，**目标窗口的确定：

> 可以根据触摸事件的位置   +   窗口的属性

> Touch事件，不是对焦点窗口分发的！！！！！！！！！！！！而是根据位置区分！！！！！----------------> 自然
>
> ------------> 因为Touch不需要焦点，他知道对哪个窗口分发
>
> key事件，自然是对焦点窗口

根据位置区分的证明：

```java
 sp<WindowInfoHandle> InputDispatcher::findTouchedWindowAtLocked(int32_t displayId, int32_t x,
                                                                 int32_t y, TouchState* touchState,
                                                                 bool addOutsideTargets,
                                                                 bool addPortalWindows,
                                                                 bool ignoreDragWindow) {
     if ((addPortalWindows || addOutsideTargets) && touchState == nullptr) {
         LOG_ALWAYS_FATAL(
                 "Must provide a valid touch state if adding portal windows or outside targets");
     }
     // Traverse windows from front to back to find touched window.
     const std::vector<sp<WindowInfoHandle>>& windowHandles = getWindowHandlesLocked(displayId);
     for (const sp<WindowInfoHandle>& windowHandle : windowHandles) {
         if (ignoreDragWindow && haveSameToken(windowHandle, mDragState->dragWindow)) {
             continue;
         }
         const WindowInfo* windowInfo = windowHandle->getInfo();
         if (windowInfo->displayId == displayId) {
             auto flags = windowInfo->flags;
 
             if (windowInfo->visible) { // 【】 窗口的属性1 visible
                 if (!flags.test(WindowInfo::Flag::NOT_TOUCHABLE)) {  // 【】 窗口的属性2 TOUCHABLE
                     bool isTouchModal = !flags.test(WindowInfo::Flag::NOT_FOCUSABLE) &&
                             !flags.test(WindowInfo::Flag::NOT_TOUCH_MODAL);
                     if (isTouchModal || windowInfo->touchableRegionContainsPoint(x, y)) { // 【】 触摸事件的位置
                         int32_t portalToDisplayId = windowInfo->portalToDisplayId;
                         if (portalToDisplayId != ADISPLAY_ID_NONE &&
                             portalToDisplayId != displayId) {
                             if (addPortalWindows) {
                                 // For the monitoring channels of the display.
                                 touchState->addPortalWindow(windowHandle);
                             }
                             return findTouchedWindowAtLocked(portalToDisplayId, x, y, touchState,
                                                              addOutsideTargets, addPortalWindows);
                         }
 
                         //add dual windows
                         ALOGD("debug_input pos:[%d,%d], deviceId:%d, displayId:%d, pid:%d, %s",
                                 x, y, touchState ? touchState->deviceId : -1, displayId,
                                 windowInfo->ownerPid, windowInfo->name.c_str());
 
                         // Found window.
                         return windowHandle;
                     }
                 }
 
                 if (addOutsideTargets && flags.test(WindowInfo::Flag::WATCH_OUTSIDE_TOUCH)) {
                     touchState->addOrUpdateWindow(windowHandle,
                                                   InputTarget::FLAG_DISPATCH_AS_OUTSIDE,
                                                   BitSet32(0));
                 }
             }
         }
     }
     return nullptr;
 }
 
```

窗口信息的获取：

> 一句话，简言之:
>
> > wms注册给IMS的：windowHandles
>
> 具体：
>
> > wms.addWindow  ----> InputMonitor ---> IMS.updateInputWindowsLw ---> native ---> InputManager.setInputWindows ----> InputDispatcher..setInputWindows -----> 更新windowHandles
>
> 参考：[android input 点击 android input系统*mob6454cc7966b9的技术博客*51CTO博客](https://blog.51cto.com/u_16099334/6439040)













## （次要）例外之HOME事件的拦截

自然，HOME事件不能让它到应用层，所以会被提前拦截：



![image-20221210234704475](Input.assets/image-20221210234704475.png)



# 参考

gityuan系列文章：

> [Input系统—启动篇](https://gityuan.com/2016/12/10/input-manager/   )
>
> [Input系统—事件处理全过程](https://gityuan.com/2016/12/31/input-ipc/ )



# Android事件的分发------从viewRootImpl到Activity



![image-20230118002819164](Input.assets/image-20230118002819164.png)



总结为，先有一个环





# Android事件的分发------从Activity开始

## 简介

![image-20221214224114690](Input.assets/image-20221214224114690.png)

<font color='red'>注意点</font>：
Q: 分发事件的对象是MotionEvent，没有touchevent与click事件？

A:  没有Touch事件（TouchEvent）， 没有click事件（ClickEvent）。原因： motion用的很恰当。手指触摸，必然是一段时间，一段距离 ------->  即 motion移动

click表示一瞬，其实是没有的

------->  虽然有时候表达成 touch事件、click事件



## 模型

参考，好文： [Android面试题（27）-android的事件分发机制](https://blog.csdn.net/pgg_cold/article/details/79472193?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-79472193-blog-125568753.pc_relevant_multi_platform_whitelistv3&spm=1001.2101.3001.4242.1&utm_relevant_index=3)

**生活化模型：** 项目经理分发任务模型：

>   项目经理（Activity）
>   任务（事件）
>   主管(viewGroup)
>   员工（view）
>   友商安排进来的员工（Listener监听者）





<font color='red'>继承表达的含义： 继承从功能的角度来看，表达  功能更多、更强  的意思</font>
自然：~~主管继承员工（viewGroup继承view）~~  
           ~~主管管理员工~~  ---》继承多出的功能，自然



![img](Input.assets/2018030715592058)

基于模型自然有：
1、自然，~~每个角色都有两种能力：向下分发的任务的能力（dispatchTouchEvent）、处理事件的能力onTouchEvent~~

2、特例：~~拦截任务向下传递的能力onInterceptTouchEvent，只属于主管viewGroup~~。这是自然的，~~因为 项目经理要是拦截，项目不要干了。普通员工没有拦截必要，在最底层~~。



现在你所在的公司中有一项任务被派发下来了，项目经理把项目交给你的老大，你的老大老大手下有很多人，看了看觉得你做很合适，把这个任务交给你了；`如果友商安排了间谍，那自然先被间谍抢去了（即view对外分发）`。如果没有间谍，你一看觉得还行，你就接下来了；

![img](Input.assets/20180307161324186)









## 基于模型，viewGroup的分发 详解

参考：

>   [从责任链模式看Android事件分发](https://mp.weixin.qq.com/s/sSPFz3E5gncYiMMFtF_xlg)      ------>     <font color='red'>好文</font> 
>   [ViewGroup事件分发机制详解](https://blog.csdn.net/tony499074462/article/details/102499302)
>   [Android View 事件分发机制源码详解(ViewGroup篇)](https://blog.csdn.net/a553181867/article/details/51287844)

一句话总结：

> 安卓事件分发机制： 是双责任链（~~树责任链 + 链表责任链~~） ，见图
>
> ![Image](Input.assets/640)
>
> 具体讨论见  设计模式----责任链模式
>
> 





<font color='red'>viewGroup分发核心问题</font>： ViewGroup那么多view，dispatch如何找到对应消费的view？

A：dispatch流程里，对 根据 view可见的Z向位置，对各个子view进行排序： 

```java
// ViewGroup.java
buildTouchDispatchChildList() {
    final float currentZ = nextChild.getZ();

    // insert ahead of any Views with greater Z
    int insertIndex = i;
    while (insertIndex > 0 && mPreSortedChildren.get(insertIndex - 1).getZ() > currentZ) { //找到对应的Z位置
        insertIndex--;
    }
    mPreSortedChildren.add(insertIndex, nextChild);  // 排序
}

public boolean dispatchTouchEvent(MotionEvent ev) {
	final ArrayList<View> preorderedList = buildTouchDispatchChildList(); // 排序
    for (int i = childrenCount - 1; i >= 0; i--) { // 【1】倒着来遍历，自然
        
    }
}

```

 【1】倒着来遍历，自然： 希望最上 层的View来响应的,而不是被覆盖这的底层的View来响应



ViewGroup的子元素成功处理事件的时候，mFirstTouchTarget会指向子元素，这里要留意一下



viewGroup中找view，结论：
<font color='red'>如果down事件由某一个 view消耗了，同一个事件序列的其他所有事件也由其处理-</font>--》很自然，事件流是对一个控件的操作，不可能多个。证明:



## 基于模型，view的分发 详解

参考： [View的事件分发机制](https://blog.csdn.net/qq_56785698/article/details/123159190)

**问题：**按道理说，叶子节点的view没有子view，那么为啥还存在分发dispatchTouchEvent呢？
A：因为要先向注册的Listener 先分发（<font color='red'>即view对外分发</font>），最后才是自己处理

```java
// view.java
public boolean dispatchTouchEvent(MotionEvent event) {
		.............
        if (onFilterTouchEventForSecurity(event)) {
            if ((mViewFlags & ENABLED_MASK) == ENABLED && handleScrollBarDragging(event)) {
                result = true;
            }
            //noinspection SimplifiableIfStatement
            ListenerInfo li = mListenerInfo;
            if (li != null && li.mOnTouchListener != null
                    && (mViewFlags & ENABLED_MASK) == ENABLED
                    && li.mOnTouchListener.onTouch(this, event)) {// 【1】先给了监听器
                result = true;
            }

            if (!result && onTouchEvent(event)) { // 【2】后自己处理
                result = true;
            }
        }


        return result;
    }
```



## 基于模型，view的处理onTouchEvent 详解

问题：onTouchEvent 分别处理了DOWN、MOVE、UP事件，如何处理的?

View.onTouchEvent()其实处理了三种情况



处理长按事件: checkForLongClick，检测长按的机制:起了一个线程，长按的计时器postDelayed，到时间发现还没有UP事件，就为长按



```
case MotionEvent.ACTION_DOWN:
if (isInScrolling Container) {

} else {

// 设置DOWN状态标志
setPressed(true, x, y);
break;

```



处理点击事件:click

处理tap事件: 

## 从事件流的角度

参考： [View的事件分发机制](https://blog.csdn.net/qq_56785698/article/details/123159190)



事件传递的疑问:
1、事件指的是什么？实际上是事件流，不是单一事件。。。自然 
2、为了解决多指触控的问题,TODO: 引入Pointer概念 





### 面试题

# Android事件的处理

参考：   [Android事件分发机制](https://blog.csdn.net/a553181867/article/details/51287844)



![image-20221210235039013](Input.assets/image-20221210235039013.png)







问题：事件是120HZ采样，绘制只有60HZ -----> 会产生问题：有两个move没有被 绘制采样 ----》  所谓的 界面不跟手



![image-20221210235337204](Input.assets/image-20221210235337204.png)





安卓处理（滑动跟手性）方法：






整体流程：

![image-20221211002500811](Input.assets/image-20221211002500811.png)



# 其他细节

## android 触摸(Touch)事件、点击(Click)事件的区别

参考：

>   [android 触摸(Touch)事件、点击(Click)事件的区别(详细解析)](https://blog.csdn.net/LR6666/article/details/52119167)
>
>   [完全理解android事件分发机制](https://blog.csdn.net/Double2hao/article/details/54374861)

简易理解：

1、onTouchEvent中3个事件就是：MotionEvent.ACTION_DOWN、ACTION_MOVE、ACTION_UP  ----->  自然，**因为手机速度必然慢，所以手指的touch过程必然是一个时间段，比如，手指滑动scroview**

2、click来源：
一波touchEvent下发ACTION_DOWN
第二波touchEvent下发ACTION_MOVE
...............
第N波touchEvent下发ACTION_UP 
-> onClick的

上述过程非常自然：~~touch结束，必然有onClick~~？ 其实没有Touch，也没有click











## 从设计模式角度理解：

 事件分发，是责任链模式的应用

见 《DesignPattern》





# 事件注入

https://blog.csdn.net/learnframework/article/details/123571546?spm=1001.2014.3001.5502   InputManager模拟触摸事件inject详解



# cancel事件

1、识别为手势了：monitor触发

2、view层级的: https://blog.csdn.net/learnframework/article/details/124086882

https://blog.csdn.net/learnframework/article/details/132797212?spm=1001.2014.3001.5502





# touch事件的同构 --------- 多对一模型

| **维度**                                 | **宏观宇宙：系统级 Touch (InputDispatcher)**                 | **微观宇宙：应用级 Touch (ViewGroup)**            | **物理/架构的必然性 (第一性原理)**                           |
| ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------ |
| **空间数据**                             | **Z-Order Window List** (按层级从上到下排序)                 | **Children Array** (按绘制顺序逆序，从上到下)     | **画家算法逆推**：找目标必须从最上面（最靠近用户的层）开始找。 |
| **寻址算法**                             | **Hit Testing** (检查 x, y 是否在 Window bounds 内)          | **Hit Testing** (检查 x, y 是否在 View bounds 内) | **几何碰撞**：点与矩形的包含关系计算。                       |
| **状态锁定**                             | 找到目标后，生成并保存 **`InputTarget`**                     | 找到目标后，生成并保存 **`mFirstTouchTarget`**    | **流的连续性 (Invariant)**：DOWN 确定目标，后续的 MOVE/UP 必须直接发给它，不用再做碰撞检测。 |
| **多点触控**                             | `Split` 机制 (不同手指分配给不同 Window)                     | `Split` 机制 (不同手指分配给不同 Child View)      | **资源并行**：多根手指是独立的输入流，可以有不同的 Target。  |
| -**<font color='red'>拦截与截胡</font>** | **System Gesture Monitor** (系统级手势拦截)------pilferPointers() | **`onInterceptTouchEvent`** (父容器拦截)          | **中间层决策 (Indirection)**：上层管理者必须有权力剥夺下层的控制权。 |
| -**<font color='red'>反悔机制</font>**   | 下发 **`ACTION_CANCEL`** 给被剥夺的 App                      | 下发 **`ACTION_CANCEL`** 给被剥夺的 Child View    | **状态机重置**：既然我把你的流掐断了，我必须给你一个收尾的信号，防止你死锁。 |



TODO:  多点触控



一句话在最高维度概括：

>   “**无论是 Key 还是 Touch，无论是在系统框架层还是在应用 UI 层**，事件分发本质上都是一个**解决‘多对一’竞争**的仲裁系统。
>
>   它通过树状结构的遍历来寻找目标，通过建立 Target 状态来维持流的事务性（DOWN-UP闭环），**并通过高优先级的拦截机制**
>
>   （Intercept/Pilfer）来处理跨层级的意图冲突。”







# key事件 -------  view焦点 











# key事件的同构 --------- 多对一模型

从物理本质上，就是解决： 多对一模型问题

例1：**Window 焦点（系统级）** 和 **View 焦点（应用级）是同构的**

| **维度**     | **宏观宇宙：Window Focus (WMS 层)**                     | **微观宇宙：View Focus (View 层)**                          | **同构本质 (第一性原理)**                                    |
| ------------ | ------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------ |
| **管理者**   | **InputDispatcher / WMS**                               | **ViewRootImpl / ViewGroup**                                | **仲裁者 (Arbiter)**：必须有一个上帝视角来决定谁是天选之子。 |
| **数据结构** | `DisplayContent` 下的 **Window List** (按 Z-order 排序) | `ViewGroup` 下的 **Children Array** (按 drawing order 排序) | **有序列表 (Ordered List)**：必须有优先级，通常“最上面”的优先。 |
| **准入资格** | **Window Flag**: `FLAG_NOT_FOCUSABLE`                   | **View Attribute**: `android:focusable="false"`             | **能力声明 (Capability)**：你自己得先举手说“我也许能处理”。  |
| **寻找逻辑** | 遍历 Window 列表，找最顶层且 `focusable` 的窗口         | 遍历 View 树，找最深层/最顶层且 `focusable` 的 View         | **遍历算法 (Traversal)**：这就是“责任链模式”的变体。         |
| **状态持有** | `mFocusedWindow` (全局唯一)                             | `mFocused` (View树内唯一)                                   | **互斥锁 (Mutex)**：焦点资源是独占的，不可能有两个光标同时闪烁。 |
| **抢夺机制** | `WMS.setFocusedWindow()`                                | `View.requestFocus()`                                       | **请求与授权 (Request/Grant)**：下级申请，上级批准。         |
| **焦点转移** | ALT+TAB 切窗口，或点击新窗口                            | TAB 键切输入框，或点击新输入框                              | **导航策略 (Navigation)**：基于方向或历史记录的切换。        |

-<font color='red'>数据结构级别都是一致的</font>！！





key同构的结论见 《touch事件的同构》



例2：




# 补充   中断



# 滑动冲突问题

TODO ------->办法:事件拦截机制





# 疑问

如果view重叠，如何找到对应的view？







# 方法



不讲代码，只讲逻辑
只画图
讲课视频，是按照 思维方式（1、目标-起点   2、遇到的问题）来讲的，而不是

技术文章的平铺直叙  ------>   <font color='red'>会很深刻，从0创造知识的思维</font>
--------->  TODO: 能否这样写技术文章呢？如果不能，能有借鉴意义嘛





数据在哪个进程的哪个线程

分析方法：1、目标-起点   2、目标到起点遇到的问题，解决问题的方法，便是核心思想-----》 实际上就是(方法、结构、流程)合理性的证明

--------->  所以，理解的深刻与否，在于 ： （1）<font color='red'>系统演进的历史</font> ，遇到了什么问题，导致这样演进的？  ---->  搜索，这一点很难知道

​                                                                         （2）退而求其次。多问合理性的问题，为什么要这样设计？

![image-20221211000426557](Input.assets/image-20221211000426557.png)

代码最最烂最烂的东西：没有重点、量太大、细节太多 ------> 只能作为字典





# 一切皆文件：

参考：[视频---------王小二图解Android【005】一切皆文件](https://www.bilibili.com/video/BV117411H732/?spm_id_from=333.999.0.0&vd_source=3eebd10b94a8a76eaf4b78bee8f23884)



![image-20221211003642588](Input.assets/image-20221211003642588.png)



![image-20221211004104541](Input.assets/image-20221211004104541.png)



# TODO

涉及窗口的知识，

1.  monitor channel 原理，例如，返回手势
2.  watch outside window
3.  spy window
4.  ANR





# ======面试题======



# Android Input 系统与事件分发面试考点总结

本文档整理了 Android 输入系统从底层 IMS 到上层 View 分发的核心面试考点、原理分析及常见误区。

---

## 一、 Input 系统架构与原理（系统层）

### 1. IMS (InputManagerService) 线程模型
* **考点**：Input 系统主要由哪两个核心线程组成？分工是什么？
* **答案**：
    * **InputReaderThread**：负责从内核读取 Raw Motion Event（原始事件）。
    * **InputDispatcherThread**：负责将事件分发给目标窗口。

### 2. 事件分发的目标窗口确定（Touch 寻址）
* **考点**：系统如何知道触摸事件该发给哪个窗口？ACTION_MOVE/UP 还需要重新寻找吗？
* **答案**：
    * **ACTION_DOWN**：根据触摸坐标 (x, y) 和窗口属性（Visible, Touchable）寻找目标窗口。
    * **ACTION_MOVE / UP**：**不重新寻找**。系统会将 DOWN 确定的目标窗口保存在 `tempTouchState`，后续事件直接复用该目标。

### 3. Touch 事件 vs Key 事件的区别
* **考点**：触摸和按键在分发对象上的核心区别？
* **答案**：
    * **Touch 事件**：基于**位置**（坐标）分发。
    * **Key 事件**：基于**窗口焦点**分发。

### 4. 特殊按键拦截
* **考点**：为什么应用层拦截不到 HOME 键？
* **答案**：HOME 键在进入应用层之前，已被系统层（PhoneWindowManager）提前拦截处理。

---

## 二、 View 事件分发机制（应用层）

### 1. 核心方法：三驾马车
| 方法名                    | 拥有者                    | 职责                   | 返回值含义                     |
| :------------------------ | :------------------------ | :--------------------- | :----------------------------- |
| **dispatchTouchEvent**    | Activity, ViewGroup, View | **分发**：事件入口     | true: 消费; false: 不处理      |
| **onInterceptTouchEvent** | **仅 ViewGroup**          | **拦截**：决定是否截断 | true: 拦截; false: 放行        |
| **onTouchEvent**          | Activity, ViewGroup, View | **处理**：消费事件     | true: 消费; false: 不处理/回传 |

### 2. 伪代码逻辑（本质关系）
理解此伪代码即可掌握三者关系：
```java
// ViewGroup 的 dispatchTouchEvent
public boolean dispatchTouchEvent(MotionEvent ev) {
    boolean consume = false;
    
    // 1. 拦截判断 (ViewGroup 独有)
    if (onInterceptTouchEvent(ev)) {
        consume = onTouchEvent(ev); // 拦截后自己处理
    } else {
        consume = child.dispatchTouchEvent(ev); // 不拦截，分发给子 View
    }

    // 2. 兜底处理 (子 View 不处理，或者自己拦截了但没处理成功)
    if (!consume) {
        consume = onTouchEvent(ev);
    }
    return consume;
}
```