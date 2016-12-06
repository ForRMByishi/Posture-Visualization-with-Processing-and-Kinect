
void draw_side_view() {
  
  side_view_points = new ArrayList();
  for (int i : selected_joints) {
    PVector temp = all_converted_joints[i];
    float z_val = map(temp.z, 0, width, -50, 50); // map x,y axis values to the range of [0,200]
    float y_val = map(temp.y, 0, height, 100, 200);
    side_view_points.add(new PVector(z_val, y_val));
  }

  //draw all connecting lines and joints
  ellipse(side_view_points.get(0).x, side_view_points.get(0).y, 5, 5);
  
  for (int i=1; i<side_view_points.size(); i++) {
    fill(getRandomColor());
    ellipse(side_view_points.get(i).x, side_view_points.get(i).y, 5, 5);
    stroke(getRandomColor());
    strokeWeight(3);
    line(side_view_points.get(i).x, side_view_points.get(i).y, side_view_points.get(i-1).x, side_view_points.get(i-1).y);
  }
}


void setup_bar_chart() {
  barChart = new BarChart(this);
  
  // initialize data 
  barChart.setData(new float[] {
    0, 0, 0.0, 0.0, 0.0
  });
  // Axis scaling
  barChart.setMinValue(0);
  barChart.setMaxValue(1);

  barChart.setBarLabels(new String[] {
    "head", "neck", "should", "torso", "hip"
  }
  );
  barChart.showCategoryAxis(true);

  // Bar colours and appearance
  barChart.setBarColour(color(2, 72, 131)); // dark blue
  barChart.setBarGap(4);

  // Bar layout
  barChart.transposeAxes(true);
}



