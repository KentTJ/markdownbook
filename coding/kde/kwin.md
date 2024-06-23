# Kwin

[KDE如何处理窗口管理？-腾讯云开发者社区 (tencent.com)](https://cloud.tencent.com/developer/techpedia/2002/14620)   ------->  没啥内容

https://wenku.baidu.com/view/540df51eac1ffc4ffe4733687e21af45b307fefa.html?_wkts_=1699511709596&bdQuery=kwin+架构

https://www.linuxprobe.com/kwin-kde.html      [KWin即将内置高级窗口分屏布局](https://www.linuxprobe.com/kwin-kde.html)

https://blog.csdn.net/a8039974/article/details/122867167   wayland详解   -----> **好文，** 虽然是Weston，但是应该与Kwin一样，都是实现了wayland协议

## kwin的架构和原理

是什么？

> kde桌面环境的，图形架构

Kwin主要由以下几个部分组成:

> 1.渲染引擎:Kwin使用OpenGL作为其渲染引擎，它负责将窗口和桌面渲染为图像。 ---->  说法有误，render在应用内。合成在 KWin
>
> KWin 是一个 X Window System 的窗口管理器和一个 Wayland 合成器
>
> 2.事件处理: Kwin通过Qt的事件系统来接收和处理用户输入。
>
> 3.窗口管理: Kwin负责管理窗口的创建、销毁和移动
>
> 4.特效和过渡:Kwin提供了许多特效和过渡效果，例如窗口淡入淡出、窗口滑动等

Kwin的原理是，当用户打开一个窗口时，Kwin会创建一个新的窗口对象，并为其分配一个唯一的标识符。然后，Kwin

会根据用户的操作和系统状态来管理窗口的显示和隐藏。当用户点击窗口时，Kwin会将其激活，并将其移动到屏幕中央。

此外，Kwin还提供了许多特效和过渡效果，使得用户能够更轻松地使用计算机

```
 SwitchEvent: 切换事件 (窗门切换)
 SwitchEvent 类通常包含以下属性:
 。SwitchEvent::Type: 表示切换事件的类型，可以是切换到上一个窗口、下一个窗口或特定窗口的事件
 。SwitchEvent::Modifiers: 表示切换事件时使用的修饰键，例如 Alt、Shift 等
 。SwitchEvent::Direction: 表示切换的方向，可以是向前切换或向后切换
 。SwitchEvent::Window: 表示切换事件所涉及的窗口对象
```

## kwin进程展开

```
 进�� USER      PR  NI    VIRT    RES    SHR � %CPU %MEM     TIME+ COMMAND
 15941 chen  20   0 5494012 220668 154216 S  2.2  2.8   4:08.60 QXcbEventReader  // ------->   事件
 15940 chen  20   0 5494012 220668 154216 S  1.9  2.8   4:23.12 kwin_x11    // ------->主线程，合成也在这里？
 16156 chen  20   0 5494012 220668 154216 S  0.3  2.8   1:50.21 llvmpipe-0
 16163 chen  20   0 5494012 220668 154216 S  0.3  2.8   1:05.68 llvmpipe-7
 16166 chen  20   0 5494012 220668 154216 S  0.3  2.8   1:06.32 llvmpipe-10
 16169 chen  20   0 5494012 220668 154216 S  0.3  2.8   1:34.99 llvmpipe-13
 16009 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:01.50 QDBusConnection
 16154 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.06 QQmlThread
 16157 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:20.53 llvmpipe-1
 16158 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:18.47 llvmpipe-2
 16159 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:16.29 llvmpipe-3
 16160 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:13.13 llvmpipe-4
 16161 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:11.32 llvmpipe-5
 16162 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:08.64 llvmpipe-6
 16164 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:06.42 llvmpipe-8
 16165 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:04.73 llvmpipe-9
 16167 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:09.25 llvmpipe-11
 16168 chen  20   0 5494012 220668 154216 S  0.0  2.8   1:14.88 llvmpipe-12
 16170 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16171 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16172 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16173 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16174 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16175 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16176 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16177 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16178 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16179 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16180 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16181 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16182 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16183 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
 16187 chen  20   0 5494012 220668 154216 S  0.0  2.8   0:00.00 kwin_x11
```

注意：

> kwin相当于安卓的框架层，wms与合成器
>
> KDE，是launcher，桌面环境

## wayland详解

https://blog.csdn.net/a8039974/article/details/122867167   TODO

## kwin源码在线

https://invent.kde.org/plasma/kwin/-/blob/master/src/inputmethod.cpp

# kwin源码阅读

## 窗口管理之焦点窗口：

结构：**stacking_order  窗口栈结构**

```
 // layers.cpp
 stacking_order:
        增删改：addWaylandWindow、updateStackingOrder、removeFromStack、removeWindow
        查：findWindowToActivateOnDesktop、findToplevel
```

使用：

> ```
>  //input.cpp
>  const QList<Window *> &stacking = Workspace::self()->stackingOrder();
>  // ------->  维护了一个栈，大概率焦点窗口，就是
> ```
>
> 一句话核心：
>
> ```
>  window = input()->findToplevel(position());   // Top窗口，大概率认为是focus的
> ```
>
> 使用层：
>
> ```
>  InputDeviceHandler::setHover(Window *window)  ---->
>     // 传给Input模块
>    InputDeviceHandler::setFocus(Window *window)
>  
> ```

## 窗口管理

Wayland/Weston 窗口管理 窗口管理涉及的内容：

窗口堆栈的改变，focus的变化等

与安卓对比：

1、Wayland/Weston 没有安卓所谓的AMS（Activity的创建与管理、进程的创建与管理）

-------> 可见，窗口管理，才是必须的

2、窗口堆栈： 对于安卓，没有，只有Activity的堆栈（究其根因：安卓是单窗口系统）；对于 Wayland，是有的窗口堆栈

```
        ------->  linux窗口管理中的（窗口堆栈），一部分被AMS承担了
```

3、窗口的切换：

窗口管理的操作（如窗口堆栈的改变，focus的改变）

https://blog.csdn.net/a8039974/article/details/122867167

https://blog.csdn.net/qqzhaojianbiao/article/details/129790817?spm=1001.2014.3001.5502     Wayland窗口系统

## 输入Input

参考：

1、 https://blog.csdn.net/qqzhaojianbiao/article/details/130932031      KWin事件总结和相关类介绍    ------->  好文

2、收藏图

主要类：

> TouchInputRedirection

input.cpp

```
 InputEventFilter
 InputKeyboardFilter
```

## 输入法：

### 虚拟键盘florence

参考:

> https://www.xmodulo.com/onscreen-virtual-keyboard-linux.html    virtual keyboard
>
> --------> 验证ok，可以输入（仅限英文）

启动：

> florence

**结构：**

> florence是一个单独进程，类似service   ------>  目前手动执行命令启动（不同于安卓）

一些基本情况：

> florence 目前是最好的 + 开源的    https://www.linuxlinks.com/best-free-open-source-virtual-keyboards/
>
> kde环境下可运行

### 虚拟键盘Onboard

### 其他：没有虚拟键盘的

> https://www.jianshu.com/p/563b1f8aff97
>
> https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450

kde下应用如何支持输入法？

> https://planet.kde.org/weng-xuetian-2023-01-06-how-to-make-your-application-support-input-method-under-linux/    How to make your application support Input method under Linux？
>
> ```
>  1、Create a connection to input method service.
>  2、Tell input method, you want to communicate with it.
>  3、Keyboard event being forwarded to input method
>  4、input method decide how key event is handled.
>  5、Receives input method event that carries text that you need to show, or commit to the application.6、
>  6、Tell input method you are done with text input
>  7、Close the connection when your application ends, or the relevant widget destructs.
> ```
>
> ---------------> 流程跟安卓一模一样！**必然，结构决定的**
>
> 不一样的点：linux侧这些是APP做的，安卓是IMMS做的

### 一些结论

从代码来看，kwin依赖于QT

QT源码下载： https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/5.15/5.15.0/single/

参考： https://www.cnblogs.com/kn-zheng/p/17689855.html

## 参考：

https://blog.csdn.net/qqzhaojianbiao   好文：

```
 KWin事件总结和相关类介绍
 Wayland中跨进程调用过程
 Weston中shm window渲染
 Wayland窗口系统
```

https://blog.csdn.net/qqzhaojianbiao/article/details/129734727?spm=1001.2014.3001.5502    Weston介绍









# KDE 圆角

## LightlyShaders

git clone https://github.com/Luwx/LightlyShaders

```java
cd LightlyShaders; mkdir qt5build; cd qt5build; 
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr -DQT5BUILD=ON       
 make    //--------->  这一步及前面是OK的
sudo make install 
(kwin_x11 --replace &)
```



疑问：

> 必须kwin_x11？？？！！！



%accordion%编译遇到的错误，缺少Qt5OpenGL：%accordion%

报错：

> 
>
> ```java
> CMake Error at /usr/lib/arm-linux-gnueabihf/cmake/Qt5/Qt5Config.cmake:28 (find_package):
>   Could not find a package configuration file provided by "Qt5OpenGL" with
>   any of the following names:
> 
>     Qt5OpenGLConfig.cmake
>     qt5opengl-config.cmake
> 
>   Add the installation prefix of "Qt5OpenGL" to CMAKE_PREFIX_PATH or set
>   "Qt5OpenGL_DIR" to a directory containing one of the above files.  If
>   "Qt5OpenGL" provides a separate development package or SDK, be sure it has
>   been installed.
> Call Stack (most recent call first):
>   CMakeLists.txt:13 (find_package)
> ```
>
> 
>
> 办法：
>
> >    sudo apt install  libqt5opengl5-dev
> >
> > 参考：https://github.com/sonic-pi-net/sonic-pi/issues/2032

%/accordion%



## KDE-Rounded-Corners

 git clone https://github.com/alex47/KDE-Rounded-Corners

## KDE-Rounded-Corners

https://github.com/matinlotfali/KDE-Rounded-Corners



注意：

> [![Wayland](https://camo.githubusercontent.com/4700b277d78e700294b0cf82088b7efc48be7a0f46092d2aa214c2d43b667920/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f5761796c616e642d737570706f727465642d677265656e3f6c6f676f3d7761796c616e64)](https://camo.githubusercontent.com/4700b277d78e700294b0cf82088b7efc48be7a0f46092d2aa214c2d43b667920/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f5761796c616e642d737570706f727465642d677265656e3f6c6f676f3d7761796c616e64) 





# kwin的插件特效





# 0层



# Wayland





参考：[Wayland与Weston简介_weston linux-CSDN博客](https://blog.csdn.net/jinzhuojun/article/details/47290707)   -------> 好文





# weston











# 一些理解

wayland是协议--------------kwin和weston都一样

> 比如：wayland-client-protocol.h 文件（比如wl_surface_set_input_region 接口，指定surface和region分发事件）



# TODO:

`windowDamaged(KWin::EffectWindow *w)`:

# 2023-02-24 如何开发一个 kwin 特效插件

https://www.jianshu.com/p/c6dc9771414d    2023-02-24 如何开发一个 kwin 特效插件

https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjy9eaQmpmFAxXMZvUHHelwAG8QFnoECBEQAQ&url=https%3A%2F%2Fblog.justforlxz.com%2F2023%2F06%2F25%2FHow-to-develop-a-kwin-special-effects-plugin%2F&usg=AOvVaw0yj3iA9Tu9Mce_3PNgMWTI&opi=89978449    开发一个KWin 特效插件





# **[KDE-Rounded-Corners](https://github.com/matinlotfali/KDE-Rounded-Corners)**特效

https://github.com/matinlotfali/KDE-Rounded-Corners        

----------->  功能：圆角+阴影

## TODO

着色器代码本身可以加日志嘛？

glGetShaderInfoLog获取到的日志为空的

> https://www.cnblogs.com/hwx0000/p/12733649.html      OpenGL常犯的错误及查错方法总结
>
> --------->   策略： 
>
> > （1）用安卓app去检查frag文件
> >
> > （2）寻找opengl源码
> >
> > （3）二分法去逼：二分法编译

## vertex着色器

cpp中默认的vertexSource:

```
 #version 300 es
 
 in vec4 position;
 in vec4 texcoord;
 out vec2 texcoord0;
 uniform mat4 modelViewProjectionMatrix;
 void main()
 {
     texcoord0 = texcoord.st;
     gl_Position = modelViewProjectionMatrix * position;
 }
```

## fragment着色器

```
 #version 300 es
 
 precision highp float;
 
 uniform sampler2D sampler;
 uniform sampler2D corner;
 
 in vec2 texcoord0;
 out vec4 fragColor;
 
 void main(void)
 {
     vec4 tex = texture(sampler, texcoord0);
     vec4 texCorner = texture(corner, texcoord0);
     tex.a = texCorner.a;
     fragColor = tex;
 }
 ------------------>  生效了，与Dim Inactive特效有关联
```

cpp中默认的fragment：

```
 #version 300 es
 
 precision highp float;
 uniform sampler2D sampler;
 
 in vec2 texcoord0;
 out vec4 fragColor;
 
 void main(void){
     vec2 texcoordC = texcoord0;
     fragColor = texture(sampler, texcoordC);
 }
 
 ------------------>  生效了，与Dim Inactive特效有关联
```

遇到的问题：

```
 接口：glGetShaderiv
 .h    <epoxy/gl.h>
 .so: aarch64-poky-linux/kdelibs4support/5.108.0-r0/recipe-sysroot/usr/lib64/libEGL.so
 cpp: ?
```

OpenGL ES着色器文件frag，关键点：

> 1、报错：
>
> ```
>  Error compiling shader:[ERROR: 0:35: 'texture2D' :   type is for Vulkan api only //【】---------> texture2D，没有这个接口，应该是texture()
>  ERROR: 0:35: 'texture2D' : cannot construct this type
>  ERROR: 0:35: 'constructor' : too many arguments
>  ERROR: 0:35: 'a' :  field selection requires structure, vector, or matrix on left hand side
>  ERROR: 0:53: '+' :  wrong operand types  no operation '+' exists that takes a left-hand operand of type 'float' and a right operand of type 'const int' (or there is no acceptable conversion)//【】：float + int，统一换成 float + float
>  ERROR: 0:54: 'clamp' : no matching overloaded function found
>  ERROR: 0:56: '<' :  wrong operand types  no operation '<' exists that takes a left-hand operand of type 'float' and a right operand of type 'const int' (or there is no acceptable conversion)
>  ERROR: 7 compilation errors.  No code generated.
> ```
>
> 2、需要设置着色器精度：浮点数精度
>
> ```
>  precision highp float;
> ```

-<font color='red'>验证frag的技巧：</font>

> 可以在安卓下使用 + 验证，是通用的



## 最终KDE的shapecorners插件

文件存放位置：

frag：

```
 /usr/share/kwin/shaders/shapecorners.frag
 /usr/share/kwin/shaders/shapecorners_core.frag
```

metadata.json：

```java
 /usr/share/kwin/builtin-effects/kwin4_effect_shapecorners/metadata.json
 /usr/share/kwin/effects/kwin4_effect_shapecorners/metadata.json ---------> 删
 //  /usr/share/kwin/shaders/shapecorners_core.frag 最终ok版本
 
 #version 300 es
 
 precision highp float;
 uniform sampler2D front;         // The painted contents of the window.
 uniform float radius;            // The thickness of the outline in pixels specified in settings.
 uniform vec2 windowSize;         // Containing `window->frameGeometry().size()`
 uniform vec2 windowExpandedSize; // Containing `window->expandedGeometry().size()`
 uniform bool disableRoundedTile;
 
 uniform vec2 windowTopLeft;      /* The distance between the top-left of `expandedGeometry` and
                                   * the top-left of `frameGeometry`. When `windowTopLeft = {0,0}`, it means
                                   * `expandedGeometry = frameGeometry` and there is no shadow. */

 uniform vec4 shadowColor;        // The RGBA of the shadow color specified in settings.
 uniform float shadowSize;        // The shadow size specified in settings.
 uniform vec4 outlineColor;       // The RGBA of the outline color specified in settings.
 uniform float outlineThickness;  // The thickness of the outline in pixels specified in settings.
 
 uniform vec4 modulation;         // This variable is assigned and used by KWinEffects used for proper fading.
 uniform float saturation;        // This variable is assigned and used by KWinEffects used for proper fading.

 in vec2 texcoord0;               // The XY location of the rendering pixel. Starting from {0.0, 0.0} to {1.0, 1.0}
 out vec4 fragColor;              // The RGBA color that can be rendered

 vec2 tex_to_pixel(vec2 texcoord) {
     return vec2(texcoord0.x * windowExpandedSize.x - windowTopLeft.x,
                 (1.0-texcoord0.y)* windowExpandedSize.y - windowTopLeft.y);
 }
 vec2 pixel_to_tex(vec2 pixelcoord) {
     return vec2((pixelcoord.x + windowTopLeft.x) / windowExpandedSize.x,
                 1.0-(pixelcoord.y + windowTopLeft.y) / windowExpandedSize.y);
 }
 bool isDrawingShadows() { return  windowSize != windowExpandedSize && shadowColor.a > 0.0; }
 bool isDrawingOutline() {
     vec2 one_edge = vec2(windowSize.x/2.0, 0.0);
     return  texture(front, pixel_to_tex(one_edge)).a > 0.5 &&
             outlineColor.a > 0.0 && outlineThickness > 0.0;
 }

 float parametricBlend(float t) {
     float sqt = t * t;
     return sqt / (2.0 * (sqt - t) + 1.0);
 }

 /*
  *  \\brief This function generates the shadow color based on the distance_from_center
  *  \\param distance_from_center: Distance of the rendering point and the reference point that is being used for rounding corners.
  *  \\return The RGBA color to be used for shadow.
  */
 vec4 getShadowColor(float distance_from_center) {
     if(!isDrawingShadows())
         return vec4(0.0,0.0,0.0,0.0);
     float percent = -distance_from_center/shadowSize + 1.0;
     percent = clamp(percent, 0.0, 1.0);
     percent = parametricBlend(percent);
     if(percent < 0.0)
         return vec4(0.0,0.0,0.0,0.0);
     else
         return vec4(shadowColor.rgb * shadowColor.a * percent, shadowColor.a * percent);
 }

 /*
  *  \\brief This function is used to choose the pixel color based on its distance to the center input.
  *  \\param coord0: The XY point
  *  \\param tex: The RGBA color of the pixel in XY
  *  \\param center: The origin XY point that is being used as a reference for rounding corners.
  *  \\return The RGBA color to be used instead of tex input.
  */
 vec4 shapeCorner(vec2 coord0, vec4 tex, vec2 start, float angle) {
     bool diagonal = abs(cos(angle)) > 0.1 && abs(sin(angle)) > 0.1;
     vec2 center;
     float distance_from_center;
     vec4 c;
     float r;
     if (disableRoundedTile) {
         r = outlineThickness;
         center = start + r * vec2(cos(angle), sin(angle));
         distance_from_center = distance(coord0, center);
         c = tex;
     }
     else {
         r = radius;
         center = start + radius * (diagonal? sqrt(2.0) : 1.0) * vec2(cos(angle), sin(angle));
         distance_from_center = distance(coord0, center);
         c = getShadowColor(distance_from_center);
     }

     if(isDrawingOutline()) {
         vec4 outlineOverlay = vec4(mix(tex.rgb, outlineColor.rgb, outlineColor.a), tex.a);

         if (distance_from_center < r - outlineThickness + 0.5) {
             // from the window to the outline
             float antialiasing = clamp(r-outlineThickness+0.5-distance_from_center, 0.0, 1.0);
             return mix(outlineOverlay, tex, antialiasing);
         }
         else {
             // from the outline to the shadow
             float antialiasing = clamp(distance_from_center-r+0.5, 0.0, 1.0);
             return mix(outlineOverlay, c, antialiasing);
         }
     }
     else {
         // from the window to the shadow
         float antialiasing = clamp(r-distance_from_center, 0.0, 1.0);
         return mix(c, tex, antialiasing);
     }
 }

 void main(void)
 {
     vec4 tex = texture(front, texcoord0);  // The RGBA of the XY pixel for the painted window
     if(tex.a == 0.0) {
         fragColor = tex;
         return;
     }

     float r = disableRoundedTile? outlineThickness: radius;

     /* Since `texcoord0` is ranging from {0.0, 0.0} to {1.0, 1.0} is not pixel intuitive,
      * I am changing the range to become from {0.0, 0.0} to {width, height}
      * in a way that {0,0} is the top-left of the window and not its shadow.
      * This means areas with negative numbers and areas beyond windowSize is considered part of the shadow. */
     vec2 coord0 = tex_to_pixel(texcoord0);

     /*
         Split the window into these sections below. They will have a different center of circle for rounding.

         TL  T   T   TR
         L   x   x   R
         L   x   x   R
         BL  B   B   BR
     */
     if (coord0.y < r) {
         if (coord0.x < r)
             tex = shapeCorner(coord0, tex, vec2(0, 0), radians(45.0));                        // Section TL
         else if (coord0.x > windowSize.x - r)
             tex = shapeCorner(coord0, tex, vec2(windowSize.x, 0), radians(135.0));            // Section TR
         else if (coord0.y < outlineThickness)
             tex = shapeCorner(coord0, tex, vec2(coord0.x, 0), radians(90.0));                 // Section T
     }
     else if (coord0.y > windowSize.y - r) {
         if (coord0.x < r)
             tex = shapeCorner(coord0, tex, vec2(0, windowSize.y), radians(315.0));            // Section BL
         else if (coord0.x > windowSize.x - r)
             tex = shapeCorner(coord0, tex, vec2(windowSize.x, windowSize.y), radians(225.0)); // Section BR
         else if (coord0.y > windowSize.y - outlineThickness)
             tex = shapeCorner(coord0, tex, vec2(coord0.x, windowSize.y), radians(270.0));     // Section B
     }
     else {
         if (coord0.x < r)
             tex = shapeCorner(coord0, tex, vec2(0, coord0.y), radians(0.0));                  // Section L
         else if (coord0.x > windowSize.x - r)
             tex = shapeCorner(coord0, tex, vec2(windowSize.x, coord0.y), radians(180.0));     // Section R

         // For section x, the tex is not changing
     }

     // Apply the saturation and modulation. This is essential for proper fades in other KWin effects.
     if (saturation != 1.0) {
         vec3 desaturated = tex.rgb * vec3( 0.30, 0.59, 0.11 );
         desaturated = vec3( dot( desaturated, tex.rgb ));
         tex.rgb = tex.rgb * vec3( saturation ) + desaturated * vec3( 1.0 - saturation );
     }
     tex *= modulation;

     // Send to output
     fragColor = tex;
 }
 // 5.0 ;
```

vertex插件没有定义，使用的是代码里硬编码的：

```java
 #version 300 es
 
 in vec4 position;
 in vec4 texcoord;
 out vec2 texcoord0;
 
 uniform mat4 modelViewProjectionMatrix;
 void main(){
     texcoord0 = texcoord.st;
     gl_Position = modelViewProjectionMatrix * position;
 }
```





### 产物

so位置：

```java
 sh-3.2# find /usr  -name "*shapecorners*"
 /usr/share/kwin/effects/kwin4_effect_shapecorners
 /usr/share/kwin/builtin-effects/kwin4_effect_shapecorners
 /usr/share/kwin/shaders/shapecorners.frag
 /usr/share/kwin/shaders/shapecorners_core.frag
 /usr/lib64/plugins/kwin/effects/configs/kwin_shapecorners_config.so   ------>  这里
 /usr/lib64/plugins/kwin/effects/plugins/kwin4_effect_shapecorners.so  ------>  这里
```



主要metadata.json位置：（次要的没导入，也ok）

```java
 /usr/share/kwin/builtin-effects/kwin4_effect_shapecorners/metadata.json
  /usr/share/kwin/effects/kwin4_effect_shapecorners/metadata.json  //【1】
```



-------> **注意：似乎【1】路径也要加，先加后删除！**

ok的脚本：

> %accordion% push.bat  %accordion%
>
> ```java
> 
> 
>      adb shell mkdir -p /usr/share/kwin/effects/kwin4_effect_shapecorners
>      adb shell mkdir -p  /usr/share/kwin/builtin-effects/kwin4_effect_shapecorners
>      ::adb push metadata.json  /usr/share/kwin/effects/kwin4_effect_shapecorners/
>      adb push metadata.json  /usr/share/kwin/builtin-effects/kwin4_effect_shapecorners/
>      
>      adb shell mkdir -p  /usr/lib64/plugins/kwin/effects/configs/
>      adb shell mkdir -p  /usr/lib64/plugins/kwin/effects/plugins/
>      adb push  kwin_shapecorners_config.so   /usr/lib64/plugins/kwin/effects/configs/
>      adb push  kwin4_effect_shapecorners.so  /usr/lib64/plugins/kwin/effects/plugins/
>      
>      adb shell mkdir -p  /usr/share/kwin/shaders/
>      adb push   shapecorners.frag        /usr/share/kwin/shaders/
>      adb push   shapecorners_core.frag  /usr/share/kwin/shaders/
>      
>      
>      ::使能
>      ::kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled true
>      ::qdbus org.kde.KWin /KWin reconfigure
>      
>      pause
> 
> 
> 
> 
> ```
>
> %/accordion%





# GDB