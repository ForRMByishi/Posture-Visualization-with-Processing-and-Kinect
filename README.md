# Posture Visualization with Processing and Kinect

This is a repository of visualization of user posture and skeleton with Processing and Kinect, including a set of Processing skectches and a compainion website.

This is part of a class project for 15-821 Mobile and Pervasive computing at Carnegie Mellon University, in which we aim to provide real-time body posture information, detect bad spinal positions such as slouching, and couch senoirs to prevent osteoporosis as well as other chronic diseases. We collect spinal status data with Kinect and a BNO055 Adafruit 9-DOF absolute orientation sensor.

## Setup 
- Kinect
- Processing 2.2.1 along with following libraries:
  - [SimpleOpenNI](http://openni.ru/files/simpleopenni/index.html) for kinect communication
  - [v3ga](http://www.v3ga.net/processing/BlobDetection/) for blob detection
  - [HE-Mesh](http://www.wblut.com/processing/) for graphic stuff
  - [OpenGL](https://www.opengl.org) for 3D stuff
  - [jbox2d](http://www.jbox2d.org/) for physics-related stuff
  - [Toxiclibs](http://toxiclibs.org/)
- [D3.js](d3js.org) for website visualization

## Credits
- **Creator**: Qian Yang ([:house:](http://yang-qian.github.io));
- **Advisors**: Asim Smailagic, Dan Siewiorek; :clap::clap:
- **Collaborators**: Kyuin Lee ([:mailbox_with_no_mail:](mailto:kyuinl@andrew.cmu.edu)), Raghu Mulukutla([:mailbox_with_no_mail:](mailto:raghu94@cmu.edu));

### References
- skeleton_basis by Antoine Puel (http:/antoine.cool)
- [Kinect Physics Example](https://github.com/msp/CANKinectPhysics) by Amnon Owed, edited by Arindam Sen
- Wblut library example [Creating a point cloud with ArrayList](http://www.wblut.com/tutorials/processing/creating-a-point-cloud-with-arraylist/)
