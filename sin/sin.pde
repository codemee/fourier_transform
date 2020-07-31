import static iadt.creative.Inputs.*;

float angle = radians(20);           // starting angle for sin wave
float[] angles;
float[] sinFreqs;
float circleFreq = 2;                // freq of circling sin wave around the rogin
float offset = 100;                    // offset to move sin wave up

float amp;                           // amplitude of sin wave
float scaleY = 100, scaleX = 10;     // scale factor for sin wave
float timesPerSec = 100;             // drawing frequency
float cInc;                    //
float[] xIncs;
float prevX = 0, prevY = 0, prevCX = 0, prevCY = 0; // previous point of sin wave and circling graph
float x, y, cx, cy, cAng = 0;
float sumX = 0, sumY = 0, avgX, avgY, total = 0;
float origX, origY, margin = 20, waveAreaHeight = (scaleY + margin) * 2;
float origT = waveAreaHeight / 2 + offset;
boolean started = false;
PImage rArea;

void settings() {
  size(660, int(scaleY * 6 + margin * 3));                 // size() can't take var as argument in setup()
}

void setup() {
  textSize(18);
  background(0);                                           // fill background to black
  frameRate(100);                                          // frequency for updateing screen 
  String freqStr;
  freqStr = readString("Enter frequencies of the sin waves:", "2 3");
  while ((angle = readInt("Enter starting angle of sin wave:", 90)) < 0);
  angle = radians(angle);
  while ((offset = readInt("Enter offset of sin wave:", 100)) < 0);
  while ((circleFreq = readFloat("Enter frequency of cycling:", 3)) < 0);
  String[] freqs = freqStr.split(" ");
  sinFreqs = new float[freqs.length];
  xIncs = new float[freqs.length];
  angles = new float[freqs.length];
  for(int i = 0;i < freqs.length;i++) {
    try {
      sinFreqs[i] = Float.parseFloat(freqs[i]); 
    }
    catch(Exception e) {
      sinFreqs[i] = 1;
    }
    xIncs[i] = radians(360 * sinFreqs[i] / timesPerSec);             // angles varied every sec for sin wave
    angles[i] = angle; 
  }
  cInc = radians(360 * circleFreq / timesPerSec);          // angles varied every sec for circling graph
  origX = width / 2;                                       // origin X of circling graph
  origY = (height - waveAreaHeight) / 2 + waveAreaHeight;  // origin Y of circling graph
  stroke(0, 255, 0);                                       // green axies
  line(                                                    // time (X) axis for sin wave
    margin, origT, 
    width - margin, origT);
  text("t", width - margin, origT + 20);                   // axies label
  line(                                                    // Y axis for sin wave
    margin, margin, 
    margin, origT);
  text("Y", margin - 12, margin);                          // axies label
  line(                                                    // X axis for circling graph
    margin, origY,    
    width - margin, origY);
  text("X", width - margin, origY + 20);                   // axies label
  line(                                                    // Y axis for circling graph
    origX, waveAreaHeight, 
    origX, height - margin);
  text("Y", origX -12, waveAreaHeight);                    // axies label
}

void draw() {
  amp = 0;
  for(int i = 0;i < sinFreqs.length;i++) {
    angles[i] = angles[i] + xIncs[i];            // compute new angle
    amp += sin(angles[i]);                // get sin value
  }
  x = prevX + 0.1 * scaleX;        // get curr x position
  y = amp * scaleY + offset;       // get curr  y position
  if(!started) {                   // if it's the first point of sin wave 
    prevX = x;                     // set previous point as this point
    prevY = y;                     // to prevent drawing a line from origin to current point
  }
  
  if(x >= (width - margin * 2)) {  // scroll back to left 
    x = 0.1 * scaleX;
    prevX = x;
  }
  if(x < width - margin * 3) {     // shift original wave right for margin pixels 
    rArea = get(                   // get pixels for wave
      int(margin + x), int(margin), 
      int(width - margin * 2 - x), int(scaleY * 2));
    rArea.loadPixels();            // loading pixels to mem
    noStroke();                    // clear right margin pixels
    fill(0);
    rect(margin + x, margin, margin + 1, scaleY * 2);
    stroke(0, 255, 0);             // green axies
    line(                          // redraw time (X) axis for sin wave
      margin, origT, 
      width - margin, origT);
    for(int i = 0;i < scaleY * 2;i++){ // copy pixels to right
      for(int j = 0;j < width - margin * 3 - x;j++){
        int idx = int(i * (width - margin * 2 - x) + j);
        rArea.pixels[int(margin + idx)] = rArea.pixels[idx];
      }
    }
    rArea.updatePixels();          // updating pixels to screen
  } //<>//

  stroke(255, 204, 0);             // drawing with yellow color
  line(                            // drawing line from previous point to current point
    margin + prevX, origT - prevY, // the coordinate is upside down with the screen coordinate
    margin + x, origT - y);
  prevX = x;                       // records curr point
  prevY = y;
  
  cAng -= cInc;                 // compute next angle for circling graph in clockwize direction 
  cx = y * cos(cAng);           // get curr x position
  cy = y * sin(cAng);           // get curr y position
  if(!started) {                // if first run
    prevCX = cx;                // set previous point as same as current point
    prevCY = cy;
    started = true;
  }
  line(                         // drawing current point
    prevCX + origX, -prevCY + origY, 
    cx + origX, -cy + origY);
  prevCX = cx;
  prevCY = cy;
  sumX += cx;                   // compute sum of total points
  sumY += cy;
  total++;
  avgX = sumX / total;          // compute the mass of circling graph
  avgY = sumY / total;
  stroke(255, 0, 0);            // drawing the mass in red circle
  fill(255);
  circle(avgX + origX, -avgY + origY, 20);
}
