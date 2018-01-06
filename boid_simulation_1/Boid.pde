class Boid {
  
  // initialize variable
  PVector pos, vel;
  int time;
  ArrayList<Boid> neighbour, personal;
  
  // constructor
  Boid(){
    println("No parameter passed!!!");
  }
  Boid(float x, float y){
    println("Boid generated");
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    
    time = 0;
    neighbour();
    personal();
  }
  
  void move(){
    
    // update flock
    neighbour();
    personal();
    
    PVector noise = new PVector(random(2) - 1, random(2) -1).div(5);
    
    // calculate velocity
    vel.add(cohesion());
    vel.add(alignment());
    vel.add(noise);
    vel.limit(maxSpeed);
    
    vel.add(separation());
    
    // update movement
    pos.add(vel);
    wrapAround();
    draw();
    
    
  }
  
  void neighbour(){
    
    // recreate list of neighbour
    neighbour = new ArrayList<Boid>();
    
    // check for nearby neighbour
    for (Boid boid : flock){
      float distance = PVector.dist(pos, boid.pos);
      if ((distance > 0)&&(distance < friendR)) neighbour.add(boid);
    }
  }
  
  PVector cohesion(){
    PVector center = new PVector(0,0);
    if (neighbour.size() <= 0) return center;
    else {
      for (Boid boid : neighbour){
        center.add(boid.pos);
      }
      center.div(neighbour.size()).sub(pos);
      return center.setMag(scale*0.05);
      //return center.div(neighbour.size()).sub(pos).div(PVector.dist(pos, center)*1.5);
    }
    
  }
  
  PVector alignment(){
    PVector align = new PVector(0,0);
    for (Boid boid : neighbour){
      align.add(boid.vel.copy().normalize().div(PVector.dist(pos, boid.pos)/2));
    }
    return align.mult(1.5);
  }
  
  void personal(){
    
    // recreate list of tooClose
    personal = new ArrayList<Boid>();
    
    // check for personal space
    for (Boid boid : neighbour){
      if (PVector.dist(boid.pos, this.pos) < selfR) personal.add(boid);
    }
  }
  
  /*
  PVector separation(){
    PVector avoid = new PVector(0,0);
    if (personal.size() <= 0) return avoid;
    else {
      for (Boid boid : personal){
        avoid.add(boid.pos);
      }
      avoid.div(neighbour.size());
      return PVector.sub(pos, avoid).setMag(vel.mag()/7+0.1);
    }
  }
  
  */
  
  PVector separation(){
    if (personal.size() <= 0) return new PVector(0,0);
    else {
      PVector avoid = new PVector(0,0);
      for (Boid boid : personal){
        float distance = PVector.dist(pos, boid.pos);
        avoid.add(PVector.sub(pos, boid.pos)).normalize().div(distance/selfR);
      }
      return avoid.div(7).mult(neighbour.size()/3+0.5).limit(maxSpeed*3);
    }
  }
  
  
  boolean reactionTime(){
    time = (time + 1)%5;
    if (time == 0) return true;
    else return false;
  }
  
  void draw(){
    
    // translate coordinates
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    //noFill(); stroke(0);
    //ellipse(0, 0, friendR*2, friendR*2);
    //ellipse(0, 0, selfR*2, selfR*2);
    fill(255, 255, 255);
    triangle(15*scale, 0, -7*scale, 7*scale, -7*scale, -7*scale);
    popMatrix();
    
  }
  
  void wrapAround() {
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }

}