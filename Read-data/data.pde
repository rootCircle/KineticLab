/**
 * LoadFile 1
 * 
 * Loads a text file that contains two numbers separated by a tab ('\t').
 * A new pair of numbers is loaded each frame and used to draw a point on the screen.
 */

String[] lines;
int index = 0;

void setup() {
  size(400, 400);
  background(0);
  lines = loadStrings("positions.txt");
  stroke(255);
}

void draw() {
  strokeWeight(10);
  
  if (index < lines.length) {
    String[] pieces = split(lines[index], '\t');
    if (pieces.length == 2) {
      point(float(pieces[0]), float(pieces[1]));
    }
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}
