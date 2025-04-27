// Variables de rotación
float yaw = 0;    // Rotación izquierda-derecha (eje Y)
float pitch = 0;  // Inclinación arriba-abajo (eje X)
float roll = 0;   // Giro sobre sí mismo (eje Z)

float rotationSpeed = 0.02;  // Velocidad de rotación

void setup() {
  size(800, 600, P3D);
}

void draw() {
  background(180);
  lights();
  
  // Cámara fija mirando al centro
  camera(0, -150, 300, 0, 0, 0, 0, 1, 0);

  // --- Manejar teclas presionadas ---
  if (keyPressed) {
    if (key == 'a') yaw -= rotationSpeed;   // Girar izquierda
    if (key == 'd') yaw += rotationSpeed;   // Girar derecha
    if (key == 'w') pitch -= rotationSpeed; // Inclinación arriba
    if (key == 's') pitch += rotationSpeed; // Inclinación abajo
    if (key == 'q') roll -= rotationSpeed;  // Rodar izquierda
    if (key == 'e') roll += rotationSpeed;  // Rodar derecha
  }

  // --- Dibujar el suelo ---
  pushMatrix();
  translate(0, 100, 0);  // Bajarlo un poco
  rotateX(HALF_PI);      // Girar para que esté plano
  fill(100, 200, 100);
  noStroke();
  rect(-5000, -5000, 10000, 10000);  // Suelo grande
  popMatrix();

  // --- Dibujar el dron ---
  pushMatrix();
  translate(0, 0, 0);  // Dron suspendido en el centro
  rotateZ(roll);
  rotateX(pitch);
  rotateY(yaw);
  
  // Cuerpo principal del dron
  fill(0, 0, 255);
  box(30, 10, 30);

  // Brazos de las hélices
  fill(255, 0, 0);
  box(10, 2, 100); // Adelante-atrás
  box(100, 2, 10); // Izquierda-derecha

  popMatrix();
}
