//A flocking simulation based on Daniel Shiffman's chapter 
//about steering forces in 'The nature of code'.
//Starts out with boidNum boids and predNum predators. 
//Clicking adds boids.
//if Obstacles is true, the boids flee from the mouse.
//There's some control over how the boids are displayed with 'a' and 'c'.
//Behaviour is controlled with 'f', 'p' and 'o'.
//abel_jansma(at)hotmail(dot)com


ArrayList<Boid> boids = new ArrayList<Boid>(); //To store all boids in.
ArrayList<Predator> preds = new ArrayList<Predator>(); //To store all predators in.
int boidNum = 10; //Initial number of boids created.
int predNum = 2; //Initial number of predators created.
PVector mouse; //Mouse-vector to use as obstacle.
float obstRad = 60; //Radius of mouse-obstacle.
int boolT = 0; //Keeps track of time to improve user-input.

boolean flocking = true; //Toggle flocking.
boolean arrow = true; //Toggle arrows.
boolean circle = false; //Toggle circles.
boolean predBool = true; //Toggle predators.
boolean obsBool = false; //Toggle obstacles.


void setup() {
  size(800, 400);
  smooth();

  for (int i=0; i<boidNum; i++) { //Make boidNum boids.
    boids.add(new Boid(new PVector(random(0, width), random(0, height))));
  }
  for (int j=0; j<predNum; j++) { //Make predNum predators.
    preds.add(new Predator(new PVector(random(0, width), random(0, height)), 50));
  }
}

void draw() {
  //background(255, 249, 240);
  fill(255, 249, 240, 90);
  noStroke();
  rect(0, 0, width, height);
  String legend = "Flocking: f \nPredator: p \nObstacle: o \nArrows: a \nCircles: c\nAdd Boid: click";
  fill(80, 20, 50);
  text(legend, 10, 10, 150, 120);  
  text("Boids:", 10, 120);
  text(boids.size(), 50, 120);
  if (mousePressed) { //Add boid by clicking.
    boids.add(new Boid(new PVector(mouseX, mouseY)));
  }

  for (Boid boid: boids) { //Cycle through all the boids and to the following for each:
    
    if (predBool) { //Flee from each predator.
      for (Predator pred: preds) { 
        PVector predBoid = pred.getLoc();
        boid.repelForce(predBoid, obstRad);
      }
    }
    if (obsBool) { //Flee from mouse.
      mouse = new PVector(mouseX, mouseY);
      boid.repelForce(mouse, obstRad);
    }
    if (flocking) { //Execute flocking rules.
      boid.flockForce(boids);
    }
    
    boid.display(circle, arrow); //Draw to screen.
    
  }
  for (Predator pred: preds) {
    //Predators use the same flocking behaviour as boids, but they use it to chase rather than flock.
    if (flocking) { 
      pred.flockForce(boids);
      for (Predator otherpred: preds){ //Predators should not run into other predators.
        if (otherpred.getLoc() != pred.getLoc()){
          pred.repelForce(otherpred.getLoc(), 30.0);
        }
      }
    }
    pred.display();
  }

  //Toggle booleans:
  //The boolT condition is there to make sure that one press isn't interpreted as multiple presses.
  if (keyPressed && key=='p' && boolT<40) {
    predBool = !predBool;
    println("pradator:", predBool);
    boolT = 0;
  }
  if (keyPressed && key=='o' && boolT<40) {
    obsBool = !obsBool;
    println("obstacle:", obsBool);
    boolT = 0;
  }
  if (keyPressed && key=='f' && boolT<40) {
    flocking = !flocking;
    println("Flocking:", flocking);
    boolT = 0;
  }
  if (keyPressed && key=='a' && boolT<40) {
    arrow = !arrow;
    println("Arrows:", arrow);
    boolT = 0;
  }
  if (keyPressed && key=='c' && boolT<40) {
    circle = !circle;
    println("circles:", circle);
    boolT = 0;
  }
}