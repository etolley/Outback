public class Constellation{
  private ArrayList<Star> stars;
  
  
  Constellation(float h){
    stars = new ArrayList<Star>();
    for (int r = 100; r < width; r+= 10){
      for (int i = 0; i < 5; i++){
        float phi = random(0,2*3.14159);
        float x = r*cos(phi);
        float y = r*sin(phi);
        if (y > height-h*1.1) continue;
        stars.add(new Star(x, y));
      }
    }
  }
  
  void draw(){

    for (Star s: stars) s.draw();
  }
}

public class Star{
  private float x;
  private float y;
  private float r;
  
  Star(float x_in, float y_in){
    x = x_in;
    y= y_in;
    r = random(1.5,3.5);
  }
  
  void draw(){
    pushMatrix();
    translate(x,y);
    noStroke();

    float fade = 0;
    if (frameCount > 600)
      fade = min(255,(frameCount-600)/2.);
    fill(colors.LIGHT,50*fade/100.);
    //float rscale = 1+1*sin(0.005*frameCount);
    //println(  sm.getElement(2).name(), sm.getElement(2).amplitude(0));
    float rscale = 200*sm.getElement(2).amplitude(2);
    ellipse(0,0,r*rscale,r*rscale);
    fill(colors.LIGHT, fade);
    ellipse(0,0,r,r);
    popMatrix();
  }
  
  
  
}
