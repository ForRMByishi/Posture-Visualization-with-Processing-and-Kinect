
/* 
 
 Qian Yang (qyang1@cs.cmu.edu)
 
 */

import processing.opengl.*; // opengl
import SimpleOpenNI.*; // kinect
import blobDetection.*; // blobs
import toxi.geom.*; // toxiclibs shapes and vectors
import toxi.processing.*; // toxiclibs display
import shiffman.box2d.*; // shiffman's jbox2d helper library
import org.jbox2d.collision.shapes.*; // jbox2d
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.common.*; // jbox2d
import org.jbox2d.dynamics.*; // jbox2d
import ddf.minim.*; // for touch
import org.gicentre.utils.stat.*; // for static chart

int timer;
int touch_timer;
int timeIntervalFlag = 3000; // 3 seconds because we are working with millis

/* Variables for info display */
PShape logo;
PShape spine;
PFont title_font;
PFont f;

/* Variables for static charts */
BarChart barChart; //static barchart
ArrayList<PVector> side_view_points; // for array point cloud

/* Variables for Kinect Physics */
// declare SimpleOpenNI object
//SimpleOpenNI context;
SkeletonKinect  kinect; // for skeleton

// declare BlobDetection object
BlobDetection theBlobDetection;
// ToxiclibsSupport for displaying polygons
ToxiclibsSupport gfx;
// declare custom PolygonBlob object (see class for more info)
PolygonBlob poly;

// PImage to hold incoming imagery and smaller one for blob detection
PImage blobs;
// the kinect's dimensions to be used later on for calculations
int kinectWidth = 640; // original: 640, 480
int kinectHeight = 480;
PImage cam = createImage(640, 480, RGB);
// to center and rescale from 640x480 to higher custom resolutions
float reScale;
// background and blob color
color bgColor, blobColor;
// three color palettes (artifact from me storing many interesting color palettes as strings in an external data file ;-)
String[] palettes = {
  "-1117720,-13683658,-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634", 
  "-67879,-9633503,-8858441,-144382,-4996094,-16604779,-588031", 
  "-1978728,-724510,-15131349,-13932461,-4741770,-9232823,-3195858,-8989771,-2850983,-10314372"
};
color[] colorPalette;

// the main PBox2D object in which all the physics-based stuff is happening
Box2DProcessing box2d;
// list to hold all the custom shapes (circles, polygons)
ArrayList<CustomShape> polygons = new ArrayList<CustomShape>();

/* Variables for Skeleton */
// SQL communication variables
PrintWriter joint_output;
PVector head;

PVector converted_joint_from_limbID;
PVector[] all_converted_joints = new PVector[15]; // an array of 15 joints' converted coordinates, which are...

// * Skeleton basis variables
boolean visibleUser;
float textPosition;
// - Array of color
color[] userColor = new color[] { 
  color(255, 0, 0), 
  color(109, 57, 255), 
  color(0, 255, 0), 
  color(0, 0, 255)
}; 

int randomColor = 0;

/* Variables for touch button */

int boxSize = 150;
PVector boxCenter = new PVector(0, 0, 1000);
float s = 1;
// used for edge detection
boolean wasJustInBox = false;

/* Variables for static charts */
ArrayList<PVector> points;

// * Enable FullScreen 
boolean sketchFullScreen() {
  return false;
} 

void setup() {
  println("SETTING UP...");
  timer = millis();

  //size(1024, 768, OPENGL);
  size(1024, 768, P3D);

  /* set up static charts */
  setup_bar_chart();
  side_view_points = new ArrayList<PVector>(); // for array point cloud

  // initialize SimpleOpenNI object
  kinect = new SkeletonKinect(this);

  /* set up info display */
  logo = loadShape("logo.svg"); // width 100, height 125
  spine = loadShape("spine.svg");

  /* set up display */
  f = loadFont("Menlo-Regular-12.vlw");
  title_font = loadFont("FiraSans-Hair-60.vlw");

  // set up corrdinates export to a csv file
  joint_output = createWriter("skeleton_points.csv"); 
  joint_output.print("head_x, head_y, head_z, neck_x, neck_y, neck_z, torso_x, torso_y, torso_z, left_shoulder_x, left_shoulder_y, left_shoulder_z, right_shoulder_x,right_shoulder_y, right_shoulder_z,");
  joint_output.print("left_elbow_x, left_elbow_y, left_elbow_z, right_elbow_x, right_elbow_y, right_elbow_z, left_hand_x, left_hand_y, left_hand_z, right_hand_x, right_hand_y, right_hand_z, left_hip_x, left_hip_y, left_hip_z, right_hip_x, right_hip_y, right_hip_z,");
  joint_output.print("left_knee_x,left_knee_y,left_knee_z, right_knee_x, right_knee_y, right_knee_z, left_feet_x, left_feet_y, left_feet_z, right_feet_x, right_feet_y, right_feet_z\n");

  /* set up kinect physics */
  if (!kinect.enableDepth() || !kinect.enableUser()) { 
    println("Kinect not connected!"); 
    exit();
  } else {
    // mirror the image to be more intuitive
    kinect.setMirror(false);
    // calculate the reScale value
    // currently it's rescaled to to fill the complete height (leaves empty sides)
    reScale = (float) height / kinectHeight;

    blobs = createImage(kinectWidth/3, kinectHeight/3, RGB);
    // initialize blob detection object to the blob image dimensions
    theBlobDetection = new BlobDetection(blobs.width, blobs.height);
    theBlobDetection.setThreshold(0.3);
    // initialize ToxiclibsSupport object
    gfx = new ToxiclibsSupport(this);
    // setup box2d, create world, set gravity
    box2d = new Box2DProcessing(this);
    box2d.createWorld();
    box2d.setGravity(0, -40);
    // set random colors (background, blob)
    setRandomColors(1);

    float gap = kinectWidth / 21;
    for (int i=0; i<20; i++)
    {
      drawString(gap * (i+1), 2, 10);
    }
  }

  /* set up display */
  smooth();
}

void drawString(float x, float size, int cards) {

  float gap = kinectHeight/cards;
  // anchor card
  CustomShape s1 = new CustomShape(x, -40, size, BodyType.DYNAMIC);
  polygons.add(s1);

  CustomShape last_shape = s1;
  CustomShape next_shape;
  for (int i=0; i<cards; i++)
  {
    float y = -20 + gap * (i+1);
    next_shape = new CustomShape(x, -20 + gap * (i+1), size, BodyType.DYNAMIC);
    DistanceJointDef jd = new DistanceJointDef();

    Vec2 c1 = last_shape.body.getWorldCenter();
    Vec2 c2 = next_shape.body.getWorldCenter();
    // offset the anchors so the cards hang vertically
    c1.y = c1.y + size / 5;
    c2.y = c2.y - size / 5;
    jd.initialize(last_shape.body, next_shape.body, c1, c2);
    jd.length = box2d.scalarPixelsToWorld(gap - 1);
    box2d.createJoint(jd);
    polygons.add(next_shape);
    last_shape = next_shape;
  }
}

void draw() {
  background(bgColor);

  // update the SimpleOpenNI object
  kinect.update();

  // * Put detected users in an IntVector
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  cam = kinect.userImage();
  cam.loadPixels();
  color black = color(0, 0, 0);
  // filter out grey pixels (mixed in depth image)
  for (int i=0; i<cam.pixels.length; i++)
  { 
    color pix = cam.pixels[i];
    int blue = pix & 0xff;
    if (blue == ((pix >> 8) & 0xff) && blue == ((pix >> 16) & 0xff))
    {
      cam.pixels[i] = black;
    }
  }
  cam.updatePixels();

  // copy the image into the smaller blob image
  blobs.copy(cam, 0, 0, cam.width, cam.height, 0, 0, blobs.width, blobs.height);
  // blur the blob image
  blobs.filter(BLUR, 1);
  // detect the blobs
  theBlobDetection.computeBlobs(blobs.pixels);
  // initialize a new polygon
  poly = new PolygonBlob();
  // create the polygon from the blobs (custom functionality, see class)
  poly.createPolygon();
  // create the box2d body from the polygon
  poly.createBody();
  // update and draw everything (see method)
  updateAndDrawBox2D();
  // destroy the person's body (important!)
  poly.destroyBody();
  // set the colors randomly every 240th frame
  setRandomColors(240);

  // * Search for an user and give him a UserId
  for (int i=0; i < userList.size (); i++) {
    int userId = userList.get(i);

    // * For every user, draw the skeleton
    if (kinect.isTrackingSkeleton(userId)) {
      stroke(userColor[ randomColor ] );
      kinect.get_all_joints(userId);
      kinect.drawSkeleton(userId);
      // * Set to false to turn off success tracking message      
      displaySuccess(true);
    } else {      
      // * Set to false to turn off error tracking message
      displayError(true);         
      // * Each time the tracking is lost, change the random color value for the next tracking   
      randomColor = (int)random(0, userColor.length);
    }
  }

  if ( millis() > timer + timeIntervalFlag ) {
    timer = millis();
    // do sth every 3 sec
    //draw_side_view();
  }

  // * Set to false to turn off the debugging informations
  displayInfo(false);
  draw_logo();
  
  // draw the static chart
  barChart.draw(20, 40, 100, 100);
  

  touchbutton();
}


