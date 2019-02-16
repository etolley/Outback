class Artifact {
  ArrayList<Point> points;
  int frameAdded = -99;
  float chords_amp = 0;
  float melody_amp = 0;
  float kick_amp = 0;
  float snare_amp = 0;
  SoundManager sm;
  Artifact(SoundManager sm_in) {
    points = new ArrayList<Point>();
    sm = sm_in;
  }

  void draw() {
    //println(sm.getElement(1).amplitude(1));
    //25/75

    boolean melody_pass = melody_amp < 0.06 && sm.getElement(1).amplitude(1) > 0.06;
    melody_amp = sm.getElement(1).amplitude(1);
    boolean chords_pass = chords_amp < 0.15 && sm.getElement(1).amplitude(0) > 0.15;
    chords_amp = sm.getElement(1).amplitude(0);
    boolean kick_pass = kick_amp < 0.15 && sm.getElement(2).amplitude(0) > 0.15;
    kick_amp   = sm.getElement(2).amplitude(0);
    //boolean snare_pass = snare_amp < 0.15 && sm.getElement(2).amplitude(1) > 0.15;
    //snare_amp   = sm.getElement(2).amplitude(1);

    //3 27 79
    if (points.size() <= 24 && (melody_pass || chords_pass )&& frameCount < 150 && frameCount - frameAdded > 20) {
      //println(frameCount, points.size());
      points.add(new Point(75, points));
      frameAdded = frameCount;
    }
    
    if (points.size() <= 24 && (kick_pass) && frameCount - frameAdded > 5) {
      //println(frameCount, points.size());
      points.add(new Point(75, points));
      frameAdded = frameCount;
    }
    
    //if (points.size() <= 24 && frameCount > 400 && frameCount %50 == 0) points.add(new Point(75, points));

    if (frameCount == 1400) {
      float goalx = 0;
      float goaly = 0;
      for (int i = 0; i < 24*2; i +=2) {
        goalx = Shapes.DOLPHIN[i];
        goaly = Shapes.DOLPHIN[i+1];
        if (i/2 < points.size() -1 )
          points.get(i/2).setGoal(goalx, goaly);
      }
      points.get(points.size()-1).setGoal(Shapes.DOLPHIN[0], Shapes.DOLPHIN[1]);
    }



    //if (frameCount >= 200 && frameCount%50 == 0) points.add(new Point(75, points));

    for (Point p : points) p.update();

    noStroke();
    noFill();
    stroke(colors.MEDIUM, max (0, frameCount-150));
    //if (frameCount > 500) stroke(lerpColor(colors.MEDIUM, colors.LIGHT, min(1.0, (frameCount-500)/500.)));

    if (points.size() >= 3) {
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < points.size(); i++) {
        //line(points.get(i-1).x(),points.get(i-1).y(),points.get(i).x(),points.get(i).y() );
        vertex(points.get(i).x(), points.get(i).y());
      }
      endShape();
    }

    stroke(colors.DARKER, max (0, frameCount-100));
    if (frameCount > 1000) stroke(lerpColor(colors.DARKER, colors.DARK, (frameCount-1000)/500.));
    for (int i = 1; i < points.size(); i++) {
      line(points.get(i-1).x(), points.get(i-1).y(), points.get(i).x(), points.get(i).y() );
    }

    for (Point p : points) p.draw();
  }
}

class Point {
  float x;
  float y;
  float vx;
  float vy;
  float phi;
  float r;
  float maxr;
  ArrayList<Point> points;
  float point_distance;
  boolean rotateClockwise;

  boolean goToGoal;
  float goalx;
  float goaly;

  Point(float in_r, ArrayList<Point> points_in) {
    points = points_in;
    maxr = in_r;
    r = random(0, maxr);
    phi = random(0, 2*PI);
    x = r*cos(phi);
    y = r*sin(phi);
    vx = random(-1, 1);
    vy = random(-1, 1);
    rotateClockwise = random(1) > .5;
    point_distance = maxr/3.;

    goToGoal = false;
    goalx = 0;
    goaly = 0;
  }

  void setGoal(float in_x, float in_y) {
    goToGoal = true;
    goalx = in_x;
    goaly = in_y;
  }

  void unSetGoal() {
    goToGoal = false;
    vx = random(-0.2, 0.2);
    vy = random(-0.2, 0.2);
  }

  float x() {  
    return x;
  }
  float y() {  
    return y;
  }



  void update() {

    float dvx = 0;
    float dvy = 0;

    if (goToGoal) {
      dvx -= (x-goalx)/10.;
      dvy -= (y-goaly)/10.;
    } else {

      if (frameCount %10 == 0) {
        dvx += random(-1, 1);
        dvy += random(-1, 1);
      }

      //rotational force
      float dphi = -r/1000.;
      if (rotateClockwise) dphi *= -1;
      dvx += r*(cos(phi+dphi) - cos(phi))/10.;
      dvy += r*(sin(phi+dphi) - sin(phi))/10.;

      //centering force
      float rcutoff = r-maxr*4/5;
      if (rcutoff > 0) {
        dvx += -(rcutoff)*(rcutoff)*cos(phi)/1000.;
        dvy += -(rcutoff)*(rcutoff)*sin(phi)/1000.;
      }

      //repulsive/attractive force
      for (Point p : points) {
        if (p == this) continue;
        float d = sqrt((x-p.x() )*(x-p.x() ) + (y-p.y() )*(y-p.y() ));
        if (d < maxr/2) {
          dvx += (x-p.x())/d/d/2.;
          dvy += (y-p.y())/d/d/2.;
        }
      }
    }
    vx += dvx/5. - vx/10.;
    vy += dvy/5. - vy/10.;

    x += vx;
    y += vy;
    r = sqrt(x*x + y*y);

    if (r > maxr) {
      r = maxr;
      x = r*cos(phi);
      y = r*sin(phi);
    }

    phi = atan2(y, x);
  }


  void draw() {
    noStroke();
    fill(colors.DARKER);
    float pointsize = max(1, 6-points.size()/3.);
    ellipse(x, y, pointsize, pointsize);
  }
}

static class Shapes {
  public static final float[] DOLPHIN = {-49.567708333333329, 7.4322916666666714, -52.317708333333329, 25.682291666666671, -39.567708333333329, 8.6822916666666714, -18.317708333333329, -4.5677083333333286, 4.4322916666666714, -4.3177083333333286, 2.4322916666666714, 8.1822916666666714, 20.182291666666671, -2.8177083333333286, 34.682291666666671, -0.067708333333328596, 44.182291666666671, -1.3177083333333286, 68.182291666666671, 5.1822916666666714, 69.432291666666671, 1.9322916666666714, 48.682291666666671, -6.0677083333333286, 69.682291666666671, -0.067708333333328596, 71.182291666666671, -3.3177083333333286, 52.682291666666671, -12.317708333333329, 48.932291666666671, -27.067708333333329, 37.932291666666671, -35.067708333333329, 5.9322916666666714, -38.817708333333329, -6.5677083333333286, -46.317708333333329, -25.567708333333329, -48.317708333333329, -12.067708333333329, -34.817708333333329, -28.067708333333329, -22.067708333333329, -44.817708333333329, -2.8177083333333286, -70.567708333333329, 1.9322916666666714};
}
