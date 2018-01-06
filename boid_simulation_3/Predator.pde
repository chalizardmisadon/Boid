class Predator extends Boid {
  // properties of predator
  static final float crowdR = 200;
  static final float selfR = 100;
  static final float huntR = 200;
  static final float maxSpeed = 3;
  static final float maxForce = 0.05;
  
  Predator(){
    super();
  }
  Predator(int c){
    super(c);
  }
  Predator(float x, float y){
    super(x, y);
  }
  Predator(float x, float y, int c){
    super(x, y, c);
  }
  
  void buildBoid(float x, float y, int c){ // function setting
    super.buildBoid(x, y, c);
    size = random(0.8, 1.2);
  }
  
  void applyForce(ArrayList<Boid> flock){
    // Cohesion acceleration
    acceleration = calcForce(cohesion(flock));
    acc.add(acceleration.mult(0.2)); // Weight the force
    
    // Alignment acceleration
    acceleration = calcForce(alignment(flock));
    acc.add(acceleration.mult(0.5)); // Weight the force
    
    // Separation acceleration
    acceleration = calcForce(separation(flock));
    acc.add(acceleration.mult(4)); // Weight the force
    
    // Hunting acceleration
    acceleration = calcForce(hunt());
    acc.add(acceleration.mult(1)); // Weight the force
    
    // add noise
    noise =  new PVector(random(-1, 1), random(-1, 1)).div(4);
    
    // update position and speed
    vel.add(acc).add(noise).limit(maxSpeed); // limit speed before noise
    pos.add(vel);
    acc = new PVector(0,0); // reset acceleration
  }
  
  PVector calcForce(PVector desired){
    steer = new PVector(0, 0);
    if (desired.magSq() > 0){ // if there is a non-zero vector
      desired.setMag(maxSpeed); // limit desired speed
      steer = PVector.sub(desired, vel); // find steering force
      steer.limit(maxForce); // limit force
    }
    return steer;
  }
  
  PVector cohesion(ArrayList<Boid> flock){
    return cohesion(flock, crowdR);
  }
  
  PVector alignment(ArrayList<Boid> flock){
    return alignment(flock, crowdR);
  }
  
  PVector separation(ArrayList<Boid> flock){
    return separation(flock, selfR);
  }
  
  PVector hunt(){ // goes for group center of mass
    center = new PVector(0, 0);
    count = 0;
    
    for (Flock species : preyList){ // Accessing prey species list
      for (Boid boid : species.flock){
        distance = PVector.dist(boid.pos, pos);
        if ((distance > 0)&&(distance < huntR)){ // check for prey
          center.add(boid.pos); // add position
          count++;
        }
      }
    }
    if (count > 0){ // there is prey
      center.div(count); // average position (target)
      center.sub(pos); // vector point from position to target
    }
    return center;
  }
  
  /* hunting based on cohesion rule
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
  
  3 Hunting options:
    head for global group center
    head for closest prey
    head for biggest/closest local group center
    
  hunt() function above use cohesion rule and head for group center
  */
  
  void draw(){
    // translate coordinates
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    
    // display radius of behaviour
    //noFill(); stroke(0);
    //ellipse(0, 0, crowdR*2, crowdR*2);
    //ellipse(0, 0, selfR*2, selfR*2);
    fill(255, 0, 0);
    
    // draw triangle
    triangle(30*size, 0, -14*size, 14*size, -14*size, -14*size);
    popMatrix(); 
  }
  
}