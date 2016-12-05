import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

// kinect variable
SimpleOpenNI kinect;

// variable to hold our current rotation represented in degrees
float rotation = 0;
// set the box size
int boxSize = 150;
// a vector holding the center of the box
PVector boxCenter = new PVector(0, 0, 600);

// this will be used for zooming
// start at normal
float s = 1;

// used for edge detection
boolean wasJustInBox = false;

// minim objects
Minim minim;
AudioSnippet player;

void setup() 
{
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // access the color camera
  kinect.enableRGB();
  // tell OpenNI to line-up the color pixels
  // with the depth data
  kinect.alternativeViewPointDepthToImage();
  
  // initialize Minim
  // and AudioPlayer
  minim = new Minim(this);
  player = minim.loadSnippet("kick.wav");
}

void draw() 
{
  background(0);
  kinect.update();
  
  // load the color image from the Kinect
  PImage rgbImage = kinect.rgbImage();

  // prepare to draw centered in x-y
  // z axis adjustment
  translate(width/2, height/2, -1000);
  // flip the point cloud vertically:
  rotateX(radians(180));
  // move the center of rotation
  // to inside the point cloud
  translate(0, 0, 1400);
  
  // rotate about the y-axis and bump the rotation
  float mouseRotation = map(mouseX, 0, width, -180, 180);
  rotateY(radians(mouseRotation));

  translate(0,0,s*-1000);
  scale(s);
  println(s);

  stroke(255);
  
  // get the depth data as 3D points
  PVector[] depthPoints = kinect.depthMapRealWorld(); 
  
  // initialize a variable
  // for storing the total
  // points we find inside the box
  // on this frame
  int depthPointsInBox = 0;
  
  for (int i = 0; i < depthPoints.length; i+=10) 
  {
    PVector currentPoint = depthPoints[i];
    
    // set the stroke color based on the color pixel
    stroke(rgbImage.pixels[i]);
    
    // The nested if statements inside of our loop 2
    if (currentPoint.x > boxCenter.x - boxSize/2
    && currentPoint.x < boxCenter.x + boxSize/2)
    {
      if (currentPoint.y > boxCenter.y - boxSize/2
      && currentPoint.y < boxCenter.y + boxSize/2)
      {
        if (currentPoint.z > boxCenter.z - boxSize/2
        && currentPoint.z < boxCenter.z + boxSize/2)
        {
          depthPointsInBox++;
        }
      }
    }
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  println(depthPointsInBox);
  
  // set the box color's transparency
  // 0 is transparent, 1000 points is fully opaque red
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);

  // edge detection
  // are we in the box this time
  boolean isInBox = (depthPointsInBox > 0); 
  // if we just moved in from outside
  // start it playing
  if (isInBox && !wasJustInBox) 
  { 
    player.play();
  }
  // if it's played all the way through
  // pause and rewind
  if (!player.isPlaying()) 
  { 
    player.rewind();
    player.pause();
  }
  // save current status
  // for next time
  wasJustInBox = isInBox; 
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  fill(255, 0, 0, boxAlpha);
  stroke(255, 0, 0);
  box(boxSize);
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

void mousePressed()
{
  save("touchedPoint.png");
}
