class Predator extends Boid { //Predators are just boids with some extra characteristics.
  float maxForce = 10; //Predators are better at steering.
  Predator(PVector location, int scope) {
    super(location);
    mass = int(random(8, 15)); //Predators are bigger and have more mass.
  }

  void display() {
    update();
    fill(255, 140, 130);
    noStroke();
    ellipse(loc.x, loc.y, mass, mass);
  }

  void update() { //Same as for boid, but with different vel.limit().
    //Calculate the next position of the boid.
    vel.add(acc);
    loc.add(vel);
    acc.mult(0); //Reset acc every time update() is called.
    vel.limit(6); //Arbitrary limit on speed, hihger for a predator.
    //Make canvas doughnut-shaped.
    if (loc.x<=0) {
      loc.x = width;
    }
    if (loc.x>width) {
      loc.x = 0;
    }
    if (loc.y<=0) {
      loc.y = height;
    }
    if (loc.y>height) {
      loc.y = 0;
    }
  }

  void approachForce(ArrayList<Boid> boids) { //Same as for boid, but with bigger approachRadius.
    float count = 0;
    PVector locSum = new PVector();

    for (Boid other: boids) {

      int approachRadius = mass + 260;
      PVector dist = PVector.sub(other.getLoc(), loc);
      float d = dist.mag();

      if (d != 0 && d<approachRadius) {
        PVector otherLoc = other.getLoc();
        locSum.add(otherLoc);
        count ++;
      }
    }
    if (count>0) {
      locSum.div(count);
      PVector approachVec = PVector.sub(locSum, loc);
      approachVec.limit(maxForce);
      applyF(approachVec);
    }
  }
}