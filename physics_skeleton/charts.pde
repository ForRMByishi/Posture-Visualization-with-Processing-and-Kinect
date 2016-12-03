
void draw_side_view() {
  
  rect(20,20,100,200);

  for (int i=0; i< all_converted_joints.length; i++) {
    PVector temp = all_converted_joints[i];
    println(temp);
    println(temp.x);
    //println(all_converted_joints[i].y);
    side_view_points.add(new PVector(100, 100));
    //side_view_points.add(new PVector(all_converted_joints[i].z, all_converted_joints[i].y));
  }
  //println(side_view_points);

  //draw all unique connecting lines
  for (int i=0; i<side_view_points.size (); i++) {
    ellipse(side_view_points.get(i).x, side_view_points.get(i).y, 3, 3);
    //for(int j=0;j<side_view_points.size(); j++) would draw all lines twice
    for (int j=i+1; j<side_view_points.size (); j++) {
      line(side_view_points.get(i).x, side_view_points.get(i).y, side_view_points.get(j).x, side_view_points.get(j).y);
    }
  }
}



void setup_bar_chart() {
  barChart = new BarChart(this);
  barChart.setData(new float[] {
    1, 0.24, 0.39, 1, 0.20
  }
  );
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

