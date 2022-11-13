
import uibooster.*;
import uibooster.components.*;

Ball b;
int page=0;

void setup() {
  UiBooster booster = new UiBooster();
  String splashImage = dataPath("splash.png");
  Splashscreen splash = booster.showSplashscreen(splashImage);


  delay(1500);

  splash.hide();
  
  size(800, 400);
  background(25);
  textSize(45);
  textAlign(CENTER,CENTER);
  text("Loading...\nPlease be Patient!",0,0,width,height);
  float[] pos={100, 100};
  float[] velocity={0, 0};
  float[] Fext={0, 0};
  float[] dimensions={1, 20, 400, 50};
  b=new Ball(pos, velocity, Fext, dimensions, 1, 0, 0, 0.07);
}

void draw() {
  if (page==0) {
    startPage();
  } else {
    b.start();
  }
}

void startPage() {
  background(#5E747E, 23);
  textAlign(CENTER);
  textSize(35);
  fill(255);
  text("Physics Lab", width/2, 50);

  fill(255);
  if (mouseX>50 && mouseX<width-100 && mouseY>height-150 && mouseY<height-50) {
    fill(192);
    if (mousePressed) {
      page=1;
    }
  }
  pushMatrix();
  noStroke();
  rect(50, height-150, width-100, 100, 30);
  popMatrix();
  fill(12);
  textAlign(CENTER, CENTER);
  text("Enter", width/2, height-100);
}
