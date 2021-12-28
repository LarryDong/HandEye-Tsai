# HandEye-Tsai
Handeye calibration using Tsai method. Matlab codes

## Usage
`tsai.m` function return the solution of AX=XB.

`Demo.m` is a test for tsai funcion.  
Load some data from `target2cam.csv` and generate gripper2base data based on a given T_gripper_camera.  
Then compare the Tasi result with the given T_gripper_camera.


## Reference
[Tsai Method Paper] R. Y. Tsai and R. K. Lenz, “A new technique for fully autonomous and efficient 3D robotics hand/eye calibration,” in IEEE Transactions on Robotics and Automation, vol. 5, no. 3, pp. 345-358, June 1989, doi: 10.1109/70.34770.
[A Blog in Chinese] [https://blog.csdn.net/tfb760/article/details/122190290](https://blog.csdn.net/tfb760/article/details/122190290)
