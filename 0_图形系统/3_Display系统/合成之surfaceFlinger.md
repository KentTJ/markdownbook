# 目录

# surfaceflinger的启动 之 .rc文件

参考：

>  [android屏幕渲染之SurfaceFlinger的启动](https://www.jianshu.com/p/dcc37f81c119)

系统文件：

```java
 /system/bin/surfaceflinger
```

如何启动系统文件surfaceflinger：

> 1、配置
>
> ```java
>  /system/etc/init/surfaceflinger.rc
>  
>  service surfaceflinger /system/bin/surfaceflinger   // -----> 定义surfaceflinger服务
>      class core animation
>      user system                     //  ------> 用户
>      group graphics drmrpc readproc  // -----> 用户组
>      onrestart restart zygote        // -----> 重启条件
>      writepid /dev/stune/foreground/tasks   // ------>  surfaceflinger放到什么调频组
>      socket pdx/system/vr/display/client     stream 0666 system graphics u:object_r:pdx_display_client_endpoint_socket:s0
>      socket pdx/system/vr/display/manager    stream 0666 system graphics u:object_r:pdx_display_manager_endpoint_socket:s0
>      socket pdx/system/vr/display/vsync      stream 0666 system graphics u:object_r:pdx_display_vsync_endpoint_socket:s0
> ```
>
> 2、按照配置启动
>
> LoadBootScripts解析
>
> ParseConfigDir    解析路径，files收集目录下所有文件   ----> 不得不
>
> for (file : files)  遍历所有文件
>
> ParseConfigFile 解析文件
>
> ParseData 解析数据
>
> ServiceParser::ParseLineSection   解析行时，根据不同的关键词，选择不同的SectionParser。比如：service 选择  ServiceParser；import 选择 ImportParser
>
> ServiceParser::ParseGroup
>
> service_->proc_attr.gid = gid;   // 【】  最终赋值点

# =====进入surfaceflinger  main 之后======

参考：

>  [【安卓源码】SurfaceFlinger启动及其与应用通信](https://blog.csdn.net/qq_40587575/article/details/129657882)
>
> ----------> 源码注释

源码：

TODO:

设计美好： 统一的配置，剥离成文件











# 合成



## why----------合成  存在的必然性

**证明：**

>   多个画家（App）各自画画，<font color='red'>必然存在</font>一个人去 张贴所有画  到 一个墙上，即合成

即使统一渲染（多个画家，指挥一个人画在墙上）：

>   也是存在**隐式的 合成**（多对一发指令）-------> 即绘图指令的合成

----------------------> 总之，<font color='red'>合成  是 “多对一”  的必然。</font>



## how--------合成策略



合成策略，图：

> 
>
> ![image-20240627013307139](合成之surfaceFlinger.assets/image-20240627013307139.png)
>
> 其中①和②
>
> [图来源：](https://www.cnblogs.com/hellokitty2/p/17637480.html#:~:text=%E5%9B%BE%E6%89%80%E7%A4%BA%EF%BC%8C-,%E6%AD%A4%E5%9B%BE%E6%9D%A5%E6%BA%90%E4%BA%8EAndrod%E5%AE%98%E7%BD%91,-%EF%BC%9A)：

两种合成方式：

> 1、~~SF合成：重新draw（即SF 的client方式）~~ ------ 最终GPU承载（~~软件部分：sf的openGl调用~~） 
>
> 2、~~硬件合成（即SF 的device方式）~~ ------ 最终显示硬件DPU承载（~~软部分：sf转发给<font color='red'>hwc-drm</font>，最终<font color='red'>DPU</font>计算~~）

对比：

|                               | Device合成(HWC)                        | Client合成(GPU)                          |      |
| ----------------------------- | -------------------------------------- | ---------------------------------------- | ---- |
| 耗电                          | 耗电低                                 | 耗电高                                   |      |
| 性能                          | 性能高                                 | 性能低                                   |      |
| Alpha处理                     | 很多Vendor的HWC不支持Alpha的处理和合成 | 能处理每个像素的Alpha及每个Layear的Alpha |      |
| DRM内容处理                   | 基本都能访问DRM内容                    | 早期版本GPU不能访问DRM的内容             |      |
| 其他限制                      | 能合成的Surface层数有限，              |                                          |      |
| 对每种Surface类型处理层数有限 | 没有处理层数限制                       |                                          |      |

[来源:Android P 图形显示系统（一）硬件合成HWC2](https://www.cnblogs.com/hellokitty2/p/17637480.html#:~:text=下面是 GPU 和 HWC 两种方式的优劣对比：)



优缺点：

> 1、硬件合成：
>
> ​           效率更高（不占GPU资源）
>
> ​           **但是有四层的限制？**
>
> 2、sf合成：
>
> ​       ~~自然~~

两种合成方式存在的必然性：





代码证明：

>   [Android P 图形显示系统（一）硬件合成HWC2](https://www.cnblogs.com/hellokitty2/p/17637480.html )  









TODO:

> 用哪一种，判断准则：
>
> 代码证明





参考:  [图解HWC的合成策略 - 简书 (jianshu.com)](https://www.jianshu.com/p/c6d46efd84f9)  

假设该屏幕支持4个Planes：

> client合成，会占用一个屏幕 Plane
>
> 剩余 ---->  直接硬件合成

### GPU合成，具体代码（字典）

代码大纲：

```java
└─ GLESRenderEngine::drawLayersInternal
    ├─ for (const auto& layer : layers) {
    │   ├─ status = mBlurFilter->render(); // 模糊特效
    │   ├─ setupLayerTexturing  // 配置贴图
    │   ├─ 
    │   ├─ if: handleShadow         // 阴影特效
    │   │   ├─ setupLayerTexturing  // 【1】 TODO: 阴影也是贴图！！！！证明：
    │   │   └─ drawMesh
    │   ├─ elseif:handleRoundedCorners // 圆角特效
    │   │   ├─ glScissor(topRect) // 限制绘制区域
    │   │   ├─ drawMesh(mesh) // 【】这里shader包含贴图
    │   │   ├─ 
    │   │   ├─ setScissor(bottomRect) 1
    │   │   ├─ drawMesh(mesh)
    │   │   ├─ 
    │   │   ├─ setScissor(middleRect)
    │   │   ├─ mState.cornerRadius = 0.0; //【】画中间区域时，悄悄把圆角半径设为0 ----> 中间区域生成的shader，剔除了圆角的计算。其他都同圆角？？
    │   │   └─ drawMesh(mesh)
    │   └─ else：drawMesh // 没有圆角和阴影时，直接drawMesh(贴图)
    │       └─ glVertexAttribPointer(mesh.getTexCoords()); // 获取 贴图坐标
    │           ├─ glVertexAttribPointer(mesh.getCropCoords()); // 取圆角裁剪坐标
    │           ├─ 
    │           ├─ useProgram
    │           │   ├─ generateVertexShader  // 【2】  根据不同的needs，配置不同shader
    │           │   └─ glUseProgram // 【3】 TODO:
    │           └─ glDrawArrays 或 glDrawElements // 最终一行绘制
    ├─ 
    └─ drawFence = GLESRenderEngine::flush // TODO:



```



%accordion%原始 tree%accordion%

```java
GLESRenderEngine::drawLayersInternal
	for (const auto& layer : layers) {
		status = mBlurFilter->render(); // 模糊特效
		setupLayerTexturing  // 配置贴图
		
		if: handleShadow         // 阴影特效
			setupLayerTexturing  // 【1】 TODO: 阴影也是贴图！！！！证明：
			drawMesh
		elseif:handleRoundedCorners // 圆角特效
			glScissor(topRect) // 限制绘制区域
			drawMesh(mesh) // 【】这里shader包含贴图
			
			setScissor(bottomRect) 1
			drawMesh(mesh)
			
			setScissor(middleRect)
			mState.cornerRadius = 0.0; //【】画中间区域时，悄悄把圆角半径设为0 ----> 中间区域生成的shader，剔除了圆角的计算。其他都同圆角？？
			drawMesh(mesh)
		else：drawMesh // 没有圆角和阴影时，直接drawMesh(贴图)
				glVertexAttribPointer(mesh.getTexCoords()); // 获取 贴图坐标 
				glVertexAttribPointer(mesh.getCropCoords()); // 取圆角裁剪坐标
				
				useProgram 
					generateVertexShader  // 【2】  根据不同的needs，配置不同shader
					glUseProgram // 【3】 TODO:
				glDrawArrays 或 glDrawElements // 最终一行绘制
	
	drawFence = GLESRenderEngine::flush // TODO:
```

%/accordion%





### weston对应的

到底走overlay还是GPU：

weston 代码： [Assign_planes](https://blog.csdn.net/u012839187/article/details/106469038?spm=1001.2014.3001.5501#:~:text=_drm_input---,Assign_planes,-assign_planes)

纯软件合成（完全的CPU合成）：weston 的pixman-render

------> 安卓不存在这种方式！





## 渲染与显示分离-----HWC

图，同上。

> ![img](合成之surfaceFlinger.assets/1117305-20230817140910580-821209824.webp)
>
> [图来源](https://www.cnblogs.com/hellokitty2/p/17637480.html#:~:text=%E5%9B%BE%E6%89%80%E7%A4%BA%EF%BC%8C-,%E6%AD%A4%E5%9B%BE%E6%9D%A5%E6%BA%90%E4%BA%8EAndrod%E5%AE%98%E7%BD%91,-%EF%BC%9A)

有没有分离的判断标志-------------即有没有

> 上面一条路：GPU渲染完，直接到Display   -----> 未分离
>
> ​                     GPU渲染完，回到sf 给到Dpu（HWC）进一步合成

**分离的必要性**：降低GPU功耗



![image-20240627012931158](合成之surfaceFlinger.assets/image-20240627012931158.png)



### weston一模一样：

硬件合成  ---> weston_plane相关流程





## 从vsync角度来看  渲染 与合成

图：

![img](合成之surfaceFlinger.assets/4525ee02ce6e6ebd0b5b76192a356e8d.webp)

[图来源：](https://blog.csdn.net/tkwxty/article/details/136154204#:~:text=%E4%B8%AD%2CSF%E6%89%A7%E8%A1%8C-,%E7%9A%84%E4%B8%BB%E8%A6%81%E9%80%BB%E8%BE%91%E6%98%AF%E4%BB%80%E4%B9%88%EF%BC%9F,-%E4%B8%80.%E4%BB%8Edumpsys)

TODO:

> 没懂 VSYNC   OFFSET 与  DrawCallback





## 跨空间跨设备的同步机制-----Fence

[图](https://zhuanlan.zhihu.com/p/543222402#:~:text=%E8%B7%A8%E8%AE%BE%E5%A4%87%E6%8C%87%E7%9A%84%E6%98%AF%E4%B8%A4%E4%B8%AA%E8%AE%BE%E5%A4%87%E7%9A%84%E9%A9%B1%E5%8A%A8%E4%B9%8B%E9%97%B4%E6%88%96%E8%80%85%E9%A9%B1%E5%8A%A8%E4%B8%8E%E8%BF%9B%E7%A8%8B)





## 维测



# who---选取什么引擎来render（~~RenderEngineType~~）



参考：~~[RenderEngineType简介](https://cloud.tencent.com/developer/article/2002551)~~

时机：自然， ~~sf 初始化~~

> %accordion%sf 初始化 代码%accordion%
>
> ```java
> SurfaceFlinger::init() 
> 	if (auto type = chooseRenderEngineTypeViaSysProp()) {
>   builder.setRenderEngineType(type.value());
> }
> mRenderEngine = renderengine::RenderEngine::create(builder.build());
> mCompositionEngine->setRenderEngine(mRenderEngine.get());
> ```
>
> %/accordion%

RenderEngineType 配置处：

> 1、持久化配置： ~~自然，配置文件~~ 
>
> ```java
> //文件/system/build.prop新增：
> 
> debug.renderengine.backend=threaded
> ```
>
> 2、动态配置（需要重启进程）：
>
> ```java
> adb root && adb remount
> adb shell setprop  debug.renderengine.backend  threaded
> adb shell getprop | grep renderengine
> ```
>
> [Android实用技巧之adb命令：getprop,setprop命令使用](https://gitcode.csdn.net/65ec51a41a836825ed798396.html?dp_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NDUyNjk2LCJleHAiOjE3MTgxMTIxNTAsImlhdCI6MTcxNzUwNzM1MCwidXNlcm5hbWUiOiJ3ZWl4aW5fMzgxOTkzODEifQ.Ez_sTs8Ke3zT7X6a7aHgIG0OpQxQHIv9tX_xybwUqH8)

具体类型：

> ```java
> enum class RenderEngineType {
> GLES = 1, //opengl
> THREADED = 2, //opengl异步线程
> SKIA_GL = 3, //skia
> SKIA_GL_THREADED = 4, //skia异步线程
> SKIA_VK = 5,  // vulkan
> SKIA_VK_THREADED = 6,
> };
> ```
>
> 即：
>
> |        | 同步     | 异步             |
> | :----- | :------- | ---------------- |
> | skia   | SKIA_GL  | SKIA_GL_THREADED |
> | opengl | GLES     | THREADED         |
> | vulkan | ........ | ..........       |





承载的类，继承关系：

```java
RenderEngine	------>  承载合成能力
	├─SkiaRenderEngine		
	│	└─SkiaVkRenderEngine		
	├─RenderEngineThreaded		
	└─GLESRenderEngine	
```







App侧：

> 渲染用的  SkiaOpenGLPipeline  和  SkiaVulkanPipeline  ------->  作用：RenderNode（view）转化成  绘图指令  最后送给GPU

目录：

> frameworks/base/libs<font color='red'>/hwui</font>/pipeline/skia/SkiaPipeline.cpp  
>
> **hwui是目录**









# SF合成之GPU合成

[Android下SF合成流程重学习之GPU合成](https://blog.csdn.net/tkwxty/article/details/136154204 )

[圆角绘制 - 安卓R](https://blog.csdn.net/SSSxCCC/article/details/119253569)

[Android下SF合成流程重学习之Refresh流程](https://blog.csdn.net/tkwxty/article/details/136153549)

合成  一行代码： glDrawRarry

重要结构：一个 **Framebuffer**（最终都是画到了这个上面）

>   1//创建GLFramebuffer  mDrawingBuffer = createFramebuffer();
>
>   创建并**持有： 纹理glGenTextures、帧缓冲 glGenFramebuffer**
>
>   作用： 1、与hwc的交互  2、承载sf的合成结果

参考 [OpenGL 帧缓冲](https://blog.csdn.net/wzz953200463/article/details/131350684)

重要结构之  BufferQueue（**GraphicBuffer** ）：

>   1、与APP的交互   2、承载APP的渲染

TODO: 信息流1： GraphicBuffer  ---->  Framebuffer

>   关键一行：准备合成原材料（输入的Buffer给到  RenderEngine）
>
>   ```java
>   
>   std::optional<compositionengine::LayerFE::LayerSettings> BufferLayer::prepareClientComposition(
>           compositionengine::LayerFE::ClientCompositionTargetSettings& targetSettings) {
>       ......
>       // 应用queue过来的Buffer
>       layer.source.buffer.buffer = mBufferInfo.mBuffer;
>       layer.source.buffer.isOpaque = isOpaque(s);
>   
>       // 创建BufferQueueLayer时创建的texture ID
>       layer.source.buffer.textureName = mTextureName;
>       ...
>   }
>   ```

**生活化模型：---- 画家绘画**

>   多个画家画画
>
>   最后SF贴图（Texture）到墙上（FrameBuffer）

TODO:

Framebuffer 与 GPU交互，熟悉的味道：

>   dequeueBuffer -------------  分配一个缓冲区作为GPU合成的暂存空间
>
>   queueBuffer  ------------  入队列已绘制好的图形缓存供HWC使用
>
>   [参考](https://blog.csdn.net/tkwxty/article/details/136154204#:~:text=14-,熟悉的味道：,-dequeueBuffer %3A 分配一个)

合成  ：[主要流程](https://blog.csdn.net/tkwxty/article/details/136154204#:~:text=存上面。setViewportAndProjection-,设置视图和投影矩阵。,-文件：frameworks/)

>   输入buffer  ----> 生成纹理（贴图）  --->  shader贴图（纹理）到最终的FrameBuffer上（glDrawArrays）
>

%accordion%  详细代码：**GLESRenderEngine::drawLayers**   %accordion%

```java
文件：frameworks/native/libs/renderengine/gl/GLESRenderEngine.cpp

status_t GLESRenderEngine::drawLayers(const DisplaySettings& display,
                                    const std::vector<const LayerSettings*>& layers,
                                    ANativeWindowBuffer* const buffer,
                                    const bool useFramebufferCache, base::unique_fd&& bufferFence,
                                    base::unique_fd* drawFence) {
       ...
       // 设置顶点和纹理坐标的size
       Mesh mesh = Mesh::Builder()
                      .setPrimitive(Mesh::TRIANGLE_FAN)
                      .setVertices(4 /* count */, 2 /* size */)
                      .setTexCoords(2 /* size */)
                      .setCropCoords(2 /* size */)
                      .build();
       for (auto const layer : layers) {
        //遍历outputlayer
           ...
        //获取layer的大小
      const FloatRect bounds = layer->geometry.boundaries;
      Mesh::VertexArray<vec2> position(mesh.getPositionArray<vec2>());
      // 设置顶点的坐标，逆时针方向
      position[0] = vec2(bounds.left, bounds.top);
      position[1] = vec2(bounds.left, bounds.bottom);
      position[2] = vec2(bounds.right, bounds.bottom);
      position[3] = vec2(bounds.right, bounds.top);
       //设置crop的坐标
      setupLayerCropping(*layer, mesh);
      // 设置颜色矩阵
      setColorTransform(display.colorTransform * layer->colorTransform);
      ...
      // Buffer相关设置
      if (layer->source.buffer.buffer != nullptr) {
          disableTexture = false;
          isOpaque = layer->source.buffer.isOpaque;
           // layer的buffer，理解为输入的buffer
          sp<GraphicBuffer> gBuf = layer->source.buffer.buffer;
          // textureName是创建BufferQueuelayer时生成的，用来标识这个layer，
          // fence是acquire fence
          bindExternalTextureBuffer(layer->source.buffer.textureName, gBuf,  // 【】
                                    layer->source.buffer.fence);

          ...
          // 设置纹理坐标，也是逆时针
          renderengine::Mesh::VertexArray<vec2> texCoords(mesh.getTexCoordArray<vec2>());
          texCoords[0] = vec2(0.0, 0.0);
          texCoords[1] = vec2(0.0, 1.0);
          texCoords[2] = vec2(1.0, 1.0);
          texCoords[3] = vec2(1.0, 0.0);
         // 设置纹理的参数，glTexParameteri
          setupLayerTexturing(texture);
      }

      // 【】处理圆角
      if (radius > 0.0 && color.a >= 1.0f && isOpaque) {
          handleRoundedCorners(display, layer, mesh);
      } else {
          drawMesh(mesh);
      }


status_t GLESRenderEngine::bindExternalTextureBuffer(uint32_t texName,
                                                   const sp<GraphicBuffer>& buffer,
                                                   const sp<Fence>& bufferFence) {
  ..............

  bool found = false;
  {
      // 在ImageCache里面找有没有相同的buffer
      std::lock_guard<std::mutex> lock(mRenderingMutex);
      auto cachedImage = mImageCache.find(buffer->getId());
      found = (cachedImage != mImageCache.end());
  }

  // If we couldn't find the image in the cache at this time, then either
  // SurfaceFlinger messed up registering the buffer ahead of time or we got
  // backed up creating other EGLImages.
  if (!found) {
      //【】如果ImageCache里面没有则需要重新创建一个EGLImage，创建输入的EGLImage是在ImageManager线程里面，利用notify唤醒机制
      status_t cacheResult = mImageManager->cache(buffer);
      if (cacheResult != NO_ERROR) {
          return cacheResult;
      }
  }

  ...
      //【】把EGLImage转换成纹理，类型为GL_TEXTURE_EXTERNAL_OES
      bindExternalTextureImage(texName, *cachedImage->second);
      mTextureView.insert_or_assign(texName, buffer->getId());
  }
}

void GLESRenderEngine::bindExternalTextureImage(uint32_t texName, const Image& image) {
  ATRACE_CALL();
  const GLImage& glImage = static_cast<const GLImage&>(image);
  const GLenum target = GL_TEXTURE_EXTERNAL_OES;
   //绑定纹理，纹理ID为texName
  glBindTexture(target, texName);
  if (glImage.getEGLImage() != EGL_NO_IMAGE_KHR) {
      // 把EGLImage转换成纹理，纹理ID为texName
      glEGLImageTargetTexture2DOES(target, static_cast<GLeglImageOES>(glImage.getEGLImage()));
  }
}文件：frameworks/native/libs/renderengine/gl/GLESRenderEngine.cpp

status_t GLESRenderEngine::drawLayers(const DisplaySettings& display,
                                    const std::vector<const LayerSettings*>& layers,
                                    ANativeWindowBuffer* const buffer,
                                    const bool useFramebufferCache, base::unique_fd&& bufferFence,
                                    base::unique_fd* drawFence) {
       ...
       // 设置顶点和纹理坐标的size
       Mesh mesh = Mesh::Builder()
                      .setPrimitive(Mesh::TRIANGLE_FAN)
                      .setVertices(4 /* count */, 2 /* size */)
                      .setTexCoords(2 /* size */)
                      .setCropCoords(2 /* size */)
                      .build();
       for (auto const layer : layers) {
        //遍历outputlayer
           ...
        //获取layer的大小
      const FloatRect bounds = layer->geometry.boundaries;
      Mesh::VertexArray<vec2> position(mesh.getPositionArray<vec2>());
      // 设置顶点的坐标，逆时针方向
      position[0] = vec2(bounds.left, bounds.top);
      position[1] = vec2(bounds.left, bounds.bottom);
      position[2] = vec2(bounds.right, bounds.bottom);
      position[3] = vec2(bounds.right, bounds.top);
       //设置crop的坐标
      setupLayerCropping(*layer, mesh);
      // 设置颜色矩阵
      setColorTransform(display.colorTransform * layer->colorTransform);
      ...
      // Buffer相关设置
      if (layer->source.buffer.buffer != nullptr) {
          disableTexture = false;
          isOpaque = layer->source.buffer.isOpaque;
           // layer的buffer，理解为输入的buffer
          sp<GraphicBuffer> gBuf = layer->source.buffer.buffer;
          // textureName是创建BufferQueuelayer时生成的，用来标识这个layer，
          // fence是acquire fence
          bindExternalTextureBuffer(layer->source.buffer.textureName, gBuf,  // 【】
                                    layer->source.buffer.fence);

          ...
          // 设置纹理坐标，也是逆时针
          renderengine::Mesh::VertexArray<vec2> texCoords(mesh.getTexCoordArray<vec2>());
          texCoords[0] = vec2(0.0, 0.0);
          texCoords[1] = vec2(0.0, 1.0);
          texCoords[2] = vec2(1.0, 1.0);
          texCoords[3] = vec2(1.0, 0.0);
         // 设置纹理的参数，glTexParameteri
          setupLayerTexturing(texture);
      }

      // 【】处理圆角
      if (radius > 0.0 && color.a >= 1.0f && isOpaque) {
          handleRoundedCorners(display, layer, mesh);
      } else {
          drawMesh(mesh);
      }


status_t GLESRenderEngine::bindExternalTextureBuffer(uint32_t texName,
                                                   const sp<GraphicBuffer>& buffer,
                                                   const sp<Fence>& bufferFence) {
  ..............

  bool found = false;
  {
      // 在ImageCache里面找有没有相同的buffer
      std::lock_guard<std::mutex> lock(mRenderingMutex);
      auto cachedImage = mImageCache.find(buffer->getId());
      found = (cachedImage != mImageCache.end());
  }

  // If we couldn't find the image in the cache at this time, then either
  // SurfaceFlinger messed up registering the buffer ahead of time or we got
  // backed up creating other EGLImages.
  if (!found) {
      //【】如果ImageCache里面没有则需要重新创建一个EGLImage，创建输入的EGLImage是在ImageManager线程里面，利用notify唤醒机制
      status_t cacheResult = mImageManager->cache(buffer);
      if (cacheResult != NO_ERROR) {
          return cacheResult;
      }
  }

  ...
      //【】把EGLImage转换成纹理，类型为GL_TEXTURE_EXTERNAL_OES
      bindExternalTextureImage(texName, *cachedImage->second);
      mTextureView.insert_or_assign(texName, buffer->getId());
  }
}

void GLESRenderEngine::bindExternalTextureImage(uint32_t texName, const Image& image) {
  ATRACE_CALL();
  const GLImage& glImage = static_cast<const GLImage&>(image);
  const GLenum target = GL_TEXTURE_EXTERNAL_OES;
   //绑定纹理，纹理ID为texName
  glBindTexture(target, texName);
  if (glImage.getEGLImage() != EGL_NO_IMAGE_KHR) {
      // 把EGLImage转换成纹理，纹理ID为texName
      glEGLImageTargetTexture2DOES(target, static_cast<GLeglImageOES>(glImage.getEGLImage()));
  }
}
```

%/accordion%





生活化模型---------见weixin

TODO:

drawMesh  画网格，来理解opengl：

>   1、drawMesh  结构：
>
>   ```java
>   drawMesh2
>    -> 封装一堆gl操作，useProgram
>    ```
>   
>2、drawMesh可以多次连续调用，即：
>   
>>   （1）画网格可以多次在一个地方画
>   >
>   >   （2）很多gl操作（比如glUseProgram），可以连续调用



# 补充sf  贴图过程

**必然有**，**贴图过程**（~~把client的图，贴到frameBuffer上~~）：

```java
status_t GLESRenderEngine::drawLayers(
     if (layer->source.buffer.buffer != nullptr) {
			.................
            sp<GraphicBuffer> gBuf = layer->source.buffer.buffer->getBuffer(); // 获取client的buffer
            .................
            bindExternalTextureBuffer(layer->source.buffer.textureName, gBuf,
                                      layer->source.buffer.fence);
         	Texture texture(Texture::TEXTURE_EXTERNAL, layer->source.buffer.textureName); // 【】 贴图
```







weston的贴图：

> gl_shader_config_set_input_textures  // 配置输入纹理的着色器
>
> [参考：Weston中shm window渲染](https://blog.csdn.net/qqzhaojianbiao/article/details/129789575)





# 参考

[Android 显示系统：SurfaceFlinger详解]( https://www.cnblogs.com/blogs-of-lxl/p/11272756.html )    ------------->  好文！！！！图很好

TODO：图很好，模仿他的图，为什么能画这么清晰，能承载的东西也多

[显示图形系统分析之SurfaceFlinger启动流程](https://juejin.cn/post/7055967248707485704)







https://blog.csdn.net/tkwxty/article/details/136154204   Android下SF合成流程重学习之GPU合成   ------->  好文章！！！！！

Android graphic系列文章： https://blog.csdn.net/tkwxty/category_11464526.html



补充 surfaceFlinger 图：

>   https://blog.csdn.net/gzzaigcnforever/article/details/22175829#:~:text=解释SurfaceFlinger从应用层到底层的整个绘图，显示的大致流程。



[显示框架之深入Vsync原理 - 简书 (jianshu.com)](https://www.jianshu.com/p/f5e2f88c475c)  



# 疑问：

如何选择 两种合成方式？





#  TODO: HM的图形

https://www.bilibili.com/video/BV1py411q7BV?t=5924.9

## 方舟图形引擎

![image-20240626003622816](合成之surfaceFlinger.assets/image-20240626003622816.png)



![image-20240626003752374](合成之surfaceFlinger.assets/image-20240626003752374.png)



![image-20240626003928366](合成之surfaceFlinger.assets/image-20240626003928366.png)

[图片来源](https://www.bilibili.com/video/BV1py411q7BV?t=471.6)











![image-20240626004003396](合成之surfaceFlinger.assets/image-20240626004003396.png)



![image-20240626004110802](合成之surfaceFlinger.assets/image-20240626004110802.png)



![image-20240626004216215](合成之surfaceFlinger.assets/image-20240626004216215.png)



![image-20240626004538526](合成之surfaceFlinger.assets/image-20240626004538526.png)



shader:

![image-20240626004451773](合成之surfaceFlinger.assets/image-20240626004451773.png)

--------> 对高频shader检测

**GPU的效率   *≈*     shader的编译与执行 的效率**





![image-20240630161205144](合成之surfaceFlinger.assets/image-20240630161205144.png)

用户不感知的，不刷新



![image-20240630161304039](合成之surfaceFlinger.assets/image-20240630161304039.png)





![image-20240630161335658](合成之surfaceFlinger.assets/image-20240630161335658.png)

DSS是啥？



![image-20240630161447005](合成之surfaceFlinger.assets/image-20240630161447005.png)



![image-20240630161530932](合成之surfaceFlinger.assets/image-20240630161530932.png)

------------------>  不懂

![image-20240630161559824](合成之surfaceFlinger.assets/image-20240630161559824.png)



![image-20240630161628916](合成之surfaceFlinger.assets/image-20240630161628916.png)

## 马良GPU

![image-20240630161834963](合成之surfaceFlinger.assets/image-20240630161834963.png)



![image-20240630161934252](合成之surfaceFlinger.assets/image-20240630161934252.png)



![image-20240630161956740](合成之surfaceFlinger.assets/image-20240630161956740.png)



![image-20240630162052324](合成之surfaceFlinger.assets/image-20240630162052324.png)



![image-20240630162116058](合成之surfaceFlinger.assets/image-20240630162116058.png)

![image-20240630162227281](合成之surfaceFlinger.assets/image-20240630162227281.png)



## 高德

![image-20240630162348470](合成之surfaceFlinger.assets/image-20240630162348470.png)

![image-20240630162400157](合成之surfaceFlinger.assets/image-20240630162400157.png)

![image-20240630162449991](合成之surfaceFlinger.assets/image-20240630162449991.png)

![image-20240630162535848](合成之surfaceFlinger.assets/image-20240630162535848.png)

![image-20240630162607047](合成之surfaceFlinger.assets/image-20240630162607047.png)

![image-20240630162731635](合成之surfaceFlinger.assets/image-20240630162731635.png)

![image-20240630162632647](合成之surfaceFlinger.assets/image-20240630162632647.png)



![image-20240630162800860](合成之surfaceFlinger.assets/image-20240630162800860.png)

![image-20240630162940936](合成之surfaceFlinger.assets/image-20240630162940936.png)

![image-20240630162921282](合成之surfaceFlinger.assets/image-20240630162921282.png)



![image-20240630163021107](合成之surfaceFlinger.assets/image-20240630163021107.png)



![image-20240630163047998](合成之surfaceFlinger.assets/image-20240630163047998.png)



![image-20240630163133651](合成之surfaceFlinger.assets/image-20240630163133651.png)



![image-20240630165544164](合成之surfaceFlinger.assets/image-20240630165544164.png)

shader本身优化：

![image-20240630165608502](合成之surfaceFlinger.assets/image-20240630165608502.png)

![image-20240630165654346](合成之surfaceFlinger.assets/image-20240630165654346.png)

https://www.bilibili.com/video/BV1py411q7BV?t=7447.7



![image-20240630165714867](合成之surfaceFlinger.assets/image-20240630165714867.png)

## 晶核性能优化

![image-20240630165843703](合成之surfaceFlinger.assets/image-20240630165843703.png)



![image-20240630170001295](合成之surfaceFlinger.assets/image-20240630170001295.png)



![image-20240630170134423](合成之surfaceFlinger.assets/image-20240630170134423.png)



![image-20240630170222996](合成之surfaceFlinger.assets/image-20240630170222996.png)

原理：**<font color='red'>快速移动时</font>**，---------->  降低分辨率（<font color='red'>空间</font>），人眼分辨不出来

注意：静态的东西（不怎变化时），降低刷新率（<font color='red'>时间</font>）

![image-20240630170304996](合成之surfaceFlinger.assets/image-20240630170304996.png)





![image-20240630170543080](合成之surfaceFlinger.assets/image-20240630170543080.png)

静态的东西（不怎变化时），降低刷新率（<font color='red'>时间</font>）

变化剧烈的，提高刷新率（<font color='red'>时间</font>），降低分辨率（<font color='red'>空间</font>）



## 方舟多媒体引擎

![image-20240630170819583](合成之surfaceFlinger.assets/image-20240630170819583.png)

原因：网络的波动

![image-20240630170852158](合成之surfaceFlinger.assets/image-20240630170852158.png)



TODO:  https://www.bilibili.com/video/BV1py411q7BV?t=8148.3



