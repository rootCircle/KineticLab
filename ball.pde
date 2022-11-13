import g4p_controls.*;


GSlider mass_slider, fx_slider, fy_slider, e_slider;
GSlider drag_slider, gravity_slider, scale_slider;
GLabel lbl;

class Ball {
  //Initial Coordinates of Ball
  float x;
  float y;
  //Initial Velocity
  float ux;
  float uy;
  //Instantaneous velocity
  float vx, vy;
  //External Forces 
  float Fx;
  float Fy;
  //Mass
  float m;
  //Coefficient of restitution
  float e;
  //Drag constant F=-kv^2
  //v=m*u/(m+kdt)
  float k;
  //Constants
  float gravity;
  float scale;
  //Time
  float t;
  //Thickness of frame
  float frame_thickness;
  //Size of side-frame
  float side;
  //Speed of light
  double c=3*Math.pow(10, 8);
  //Diameter of ball
  float ballWidth;
  int cslider=0;

  boolean Paused=false;
  Ball(float[] pos, float[] velocity, float[] Fext, float[] dimensions, float e, float k, float g, float scale) {
    this.x=pos[0];
    this.y=height-pos[1];
    this.ux=velocity[0];
    this.uy=velocity[1];
    this.Fx=Fext[0];
    this.Fy=Fext[1];
    this.m=dimensions[0];
    frame_thickness=dimensions[1];
    side=dimensions[2];
    ballWidth=dimensions[3];
    this.e=e;
    this.k=k;
    this.scale=scale;
    gravity=g;
    vx=ux;
    vy=uy;
  }

  void start() {
    show(x, y);
    if (!Paused) {
      physics();
      collision();
    } else {
      fill(255, 255, 255, 120);
      rect(0, 0, width-side, height, 64);
      fill(106);
      textAlign(CENTER, CENTER);
      textSize(40);
      text("|| Paused", 0, 0, width-side, height);
    }


    fill(255);
    if (mouseX>width-50 && mouseX<width-20 && mouseY>height-150 && mouseY<height-120) {
      fill(192);
      if (mousePressed) {
        Paused=!Paused;
        delay(200);
      }
    }
    pushMatrix();
    noStroke();
    rect(width-50, height-150, 30, 30, 10);
    popMatrix();
    fill(12);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("||", width-35, height-137);
  }

  void show(float x, float y) {
    background(#DEF5FA);
    frame(frame_thickness);
    fill(x, y, 0);
    ellipse(x, height-y, ballWidth, ballWidth);
  }

  void frame(float thickness) {
    fill(0, 128);
    noStroke();
    rect(width-side-thickness, 0, thickness, height);
    rect(0, 0, width-side, thickness);
    rect(0, 0, thickness, height);
    rect(0, height-thickness, width-side, thickness);

    sideframe();
  }

  void sideframe() {
    fill(#DB5454, 225);
    rect(width-side, 0, side, height, 55);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("Manipulate Data", width-side, 20, side, 150);
    if (cslider!=1) {
      sliders(m, Fx, Fy, e, k, gravity,scale, width-side, 120);
    } else {
      Fx=fx_slider.getValueF();
      Fy=fy_slider.getValueF();
      m=mass_slider.getValueF();
      e=e_slider.getValueF();
      k=drag_slider.getValueF();
      gravity=gravity_slider.getValueF();
      scale=scale_slider.getValueF();
    }
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Lower Coefficient of Restitution to decrease velocity.", width-side, height-80, side, 80);

    double v=round(sqrt(vx*vx+vy*vy));
    double angle=0;
    if (vx!=0 && vy!=0) {
      angle=round((atan((float)vy/vx))*180/(22/7.0));
    }
    else if(vy!=0){
      angle=sgn(vy)*90;
    }
    text("Velocity:"+v+" px/unit time\nDirection: "+angle+"º", width-170, height/2-100, 170, 200);
  }

  void physics() {
    float ax=(float)(Fx/m);
    float ay=(float)(Fy/m)-gravity;
    float dragvx=0;
    if (vx+k!=0 && k!=0) {
      dragvx=(-1)*(float)sgn(vx)*abs((float)m*vx/(m+k))*scale;
    }
    float dragvy=0;
    if (vy+k!=0 && k!=0) {
      dragvy=(-1)*(float)sgn(vy)*abs((float)m*vy/(m+k))*scale;
    }
    ax*=scale;
    ay*=scale;
   
    vx+=ax+dragvx;
    vy+=ay+dragvy;
    
    if (vx*vx>c*c) {
      vx=(float)(sgn(vx)*c);
      ax=0;
    }
    if (vy*vy>c*c) {
      vy=(float)(sgn(vy)*c);
      ay=0;
    }
    y+=vy*scale;
    x+=vx*scale;
  }

  private double sgn(double a) {
    if (a==0) {
      return 0.0;
    } else {
      double mod_a=Math.sqrt(a*a);
      return a/mod_a;
    }
  }

  void collision() {
    float collision_point=frame_thickness+ballWidth/2.0;
    if (x<=collision_point) {
      x=collision_point;
      vx=-1*vx*e;
    } else if (x>=width-side-collision_point) {
      x=width-side-collision_point;
      vx=-1*vx*e;
    }

    if (y<=collision_point) {
      y=collision_point;
      vy=-1*vy*e;
    } else if (y>=height-collision_point) {
      y=height-collision_point;
      vy=-1*vy*e;
    }
  }
}


void sliders(float m, float forcex, float forcey, float e, float k, float g,float scale, float x, float y) {
  b.cslider=1;
  x+=5;

  mass_slider = new GSlider(this, x, y, 120, 40, 12);
  mass_slider.setLimits(0.1f, 100.0f);
  mass_slider.setValue(m);
  mass_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Mass");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();

  y += 30;
  fx_slider = new GSlider(this, x, y, 120, 40, 12);
  fx_slider.setLimits(-100.0f, 100.0f);
  fx_slider.setValue(forcex);
  fx_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Horizontal Force");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();

  y += 30;
  fy_slider = new GSlider(this, x, y, 120, 40, 12);
  fy_slider.setLimits(-100.0f, 100.0f);
  fy_slider.setValue(forcey);
  fy_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Vertical Force");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();

  y += 30;
  e_slider = new GSlider(this, x, y, 120, 40, 12);
  e_slider.setLimits(0f, 1.0f);
  e_slider.setValue(e);
  e_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Coeffient of Restitution");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();

  y += 30;
  drag_slider = new GSlider(this, x, y, 120, 40, 12);
  drag_slider.setLimits(0f, 50.0f);
  drag_slider.setValue(k);
  drag_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Air Drag");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();

  y += 30;
  gravity_slider = new GSlider(this, x, y, 120, 40, 12);
  gravity_slider.setLimits(0f, 20.0f);
  gravity_slider.setValue(g);
  gravity_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Gravity");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();
  
  y += 30;
  scale_slider = new GSlider(this, x, y, 120, 40, 12);
  scale_slider.setLimits(0.01f, 0.2f);
  scale_slider.setValue(scale);
  scale_slider.setShowValue(true);
  lbl = new GLabel(this, x + 122, y, 100, 40, "Scale of Time");
  lbl.setTextAlign(GAlign.LEFT, null);
  lbl.setTextItalic();
}
