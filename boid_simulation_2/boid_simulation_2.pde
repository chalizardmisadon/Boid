// Based on Craig Reynolds' Boid Algorithm

// global values
float global = 1;

float friendR = 60*global;
float selfR = 40*global;

float maxForce = 0.05*global;
float maxSpeed = 2.5;

Flock species;

void setup(){
  // background(0, 230, 230);
  size(1600, 900);
  noStroke();
  
  species = new Flock(200);
}

void draw(){
  
  background(0, 230, 230); // reset background
  species.behave(); // process behaviour
}

void mousePressed(){
  species.addBoid(new Boid(mouseX, mouseY));
}