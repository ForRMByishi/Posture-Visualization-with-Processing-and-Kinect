/* *-*-*-*-*-* GET THE POSITION OF ANY SKELETON JOINT *-*-*-*-*-*
 
 * Return a 3 dimensionnal PVector, values are already mapped to fullscreen
 
 */

PVector getJoint(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint);

  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);

  // * Translation of kinect proportion to fullscreen proportions
  convertedJoint.x = map(convertedJoint.x, 0, 640, 0, width/reScale);
  convertedJoint.y = map(convertedJoint.y, 0, 640, 0, height/reScale);
  convertedJoint.z = abs(map(convertedJoint.z, 800, 4000, -1, 0));

  return convertedJoint;
} 

PVector converted_joint_from_limbID(int userId, int limbID) {
  PVector joint = new PVector();
  float limb = kinect.getJointPositionSkeleton(userId, limbID, joint);
  PVector convertedJoint = new PVector();
  kinect.convertRealWorldToProjective(joint, convertedJoint);
  return convertedJoint;
}

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

