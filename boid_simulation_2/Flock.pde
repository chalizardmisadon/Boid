// create a flock of boids

class Flock {
  ArrayList<Boid> flock;
  
  Flock(){
    flock = new ArrayList<Boid>();
  }
  
  Flock(int initial){
    flock = new ArrayList<Boid>();
    for (int i = 0; i < initial; i++){
      flock.add(new Boid(0, 0));
    }
  }
  
  void behave(){
    for (Boid boid : flock){
      boid.move();
    }
  }
  
  void addBoid(Boid boid){
    flock.add(boid);
  }
}