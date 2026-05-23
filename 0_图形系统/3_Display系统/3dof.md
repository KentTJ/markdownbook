# 目录

# 参考资料

https://developers.meta.com/horizon/documentation/native/android/os-compositor/

减少感知延迟（重投影/时间扭曲）

**普通的手机 UI 或者早期的智能眼镜（0DOF），图层是直接绑定在“屏幕坐标系（Screen Space）”上的**

**而实现 3DOF 悬停，本质上是在系统的图层合成阶段，将 UI 锚定在一个虚拟的“世界坐标系（World Space）”中。然后高频读取 IMU 的姿态矩阵，用其逆矩阵**去实时计算该图层在当前屏幕上的投影位置