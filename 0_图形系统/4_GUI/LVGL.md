# 目录

# 参考

https://lvgl.100ask.net/7.11/documentation/02_porting/02_project.html    百问王LVGL中文教程手册文档



# 与安卓/weston对比理解

![http://photos.100ask.net/lvgl/02_poring/01_sys/01_sys.png](LVGL.assets/01_sys.png)

## **模块架构**

<img src="LVGL.assets/lvgl_pipeline.svg" alt="lvgl_pipeline" style="zoom: 25%;" />

```
src/draw/sw/lv_draw_sw.c
	evaluate 调度机制：evaluate 竞标 --------> 混合渲染："竞标"其实就是能走加速器(VG-Lite)的尽量走，走不了的 CPU 兜底

DMA2D（VG-Lite） 能做什么？
	矩形填充  ✓
	图片搬运  ✓
	像素混合  ✓
	文字排版  ✗  没有 CPU 根本排不出来
	复杂路径  ✗  贝塞尔曲线怎么裁？不会
	向量图形  ✗  DMA2D 不认 SVG	
	
为啥安卓的应用框架不需要混合渲染呢？可以默认走hwui？
	A: GPU shader 是图灵完备的，任何像素计算它都能做

安卓实际上也有混合渲染（隐藏在Skia内部）：
	安卓渲染栈：
		App 层:    View.draw(Canvas)     ← "全走 GPU" 的错觉
				  ─────────────────────
		Skia 层:   文字? → CPU: FreeType 光栅化 → 纹理上传 → GPU 合成
				   SVG?  → CPU: 路径剖分为三角形 → 顶点上传 → GPU 渲染
				   Bitmap? → CPU: 解码 JPEG/PNG → 纹理上传 → GPU 贴图
				  ─────────────────────
		GPU 层:    最终像素着色（shader 执行）
	文字、路径剖分、图片解码全在 CPU 上做，只是 Skia 把这层藏起来了。框架层看到 "走 GPU"，但其实 CPU 干了大量脏活。

本质原因	GPU 是指令可编的	VG-Lite 是功能固化的

硬件            IP 来源           集成于           能力范围
───────────────────────────────────────────────────────────
DMA2D           ST 自研           STM32F4/F7/     填充 + 搬运 + 混合
(Chrom-ART)                      H7/U5/L4        (4 种固定操作)

VG-Lite         VeriSilicon       NXP i.MX RT     路径/渐变/描边/变换
(gc355/gc555)   (授权 IP)         1050/1060/1170   (~20 种固定操作)

OpenGL ES       ARM/Imagination   带 GPU 的 MPU    全部可编程 shader
(Mali/Adreno)   /Qualcomm         (如树莓派等)     (图灵完备)


混合渲染，并行的前提：CPU 和 GPU任务区域不重叠


原生code默认CPU绘制
打开GPU绘制（软件模拟的）：
	（1）修改 lv_conf.h
	// 第 318 行：从 0 改为 1
	#define LV_USE_DRAW_VG_LITE 1
	// 第 372 行：从 0 改为 1（在 #if LV_USE_DRAW_VG_LITE 块内）
	#define LV_USE_VG_LITE_THORVG   1
	2. CMake 路径修复
	env_support/cmake/main.cmake 第 73 行已从 src/others/vg_lite_tvg 修正为 src/debugging/vg_lite_tvg

软绘src/draw/sw/lv_draw_sw.c
	case LV_DRAW_TASK_TYPE_IMAGE:
    LV_LOG_ERROR("lv_draw_sw_image called");  // 加这行
    lv_draw_sw_image(t, t->draw_dsc, &t->area);
    break;
硬绘：lv_draw_vg_lite_img.c:48  加入LV_LOG_ERROR("chen lv_draw_vg_lite_img");



VG-Lite 绘制后端：
	文件	                 功能
	lv_draw_vg_lite.c	VG-Lite 后端入口，初始化/调度
	lv_draw_vg_lite_arc.c	圆弧绘制
	lv_draw_vg_lite_rect.c / _fill.c / _border.c	矩形填充/边框
	lv_draw_vg_lite_label.c	文字绘制
	lv_draw_vg_lite_img.c	图片渲染
	lv_draw_vg_lite_line.c	线段绘制
	lv_draw_vg_lite_triangle.c	三角形
	lv_draw_vg_lite_vector.c	矢量图形
	lv_draw_vg_lite_layer.c	图层混合
	lv_draw_vg_lite_box_shadow.c	阴影
	lv_vg_lite_path.c / _grad.c / _stroke.c / _utils.c	底层路径/渐变/描边/工具
	lv_vg_lite_decoder.c	VG-Lite 图片解码器



demo入口：
	/lv_port_pc_vscode/src/main.c
		lv_demo_widgets();函数 -------> (1)替换为 lv_demo_music() ........
									    (2)替换为 lv_example_button_1 ........
```



## **线程结构** ------ 驱动力

![lvgl_tread](LVGL.assets/lvgl_tread.svg)

结论：

>   1、只有一个UI线程（也是渲染线程）
>
>   2、接受硬件中断！

## 美好之冲突解决（硬件中断与软件冲突）

**冲突：**

```java
我很难理解这个硬件中断，即使他快如闪电，但是对于UI线程来说，也是致命的，比如UI线程正在读一个变量，中断立刻改变了它。那么对于UI线程来说，这个变量就是不可预测的，不稳定的
果没有额外的保护机制，硬件中断对于正在读取同一块内存的 UI 线程来说就是毁灭性的。
```

-<font color='red'>软 + 软的冲突：用mutex锁</font>

硬件（Tick ISR） vs 软件（LVGL 主 UI 线程）-----调度者不同：

>   -   **LVGL 主 UI 线程（Thread）：** 它运行在**线程上下文（Thread Context）**。它的生杀大权掌握在操作系统的软件调度器（Scheduler）手里。OS 可以让它挂起（Suspend）、睡眠（Sleep）、或者时间片用完后把它切走。
>   -   **Tick ISR（Interrupt）：** 它运行在**中断上下文（Interrupt Context）**。它的生杀大权掌握在 CPU 内部的硬件中断控制器（如 ARM 的 NVIC）手里。只要硬件定时器的时间一到，电平一翻转，**无论主 UI 线程正在执行多么关键的代码，都会被瞬间强制打断（抢占）**，CPU 会立刻跳去执行 ISR 的代码。

### 方法一：关中断（<font color='red'>UI线程主控</font>）

当 UI 线程需要读取或修改这种“会被中断修改的共享变量”时，它会进入一个叫做临界区（Critical Section）的绝对安全领域。

```java
uint32_t lv_tick_get(void)
{
    uint32_t result;

    /* 1. 物理屏蔽全局中断（降下绝对防御护盾）*/
    __disable_irq(); 

    /* ---------------- 临界区开始 ---------------- */
    /* 此时任何硬件定时器哪怕到了时间，CPU 也绝对不理它，只能在门外憋着（挂起/Pending） */
    
    result = sys_tick; /* 2. 绝对安全地读取，哪怕它是 64 位的，也不会被撕裂 */
    
    /* ---------------- 临界区结束 ---------------- */

    /* 3. 恢复全局中断（撤销护盾） */
    /* 刚才在门外憋着的中断，会在这条指令执行后的一瞬间，立刻劈进来执行 */
    __enable_irq();  

    return result;
}
```

-------------------------->**缺点**：__disable_irq()与平台相关 （文件里硬编码了某一种硬件的关中断指令，它就丧失了通用性）



### 方法二：乐观并发控制（无锁解决冲突）

LVGL 原生代码中，并没有使用“拔掉物理中断插头（硬件临界区）”这种方法。

**平台无关性：**

```java
LVGL 的最高设计哲学是绝对的平台无关性（Platform Agnostic）。
它根本不知道自己是运行在 ARM Cortex-M（用 __disable_irq()）、还是 ESP32（用 portENTER_CRITICAL()）、亦或是 Linux 用户态。
```





```java
/* 定义两个全局易失性变量 */
volatile uint32_t sys_time = 0;     // 存储系统时间的变量
volatile uint8_t  tick_irq_flag;    // 哨兵旗帜

/* =========================================
 * 运行在中断 (ISR) 中的代码：负责写
 * ========================================= */
void lv_tick_inc(uint32_t tick_period) 
{
    tick_irq_flag = 0;        /* 核心动作：只要中断触发，立刻把旗子“拔掉”！ */
    sys_time += tick_period;  /* 更新时间 */
}

/* =========================================
 * 运行在主 UI 线程中的代码：负责读
 * ========================================= */
uint32_t lv_tick_get(void) 
{
    uint32_t result;
    
    /* 经典的多线程乐观读取循环 */
    do {
        tick_irq_flag = 1;    /* 1. UI 线程先插上一面“旗子” */
        
        result = sys_time;    /* 2. 尝试读取系统时间（这一步可能发生数据撕裂） */
        
    /* 3. 检查旗子还在不在？
       如果旗子变成 0 了，说明在执行第 2 步的时候，中断像闪电一样劈进来了。
       既然被打断了，刚才读出来的 result 肯定是错乱的，那我就废弃掉，再循环读一次！
       如果旗子还是 1，说明刚才没被中断，数据是完美的，退出循环。 */
    } while(!tick_irq_flag);  

    return result;
}
```

-<font color='red'>绝妙之处：</font>

>   -<font color='red'>1、没有任何锁！！！！</font>
>
>   2、**零硬件依赖**：全靠 C 语言的 `while` 循环和基础变量控制，可以在任何一块几毛钱的单片机上完美编译运行。
>
>   3、**永远不阻塞中断**：ISR（中断服务函数）永远处于最高优先级，它想写就写，不需要等待谁释放锁，保证了极高的实时响应。
>
>   4、**极低的性能开销**：在 99.99% 的情况下，UI 线程读取 `sys_time` 的那一瞬间是不会恰好撞上中断的，所以 `while` 循环只会执行一次，几乎零损耗。<font color='red'>只有在那极小概率撞车的情况下，它才会重新读一次。</font>

**生活化同构 --------- 一写多读（1读）：**

>   -<font color='red'>多个人抄写</font>高铁站的“滚动时刻表”（最完美的对应）
>   想象你正在高铁站候车，抬头看着那个巨大的滚动航班/列车信息大屏。
>
>   大屏的后台刷新系统 = 硬件中断 (ISR)： 它极其霸道，时间一到，“唰”地一下就会刷新屏幕上的车次信息。它绝对不可能因为有个旅客正在抄信息，就停下来等。
>
>   你 = UI 线程 (Reader)： 你的动作比较慢，你需要低头把“车次、站台号、发车时间”写到你的小本子上。
>
>   致命危机 (数据撕裂)： 假设大屏上显示“G123，站台5”。你刚在纸上写下“G123”，此时大屏“唰”地刷新了，变成了下一趟车“G456，站台8”。你低着头没发现，接着写了“站台8”。结果你的本子上记成了“G123，站台8”——这是一个完全错误、拼凑出来的假数据。跑去 8 站台你绝对会错过你的车。
>
>   互斥锁（加锁）的荒谬性：
>   如果你用“互斥锁”的思维，这就相当于你拿个大喇叭在候车大厅喊：“控制室注意！我正在抄信息，大屏立刻停止刷新！等我这 5 秒钟抄完了你再动！”
>   这显然是不可能的，会扰乱整个高铁站的运行。
>
>   LVGL 乐观锁（标志位重试）的日常做法：
>   事实上，作为一个有经验的旅客，你是这么做的：
>
>   设下标记 (Flag = 1)： 抄写前，你先看一眼屏幕右下角的一个 “正在显示第 1 页” 的小红点。
>
>   低头干活 (Read)： 你飞速地低头抄写。
>
>   抬头验货 (Check Flag)： 抄完后，你立刻抬头再看一眼右下角。
>
>   情况 A： 如果还是“第 1 页”，说明你低头的时候大屏没动。你抄的数据是 100% 完美 的，放心走人。
>
>   情况 B (重试)： 如果右下角变成了“第 2 页” (Flag 被后台系统改成了 0)，你立刻意识到：“糟了，我刚才抄的时候屏幕翻篇了！” 你叹了口气，把纸上的字划掉，等屏幕转回来，重新抄一遍。
>
>   这就是 LVGL do...while(!flag) 的<font color='red'>本质：不锁屏幕，事后验证，如果变化，推倒重来。</font>

**本质特征**：

>   <font color='red'>写的刚性</font>！！！！

**最完美的归宿（使用条件）**是：

>   1.  **<font color='red'>一写多读 </font>**
>
>       (1) 不是必要条件  （2）可以最大发挥价值（写的地方没有加锁，对其他读没有影响!!!）
>
>   2.  **<font color='red'>写操作频率非常低</font>**（极难发生碰撞）
>
>   3.  **读操作毫无副作用**
>
>   4.  **运行在单核且无复杂缓存机制的系统中**



## 代码路径结构

```
lvgl_workspace/
├── ⚙️ 1. 工程构建与环境配置 (Build & Environment) - [外层支撑]
│   ├── CMakeLists.txt         ▶ [构建骨架] 定义编译目标和宏。决定了库是如何跨平台编译并链接到宿主系统（如 Linux/RTOS）的。
│   ├── library.properties     ▶ [包管理] Arduino 等特定平台的依赖与版本识别文件。
│   ├── pack_code.py           ▶ [自定义工具] 你上传的 Python 打包脚本，用于代码的提取和过滤。
│   ├── README.md              ▶ [项目门面] 快速启动说明。
│   └── LICENCE.txt            ▶ [合规声明] MIT 开源协议。
│
├── 🧠 2. 顶层 API 与静态契约 (API & Contracts) - [系统边界]
│   ├── lvgl.h                 ▶ [外观模式 API] 唯一对外的 C 头文件，向应用层屏蔽了 src/ 下所有的复杂内部实现。
│   ├── lv_version.h           ▶ [版本控制] 编译期的版本宏定义，用于业务层做特性兼容。
│   └── lv_conf_template.h     ▶ [静态裁剪总闸] 极其重要的配置文件模板！通过宏定义控制 `src/` 中各个组件的开关、显存分配和色深，实现极致的内存控制。
│
├── 🫀 3. 核心源码层 (src/ Engine) - [系统内核 - 重点展开]
│	├── core/                ▶ [框架基石：DOM与事件流] 系统的“大脑”
│	│   ├── lv_obj.c/h       -> 【核心对象模型】一切 UI 组件的基类。通过 C 语言结构体嵌套实现“继承”。管理父子层级关系、坐标域和状态。
│	│   ├── lv_refr.c/h      -> 【渲染总管/脏矩形引擎】核心中的核心！负责收集失效区域（Invalidated Areas），计算脏矩形交集，并触发真正的渲染管线。类似于 SurfaceFlinger 的 Damage Region 管理。
│	│   ├── lv_disp.c/h      -> 【显示管理器】管理多个物理屏幕的逻辑映射，维护各自的渲染缓冲区（Draw Buffer）。
│	│   ├── lv_event.c/h     -> 【事件总线】基于观察者模式，处理事件的冒泡与捕获。
│	│   └── lv_group.c/h     -> 【焦点管理器】专为非触摸外设（如编码器、键盘）设计的逻辑焦点轮转系统。
│	│
│	├── draw/                ▶ [图形渲染管线：光栅化与 GPU 接口] 系统的“画笔”
│	│   ├── lv_draw.c        -> 【渲染入口】接收脏矩形，分发具体的绘制任务（画背景、画边框、画阴影、画文字）。
│	│   ├── sw/              -> 【软件渲染器 (Software Renderer)】CPU 回退方案。包含高度优化的纯 C 语言画线、混合（Blend）、抗锯齿（AA）算法。
│	│   └── [gpu_hooks]/     -> 【硬件加速层】(如 nxp_pxp, stm32_dma2d, sdl)。这里定义了 Draw Context 抽象，允许将特定的图元绘制任务卸载（Offload）给 2D 图形加速器或 GPU。
│	│
│	├── widgets/             ▶ [标准组件库：UI 具象化] 系统的“血肉”
│	│   ├── lv_btn.c         -> 【按钮】继承自 lv_obj，极简实现。
│	│   ├── lv_label.c       -> 【文本标签】处理复杂的长文本换行、滚动动画（Marquee）。
│	│   ├── lv_chart.c       -> 【图表】复杂组件代表，涉及内部数据流和定制化绘制规则。
│	│   └── ... (几十种标准组件)
│	│
│	├── font/                ▶ [排版与字库引擎] 
│	│   ├── lv_font.c        -> 【字体接口】统一的字距（Kerning）、基线匹配和点阵获取接口。
│	│   └── lv_font_fmt_txt.c-> 【原生格式解析】解析 LVGL 自定义的、高度压缩的矢量/点阵混合字体格式。
│	│
│	├── layout/              ▶ [动态盒模型引擎] 
│	│   ├── flex/            -> 【弹性布局】实现类似 CSS 的 Flexbox 算法。
│	│   └── grid/            -> 【网格布局】实现二维的 Grid 布局逻辑。
│	│
│	├── hal/                 ▶ [硬件抽象层] (在较新版本中逐渐与 core 融合或重构)
│	│   ├── lv_hal_disp.c    -> 【显示驱动契约】对接底层 Framebuffer 刷屏函数 (flush_cb)。
│	│   ├── lv_hal_indev.c   -> 【输入驱动契约】对接触摸屏、鼠标、按键的读取回调 (read_cb)。
│	│   └── lv_hal_tick.c    -> 【系统心跳】提供系统时钟基准。
│	│
│	└── misc/                ▶ [基础工具链] 
│		├── lv_anim.c        -> 【插值动画引擎】基于时间轴的回调式动画管理器。
│		├── lv_tlsf.c        -> 【内存分配器】为无 OS 环境自带的实时内存池算法，对抗内存碎片。
│		├── lv_math.c        -> 【定点数数学库】查表法实现的快速三角函数、平方根，避免浮点运算。
│		└── lv_timer.c       -> 【定时器与异步任务】系统的任务调度器，驱动整个 LVGL 的主循环（`lv_timer_handler`）。
│
├── 🎨 4. 业务验证与演示层 (demos/) - [应用切片]
│   ├── lv_demos.h/c           ▶ 统一的 Demo 路由管理器。
│   ├── benchmark/             ▶ [渲染压测] 极限测试帧率 (FPS) 和 CPU 负载。
│   ├── music/                 ▶ [综合业务] 包含 MVC 雏形的复杂高保真 UI 示例。
│   ├── flex/                  ▶ [布局验证] 弹性盒模型的直观展示。
│   └── keypad_encoder/        ▶ [焦点验证] 无触摸屏环境下的按键/编码器焦点流转演示。
│
└── 📚 5. 辅助支撑与外围扩展 (边缘路径 - 折叠)
    ├── examples/              ▶ [未展开] 各个独立 Widget 的极简 API 调用代码片段（比 demos 更底层）。
    ├── env_support/           ▶ [未展开] 针对 Zephyr, RT-Thread, CMake 等环境的适配模板代码。
    ├── scripts/               ▶ [未展开] 官方用于自动化生成文档、字库转换的辅助脚本。
    ├── tests/                 ▶ [未展开] 针对各个模块的 CI 单元测试用例。
    └── docs/                  ▶ [未展开] 官方使用文档的 Markdown 源文件。
```

# 运行时代码调用栈

##  LVGL 9.2.2 渲染流水线 (带异步 Task 分发)

```
lv_timer_handler()  [位于 lv_timer.c - 主循环入口]
 └── _lv_timer_core()
      └── lv_display_refr_timer()  [位于 lv_refr.c - UI 管线主引擎]
           ├─► 【阶段 1：Layout & Measure 同步排版】
           │   lv_obj_update_layout(display->act_scr)
           │    └── layout_update_core(obj)  (递归计算树)
           │         ├─► [Measure] lv_obj_send_event(obj, LV_EVENT_GET_SELF_SIZE, &size)
           │         └─► [Layout]  lv_obj_send_event(obj, LV_EVENT_LAYOUT_CHANGED, NULL)
           │             └─► 触发 flex/grid 等布局引擎，确立绝对物理坐标 (x,y,w,h)。
           ├─► 【阶段 2：脏矩形计算 (Dirty Area)】
           │   _lv_display_refr_join_area(display) 
           │   └─► 合并需要重绘的无效区域，存入 display->inv_areas。
           ├─► 【阶段 3：Task Generation (同步指令生成，取代老版的同步渲染)】
           │   lv_refr_area(display, &area)
           │    ├─► 创建根图层: layer = lv_draw_layer_create(display, &draw_area)
           │    └── lv_obj_redraw(display->act_scr, layer)  [核心变化点: 传入的是 layer]
           │         ├─► lv_obj_send_event(obj, LV_EVENT_DRAW_MAIN, layer)
           │         │   └─► (例如：Button 控件接收事件)
           │         │       └── lv_draw_rect(layer, &rect_dsc, &coords)  [注意：此处只记录，不画点！]
           │         │            └─► lv_draw_add_task(layer, &coords) 
           │         │                └─► 申请一个 lv_draw_task_t，填入颜色/圆角/坐标参数。
           │         │                └─► 将该 task 挂载到 layer->task_list 链表尾部。
           │         ├─► 递归调用子节点 lv_obj_redraw(child, layer) -> 继续向链表塞 Task
           │         │
           │         └─► [图层缓存机制 (Layer Buffer)] 
           │             如果控件设置了 opacity 或 transform，会触发 lv_draw_layer_alloc_buf()，
           │             为该节点开辟独立离屏缓存，并将后续的 child_tasks 挂载到新的 sub_layer 上。
           │
           └─► 【阶段 4：异步唤醒 (Async Dispatch Request)】
               lv_draw_dispatch_request()  [位于 lv_draw.c]
                └─► 如果配置了 LV_USE_OS == 1，此处会释放一个信号量 (Semaphore/Condition Variable)，
                    唤醒后台的专属渲染线程；随后主线程直接返回，继续处理下一轮的触摸事件。

========================= 线程级物理隔离 =========================

【阶段 5：Asynchronous Task Dispatch & Execution (异步渲染消费线程/中断)】
[由独立的 OS 线程或硬件 DMA 中断驱动 - 位于 lv_draw.c]

lv_draw_thread()  (独立线程死循环)
 └── while(1) {
      lv_draw_dispatch_wait_for_request(); // 阻塞等待主线程发出指令
      └── lv_draw_dispatch()  // 全局渲染任务调度器
           └─► lv_draw_dispatch_layer(display, layer)
                └─► 遍历 layer->task_list 中的所有待处理的 lv_draw_task_t
                     └─► 查询系统中注册的所有渲染引擎 (Draw Units):
                         [Draw Unit 1]: VG-Lite GPU 加速器 (如果是 NXP/STM32 某些带 2.5D GPU 的芯片)
                         [Draw Unit 2]: PXP / DMA2D 硬件搬运器
                         [Draw Unit 3]: SW 纯软件光栅化引擎
                         │
                         └─► 匹配算法：哪个 Unit 处于空闲 (idle)，且声称自己能处理该 task (evaluate_cb)？
                             └─► 将 Task 交给特定的 Unit 执行 (dispatch_cb)
                                 └── 【执行终点】：以默认纯软件引擎为例
                                     lv_draw_sw_dispatch()  [位于 lv_draw_sw.c]
                                      └── 执行实际的算术和内存写入：
                                          lv_draw_sw_rect() -> 像素混合，将颜色写到内存 framebuffer 中。
                                          (如果是 GPU Unit，则在此处构造 GPU 命令列表并提交)
                                      │
                                      └── 标记 Task 完成 (state = LV_DRAW_TASK_STATE_READY)
    }
```

## Label 绘制与硬件提交

### 异步：

```java
lv_draw_label()  [LVGL 绘图分发层]
 └── lv_draw_vglite_label()  [VG-Lite 专属 Label 绘制入口]
      ├── 1. 上下文准备：获取目标 Buffer 地址、字体信息、文本颜色、透明度等
      ├── 2. lv_draw_label_iterate_characters()  [LVGL 核心字符迭代器]
      │    │  (遍历字符串，处理换行、字间距、Bidi 双向文本对齐等逻辑)
      │    └── _draw_vglite_letter()  [逐字回调函数 - 针对单个字符]
      │         └── _vglite_draw_letter()  [第189-214行：核心硬件指令封装]
      │              ├── 检查当前字符字形 (Glyph) 是否支持硬件加速 (格式/对齐)
      │              ├── 若不支持 -> 触发 Fallback (降级到 CPU 软件绘制)
      │              └── 若支持 -> 构建 GPU 渲染指令
      │                   └── vg_lite_blit_rect() / vg_lite_blit()
      │                       └── 写入 VG-Lite Command Buffer (此时 GPU 仍在休眠或处理上一批指令)
      │
      └── 3. 退出 Label 绘制函数 (此时整个 Label 的指令都在 Buffer 中，尚未执行)

==================== 异步/延迟提交分界线 ====================

[触发 Flush / Finish 的时机 (见下文详细解释)]
 ├── 场景 A：VG-Lite 底层命令缓冲区满了 (驱动层自动触发)
 ├── 场景 B：发生 CPU 软件绘制降级 (需同步硬件结果)
 └── 场景 C：整个图层或帧绘制完毕 (LVGL 调度层主动触发)
      └── lv_draw_vglite_wait_for_finish() / lv_draw_vglite_flush()
           └── vg_lite_finish() 或 vg_lite_flush()  [VG-Lite 核心 API]
                ├── 发送中断/寄存器信号给 GPU 硬件
                ├── GPU 开始读取 Command Buffer，执行像素光栅化、混合 (Alpha Blending)
                └── 等待 GPU 硬件完成中断 (如果是 finish 的话)
```



为什么每个字形都要 `blit` 一次，而不是整个字符串一起给 GPU？

>   GPU 的 2D 引擎（像 VG-Lite）本质上只认“矩形色块”或“矢量路径”。它不认识“字符串”。LVGL 必须通过 CPU 算出每个字体的排版位置（Kerning、换行），然后把每一个字符当成一张“小图片”，单独命令 GPU 去贴图（Blit）。

`vg_lite_blit_rect` 只是存指令，那么真正的触发点在哪？LVGL 的 VG-Lite 驱动在以下三种情况下会发生实际的提交：

-   **触发点 1：Command Buffer 填满（底层被动触发）** VG-Lite 驱动在初始化时会分配一块定长的命令缓冲区（通常是 64KB 或 128KB）。如果你的 Label 极长（比如一屏幕密密麻麻的小字），当 `vg_lite_blit_rect` 发现当前缓冲区不够写了，它会自动在内部触发一次 `flush`，然后清空指针，继续记录剩余字符。
-   **触发点 2：发生软硬件切换 (CPU Fallback Sync)** 假设你画了一个 Label (GPU 构建指令) -> 紧接着画了一个复杂的多边形蒙版 (VG-Lite 不支持，LVGL 必须用 CPU 画)。 在这个瞬间，如果 CPU 直接去改写显存，就会和 GPU 还没执行的 Label 绘制发生**数据竞争冲突**。 所以，当 LVGL 发现需要动用 CPU 渲染器前，会强制调用 `vg_lite_finish()`，让 GPU 把之前积攒的 Label 赶紧画完，然后 CPU 再接手。
-   **触发点 3：当前 Layer/Task 绘制结束（主动触发）** 在 LVGL 的绘图流水线（Draw Thread）末尾，当一个图层（Layer）上的所有节点都遍历完了，或者准备要把缓冲区送到屏幕控制器（LCDC/eLCDIF）显示之前，LVGL 底层会调用 `lv_draw_vglite_wait_for_finish()` 或类似回调，强制提交并等待所有 GPU 操作完成。

### 同步：



```java
lv_draw_dispatch() / lv_refr_vdb_flush()  [LVGL 核心调度器 / 刷新引擎]
 ├── 1. 判定需要同步：当前图层的 GPU 任务队列已下发完毕，或即将发生软硬件渲染切换
 ├── 2. lv_draw_vglite_wait_for_finish()  [LVGL 的 VG-Lite 移植层同步入口]
 │    ├── (步骤 A) 缓存同步：执行 CPU D-Cache Clean (确保 CPU 生成的指令和图像数据已写入主存 RAM)
 │    └── (步骤 B) vg_lite_finish()       [VG-Lite 驱动层核心同步 API]
 │         ├── 1. vg_lite_flush()         [内部强制调用，把当前 Command Buffer 立即推给 GPU]
 │         ├── 2. 硬件寄存器操作：向 GPU 发送 "START" 或类似触发信号
 │         ├── 3. OS 级线程挂起：调用 xSemaphoreTake / tx_semaphore_get 等 RTOS 接口
 │         │    │  (★ 此时当前 LVGL 绘图线程进入睡眠，交出 CPU 使用权)
 │         │    │  ... CPU 去执行其他任务，GPU 开始在后台疯狂进行像素光栅化和混合 ...
 │         │    │
 │         ├── 4. GPU 硬件中断 (IRQ)：GPU 画完所有像素，向中断控制器 (NVIC/GIC) 发送中断信号
 │         │    │
 │         ├── 5. VG-Lite 中断服务函数 (ISR)：在中断上下文中，调用 xSemaphoreGive 释放信号量
 │         │    │
 │         └── 6. 线程唤醒：vg_lite_finish 成功获取到信号量，解除阻塞，函数返回！
 │
 └── 3. 返回 LVGL 层：此时显存中的画面已经 100% 准备好。
        (后续动作：CPU 执行软件降级绘制，或者调用屏幕控制器的 DMA 把这帧画面刷到 LCD 上)
```





### “必须”同步？

在实际的 GUI 开发中，滥用同步会导致严重的卡顿（因为 CPU 和 GPU 没有并行工作），但在以下三种情况下，**必须严丝合缝地执行同步栈**：

-   **场景一：CPU Fallback（软件降级渲染）** 如果 LVGL 发现一个复杂的圆角渐变阴影 VG-Lite 硬件不支持，必须用 CPU 的软件算法画。此时**必须**调用同步栈，等 GPU 把之前的纯色背景和文字先画完。否则，CPU 和 GPU 会同时读写同一块显存，导致画面出现随机的撕裂或马赛克。
-   **场景二：Buffer Swap（双缓冲切换）** 当整个 Frame Buffer（帧缓冲）画完了，准备把这块内存的地址交给 LCD 屏幕控制器显示前。如果不调用 `finish` 同步，屏幕可能会显示出一张 GPU 才画了一半（比如文字只显示了上半截）的半成品画面。
-   **场景三：Command Buffer** 已满 系统分配给 VG-Lite 的命令缓冲区内存是有限的。当这些缓冲区全部写满，且之前的指令 GPU 还没执行完时，CPU 只能被迫进入同步等待，等 GPU 消费掉一部分指令，腾出空间后，CPU 才能继续往里写新的渲染指令。





# 维测

## FPS

开关：

```java
/* 1. 开启系统监视器 (LVGL v9+) */
#define LV_USE_SYSMON           1

/* 2.(可选) 开启性能监控悬浮窗 (显示 FPS, CPU 占用, 渲染时间等) */
#define LV_USE_PERF_MONITOR     1

/* 3. (可选) 控制监控数据的输出方式 */
/* 在屏幕上显示悬浮窗 (默认通常开启) */
#define LV_USE_PERF_MONITOR_POS LV_ALIGN_BOTTOM_RIGHT
/* 是否将性能数据通过 LV_LOG_INFO 打印到串口 (产生你看到的那条 log) */
#define LV_USE_PERF_MONITOR_LOG_MODE 1 

/* 4. (可选) 搭配开启内存监控，排查内存泄漏 */
#define LV_USE_MEM_MONITOR      1
```

日志：

```java
lvgl-sysmon-fps: 12 FPS (refr_cnt: 5 | redraw_cnt: 5), refr 66ms (render 56ms | flush 2ms), CPU 100 -
```

| **字段**            | **含义**                                                     | **诊断意义**                                                 |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **`12 FPS`**        | **当前帧率 (Frames Per Second)**。                           | 12 FPS 属于明显卡顿，通常流畅的 UI 需要 30+，丝滑需要 60。   |
| **`refr_cnt: 5`**   | **刷新区域数量**。LVGL 计算出屏幕上有 5 个不相交的“脏矩形”（Dirty Areas）需要更新。 | 数量越多，LVGL 合并脏矩形的开销越大。若本该一起更新的 UI 碎片化了，需优化布局。 |
| **`redraw_cnt: 5`** | -**<font color='red'>重绘次数</font>**。实际调用绘图指令的次数。 | 通常与 `refr_cnt` 对应。如果远大于 `refr_cnt`，说明发生了很多透明图层的反复重绘（Overdraw）。 |
| **`refr 66ms`**     | **单次刷新的总耗时**。从开始计算脏区到最终送显完成。         | **核心卡点**。66ms 意味着一秒最多只能跑 1000/66 ≈ 15 帧（与你的 12 FPS 吻合）。 |
| **`render 56ms`**   | -**<font color='red'>纯渲染耗时</font>**。CPU 或 GPU（VG-Lite/PXP等）进行光栅化、混合、画图的总耗时。 | 56ms 占比极大！说明**瓶颈在渲染端**。可能：1. 没开启硬件加速；2. 使用了大量高斯模糊、复杂遮罩；3. 图层叠得太多。 |
| **`flush 2ms`**     | -**<font color='red'>送显耗时</font>**。将算好的画面像素拷贝/DMA传给 LCD 屏幕的耗时。 | 2ms 非常健康，说明你的底层 LCD 驱动（如 DMA 或 SPI 刷屏）效率很高，没有拖后腿。 |
| **`CPU 100`**       | **CPU 占用率 100%**。                                        | 证实了上面的猜想，CPU 被彻底榨干了。它完全在做纯软件的算力运算（可能在死磕软渲染）。 |

## 显示面板

要让它显示在屏幕右下角，只需确保你的 `lv_conf.h` 中有以下配置：

```java
/* 1. 开启系统监视器核心组件 (v9+ 必须) */
#define LV_USE_SYSMON           1

/* 2. 开启性能监视器 (显示 FPS, CPU 等) */
#define LV_USE_PERF_MONITOR     1

/* 3. 决定悬浮窗显示在屏幕的哪个角落 (核心宏) */
#define LV_USE_PERF_MONITOR_POS LV_ALIGN_BOTTOM_RIGHT
```



# code

~~拉取纯FreeRTOS-Kernel内核仓库：~~

```java
git clone --branch V10.5.1 --depth=1 https://github.com/FreeRTOS/FreeRTOS-Kernel.git
```

~~拉取 LVGL:~~

```java
git clone --branch v9.2.2 --depth=1 https://github.com/lvgl/lvgl.git
```

官方的Linux模拟器环境：

```
0.把 LVGL 的核心库（作为子模块）一并下载下来。
git clone --recursive https://github.com/lvgl/lv_port_pc_vscode.git

#编译：
cd lv_port_pc_vscode
2. 创建一个独立的编译目录（保持源码干净）并进入
mkdir build && cd build
3. 让 CMake 生成 Makefile 构建脚本（.. 代表上一级目录）
cmake ..
4. 开启多线程满血编译（你的 CPU 有几个核就火力全开）
make -j$(nproc)
```



# 环境构建

FreeRTOS V10.5.1   LVGL 版本：9.2.2

