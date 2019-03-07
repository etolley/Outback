public class Constellation {
  private ArrayList<Star> stars;


  Constellation(float h) {
    stars = new ArrayList<Star>();
    for (int r = 100; r < width; r+= 10) {
      for (int i = 0; i < 5; i++) {
        float phi = random(0, 2*3.14159);
        float x = r*cos(phi);
        float y = r*sin(phi);
       // if (y > height-h*1.1) continue;
        stars.add(new Star(x, y,h));
      }
    }
  }

  void draw() {

    for (Star s : stars) s.draw();
  }
}

public class Star {
  private float x;
  private float y;
  private float r;
  private float centerx;
  private float centery;
  private float phi;
  private float dphi;
  private float horizon;

  Star(float x_in, float y_in, float h_in) {
    x = x_in;
    y= y_in;
    centerx = 0;
    centery = 0;
    horizon = h_in;
    r = random(1.5, 3.5);
    phi = 0;
    dphi = random(0.001/2,0.002/2);
  }
  
  Star(float x_in, float y_in, float xcenter_in, float ycenter_in) {
    this(x_in,y_in,0);
    centerx = xcenter_in;
    centery = ycenter_in;
  }

  void draw() {
    pushMatrix();
    rotate(phi);
    phi+= dphi;
    translate(x, y);
    
    
    noStroke();

    float fade = 0;
    if (frameCount > 1200)
      fade = (frameCount-1200)/4.;
    if (frameCount > 6000)
      fade = 255 - (frameCount-6000)/4.;
      
    if (fade > 255) fade = 255;
    if (fade < 0) fade = 0;
    //if (y > height-horizon*1.1) fade = 0;
    // TODO: fade out again at 6000
    fill(colors.LIGHT, 50*fade/100.);
    //float rscale = 1+1*sin(0.005*frameCount);
    //println(  sm.getElement(2).name(), sm.getElement(2).amplitude(0));
    //float rscale = 200*sm.getElement(2).amplitude(2);
    //ellipse(0, 0, r*rscale, r*rscale);
    fill(colors.LIGHT, fade);
    ellipse(0, 0, r, r);
    popMatrix();
  }
}

class Moon {
  private float x;
  private float y;
  private float phi;
  Moon() {
    x = width/2.;
    y= height/2.;
    phi = PI/3.;
  }
  
  void update(){
    x = width/2 + 400*cos(phi);
    y = height*horizon - 600 + 400*sin(phi);
    float dphi = 0;
    if (frameCount < 6000)
     dphi = (PI/2-phi)/300.;
    else
     dphi = max(0.00001 + (PI/2-phi)/300.,0.001);
    phi += dphi;
  }

  void draw(float xcenter, float ycenter) {
    
    update();
    
    float dmidx = (xcenter - x);
    float dmidy = (ycenter - y);
    float dmidr = sqrt(dmidx*dmidx + dmidy*dmidy);
    float phimid = atan2(dmidy, dmidx);

    noStroke();
    fill(colors.LIGHT);
    ellipse(x,y,160,160);
   
    
    fill(colors.MEDIUM);
    
    float shadowr = 150-dmidr/10.;
    dmidr = min( (160-shadowr)/2.,dmidr);
    
    float shadowr2 = (3*shadowr+160)/4.;
    ellipse(x-dmidr*cos(phimid)*3/4.,y - dmidr*sin(phimid)*3/4.,shadowr2,shadowr2);
    
    fill(colors.DARKER);
    //shadowr = 150-dmidr/10.;
    //dmidr = min( (160-shadowr)/2.,dmidr);
    ellipse(x-dmidr*cos(phimid),y - dmidr*sin(phimid),shadowr,shadowr);
    //arc(x, y, 150, 150, phimid - PI/2, phimid + PI/2, CHORD );
    /*int rings = 4;
    float ringspace = 5.0;
    for (int i = 0; i < rings; i++) {
      fill(lerpColor(colors.LIGHT, colors.MEDIUM, i/(rings-1.)));
      ellipse(x+i*min(ringspace/2.,dmidx/5.), y+i*min(ringspace/2.,dmidy/5.), 160-i*ringspace, 160-i*ringspace);
    }
    fill(colors.DARKER);
    ellipse(x+rings*min(ringspace/2.,dmidx/5.), y+rings*min(ringspace/2.,dmidy/5.), 160-rings*ringspace, 160-rings*ringspace);*/
  }
}
