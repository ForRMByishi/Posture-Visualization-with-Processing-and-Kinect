/* *-*-*-*-*-* DEBUGGING INFORMATIONS *-*-*-*-*-* */


void draw_logo(){
  logo.disableStyle();  // Ignore the colors in the SVG
  fill(getRandomColor()); 
  shape(logo,20,20,15,15/logo.width*logo.height);
  
  translate(logo.width, 15/logo.width*logo.height/2 - 8);
  
  textFont(title_font);
  textSize(8);
  fill(getRandomColor());
  text("spine coach", 10, textWidth("spine coach"));
}


/* Display  informations to debug */
 
void displayInfo(boolean active) {
  if(active == true) {

/* * Display the depth image (great for debugging purpose, but the image is mirrored!)
 * (except if you set.mirror(true), but the skeleton will be mirrored instead!)
*/
  //image(kinect.depthImage(), 0, 0);
  //int[] depth = kinect.getRawDepth();
  //println(depth);
  
  int howMany = kinect.getNumberOfUsers();
  textFont(f);
  textSize(12);
  fill(255);
  text("Number of users = " + howMany, textPosition, 50);  
  
  if(visibleUser) {
  textFont(f);
  textSize(12);
  fill(175, 200, 255);
  text("Someone is in front of the Kinect", textPosition, 100);
  } else {
    textFont(f);
    textSize(12);
    fill(255, 100, 0);
    text("Nobody is in front of the Kinect...", textPosition, 100);
    }
  }
}

void displaySuccess(boolean active) {
if(active == true) {
  textFont(f);
  textSize(12);
  fill(0, 255, 0);
  text("Tracking successful !", textPosition, 150);
  }
}

void displayError(boolean active) {
if(active == true) {
  textFont(f);
  textSize(12);
  fill(255, 0, 0);
  text("Nobody is tracked...", textPosition, 150);
  }
}
