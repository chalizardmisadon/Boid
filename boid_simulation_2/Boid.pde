class Boid {
  PVector position, velocity, acceleration;
  PVector desired, steer;
  PVector cohesion, alignment, separation;
  ArrayList<Boid> neighbour, personal;
  float distance;
  int time;
  
  Boid(){
    println("No parameter passed");
  }
  
  Boid(float x, float y){
    position = new PVector(x, y);
    velocity = PVector.random2D();
    acceleration = new PVector(0,0);
    
    desired = new PVector(0, 0);
    steer = new PVector(0, 0);
    neighbour = new ArrayList<Boid>();
    personal = new ArrayList<Boid>();
    
  }
  
  void move(){
    if (think()){
      neighbour(species.flock);
      personal();
    }
    
    // calculate all force
    cohesion = cohesion();
    alignment = alignment();
    separation = separation();
    
    // Weight force by a factor
    cohesion.mult(1.0);
    alignment.mult(1.0);
    separation.mult(4);
    
    // accumulate acceleration
    acceleration.add(cohesion);
    acceleration.add(alignment);
    acceleration.add(separation);
    
    PVector noise = new PVector(random(2) - 1, random(2) -1).div(4);
    
    velocity.add(acceleration).add(noise).limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
    
    wrap();
    draw();
    
  }
  
  void neighbour(ArrayList<Boid> flock){
    neighbour = new ArrayList<Boid>(); // recreate list of neighbour
    
    // check for nearby neighbour
    for (Boid boid : flock){
      distance = PVector.dist(boid.position, position);
      if ((distance > 0)&&(distance < friendR)) neighbour.add(boid);
    }
  }
  
  PVector cohesion(){
    desired.mult(0); // empty vector to find center of mass
    if (neighbour.size() == 0) return desired;
    else {
      for (Boid boid : neighbour){
        desired.add(boid.position); // sum all position
      }
      desired.div(neighbour.size()); // find center of mass
      
      // using Craig Reynolds' Seek Behaviour
      desired = PVector.sub(desired, position); // vector point from position to target
      desired.setMag(maxSpeed); // desired velocity to reach target
      steer = PVector.sub(desired, velocity); // find steering force
      steer.limit(maxForce); // limit force
      
      return steer;
    }
  }
  
  /*
  PVector seek(PVector target){ // seek destination
    PVector desired = PVector.sub(target, position); // vector point from position to target
    desired.setMag(maxSpeed); // desired velocity for this situation
    
    PVector steer = PVector.sub(desired, velocity); // finding force vector
    steer.limit(maxForce); // desired force for this situation
    return steer;
  }
  */
  
  PVector alignment(){
    desired.mult(0); // empty vector to accumulate nearby velocities
    if (neighbour.size() == 0) return desired;
    else {
      for (Boid boid : neighbour){
        desired.add(boid.velocity); // sum all velocity of group
      }
      
      // using Craig Reynolds' Steer Behaviour
      desired.setMag(maxSpeed); // limit desired speed
      steer = PVector.sub(desired, velocity); // find steering force
      steer.limit(maxForce); // limit force
      
      return steer;
    }
  }
  
  void personal(){
    personal = new ArrayList<Boid>(); // recreate list of neighbour
    
    // check for nearby neighbour
    for (Boid boid : neighbour){
      distance = PVector.dist(boid.position, position);
      if ((distance > 0)&&(distance < selfR)) personal.add(boid);
    }
  }
  
  PVector separation(){
    if (personal.size() == 0) return new PVector(0,0);
    else {
      for (Boid boid : personal){
        steer = PVector.sub(position, boid.position);
        steer.normalize().div(steer.mag());
        desired.add(steer); // reusing steer to reduce calculation time
      }
      
      // using Craig Reynolds' Flee Behaviour (reverse Seek)
      desired.setMag(maxSpeed); // limit desired speed
      steer = PVector.sub(desired, velocity); // find steering force
      steer.limit(maxForce); // limit force
      
      return steer;
    }
  }
  
  boolean think(){
    time = (time +1)% 5;
    return time == 0;
  }
    
  
  void draw(){
    // translate coordinates
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    
    // display radius of behaviour
    //noFill(); stroke(0);
    //ellipse(0, 0, friendR*2, friendR*2);
    //ellipse(0, 0, selfR*2, selfR*2);
    fill(255, 255, 255);
    
    // draw triangle
    triangle(15*global, 0, -7*global, 7*global, -7*global, -7*global);
    popMatrix();
    
  }
  
  
  void wrap(){ // warp around the screen
   position.x = (position.x + width) % width;
   position.y = (position.y + height) % height;
  }
}