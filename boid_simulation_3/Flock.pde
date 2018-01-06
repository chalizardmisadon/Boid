enum Species { // enum for type of boid
  PREY("prey"), PREDATOR("Predator");
  
  private final String name;
  Species(String s){
    this.name = s; // set name of species
  }
}

class Flock { // create a flock of boids
  ArrayList<Boid> flock = new ArrayList<Boid>();
  Species species; // species type variable
  int colour;
  
  Flock(){ // default constructor
    println("Default setting : Prey");
    buildSpecies(Species.PREY, 50, 255);
  }
  Flock(Species s){ // new flock of 1 boid
    buildSpecies(s, 50, 255);
  }
  Flock(Species s, int n){ // new flock of n boids
    buildSpecies(s, n, 255);
  }
  Flock(Species s, int n, int c){ // new flock of n boids c colour
    buildSpecies(s, n, c);
  }
  
  // function setting population and colour
  void buildSpecies(Species s, int n, int c){
    species = s;
    colour = c;
    addBoid(n);
    println("Building", n, species.name);
  }
  
  
  void addBoid(){ // add 1 boid
    switch (species){
      case PREY: flock.add(new Prey(random(width), random(height), colour)); break;
      case PREDATOR: flock.add(new Predator(width/2, height/2, colour)); break;
    }
  }
  void addBoid(int n){ // add multiple boid
    for (int i = 0; i < n; i++){
      addBoid();
    }
  }
  void addBoid(float x, float y){ // add 1 boid at mouse position
    switch (species){
      case PREY: flock.add(new Prey(x, y, colour)); break;
      case PREDATOR: flock.add(new Predator(x, y, colour)); break;
    }
  }
  void addBoid(float x, float y, int n){ // add n boid at mouse position
    for (int i = 0; i < n; i++){
      addBoid(x, y);
    }
  }
  
  // calculating all boid movement
  void behave(){
    for (Boid boid : flock){
      boid.move(flock);
    }
  }
}