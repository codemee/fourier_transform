float angle = radians(90);           // starting angle for sin wave 
float sinFreq = 3;                   // freqency of sin wave
float circleFreq = 3;                // freq of circling sin wave around the rogin
float offset = 0;                  // offset to move sin wave up

float amp;                           // amplitude of sin wave
float scaleY = 100, scaleX = 10;     // scale factor for sin wave
float timesPerSec = 100;             // drawing frequency
float xInc, cInc;                    // 
float prevX = 0, prevY = 0, prevCX = 0, prevCY = 0; // previous point of sin wave and circling graph
float x, y, cx, cy, cAng = 0;
float sumX = 0, sumY = 0, avgX, avgY, total = 0;
float origX, origY, margin = 20, waveAreaHeight = (scaleY + margin) * 2;
float origT = waveAreaHeight / 2 + offset;
boolean started = false;

void setup() {
  size(660, 800);                                          // set window size
  textSize(18);
  background(0);                                           // fill background to black
  frameRate(100);                                          // frequency for updateing screen 
  xInc = radians(360 * sinFreq / timesPerSec);             // angles varied every sec for sin wave
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
  stroke(255, 204, 0);          // drawing with yellow color
  angle = angle + xInc;         // compute new angle
  amp = sin(angle);             // get sin value
  x = prevX + 0.1;              // get curr x position
  y = amp * scaleY + offset;    // get curr  y position
  if(!started) {                // if it's the first point of sin wave 
    prevX = x;                  // set previous point as this point
    prevY = y;                  // to prevent drawing a line from origin to current point
  }
  line(                                     // drawing line from previous point to current point
    margin + prevX * scaleX, origT - prevY, // the coordinate is upside down with the screen coordinate
    margin + x * scaleX, origT - y);
  prevX = x;                    // records curr point
  prevY = y;
  
  cAng -= cInc;                 // compute next angle for circling graph in clockwize direction 
  cx = y * cos(cAng);           // get curr x position
  cy = y * sin(cAng);           // get curr y position
  if(!started) {
    prevCX = cx;
    prevCY = cy;
    started = true;
  }
  line(
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
  circle(avgX + origX, -avgY + origY, 20);
}
