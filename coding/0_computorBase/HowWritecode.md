

# 目录

# 一些原则

## 0层：一点点思想

为什么会这样？因为代码的易错性造成的，一个符号都就会造成大问题

---------> 对于易错的东西，最好的办法，就是一点点



## 1层（一点点思想）

### 代码一点点增加（然后验证）

极限：每次只增加一行，验证一行........

例子：

写反射的时候，很容易出错

### git commit一点点

每验证好一个小功能，前进一小步，commit一次，且分开

-<font color='red'>规定</font>：基于commit维度：

> 1、保存代码  
>
> 2、保存jar，保证commit级别可以回退
>
> 3、每笔commit，都要验证基本功能OK：
>
> ​    （1）**attach system_server进程，不会挂**   
>
> ​     （2）业务基本功能OK



目标：

> 每一笔commit，做到哪些功能要很清晰
>
> 要可<font color='red'>快速</font>回退



### 写代码第一步：一个干净的环境

一个可以断点的环境



### 能编译OK，极大程度意味着可以运行

为什么呢？**因为编译是协议**  ，协议即通顺，即运行





### 修改bug，尽量限制范围

```java
if (严格条件) {
  //修改
}
```

条件尽量严格，限制不影响其他场景



### 做好备份

最忌讳的是重复劳动，所以**代码备份** ,方式：

一小步一个commit、

**一大步提一个链接**



### 做好jar的备份

1、`每次刷完机，`做一下jar的备份

2、`每次一个比较完整功能的commit`，做一次jar的备份   ------->  可能需要回退



### 技巧：在debug断点中写代码

这是<font color='red'>极优</font>的，因为相当于，<font color='red'>在运行时写代码</font>

不是在代码态写代码，也不是编译态写代码，而是直接运行态

优点：

1、**立刻给出运行结果**-----> 验证代码的正确性

2、**省去了编译的时间**

3、此时 （1）虚浮窗可以跳转 AS代码  （2）AS代码如正常情况一样，可以跳转，back导航..........................

​     ----------------> 总之，**多了一个运行态窗口，其他不变**

![image-20230804223649337](HowWritecode.assets/image-20230804223649337.png)

4、见 《动态开关的利用》



<font color='red'>规定：</font>

> 只允许在运行态写代码



### 技巧：动态开关的利用(手动开关)

修改的代码，用动态开关

```java
static boolean isSwitchOn = false; 

if (isSwitchOn) {
    //新增代码
}
```

----------> 为啥要这样做？

1、如果新增代码，验证后是一个无用的代码 ----> 重启便可以恢复新增代码之前，<font color='red'>减少了再次编译的时间</font>

2、**手动开启更好:** 

> <font color='red'>新增代码有可能导致开不了机</font>。所以，还是运行后，手动开启更好

### <font color='red'>避免空指针</font>是写代码的第一要义

-<font color='red'>加log</font>(定位问题) 也是写代码，也要特别注意 空指针

否则：

> 1、log会将程序崩溃
>
> 2、有时候，崩溃在子线程，还没有报错   ---->   **根本看不出来，难以定位**
>
> 3、debug时 attach一些进程，直接vm挂掉

如何避免空指针？

### 准则1：怀疑一切使用的量

1、对一切量进行校验

2、除了下面的准则里的，百分百确认的

### 准则2：他人用过的不用校验

比如，

mContext使用过了，在图中2处，便不需要校验，可直接使用

![image-20230818231823448](HowWritecode.assets/image-20230818231823448.png)

### 准则2：他人待用的暂时不用校验

比如，

mContext使用过了，在图1处可以直接使用

------->  前提：

**其他人没校验使用沒有问题** （一般来说可以）

![image-20230818231823448](HowWritecode.assets/image-20230818231823448.png)

### 准则3：构造方法中传过来，且用过，且不会置为null ----> 不用校验

除了以上，其他的都要校验



### 准则4：利用<font color='red'>空实现</font>来替代<font color='red'>判定空</font>



例子：安卓中

```java
public abstract class InputMethodManagerInternal {
    
}
```



获取   -------InputMethodManagerInternal协议-------实现

因为InputMethodManagerInternal是协议，我们不能保证我们获取到的非null





何时会这样做？

结合例子体会：

（1）当<font color='red'>调用点很多</font>  且<font color='red'>分散在 非常多个文件里</font>     (TODO: 疑问：很多对外接口都能做到，为什么没这样做呢？)

------->  单例（见《设计模式之单例》）

（2）我们保证不了返回值不为null ------> 那么<font color='red'>意味着大量的调用点，都要判空</font>

-------->  避免这种情况：为null时，返回空实现

```
    public static InputMethodManagerInternal get() {
        final InputMethodManagerInternal instance =
                LocalServices.getService(InputMethodManagerInternal.class);
        return instance != null ? instance : NOP;
    }
```

背后思想：

1、以空实现替代 判空

2、 

好处是什么？真的有好处嘛？

好处：

给其他文件用的接口（尤其大量被调用的），最好不要返回null



## 如何下上升代码？

原则：

> 开发时上升代码。。。。设计时下沉代码。。。。

目的：

> 上升代码到APP，**在APP里编译** -------> <font color='red'>优点： 高效、无风险</font>（framwork写错代码，起不了机器）

具体操作:

> 1、继承 方式：      LIntent extends Intent
>
> ​         ~~override 来把流程拦截到APP里，然后在APP内部写代码~~
>
> 2、组合（持有父类）----代码稍微麻烦一些
>
>  ~~override 来把流程拦截到APP里，然后在APP内部写代码~~
>
> 3、通过编译SDK，把要写的类传递给APP   TODO：具体怎么做？

------------------->  从这一点来看，APP与框架，并没有任何区别



```java
    public Lparcel() {
        mParcel = Parcel.obtain();
    }
```

3、TODO: 强制继承，万能：修改sdk？？？



## 利用chatgpt写代码

让它写，它知道哪些接口可以使用，你不知道



## 识别 频繁路径+关键路径

**规定：**

> 1、初步写代码**必须每个函数加log**  ----> 以识别频繁路径
>
> 2、<font color='red'>频繁路径+关键路径，不允许加代码：</font>
>
> 3、频繁路径加代码，需要进行性能验证

方法一：缓存机制  

方法二：



## 从源码中积累素材 ------> 学会捡金子





# 代码技巧：

子类修改父类的属性值，`关于修改点：可以插到父类任意一行代码位置上！！！！`  <font color='green'>利用复写的截断流程思想</font>

![image-20230802231418983](HowWritecode.assets/image-20230802231418983.png)

<font color='red'>比如想要在1648行就修改userId：</font>

父类新增一个接口modifyUsrid(), 空实现；子类具体实现去修改

-----------> 好处：

> 1、父不会对子产生依赖  
>
> 2、实现任意点插入

