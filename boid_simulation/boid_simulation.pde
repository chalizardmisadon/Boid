// boid behaviour variables
float scale = 1;
float friendR = 120*scale;
float selfR = 40*scale;
float maxSpeed = 3.7*scale;


// object lists
ArrayList<Boid> flock;

// setup()
void setup(){
  
  // screen settings
  frameRate(60);
  background(0, 230, 230);
  size(1600, 900);
  noStroke();
  
  // initialize variables
  flock = new ArrayList<Boid>();
  for (int i = 0; i < 250; i++){
    flock.add(new Boid(0, 0));
  }
}

void draw(){
  
  // reset background
  background(0, 230, 230);
  //fill(0, 230, 230,50);
  //rect(0, 0, width, height);
  
  
  // boid movement
  for (Boid boid : flock){
    
    boid.move();
    
  }
  
}

void mousePressed(){
  flock.add(new Boid(mouseX, mouseY));
}