
# hand-eye calibration


## File 

Main files:  
`calibHandEye.m`: hand eye calibration main function. Use `cam2target.csv` and `gripper2base.csv` andd using Tsai method to calculate the camera2gripper  
`tsai.m`: Tsai method.  
`cameraParams.mat`: camera instrinsics (calibrated ahead)  
`Rodrigues.m`/`invRodrigues.m`: rotation axis to rotation matrix / matrix2axis.  

Other files:  
`generate_cam2target.m`: generate (from images) camera to target transformation. Save data into `cam2target.csv` as axis-angle format (rvec, tvec).  
`generate_gripper2base.m`: generate (from VICON) gripper to base transformation. Save data into `gripper2base.csv` as axis-angle format (rvec, tvec).  
`calcCameraPose.m`: function to calculate camera pose in target frame.  
--image: all images from a USB camera  
--vicon_data: gripper from a VICON system  
--scripts: some codes for simulation (not used. Only for my own backup)  


## Usage

### 1. Just test hand-eye calibration by Tsai:

run `calibHandEye.m` directly, which use two csv file to calculate show Tsai's result.

### 2. Use original images (or your own data)

run `generate_cam2target.m` to generate `cam2target.csv`. You need to modify the chessboard size if different images are used.  
Then you need to `generate_gripper2base`.

Sometimes you need to delete invalid data by hand in both .csv files.


### 3. Use simulated data
See "scripts" file, you will find `generate_simulateData.m`, which generate idea/noisy gripper2base.csv based on real cam2target.csv. The generated data are based on your own setting camera2gripper transformation.  
Then use the simulated data to run `calibHandEye` to see the result.

Attention that you need to use a **read** cam2target pose (the provided one is not bad, I believe), since improper data may lead to large error. (See Tsai's paper for more details).
