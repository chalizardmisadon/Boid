ArrayList<Flock> flock = new ArrayList<Flock>();

void setup(){
  size(1600, 900);
  background(0, 230, 230);
  noStroke();
  
  for (int i = 0; i < 2; i++){
    flock.add(new Flock(Species.PREY, 10, 255-100*i));
  }
}

void draw(){
  background(0, 230, 230); // reset background
  
  for (Flock species : flock){
    species.behave();
  }
  
}

void mousePressed() {
  switch (mouseButton){
    case (LEFT): flock.get(0).addBoid(mouseX, mouseY, 10); break;
    case (RIGHT): break;
  }
}