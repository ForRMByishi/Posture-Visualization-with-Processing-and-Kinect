void setup_bar_chart(){
  barChart = new BarChart(this);
  barChart.setData(new float[] {1, 0.24, 0.39, 1, 0.20});
  // Axis scaling
  barChart.setMinValue(0);
  barChart.setMaxValue(1);
     
  barChart.setBarLabels(new String[] {"head","neck","should","torso","hip"});
  barChart.showCategoryAxis(true);
  
  // Bar colours and appearance
  barChart.setBarColour(color(2,72,131)); // dark blue
  barChart.setBarGap(4);
   
  // Bar layout
  barChart.transposeAxes(true);

}

