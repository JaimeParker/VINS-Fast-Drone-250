This repo is totally from [Fast-Drone-250](https://github.com/ZJU-FAST-Lab/Fast-Drone-250), all copyrights belong to them and their license.

This is for my own use and git clone on public machine, so without private setting.

[VINS README](VINS-README.md)



The instruction part is also revised from [Fast-Drone-250](https://github.com/ZJU-FAST-Lab/Fast-Drone-250), I do not hold any copyrights.

* 检查飞控mavros连接正常
  * `ls /dev/tty*`，确认飞控的串口连接正常。一般是`/dev/ttyACM0`
  * `sudo chmod 777 /dev/ttyACM0`，为串口附加权限
  * `roslaunch mavros px4.launch`
  * `rostopic hz /mavros/imu/data_raw`，确认飞控传输的imu频率在200hz左右
* 检查realsense驱动正常
  * `roslaunch realsense2_camera rs_camera.launch`
  * 进入远程桌面，`rqt_image_view`
  * 查看`/camera/infra1/image_rect_raw`,`/camera/infra2/image_rect_raw`,`/camera/depth/image_rect_raw`话题正常
* VINS参数设置
  * 进入`realflight_modules/VINS_Fusion/config/`

  * 驱动realsense后，`rostopic echo /camera/infra1/camera_info`，把其中的K矩阵中的fx,fy,cx,cy填入`left.yaml`和`right.yaml`

  * 在home目录创建`vins_output`文件夹(如果你的用户名不是fast-drone，需要修改config内的vins_out_path为你实际创建的文件夹的绝对路径)

  * 修改`fast-drone-250.yaml`的`body_T_cam0`和`body_T_cam1`的`data`矩阵的第四列为你的无人机上的相机相对于飞控的实际外参，单位为米，顺序为x/y/z，第四项是1，不用改

* VINS外参精确自标定
  * `sh shfiles/rspx4.sh`
  * `rostopic echo /vins_fusion/imu_propagate`
  * 拿起飞机沿着场地<font color="#dd0000">尽量缓慢</font>地行走，场地内光照变化不要太大，灯光不要太暗，<font color="#dd0000">不要使用会频闪的光源</font>，尽量多放些杂物来增加VINS用于匹配的特征点
  * 把`vins_output/extrinsic_parameter.txt`里的内容替换到`fast-drone-250.yaml`的`body_T_cam0`和`body_T_cam1`
  * 重复上述操作直到走几圈后VINS的里程计数据偏差收敛到满意值（一般在0.3米内）
* 建图模块验证
  * `sh shfiles/rspx4.sh`
  * `roslaunch ego_planner single_run_in_exp.launch`
  * 进入远程桌面 `roslaunch ego_planner rviz.launch`
