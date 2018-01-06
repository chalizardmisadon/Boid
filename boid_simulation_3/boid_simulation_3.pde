ArrayList<Flock> preyList = new ArrayList<Flock>();
Flock predator;

void setup(){
  size(1600, 900);
  background(0, 230, 230);
  noStroke();
  //frameRate(60);
  
  for (int i = 0; i < 1; i++){
    preyList.add(new Flock(Species.PREY, 600, 255-100*i));
  }
  predator = new Flock(Species.PREDATOR, 2);
}

void draw(){
  background(0, 230, 230); // reset background
  
  for (Flock flock : preyList){
    flock.behave();
  }
  predator.behave();
  
  fill(0);
  text("Framerate: " + int(frameRate),10,height-6);
}

void mousePressed() {
  switch (mouseButton){
    case (LEFT): preyList.get(0).addBoid(mouseX, mouseY, 10); break;
    case (RIGHT): predator.addBoid(mouseX, mouseY); break;
  }
}