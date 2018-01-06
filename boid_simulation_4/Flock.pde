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
  
  // bin-lattice
  int boidX, boidY, cellX, cellY;
  int cellSize = 100, row = width/cellSize, column = height/cellSize;
  ArrayList<Boid>[][] lattice = new ArrayList[row][column];
  ArrayList<Boid>[][] preyGrid = new ArrayList[row][column];
  
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
  
  // 
  void lattice(){
    for (int i = 0; i < row; i++){ // clear lattice
      for (int j = 0; j < column; j++){
        lattice[i][j] = new ArrayList<Boid>();
        preyGrid[i][j] = new ArrayList<Boid>();
      }
    }
    for (Boid boid : flock){ // gridding boids
      boidX = int(boid.pos.x)/cellSize;
      boidY = int(boid.pos.y)/cellSize;
      
      for (int i = -1; i <= 1; i++){ // adding to 3x3
        for (int j = -1; j <= 1; j++){
          cellX = (boidX + i + row) % row;
          cellY = (boidY + j + column) % column;
          lattice[cellX][cellY].add(boid);
        }
      }
      for (int i = -2; i <= 2; i++){ // adding to 5x5
        for (int j = -2; j <= 2; j++){
          cellX = (boidX + i + row) % row;
          cellY = (boidY + j + column) % column;
          preyGrid[cellX][cellY].add(boid);
        }
      }
    }
  }
  
  
  void behave(){ // calculating all boid movement
    switch (species){
      case PREY:
        lattice();
        for (Boid boid : flock){
          boidX = int(boid.pos.x)/cellSize;
          boidY = int(boid.pos.y)/cellSize;
          boid.move(lattice[boidX][boidY]);
        }
        break;
      case PREDATOR:
        for (Boid boid : flock){
          boidX = int(boid.pos.x)/cellSize;
          boidY = int(boid.pos.y)/cellSize;
          boid.move(prey.preyGrid[boidX][boidY]);
        }
        break;
    }
  }
}