# 目录

# surfaceflinger的启动 之 .rc文件

参考：

> https://www.jianshu.com/p/dcc37f81c119

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

# ==进入surfaceflinger  main 之后==

参考：

> https://blog.csdn.net/qq_40587575/article/details/129657882     【安卓源码】SurfaceFlinger 启动及其与应用通信
>
> ----------> 源码注释

源码：

TODO:

设计美好： 统一的配置，剥离成文件



# SF合成之GPU合成

https://blog.csdn.net/tkwxty/article/details/136154204         Android下SF合成流程重学习之GPU合成

https://blog.csdn.net/SSSxCCC/article/details/119253569      圆角绘制 - 安卓R

https://blog.csdn.net/tkwxty/article/details/136154204#:~:text=本篇文章，-,我们先聚焦如下量点做介绍,-：     图

https://blog.csdn.net/tkwxty/article/details/136153549     Android下SF合成流程重学习之Refresh流程

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
>   详细：
>
>   ```java
>   文件：frameworks/native/libs/renderengine/gl/GLESRenderEngine.cpp
>   
>   status_t GLESRenderEngine::drawLayers(const DisplaySettings& display,
>                                         const std::vector<const LayerSettings*>& layers,
>                                         ANativeWindowBuffer* const buffer,
>                                         const bool useFramebufferCache, base::unique_fd&& bufferFence,
>                                         base::unique_fd* drawFence) {
>            ...
>            // 设置顶点和纹理坐标的size
>            Mesh mesh = Mesh::Builder()
>                           .setPrimitive(Mesh::TRIANGLE_FAN)
>                           .setVertices(4 /* count */, 2 /* size */)
>                           .setTexCoords(2 /* size */)
>                           .setCropCoords(2 /* size */)
>                           .build();
>            for (auto const layer : layers) {
>             //遍历outputlayer
>                ...
>             //获取layer的大小
>           const FloatRect bounds = layer->geometry.boundaries;
>           Mesh::VertexArray<vec2> position(mesh.getPositionArray<vec2>());
>           // 设置顶点的坐标，逆时针方向
>           position[0] = vec2(bounds.left, bounds.top);
>           position[1] = vec2(bounds.left, bounds.bottom);
>           position[2] = vec2(bounds.right, bounds.bottom);
>           position[3] = vec2(bounds.right, bounds.top);
>            //设置crop的坐标
>           setupLayerCropping(*layer, mesh);
>           // 设置颜色矩阵
>           setColorTransform(display.colorTransform * layer->colorTransform);
>           ...
>           // Buffer相关设置
>           if (layer->source.buffer.buffer != nullptr) {
>               disableTexture = false;
>               isOpaque = layer->source.buffer.isOpaque;
>                // layer的buffer，理解为输入的buffer
>               sp<GraphicBuffer> gBuf = layer->source.buffer.buffer;
>               // textureName是创建BufferQueuelayer时生成的，用来标识这个layer，
>               // fence是acquire fence
>               bindExternalTextureBuffer(layer->source.buffer.textureName, gBuf,  // 【】
>                                         layer->source.buffer.fence);
>   
>               ...
>               // 设置纹理坐标，也是逆时针
>               renderengine::Mesh::VertexArray<vec2> texCoords(mesh.getTexCoordArray<vec2>());
>               texCoords[0] = vec2(0.0, 0.0);
>               texCoords[1] = vec2(0.0, 1.0);
>               texCoords[2] = vec2(1.0, 1.0);
>               texCoords[3] = vec2(1.0, 0.0);
>              // 设置纹理的参数，glTexParameteri
>               setupLayerTexturing(texture);
>           }
>   
>           // 【】处理圆角
>           if (radius > 0.0 && color.a >= 1.0f && isOpaque) {
>               handleRoundedCorners(display, layer, mesh);
>           } else {
>               drawMesh(mesh);
>           }
>   
>   
>   status_t GLESRenderEngine::bindExternalTextureBuffer(uint32_t texName,
>                                                        const sp<GraphicBuffer>& buffer,
>                                                        const sp<Fence>& bufferFence) {
>       ..............
>   
>       bool found = false;
>       {
>           // 在ImageCache里面找有没有相同的buffer
>           std::lock_guard<std::mutex> lock(mRenderingMutex);
>           auto cachedImage = mImageCache.find(buffer->getId());
>           found = (cachedImage != mImageCache.end());
>       }
>   
>       // If we couldn't find the image in the cache at this time, then either
>       // SurfaceFlinger messed up registering the buffer ahead of time or we got
>       // backed up creating other EGLImages.
>       if (!found) {
>           //【】如果ImageCache里面没有则需要重新创建一个EGLImage，创建输入的EGLImage是在ImageManager线程里面，利用notify唤醒机制
>           status_t cacheResult = mImageManager->cache(buffer);
>           if (cacheResult != NO_ERROR) {
>               return cacheResult;
>           }
>       }
>   
>       ...
>           //【】把EGLImage转换成纹理，类型为GL_TEXTURE_EXTERNAL_OES
>           bindExternalTextureImage(texName, *cachedImage->second);
>           mTextureView.insert_or_assign(texName, buffer->getId());
>       }
>   }
>   
>   void GLESRenderEngine::bindExternalTextureImage(uint32_t texName, const Image& image) {
>       ATRACE_CALL();
>       const GLImage& glImage = static_cast<const GLImage&>(image);
>       const GLenum target = GL_TEXTURE_EXTERNAL_OES;
>        //绑定纹理，纹理ID为texName
>       glBindTexture(target, texName);
>       if (glImage.getEGLImage() != EGL_NO_IMAGE_KHR) {
>           // 把EGLImage转换成纹理，纹理ID为texName
>           glEGLImageTargetTexture2DOES(target, static_cast<GLeglImageOES>(glImage.getEGLImage()));
>       }
>   }
>   ```

生活化模型---------见weixin

TODO:

drawMesh  画网格，来理解opengl：

>   1、drawMesh  结构：
>
>   ```
>   1
>   drawMesh2
>     -> 封装一堆gl操作，useProgram
>   ```
>
>   2、drawMesh可以多次连续调用，即：
>
>   >   （1）画网格可以多次在一个地方画
>   >
>   >   （2）很多gl操作（比如glUseProgram），可以连续调用





# 参考

 https://www.cnblogs.com/blogs-of-lxl/p/11272756.html    Android 显示系统：SurfaceFlinger详解    ------------->  好文！！！！图很好

TODO：图很好，模仿他的图，为什么能画这么清晰，能承载的东西也多



https://juejin.cn/post/7055967248707485704    显示图形系统分析之SurfaceFlinger启动流程







https://blog.csdn.net/tkwxty/article/details/136154204   Android下SF合成流程重学习之GPU合成   ------->  好文章！！！！！

Android graphic系列文章： https://blog.csdn.net/tkwxty/category_11464526.html



补充 surfaceFlinger 图：

>   https://blog.csdn.net/gzzaigcnforever/article/details/22175829#:~:text=解释SurfaceFlinger从应用层到底层的整个绘图，显示的大致流程。