/* *-*-*-*-*-* SkeletonKinect *-*-*-*-*-* */
// A SimpleOpenNI Class Extension
// Gather all my custom drawing functions in a class extension of SimpleOpenNI
// Why ? --> cleaner and more intuitive for using in future new sketches

private class SkeletonKinect extends SimpleOpenNI {
  PApplet parent;
  SkeletonKinect(PApplet parent) {
    super(parent);
    this.parent = parent;
    if (!this.isInit()) {
      println("no kinect found");
      exit();
    }
  }

  //------------------------------
  /*
	Basic Methods
   */

  /* ----------------------------*-*-*- drawLimbs function -*-*-*---------------------------- 
   
   * Create a line between two joints
   
   * /!\ BE CAREFUL !
   * This is NOT the 'kinect.drawLimb' BUILT-IN function from SimpleOpenNI
   * I re-create the 'kinect.drawLimb' function for fullscreen purpose
   * That's why it is called : 'drawLimbs' (with an 's') 
   
   */

  // * 3 arguments --> userId, 1st limb and 2nd limb
  void drawLimbs(int userId, int limbID1, int limbID2) {

    PVector joint1 = new PVector();
    PVector joint2 = new PVector();
    float limb1 = kinect.getJointPositionSkeleton(userId, limbID1, joint1);
    float limb2 = kinect.getJointPositionSkeleton(userId, limbID2, joint2);

    PVector convertedJoint1 = new PVector();
    PVector convertedJoint2 = new PVector();
    kinect.convertRealWorldToProjective(joint1, convertedJoint1);
    kinect.convertRealWorldToProjective(joint2, convertedJoint2);

    // * Translation of kinect proportion to fullscreen proportions
    float limb1X = map(convertedJoint1.x, 0, 640, 0, width/reScale);
    float limb1Y = map(convertedJoint1.y, 0, 480, 0, height/reScale);
    float limb2X = map(convertedJoint2.x, 0, 640, 0, width/reScale);
    float limb2Y = map(convertedJoint2.y, 0, 480, 0, height/reScale);


    /* draw the line from a joint to another*/
    stroke(getRandomColor());
    strokeWeight(1);
    line(limb1X, limb1Y, limb2X, limb2Y);
  }


  void draw_spine_between_joint_IDs(int userId, int jointID1, int jointID2, int seg_num) {

    PVector joint1 = new PVector();
    float confidence1 = kinect.getJointPositionSkeleton(userId, jointID1, joint1);
    if (confidence1 < 0.5) {
      return;
    }

    PVector joint2 = new PVector();
    float confidence2 = kinect.getJointPositionSkeleton(userId, jointID2, joint2);
    if (confidence2 < 0.5) {
      return;
    }

    PVector convertedJoint1 = new PVector();
    PVector convertedJoint2 = new PVector();
    kinect.convertRealWorldToProjective(joint1, convertedJoint1);
    kinect.convertRealWorldToProjective(joint2, convertedJoint2);

    // * Translation of kinect proportion to fullscreen proportions
    float limb1X = map(convertedJoint1.x, 0, 640, 0, width/reScale);
    float limb1Y = map(convertedJoint1.y, 0, 480, 0, height/reScale);
    float limb1Z = abs(map(convertedJoint1.z, 800, 4000, -1, 0));
    float limb2X = map(convertedJoint2.x, 0, 640, 0, width/reScale);
    float limb2Y = map(convertedJoint2.y, 0, 480, 0, height/reScale);
    float limb2Z = abs(map(convertedJoint2.z, 800, 4000, -1, 0)); //depth value roughly in the range of 0-2


    PVector spineVector = new PVector((limb2X-limb1X)/seg_num, (limb2Y-limb1Y)/seg_num, (limb2Z - limb1Z)/seg_num);
    for (int n=0; n < seg_num; n++) {
      shape(spine, limb1X + (spineVector.x * n), limb1Y + (spineVector.y * n), 20*limb1Z, 10*limb1Z);
    }
  }

  void draw_spine_between_joints(int userId, PVector convertedJoint1, PVector convertedJoint2, int seg_num) {

    

    // * Translation of kinect proportion to fullscreen proportions
    float limb1X = map(convertedJoint1.x, 0, 640, 0, width/reScale);
    float limb1Y = map(convertedJoint1.y, 0, 480, 0, height/reScale);
    float limb1Z = abs(map(convertedJoint1.z, 800, 4000, -1, 0));
    float limb2X = map(convertedJoint2.x, 0, 640, 0, width/reScale);
    float limb2Y = map(convertedJoint2.y, 0, 480, 0, height/reScale);
    float limb2Z = abs(map(convertedJoint2.z, 800, 4000, -1, 0)); //depth value roughly in the range of 0-2

    PVector spineVector = new PVector((limb2X-limb1X)/seg_num, (limb2Y-limb1Y)/seg_num, (limb2Z - limb1Z)/seg_num);
    for (int n=0; n < seg_num; n++) {
      shape(spine, limb1X + (spineVector.x * n), limb1Y + (spineVector.y * n), limb1Z*20 + (spineVector.z * n), limb1Z*10 + (spineVector.z * n));
    }
  }
  
  /* ----------------------------*-*-*- drawJoint function -*-*-*---------------------------- 
   
   * Get each joint position, create an ellipse at this position */

  void drawJoint(int userId, int jointID) {

    PVector joint = new PVector();
    float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);
    if (confidence < 0.5) {
      return;
    }

    PVector convertedJoint = new PVector();
    kinect.convertRealWorldToProjective(joint, convertedJoint);

    // * Translation of kinect proportion to fullscreen proportions
    float jointX = map(convertedJoint.x, 0, 640, 0, width/reScale);
    float jointY = map(convertedJoint.y, 0, 480, 0, height/reScale);

    // * Draw the joints
    noStroke();
    fill(getRandomColor());
    ellipse(jointX, jointY, random(7, 15), random(7, 15));
  }


  /* ----------------------------*-*-*- drawHeadfunction -*-*-*---------------------------- 
   
   * Display the head with an ellipse (you can change it by whatever you want) 
   
   */

  void drawHead(int userId) {

    // * Track the head
    PVector head = new PVector();
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, head);
    PVector convertedHead = new PVector();
    kinect.convertRealWorldToProjective(head, convertedHead);

    // * Translation of kinect proportion to fullscreen proportions
    float headx = map(convertedHead.x, 0, 640, 0, width/reScale);
    float heady = map(convertedHead.y, 0, 480, 0, height/reScale);

    // * Graphic stuff 
    strokeWeight(5);
    noFill();
    ellipseMode(CENTER);
    ellipse(headx, heady, 70, 70);
  }



  /* ----------------------------*-*-*- drawSkeleton function -*-*-*---------------------------- 
   
   * Note : drawLimbs & drawJoint are designed for drawing each joint indivdually
   * drawSkeleton is the function which draw all the limbs/joints
   * = draw every joint and limbs with drawLimbs & drawJoint functions
   
   */
   
  PVector mid_joint(int userId, int left_joint_ID, int right_joint_ID){
    
    PVector mid = new PVector();
    PVector left = new PVector();
    PVector right = new PVector();
    kinect.getJointPositionSkeleton(userId, left_joint_ID, left);
    kinect.getJointPositionSkeleton(userId, right_joint_ID, right);
    PVector convertedleft = new PVector();
    PVector convertedright = new PVector();
    kinect.convertRealWorldToProjective(left, convertedleft);
    kinect.convertRealWorldToProjective(right, convertedright);
    
    mid.set((convertedleft.x + convertedright.x)/2, (convertedleft.y + convertedright.y)/2, (convertedleft.z + convertedright.z)/2);
    println(left, right, mid);
    
    return mid;
  }
  
  PVector joint_get_convert(int userId, int joint_ID){
    return mid_joint(userId, joint_ID, joint_ID);
  }

  void drawSkeleton(int userId) {

    // * DRAW EACH LIMBS INDVIDUALLY
    
    PVector mid_hip_joint = mid_joint(userId, SimpleOpenNI.SKEL_LEFT_HIP,SimpleOpenNI.SKEL_RIGHT_HIP);
    
    draw_spine_between_joint_IDs(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 7); // * head to neck: seg_num = 7
    draw_spine_between_joint_IDs(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_TORSO, 7);
    draw_spine_between_joints(userId, joint_get_convert(userId, SimpleOpenNI.SKEL_TORSO), mid_hip_joint, 7); 

    //drawLimbs(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    drawLimbs(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawLimbs(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawLimbs(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    drawLimbs(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
    drawLimbs(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    drawLimbs(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    drawLimbs(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawLimbs(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    drawLimbs(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    drawLimbs(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

    drawHead(userId);


    /* * DRAW EACH JOINTS INDIVIDUALLY
     
     * By default, I comment these because I only want my limbs drawed */

    drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
    drawJoint(userId, SimpleOpenNI.SKEL_NECK);
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
    drawJoint(userId, SimpleOpenNI.SKEL_NECK);
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
    drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
    drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
  }
}

void print_joints_to_csv() {
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

