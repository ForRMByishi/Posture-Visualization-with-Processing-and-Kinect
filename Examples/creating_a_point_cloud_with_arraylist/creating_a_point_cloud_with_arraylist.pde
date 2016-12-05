ArrayList<PVector> points;

void setup() {
  size(1280, 720); 
  points=new ArrayList<PVector>();
  stroke(255, 50);
  noFill();
}

void draw() {
  background(55);
  //draw all unique connecting lines
  for (int i=0; i<points.size(); i++) {
    ellipse(points.get(i).x, points.get(i).y, 3, 3);
    //for(int j=0;j<points.size(); j++) would draw all lines twice
    for (int j=i+1; j<points.size(); j++) {
      line(points.get(i).x, points.get(i).y, points.get(j).x, points.get(j).y);
    }
  }
}

void mousePressed() {
  points.add(new PVector(mouseX, mouseY));
}
