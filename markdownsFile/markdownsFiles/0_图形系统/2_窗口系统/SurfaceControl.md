# 目录







# 代码里截图 & 存储

```java
 Rect crop = new Rect(0, 0, size.x, size.y);
 SurfaceControl.ScreenshotHardwareBuffer buffer =
         SurfaceControl.captureLayers(surfaceControl, crop, 1); // 【】 SurfaceControl.captureLayers
 if (buffer == null) {
     return 0;
 }
 
 mySecondBitmap = buffer.asBitmap();
 


 //cg add.
 new Thread(new Runnable() { //3、在子线程里发消息
     @Override
     public void run() {
         try {
             if (mySecondBitmap != null) {
                 Log.d("", "myFisrtBitmap save to png");
                 File f = new File("/data/local/tmp" ,"mySecondImage.png");// /data/local/tmp
                 f.createNewFile();
 
                 FileOutputStream out = new FileOutputStream(f);
                 mySecondBitmap.compress(Bitmap.CompressFormat.PNG, 50, out);
                 out.flush();
                 out.close();
             }
         } catch (Exception e) {
             e.printStackTrace();
         }
     }
 }).start();
```



TODO: 截图的底层实现： 大致是弄了一个虚拟屏，在虚拟屏上合成（因为存在部分密码等场景，有些surface不能合成进去）