class Prey extends Boid {
  static final float defaultCrowdR = 60;
  static final float defaultSelfR = 40;
  static final float defaultMaxSpeed = 3;
  static final float defaultMaxForce = 0.05;
  
  float crowdR, selfR, maxSpeed, maxForce;
  
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
  
  void buildBoid(float x, float y, int c){
    super.buildBoid(x, y, c);
    crowdR = defaultCrowdR+(max(1, size)-0.8)*80;
    selfR = defaultSelfR+(min(1, size)-1)*30;
    maxSpeed = defaultMaxSpeed/(min(1, size)/4+0.75);
    maxForce = defaultMaxForce/(size/2+1);
  }
  
  void applyForce(ArrayList<Boid> flock){
    // calculate force
    cohesion = calcForce(cohesion(flock));
    alignment = calcForce(alignment(flock));
    separation = calcForce(separation(flock));
    
    // Weight force
    acc.add(cohesion.mult(1));
    acc.add(alignment.mult(2));
    acc.add(separation.mult(4));
    
    // add noise
    noise =  new PVector(random(2)-1, random(2)-1).div(4);
    
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
  
  void draw(){
    // translate coordinates
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    
    // display radius of behaviour
    noFill(); stroke(0);
    ellipse(0, 0, crowdR*2, crowdR*2);
    ellipse(0, 0, selfR*2, selfR*2);
    fill(colour, colour, colour);
    
    // draw triangle
    triangle(15*size, 0, -7*size, 7*size, -7*size, -7*size);
    popMatrix(); 
  }
  
}