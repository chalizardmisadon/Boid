# Boid Behaviour
Boid is an algorithm that simulates flocking behaviour developed by [Craig Reynolds](https://www.red3d.com/cwr/boids/). The complex behaviour of a flock comes from each boid following three simple rules: cohesion, alignment, separation.

This code was written based on [Chapter 6 of The Nature of Code by Daniel Shiffman](http://natureofcode.com/book/chapter-6-autonomous-agents/). The simulation includes prey and predator model, and is optimized with spatial subdivision.

#There are 4 versions of the code:  
v1: testing out concept, create basic boid behaviour  
v2: add Flock class to manage a group of boid (thinking of creating multiple different flock)  
v3: from Boid class create subclass of Prey and Predator, and use Flock class to manage each  
v4: optimize using bin-lattice spatial subdivision, add aesthetic and randomness to individual boid  
