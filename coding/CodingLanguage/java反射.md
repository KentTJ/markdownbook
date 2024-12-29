# 反射

## 为什么要用反射？精髓在哪里？

**安卓源码中反射的场景：**

> XML  ------>  类： new view()
>
>
> byte  -------->  类： 反序列化创建 parcelable，使用到的Creator   参考：[android对象序列化Parcelable浅析 - xerrard - 博客园 (cnblogs.com)](https://www.cnblogs.com/xerrard/p/5144386.html)          https://www.cnblogs.com/xerrard/p/5144386.html
>
--------------->  总之:  <font color='red'>（1）都是从二进制 到 类的过程   （2）一般都是很多个类-----> 反射，大量简化代码量</font>！！！！！！

注意，**安卓为了优化性能，缓存策略：**

> 安卓的Parcelable  mCreators，就用了缓存策略！！！！！！！！！ <String, Parcelable.Creator>   ！！！！！！
>
>
> 即：~~在真正binder通信时，没有反射~~
>

**从设计角度看Creator：**

> 只是把反序列化过程 要用的反射部分，从 parcelable 里抽出来
>
> ------------> 为啥要这样？
>
> （1）我们要用缓存策略，反射太耗时
>
> （2）不可能缓存 Parcelable 对象的，因为没一个对象都是不一样的，参数是parcel里的数据
>
> （3）所以，**<font color='red'>抽出公共部分，并缓存公共部分</font>：**（**太TM神了!!!!!**!）
>
> Parcelable 对象的创建部分，即 Creater（这个对于同一个类的Parcelable ）
>

**总结：**

> 1、缓存对象
>
> 2、<font color='red'>缓存不了对象，缓存对象的创建方式  Creater</font>
>
> 3、**Creater是永远不变的、静态的，不是对象**

-**<font color='red'>反射，可以实现的功能（或者  为啥要用反射）</font>：**

> （1）从编译角度，可以避开编译约束:   私有，不可见
>
>
> （2）从代码角度, 可以实现 **统一，大量简化代码量**（一行代码，可以new 出各种类）------->  **语言，架构层面**
>
> （3） 从功能角度：同（1）
>
>  (4)  从**代码 扩展性、弹性角度：**   反射有着非常好的弹性。比如，新增一个MyView，xml解析器创建view的代码，<font color='red'>不需要改动一行</font>

## 反射的使用

参考：

>  https://blog.csdn.net/weixin_56442629/article/details/115430249  .java反射
>
> [[《Debug Skills的反射章节》](https://kenttj.github.io/-book/coding/Tool/debugSkills.html#%E6%94%B9%E5%86%99%E5%80%BC%E4%B9%8B-%E5%8F%8D%E5%B0%84)





## 反射性能

https://blog.csdn.net/googdev/article/details/100039092#:~:text=%E4%B8%8B%E9%9D%A2%E6%98%AF%E6%88%91%E4%BB%AC%E7%9A%84%E6%B5%8B%E8%AF%95%E7%BB%93%E6%9E%9C%EF%BC%88%E6%97%B6%E9%97%B4%E5%8D%95%E4%BD%8D%E5%9D%87%E4%B8%BA%E6%AF%AB%E7%A7%92%EF%BC%89%EF%BC%9A,%E6%98%BE%E7%84%B6%EF%BC%8C%E5%9C%A8Android%E4%B8%AD%E4%BD%BF%E7%94%A8%E5%8F%8D%E5%B0%84%E9%9D%9E%E5%B8%B8%E6%85%A2%EF%BC%8C%E4%BD%BF%E7%94%A8%E5%8F%8D%E5%B0%84%E7%9A%84%E6%B5%8B%E8%AF%95%E6%89%A7%E8%A1%8C%E5%88%86%E5%88%AB%E9%9C%80%E8%A6%811332%E6%AF%AB%E7%A7%92%E3%80%816384%E6%AF%AB%E7%A7%92%E3%80%812891%E6%AF%AB%E7%A7%92%EF%BC%8C%E8%80%8C%E4%B8%8D%E4%BD%BF%E7%94%A8%E5%8F%8D%E5%B0%84%E5%88%99%E5%8F%AA%E9%9C%80%E8%A6%81312%E6%AF%AB%E7%A7%92%E3%80%81358%E6%AF%AB%E7%A7%92%E3%80%81774%E6%AF%AB%E7%A7%92%E3%80%82

https://www.skoumal.com/en/is-android-reflection-really-slow/



https://www.itzhimei.com/archives/2852.html            Java反射 反射性能和优化

方法调用有三种：直接调用、反射调用、MethodHandle调用



## 反射性能消耗的根因：

1、**方法**   查找和动态绑定： ------>  **解决方法： 方法句柄（MethodHandle）**，类似于指针，不需要动态绑定

> 每次调用方法都需要进行一次方法查找和动态绑定

2、**反射对象**的创建：  ---->  **办法： 缓存反射信息**

> 反射对象的创建和操作的性能较低，因为需要进行一些安全检查和复杂的对象初始化过程。

TODO: METHODY

反射能力：

> 一法破万法

同理 所有数据 序列化成 byte[]

同理，参数可以任意多个

```
 MethodType methodType(Class<?> rtype, List<Class<?>> ptypes)
```

## 反射性能优化

1、主要很耗时的函数，有些函数不耗时：

Class.forName这个方法比较耗时 （它实际上调用了一个本地方法，通过这个方法来要求JVM查找并加载指定的类）

getFields

。。。。。。。。。。。。

2、优化-----------缓存策略：

```
 把Class.forName返回的Class对象缓存起来，下一次使用的时候直接从缓存里面获取，这样就极大的提高了获取Class的效率
 同理，在我们获取Constructor、Method等对象的时候也可以缓存起来使用
```

https://blog.51cto.com/u_16213578/7527733

TODO:  安卓的Parcelable  mCreators，似乎就用了缓存策略

3、关闭安全检查

通过setAccessible(true)的方式可以关闭安全检查：

> jdk在设置获取字段，调用方法的时候会执行安全访问检查，而此类操作会比较耗时，所以通过setAccessible(true)的方式可以关闭安全检查，从而提升反射效率
>

4、高性能反射工具包ReflectASM



## MethodHandle调用---------函数指针

参考： [JVM角度看方法调用-MethodHandle篇 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/524591401?utm_id=0)

https://blog.csdn.net/seanxwq/article/details/122179781  --------------》 好文，详细使用

性能上：

> MethodHandle =  直接调用  >>  反射

本质上，性能好的原因：

结论：非静态化使用MethodHandle是不会比直接反射更快的

[方法调用9——MethodHandle方法调用checkCustomized优化 - 简书 (jianshu.com)](https://www.jianshu.com/p/58642c6bd672)      --------->  **好文**

https://www.jianshu.com/p/a9cecf8ba5d9

若要访问**私有**的成员,得先申请一下

con.setAccessible(**true**); ---------------->  **忽略访问权限，似乎对提升性能没有帮助**



## 理念！

在讨论性能的时候，一定要知道背景--------------------------是否是在高频调用的背景下

1、有些调用**不是高频**的，允许一定反射



# 反射性能数据

测试代码：

%accordion%hideContent%accordion%

```java
package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ComponentName;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainActivity extends AppCompatActivity {
    private static String TAG = "chenjinke2";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = findViewById(R.id.button1);


        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                Intent intent = new Intent();
//                //跳转其他APP的固定页面，需要APP的包名，activity的全路径
//                //在要跳转的APP的activity的配置添加 android:exported="true"，将activity暴露出来
//                ComponentName name = new ComponentName("com.wj.app2","com.wj.app2.activity.ReceiveActivity");
//                intent.setComponent(name);
////                startActivity(intent);
//                startActivityAsUser();

                int b = sum();
//                myTEST();
//                myTest2();
//                MethodHandle



                String javaVersion = System.getProperty("java.version");
                System.out.println("当前 Java 版本是：" + javaVersion);
                Log.d(TAG, "mytest:  当前 Java 版本是：" + javaVersion);

                // 创建测试数据
                ComponentName componentName = new ComponentName("com.example", "com.example.MainActivity");
                Intent intent = new Intent();
//                intent.setComponent();



                // 测试直接调用性能
                testDirectInvocationPerformance(intent, componentName);

                // 测试普通反射接口 method.invoke性能
                testReflectionPerformance(intent, componentName);

                try {
                    // 不定参数形式
                    testReflectionPerformanceWithArgs(intent, componentName);
                } catch (NoSuchMethodException e) {
                    throw new RuntimeException(e);
                } catch (InvocationTargetException e) {
                    throw new RuntimeException(e);
                } catch (IllegalAccessException e) {
                    throw new RuntimeException(e);
                }

                // 测试 MethodHandle 性能
                testMethodHandlePerformance(intent, componentName);

                // 测试 static MethodHandle 性能
                testStaticMethodHandlePerformance(intent, componentName);

                // 测试 MethodHandle.invoke 性能
                testMethodHandleInvokePerformance(intent, componentName);

                // 测试 static MethodHandle.invoke 性能
                testMethodHandleStaticInvokePerformance(intent, componentName);





//                test3();
            }
        });
    }


        private  void testMethodHandlePerformance(Intent intent, ComponentName componentName) {
            try {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                    long startFindTime = System.nanoTime();
                    MethodHandles.Lookup lookup = MethodHandles.publicLookup();
                    MethodType methodType = MethodType.methodType(Intent.class, ComponentName.class);
                    MethodHandle setComponentMethod = lookup.findVirtual(Intent.class, "setComponent", methodType);
                    Log.d(TAG, "mytest:  MethodHandle Find Method Time：" + (System.nanoTime() - startFindTime) + " 纳秒" );


                    long totalDuration = 0;

                    long startTime = System.nanoTime();
                    for (int i = 0; i < 1000000; i++) {
                        setComponentMethod.invokeWithArguments(intent, componentName);
                    }
                    long endTime = System.nanoTime();
                    totalDuration += (endTime - startTime);

                    long averageDuration = totalDuration / 1000000;
                    System.out.println("MethodHandle 调用平均耗时：" + averageDuration + " 纳秒");
                    Log.d(TAG, "mytest:  MethodHandle.invokeWithArguments 调用平均耗时：" + averageDuration + " 纳秒" );
                }
            } catch (Throwable throwable) {
                throwable.printStackTrace();
            }
        }

        private  void testDirectInvocationPerformance(Intent intent, ComponentName componentName) {
            long totalDuration = 0;

//            long n = 0;
            long startTime = System.nanoTime();
            for (int i = 0; i < 1000000; i++) {
                intent.setComponent(componentName);
//                n = System.nanoTime();
            }
            long endTime = System.nanoTime();
            totalDuration += (endTime - startTime);

            long averageDuration = totalDuration / 1000000;
            System.out.println("直接调用方式平均耗时：" + averageDuration + " 纳秒");
            Log.d(TAG, "mytest: 直接调用方式平均耗时：" + averageDuration + " 纳秒");
        }

    private static void testReflectionPerformance(Intent intent, ComponentName componentName) {
        try {
            long startFindTime = System.nanoTime();
            Class<?> intentClass = Intent.class;
            Class<?>[] parameterTypes = {ComponentName.class};
            Method method = intentClass.getMethod("setComponent", parameterTypes);
            Log.d(TAG, "mytest:  普通反射接口 method.invoke Find Method Time：" + (System.nanoTime() - startFindTime) + " 纳秒" );

            long totalDuration = 0;
            long startTime = System.nanoTime();
            for (int i = 0; i < 1000000; i++) {

                method.invoke(intent, componentName);
            }
            long endTime = System.nanoTime();
            totalDuration += (endTime - startTime);

            long averageDuration = totalDuration / 1000000;
            System.out.println("普通反射接口 method.invoke调用平均耗时：" + averageDuration + " 纳秒");
            Log.d(TAG, "mytest: 普通反射接口 method.invoke调用平均耗时：" + averageDuration + " 纳秒");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 获取参数类型列表
    private static Class<?>[] getParameterTypes(Object[] parameters) {
        Class<?>[] parameterTypes = new Class<?>[parameters.length];
        for (int i = 0; i < parameters.length; i++) {
            parameterTypes[i] = parameters[i].getClass();
        }
        return parameterTypes;
    }

    private void testReflectionPerformanceWithArgs(Intent intent, ComponentName componentName) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        long startFindTime = System.nanoTime();
        // 获取 MyClass 类
        Class<?> myClass = intent.getClass();
        // 获取 myMethod 方法，注意这里的参数类型是不确定的，所以可以传递一个可变参数
        Object[] parametersArrays = {componentName}; // 前一个返回值
        Method myMethod = myClass.getMethod("setComponent", getParameterTypes(parametersArrays));
        Log.d(TAG, "mytest:  普通反射不定参数接口： Find Method Time：" + (System.nanoTime() - startFindTime) + " 纳秒" );


        long totalDuration = 0;
        long startTime = System.nanoTime();
        for (int i = 0; i < 1000000; i++) {

            // 调用 myMethod 方法，并传递参数
            myMethod.invoke(intent, parametersArrays);
        }
        long endTime = System.nanoTime();
        totalDuration += (endTime - startTime);

        long averageDuration = totalDuration / 1000000;
        System.out.println("普通反射接口 method.invoke调用平均耗时：" + averageDuration + " 纳秒");
        Log.d(TAG, "mytest:  普通反射不定参数接口， 调用平均耗时：" + averageDuration + " 纳秒");
    }


        public static final MethodHandle staticsetComponentMethod;

    static {
        try {
            staticsetComponentMethod = initStaticsetComponentMethod();
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (NoSuchMethodException e) {
            throw new RuntimeException(e);
        }
    }

    private static MethodHandle initStaticsetComponentMethod() throws IllegalAccessException, NoSuchMethodException {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                return MethodHandles.lookup().findVirtual(Intent.class, "setComponent", MethodType.methodType(Intent.class, ComponentName.class));
            }
            return null;
        }
        private void testStaticMethodHandlePerformance(Intent intent, ComponentName componentName) {
            try {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//                    MethodHandles.Lookup lookup = MethodHandles.lookup();
//                    MethodType methodType = MethodType.methodType(Intent.class, ComponentName.class);
//                    MethodHandle setComponentMethod = lookup.findVirtual(Intent.class, "setComponent", methodType);

                    long totalDuration = 0;

                    long startTime = System.nanoTime();
                    for (int i = 0; i < 1000000; i++) {
                        staticsetComponentMethod.invokeWithArguments(intent, componentName);
                    }
                    long endTime = System.nanoTime();
                    totalDuration += (endTime - startTime);

                    long averageDuration = totalDuration / 1000000;
                    System.out.println("MethodHandle 调用平均耗时：" + averageDuration + " 纳秒");
                    Log.d(TAG, "mytest:  static MethodHandle.invokeWithArguments 调用平均耗时：" + averageDuration + " 纳秒" );
                }
            } catch (Throwable throwable) {
                throwable.printStackTrace();
            }
        }

    private static void testMethodHandleInvokePerformance(Intent intent, ComponentName componentName) {
        try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                MethodHandles.Lookup lookup = MethodHandles.lookup();
                MethodType methodType = MethodType.methodType( Intent.class, ComponentName.class);
                MethodHandle setComponentMethod = lookup.findVirtual(Intent.class, "setComponent", methodType);

                long totalDuration = 0;
                long startTime = System.nanoTime();

                for (int i = 0; i < 1000000; i++) {
                    setComponentMethod.invoke(intent, componentName);
                }
                long endTime = System.nanoTime();
                totalDuration += (endTime - startTime);

                long averageDuration = totalDuration / 1000000;
                System.out.println("MethodHandle.invoke 调用平均耗时：" + averageDuration + " 纳秒");
                Log.d(TAG, "mytest:  MethodHandle.invoke 调用平均耗时：" + averageDuration + " 纳秒" );
            }
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
    }

    private static void testMethodHandleStaticInvokePerformance(Intent intent, ComponentName componentName) {
        try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//                MethodHandles.Lookup lookup = MethodHandles.lookup();
//                MethodType methodType = MethodType.methodType( Intent.class, ComponentName.class);
//                MethodHandle setComponentMethod = lookup.findVirtual(Intent.class, "setComponent", methodType);

                long totalDuration = 0;
                long startTime = System.nanoTime();
                for (int i = 0; i < 1000000; i++) {
                    staticsetComponentMethod.invoke(intent, componentName);
                }
                long endTime = System.nanoTime();
                totalDuration += (endTime - startTime);

                long averageDuration = totalDuration / 1000000;
                System.out.println("MethodHandle.invoke 调用平均耗时：" + averageDuration + " 纳秒");
                Log.d(TAG, "mytest:  static MethodHandle.invoke 调用平均耗时：" + averageDuration + " 纳秒" );
            }
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
    }


```

%/accordion%



結果：

```
1、反射性能测试结果，基于调用100w次求平均：
D  mytest:  直接调用方式平均耗时：4 纳秒
D  mytest:  method.invoke接口 Find Method Time：431154 纳秒  ------> 【1】 查找method 用时0.4ms
D  mytest:  method.invoke接口：429 纳秒

D  mytest:  method.invoke不定参数接口： Find Method Time：96000 纳秒
D  mytest:  method.invoke不定参数接口：322 纳秒
D  mytest:  method.invoke不定参数接口 + 关闭校验： Find Method Time：69462 纳秒
D  mytest:  method.invoke不定参数接口 + 关闭校验：323 纳秒  ------> 【2】

D  mytest:  MethodHandle Find Method Time：280847 纳秒
D  mytest:  MethodHandle.invokeWithArguments 调用平均耗时：3612 纳秒
D  mytest:  MethodHandle.invoke 调用平均耗时：1024 纳秒
```

**<font color='red'>结论：</font>**

```java
2、反射主要耗时：
（1）查找类，未测     ----------> 耗时，缓存
（2）创建类，未测     ----------> 耗时，缓存
（3）查找方法：0.4ms 见【1】  ----------> 耗时，缓存
（4）反射调用method.invoke：0.3us 见【2】 ----------> 不耗时
```



安卓代码实测：

```java
mytest testOrigin:     831805 580 048
mytest testOrigin in:  831805 614 279  ----> 进入 testOrigin 耗时30us

mytest startActivity:           831805 725 587
mytest:  method.invoke endTime: 831805 764 971nm  ----> 直接调用，进入startActivity 40us

mytest:  method.invoke: Find Method Time: 24616 nm

mytest:  method.invoke startTime: 831813 459 510 nm
mytest:  method.invoke endTime:   831813 489 048   nm   ----> 反射调用，进入startActivity 30us

mytest:  method.invoke startActivity Time: 12650384 nm
```



# 测性能的注意事项

环境：

> cpu当前负载（其他进程的影响）
>
> debug版本
>
> log打印量
>
> 函数复杂程度
>
> 是否跨进程
>
> 其他进程的影响

 -------> **所以，理念：测试性能，<font color='red'>绝对值没有意义。</font>只有相对值！！！！**

 正常耗时、反射耗时 ----------> 百分比

性能测试（包括反射性能），环境影响很大，**规定：**

(1) **串行测试**：  **对照组**一定要在**同一调用流程里**  ----------->   **保证环境相对不变**

（2） 流程中不能有跨进程  --------> 对面进程不可控

（3）针对于反射：  函数**进入前  + 进入后** 记时

# 类名不定、函数名不定、参数个数不定------反射

**一法通万法：**

```java
// 目标类
String targetClassName = parcel.readString();
Object target = prepareTargetInstance(targetClassName); // TODO: 目标类，是不是不用缓存？
if (target == null) {
	return;
}

// 目标函数名
String targetMethodName = parcel.readString();

// 构建参数1, 参数2......
ArrayList<Object> paras = new ArrayList<>();
prepareParas(lparcel, paras, sb);

// TODO:假设参数2
paras.add(new Bundle());

Class<?> targetClass = target.getClass();
// 获取 myMethod 方法，注意这里的参数类型是不确定的，所以可以传递一个可变参数
Object[] parametersArrays = paras.toArray(new Object[paras.size()]);

// 缓存策略
Method targetMethod;
if (targetClassMethod.containsKey(key)) {
	targetMethod =  targetClassMethod.get(key);
} else {
	targetMethod = targetClass.getMethod(targetMethodName, getParameterTypes(parametersArrays));// 【1】 时间，1ms 目标类可以是子类，但是参数不能是子类！！！！
	targetClassMethod.put(key, targetMethod);
}

targetMethod.setAccessible(true);

targetMethod.invoke(target, parametersArrays);  //【2】
```

**注意：**

> 【1】 如果**参数**parameterTypes**传子类实例**（获取到子类名），反射 getMethod 方法**找不到方法**
>
>   根因：---------->  因为函数签名是包括参数的，根据函数签名找的
>
> ​                 自然，~~但是  targetClass 可以是子类！！！！！！！~~





# 补充 反射

> https://zhuanlan.zhihu.com/p/519992996     JVM角度看方法调用-反射篇
>
> https://zhuanlan.zhihu.com/p/524591401?utm_id=0    JVM角度看方法调用-MethodHandle篇
>
> https://www.jianshu.com/p/58642c6bd672   方法调用9——MethodHandle方法调用checkCustomized优化

​     ---------------》 好文，系列文章