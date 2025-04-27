int numSegments = 40;
PVector[] segments;
float[] angles;
float segLength = 15;
color baseColor;
ArrayList<Particle> particles;

void setup() {
  size(800, 600);
  smooth();
  segments = new PVector[numSegments];
  angles = new float[numSegments];
  particles = new ArrayList<Particle>();
  
  for (int i = 0; i < numSegments; i++) {
    segments[i] = new PVector(width/2, height/2);
    angles[i] = 0;
  }
  
  baseColor = color(255, 50, 50); // Color inicial: rojo-anaranjado
}

void draw() {
  background(0, 30); // Fondo semi-transparente para dejar "rastro fantasma"

  moveSegments();
  drawDragon();
  drawParticles();
  
  if (mousePressed) {
    spawnParticles();
  }
}

void moveSegments() {
  PVector target = new PVector(mouseX, mouseY);
  segments[0] = PVector.lerp(segments[0], target, 0.2);
  for (int i = 1; i < numSegments; i++) {
    segments[i] = PVector.lerp(segments[i], segments[i-1], 0.2);
    angles[i] = atan2(segments[i-1].y - segments[i].y, segments[i-1].x - segments[i].x);
  }
}

void drawDragon() {
  for (int i = 0; i < numSegments; i++) {
    float size = map(i, 0, numSegments, 20, 5);
    float speed = dist(segments[i].x, segments[i].y, segments[0].x, segments[0].y);
    color dynamicColor = lerpColor(baseColor, color(50, 100, 255), constrain(speed/100.0, 0, 1));
    
    fill(dynamicColor);
    noStroke();
    ellipse(segments[i].x, segments[i].y, size, size);
    
    // Líneas curvas como aletas laterales
    if (i % 4 == 0 && i > 0) {
      stroke(255, 80);
      strokeWeight(1);
      noFill();
      bezier(segments[i].x, segments[i].y,
             segments[i].x + 30 * cos(angles[i] + HALF_PI), segments[i].y + 30 * sin(angles[i] + HALF_PI),
             segments[i].x + 50 * cos(angles[i] + HALF_PI), segments[i].y + 50 * sin(angles[i] + HALF_PI),
             segments[i].x + 70 * cos(angles[i] + HALF_PI), segments[i].y + 70 * sin(angles[i] + HALF_PI));
    }
  }
  
  drawHead();
}

void drawHead() {
  pushMatrix();
  translate(segments[0].x, segments[0].y);
  float headAngle = atan2(segments[1].y - segments[0].y, segments[1].x - segments[0].x);
  rotate(headAngle);
  
  fill(255);
  stroke(0);
  strokeWeight(2);
  
  beginShape();
  vertex(0, -15);
  vertex(30, 0);
  vertex(0, 15);
  vertex(-5, 0);
  endShape(CLOSE);
  
  // Ojo
  fill(0);
  ellipse(15, -5, 5, 5);
  popMatrix();
}

void spawnParticles() {
  for (int i = 0; i < 5; i++) {
    particles.add(new Particle(segments[numSegments-1].x, segments[numSegments-1].y));
  }
}

void drawParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}

// Clase para las partículas
class Particle {
  PVector pos;
  PVector vel;
  float lifespan;
  
  Particle(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.mult(random(1, 3));
    lifespan = 255;
  }
  
  void update() {
    pos.add(vel);
    lifespan -= 4;
  }
  
  void display() {
    noStroke();
    fill(255, lifespan);
    ellipse(pos.x, pos.y, 4, 4);
  }
  
  boolean isDead() {
    return lifespan <= 0;
  }
}
