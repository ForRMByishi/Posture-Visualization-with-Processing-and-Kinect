/* 
 
 - Qian Yang (qyang1@cs.cmu.edu)
 - Class Project for Carnegie Mellon University 15-821 Mobile and Pervasive Computing
 
 - This sketch is built on Antoine Puel's script skeleton_basis (http:/antoine.cool)  
 - Credits for the font : Alte DIN 1451 by Peter Wiegel 
 
 */

import SimpleOpenNI.*;

SkeletonKinect  kinect;

PrintWriter joint_output;
PVector head;


boolean visibleUser;
float textPosition;

// * Array of color (put as many color as you want)
color[] userColor = new color[] { 
  color(255, 0, 0), 
  color(109, 57, 255), 
  color(0, 255, 0), 
  color(0, 0, 255)
}; 

// * Start at the 0 value 
int randomColor = 0;
PFont f;

// * Enable FullScreen 
boolean sketchFullScreen() {
  return false;
}

void setup() {
  // Create a new file in the sketch directory
  // join dict reference: http://www.leondangio.net/masters-thesis/masters-thesis-data-acquisition/masters-thesis-data-acquisition-working-with-kinect-skeleton-data/
  joint_output = createWriter("to_sql.txt"); 
  joint_output.println("head, neck, torso, left_shoulder, right_shoulder,left_elbow, right_elbow, left_hand, right_hand, left_hip, right_hip, left_knee, right_knee, left_feet, right_feet");

  // Set up display
  f = loadFont("AlteDIN1451.vlw");
  textFont(f);

  size(displayWidth, displayHeight, P3D);

  kinect = new SkeletonKinect(this);
  // * kinect.setMirror MUST BE BEFORE enableDepth and enableUser functions!!!
  kinect.setMirror(true);
  kinect.enableDepth();
  // * Turn on user tracking
  kinect.enableUser();

  // * Choose the x position you want to display the debbuging informations
  textPosition = width/1.5;

  smooth();
}

void draw() { 

  kinect.update();
  background(0);

  // * Put detected users in an IntVector
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  // * Search for an user and give him a UserId
  for (int i=0; i < userList.size (); i++) {
    int userId = userList.get(i);

    // * For every user, draw the skeleton
    if ( kinect.isTrackingSkeleton(userId)) {
      stroke(userColor[ randomColor ] );
      kinect.drawSkeleton(userId);
      // * Set to false to turn off success tracking message      
      displaySuccess(true);
    } else {      
      // * Set to false to turn off error tracking message
      displayError(true);         
      // * Each time the tracking is lost, change the random color value for the next tracking   
      randomColor = (int)random(0, userColor.length);
    }

    // * Export join coordinates to joint_output.txt
    // Scehma: head, neck, torso, left_shoulder, right_shoulder, left_elbow, right_elbow,
    // left_hand, right_hand, left_hip, right_hip, left_knee, right_knee, left_feet, right_feet.
    joint_output.println(getJoint(1, SimpleOpenNI.SKEL_HEAD) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_NECK) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_TORSO) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_SHOULDER) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_ELBOW) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_ELBOW) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_HAND) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_HAND) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_HIP) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_HIP) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_KNEE) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_KNEE) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_LEFT_FOOT) + ","
                         + getJoint(1, SimpleOpenNI.SKEL_RIGHT_FOOT)
                         );
    //joint_output.println(getJoint(1, SimpleOpenNI.SKEL_RIGHT_COLLAR));
    joint_output.flush();
  }

  // * Set to false to turn off the debugging informations
  displayInfo(true);
}


void keyPressed() {
  if (keyCode == ENTER) {
    joint_output.close(); // Finishes the file
    exit(); // Stops the program
  }
}


