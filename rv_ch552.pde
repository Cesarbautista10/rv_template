// Variables del jugador
int playerX, playerY;
int playerSpeed = 6;
boolean moveLeft = false;
boolean moveRight = false;

// Variables de los disparos
ArrayList<Projectile> projectiles;

// Variables de los bloques
ArrayList<Block> blocks;

// Juego
int score = 0;
int gameTime = 30;  // duración del juego en segundos
int startTime;
boolean gameOver = false;
boolean victory = false;
boolean gameStarted = false; // << NUEVO: indica si el juego ya empezó

// Disparo automático
boolean shooting = false;
int shootDelay = 200; // Tiempo entre disparos (milisegundos)
int lastShotTime = 0;

void setup() {
  size(800, 600);
  initGame();
}

void draw() {
  background(0);
  
  int currentTime = millis();
  
  if (!gameStarted) {
    // Mostrar mensaje para iniciar
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Presiona Espacio para comenzar", width/2, height/2);
    return; // << Salimos hasta que presione Space
  }
  
  if (!gameOver) {
    // Movimiento continuo
    if (moveLeft) {
      playerX -= playerSpeed;
      if (playerX < 25) playerX = 25;
    }
    if (moveRight) {
      playerX += playerSpeed;
      if (playerX > width - 25) playerX = width - 25;
    }
  
    // Disparo automático
    if (shooting && currentTime - lastShotTime > shootDelay) {
      projectiles.add(new Projectile(playerX, playerY));
      lastShotTime = currentTime;
    }
  
    // Dibujar jugador
    fill(0, 255, 0);
    ellipse(playerX, playerY, 50, 50);
  
    // Dibujar disparos
    for (int i = projectiles.size() - 1; i >= 0; i--) {
      Projectile p = projectiles.get(i);
      p.update();
      p.display();
    
      if (p.y < 0) {
        projectiles.remove(i);
      }
    }
  
    // Dibujar bloques
    for (int i = blocks.size() - 1; i >= 0; i--) {
      Block b = blocks.get(i);
      b.display();
    
      for (int j = projectiles.size() - 1; j >= 0; j--) {
        Projectile p = projectiles.get(j);
        if (b.hit(p)) {
          blocks.remove(i);
          projectiles.remove(j);
          score += 10;
          break;
        }
      }
    }
  
    // Mostrar puntaje y tiempo
    fill(255);
    textSize(24);
    textAlign(LEFT);
    text("Score: " + score, 20, 40);
    
    int elapsed = (currentTime - startTime) / 1000;
    int timeLeft = max(0, gameTime - elapsed);  // << Solo enteros
    text("Time Left: " + timeLeft, 20, 80);
  
    // Comprobar condiciones de fin
    if (blocks.size() == 0 && !gameOver) {
      gameOver = true;
      victory = true;
    }
  
    if ((elapsed >= gameTime) && !gameOver) {
      gameOver = true;
      victory = false;
    }
  } else {
    // Mostrar mensaje de fin
    background(30);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    if (victory) {
      text("¡Victoria!\nPresiona Espacio para reiniciar", width/2, height/2 - 30);
    } else {
      text("¡Juego Terminado!\nPresiona Espacio para reiniciar", width/2, height/2 - 30);
    }
  }
}

void keyPressed() {
  if (!gameStarted) {
    if (key == ' ') {
      gameStarted = true;
      startTime = millis(); // << Ahora sí empezamos a contar
    }
  } else if (!gameOver) {
    if (key == ' ') {
      shooting = true;
    } else if (key == 'a' || key == 'A') {
      moveLeft = true;
    } else if (key == 'd' || key == 'D') {
      moveRight = true;
    }
  } else {
    if (key == ' ') {
      initGame();
      gameStarted = false; // << Esperamos Space otra vez
    }
  }
}

void keyReleased() {
  if (gameStarted && !gameOver) {
    if (key == ' ') {
      shooting = false;
    } else if (key == 'a' || key == 'A') {
      moveLeft = false;
    } else if (key == 'd' || key == 'D') {
      moveRight = false;
    }
  }
}

void initGame() {
  playerX = width / 2;
  playerY = height - 50;
  
  projectiles = new ArrayList<Projectile>();
  blocks = new ArrayList<Block>();
  
  spawnBlocks();
  
  score = 0;
  startTime = 0;  // << No iniciar contador aquí
  gameOver = false;
  victory = false;
  shooting = false;
  moveLeft = false;
  moveRight = false;
}

void spawnBlocks() {
  int cols = 8;
  int rows = 3;
  int blockWidth = 80;
  int blockHeight = 40;
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = 60 + i * (blockWidth + 10);
      int y = 60 + j * (blockHeight + 10);
      blocks.add(new Block(x, y, blockWidth, blockHeight));
    }
  }
}

// Clases
class Projectile {
  float x, y;
  float speed = 8;
  
  Projectile(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    y -= speed;
  }
  
  void display() {
    stroke(0, 255, 0);
    line(x, y, x, y - 10);
  }
}

class Block {
  float x, y, w, h;
  
  Block(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    noStroke();
    fill(255, 0, 0);
    rect(x, y, w, h);
  }
  
  boolean hit(Projectile p) {
    return (p.x > x && p.x < x + w && p.y > y && p.y < y + h);
  }
}
