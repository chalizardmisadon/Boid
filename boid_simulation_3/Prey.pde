class Prey extends Boid {
  // properties of prey
  static final float crowdR = 80;
  static final float selfR = 40;
  static final float fleeR = 120;
  static final float maxSpeed = 3;
  static final float maxForce = 0.05;
  
  PVector future;
  
  Prey(){
    super();
  }
  Prey(int c){
    super(c);
  }
  Prey(float x, float y){
    super(x, y);
  }
  Prey(float x, float y, int c){
    super(x, y, c);
  }
  
  void buildBoid(float x, float y, int c){ // function setting
    super.buildBoid(x, y, c);
    size = random(0.8, 1.3); // randomize size
  }
  
  
  void applyForce(ArrayList<Boid> flock){
    // Cohesion acceleration
    acceleration = calcForce(cohesion(flock));
    acc.add(acceleration.mult(1)); // Weight the force
    
    // Alignment acceleration
    acceleration = calcForce(alignment(flock));
    acc.add(acceleration.mult(2)); // Weight the force
    
    // Separation acceleration
    acceleration = calcForce(separation(flock));
    acc.add(acceleration.mult(4)); // Weight the force
    
    // Avoid acceleration
    acceleration = calcForce(flee());
    acc.add(acceleration.mult(8)); // Weight the force
    
    
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
  
  PVector flee(){
    future = PVector.add(pos, vel); // using future position
    center = new PVector(0, 0);
    steer = new PVector(0, 0);
    for (Boid boid : predator.flock){
      distance = PVector.dist(boid.pos, future); // check using future position
      if ((distance > 0)&&(distance < fleeR)){ // check for predator
        center = PVector.sub(future, boid.pos); // separate from center
        center.div(distance); // weight by distance (closer = more danger)
        steer.add(center); // accumulate direction
      }
      
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
  
  
  void draw(){
    // translate coordinates
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    
    // display radius of behaviour
    //noFill(); stroke(0);
    //ellipse(0, 0, crowdR*2, crowdR*2);
    //ellipse(0, 0, selfR*2, selfR*2);
    fill(colour, colour, colour);
    
    // draw triangle
    triangle(15*size, 0, -7*size, 7*size, -7*size, -7*size);
    popMatrix(); 
  }
  
}