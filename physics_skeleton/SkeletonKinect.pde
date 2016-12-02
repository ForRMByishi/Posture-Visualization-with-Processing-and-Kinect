/* *-*-*-*-*-* SkeletonKinect *-*-*-*-*-* */
// A SimpleOpenNI Class Extension

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

  /* Basic Methods */

  PVector converted_joint_from_limbID(int userId, int limbID) {
    PVector joint = new PVector();
    float limb = kinect.getJointPositionSkeleton(userId, limbID, joint);
    PVector convertedJoint = new PVector();
    kinect.convertRealWorldToProjective(joint, convertedJoint);
    return convertedJoint;
  }

  void get_all_joints(int userId) {
    all_converted_joints[0] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_HEAD);
    all_converted_joints[1] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_NECK);
    all_converted_joints[2] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_TORSO);
    all_converted_joints[3] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    all_converted_joints[4] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    all_converted_joints[5] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
    all_converted_joints[6] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    all_converted_joints[7] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_HAND);
    all_converted_joints[8] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
    all_converted_joints[9] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
    all_converted_joints[10] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
    all_converted_joints[11] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
    all_converted_joints[12] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
    all_converted_joints[13] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
    all_converted_joints[14] = converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);

    export(all_converted_joints);
  }



  /* ----------------------------*-*-*- drawLimbs function -*-*-*---------------------------- */
  /* Create a line between two joints */

  // * 3 arguments --> userId, 1st limb and 2nd limb
  void drawLimbs(int userId, int limbID1, int limbID2) {

    // * Translation of kinect proportion to fullscreen proportions
    float limb1X = map(converted_joint_from_limbID(userId, limbID1).x, 0, 640, 0, width/reScale);
    float limb1Y = map(converted_joint_from_limbID(userId, limbID1).y, 0, 480, 0, height/reScale);
    float limb2X = map(converted_joint_from_limbID(userId, limbID2).x, 0, 640, 0, width/reScale);
    float limb2Y = map(converted_joint_from_limbID(userId, limbID2).y, 0, 480, 0, height/reScale);

    /* draw the line from a joint to another*/
    stroke(getRandomColor());
    strokeWeight(1);
    line(limb1X, limb1Y, limb2X, limb2Y);
  }


  /* ----------------------------*-*-*- drawJoint function -*-*-*---------------------------- 
   
   * Get each joint position, create an ellipse at this position */
  void drawJoint(int userId, int jointID) {

    // * Translation of kinect proportion to fullscreen proportions
    float jointX = map(converted_joint_from_limbID(userId, jointID).x, 0, 640, 0, width/reScale);
    float jointY = map(converted_joint_from_limbID(userId, jointID).y, 0, 480, 0, height/reScale);

    // * Draw the joints
    noStroke();
    fill(getRandomColor());
    ellipse(jointX, jointY, random(7, 15), random(7, 15));
  }


  /* ----------------------------*-*-*- drawHeadfunction -*-*-*---------------------------- 
   
   * Display the head with an ellipse
   
   */
  void drawHead(int userId) {
    // * Translation of kinect proportion to fullscreen proportions
    float headx = map(converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_HEAD).x, 0, 640, 0, width/reScale);
    float heady = map(converted_joint_from_limbID(userId, SimpleOpenNI.SKEL_HEAD).y, 0, 480, 0, height/reScale);

    // * Graphic stuff 
    strokeWeight(1);
    noFill();
    ellipseMode(CENTER);
    ellipse(headx, heady, 70, 70);
  }


  /* ----------------------------*-*-*- drawSpine function -*-*-*---------------------------- */

  void draw_spine_between_joint_IDs(int userId, int jointID1, int jointID2, int seg_num) {
    draw_spine_between_joints(userId, converted_joint_from_limbID(userId, jointID1), converted_joint_from_limbID(userId, jointID2), seg_num);
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
      shape(spine, limb1X + (spineVector.x * n), limb1Y + (spineVector.y * n), limb1Z*22 + (spineVector.z * n *22), limb1Z*12 + (spineVector.z * n * 12));
    }
  }


  /* ----------------------------*-*-*- middle joint (i.e. middle hip) function -*-*-*---------------------------- */
  // if SimpleOpenNI returns only left and right joints, average and convert the corrdinates
  PVector mid_joint(int userId, int left_joint_ID, int right_joint_ID) {
    PVector convertedleft = converted_joint_from_limbID(userId, left_joint_ID);
    PVector convertedright = converted_joint_from_limbID(userId, right_joint_ID);
    PVector mid = new PVector();
    mid.set((convertedleft.x + convertedright.x)/2, (convertedleft.y + convertedright.y)/2, (convertedleft.z + convertedright.z)/2);

    return mid;
  }

  // otherwise, convert the original coordinates
  PVector joint_get_convert(int userId, int joint_ID) {
    return mid_joint(userId, joint_ID, joint_ID);
  }


  /* ----------------------------*-*-*- drawSkeleton function -*-*-*----------------------------  */
  void drawSkeleton(int userId) {

    // * DRAW EACH LIMBS INDVIDUALLY
    PVector mid_hip_joint = mid_joint(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_RIGHT_HIP);

    draw_spine_between_joint_IDs(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK, 7); // * head to neck: seg_num = 7
    draw_spine_between_joint_IDs(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_TORSO, 9);
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

    /* * DRAW EACH JOINTS INDIVIDUALLY * */

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

void export(PVector[] jointList) {
  // * Export join coordinates to joint_output csv file
  FloatList temp = new FloatList();

  for (int i=0; i < jointList.length; i++) {
    joint_output.print(jointList[i].x + "," + jointList[i].y + "," + jointList[i].x + ",");
  }
  joint_output.print("\n");
  joint_output.flush();
}

