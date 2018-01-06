Flock prey, predator;

void setup(){
  size(1600, 900);
  background(0, 230, 230);
  noStroke();
  //frameRate(60);
  
  prey = new Flock(Species.PREY, 500);
  predator = new Flock(Species.PREDATOR, 2);
}

void draw(){
  background(0, 230, 230); // reset background
  
  prey.behave();
  predator.behave();
  
  fill(0);
  text("Framerate: " + int(frameRate),10,height-6);
}

void mousePressed() {
  if (59 < frameRate){
    switch (mouseButton){
      case (LEFT):
        prey.addBoid(mouseX, mouseY, 10); break;
      case (RIGHT):
        if (predator.flock.size() < 4){
          predator.addBoid(mouseX, mouseY); break;
        }
    }
  }
}