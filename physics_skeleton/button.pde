/* on-screen button */
void touchbutton()
{
  // load the color image from the Kinect
  //PImage rgbImage = kinect.rgbImage();

  // prepare to draw centered in x-y
  // z axis adjustment
  //translate(width/2, height/2, -1000);
  translate(0,0,s*-1000);
  //scale(s);

  stroke(255);
  
  // get the depth data as 3D points
  PVector[] depthPoints = kinect.depthMapRealWorld(); 
  
  // initialize a variable for storing the total points found inside the box on this frame
  int depthPointsInBox = 0;
  
  for (int i = 0; i < depthPoints.length; i+=10) 
  {
    PVector currentPoint = depthPoints[i];
    
    // set the stroke color based on the color pixel
    //stroke(rgbImage.pixels[i]);
    
    // The nested if statements inside of our loop 2
    if (currentPoint.x > boxCenter.x - boxSize/2 && currentPoint.x < boxCenter.x + boxSize/2)
    {
      if (currentPoint.y > boxCenter.y - boxSize/2 && currentPoint.y < boxCenter.y + boxSize/2)
      {
        if (currentPoint.z > boxCenter.z - boxSize/2 && currentPoint.z < boxCenter.z + boxSize/2)
        {
          depthPointsInBox++;
        }
      }
    }
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  
  // set the box color's transparency
  // 0 is transparent, 1000 points is fully opaque red
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);

  // edge detection: is the user in the box this time
  boolean isInBox = (depthPointsInBox > 0); 

  // save current status for next time
  wasJustInBox = isInBox; 
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  fill(255, 0, 0, boxAlpha);
  stroke(255, 0, 0);
  box(boxSize);
  
  println("depth", depthPointsInBox);
  if (depthPointsInBox > 350){
    touch_timer += 1;
    println(">450");
  } else {
    println("cleared when timer is", touch_timer);
    touch_timer = 0;
  }
  
  if (touch_timer > 3){
    touch_timer = 0;
    println("triggered!");
    link("http://www.google.com");
  }
}
