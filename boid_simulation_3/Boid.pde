class Boid { // basic boid class
  PVector pos;
  PVector vel = PVector.random2D();
  PVector acc = new PVector(0,0);
  
  PVector center, steer, noise;
  PVector acceleration;
  
  //float crowdR, selfR, speed, force;
  float distance, size;
  int count, colour;
  
  Boid(){ // default position
    buildBoid(0, 0, 255);
  }
  Boid(int c){ // default position with colour
    buildBoid(0, 0, c);
  }
  Boid(float x, float y){ // set position
    buildBoid(x, y, 255);
  }
  Boid(float x, float y, int c){ // set position with colour
    buildBoid(x, y, c);
  }
  
  void buildBoid(float x, float y, int c){ // function setting
    pos = new PVector(x, y);
    colour = c;
  }
  
  void move(ArrayList<Boid> flock){
    applyForce(flock);
    
    // animate and edge detection
    wrap();
    draw();
  }
  
  void applyForce(ArrayList<Boid> flock){
  }
  
  
  PVector cohesion(ArrayList<Boid> flock, float radius){
    center = new PVector(0,0);
    count = 0;
    for (Boid boid : flock){
      distance = PVector.dist(boid.pos, pos);
      if ((distance > 0)&&(distance < radius)){ // check for neighbour
        center.add(boid.pos); // add position
        count++;
      }
    }
    if (count > 0){
      center.div(count); // average position (target)
      center.sub(pos); // vector point from position to target
    }
    return center;
  }
  
  PVector alignment(ArrayList<Boid> flock, float radius){
    center = new PVector(0,0);
    for (Boid boid : flock){
      distance = PVector.dist(boid.pos, pos);
      if ((distance > 0)&&(distance < radius)){ // check for neighbour
        center.add(boid.vel); // accumulate velocity
      }
    }
    return center;
  }
  
  PVector separation(ArrayList<Boid> flock, float radius){
    center = new PVector(0,0);
    steer = new PVector(0,0);
    for (Boid boid : flock){
      distance = PVector.dist(boid.pos, pos);
      if ((distance > 0)&&(distance < radius)){ // check for neighbour
        center = PVector.sub(pos, boid.pos); // separate from center
        center.div(distance); // weight by distance
        steer.add(center); // accumulate direction
      }
    }
    return steer;
  }
  
  void draw(){
  }
  
  void wrap(){ // warp around the screen
   pos.x = (pos.x + width) % width;
   pos.y = (pos.y + height) % height;
  }
  
}