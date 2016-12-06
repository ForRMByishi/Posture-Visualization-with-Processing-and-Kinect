void updateAndDrawBox2D() {
  // if frameRate is sufficient, add a polygon and a circle with a random radius

  if (frameRate > 30) {
    CustomShape shape1 = new CustomShape(kinectWidth/2, -50, -1, BodyType.DYNAMIC) ;
    CustomShape shape2 = new CustomShape(kinectWidth/2, -50, random(2.5, 20), BodyType.DYNAMIC);
    polygons.add(shape1);
    polygons.add(shape2);
  }
  // take one step in the box2d physics world
  box2d.step();

  // center and reScale from Kinect to custom dimensions
  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);

  // display the person's polygon  
  stroke(153);
  //noStroke();
  fill(blobColor);
  gfx.polygon2D(poly);

  // display all the shapes (circles, polygons)
  // go backwards to allow removal of shapes
  for (int i=polygons.size ()-1; i>=0; i--) {
    CustomShape cs = polygons.get(i);
    // if the shape is off-screen remove it (see class for more info)
    if (cs.done()) {
      polygons.remove(i);
      // otherwise update (keep shape outside person) and display (circle or polygon)
    } else {
      cs.update();
      cs.display();
    }
  }
}

