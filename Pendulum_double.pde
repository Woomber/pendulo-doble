final float gravedad = 1.1;
final float frict = 0.9999;

Pendulo p1, p2;

final int cx = 700, cy = 700;
int anchorX, anchorY;
boolean draw = false;

PGraphics pg;
float old_x, old_y;

void settings(){
  size(cx, cy);
  anchorX = width/2;
  anchorY = height/2;
}

void setup(){
  // Crear péndulos
  p1 = new Pendulo(150, 25, random(0, 2*PI));
  p2 = new Pendulo(150, 25, random(0, 2*PI));
 
  stroke(0);
  fill(0);
   
  pg = createGraphics(cx, cy); 
  pg.beginDraw();
  pg.background(255);
  pg.strokeWeight(1);
  pg.stroke(150);
  pg.endDraw();
  
   draw = false;
}

void draw(){
 background(255);
 image(pg, 0, 0);
 
 //Mover al punto de anclaje
 translate(anchorX, anchorY);

 // Calcular aceleración de péndulos
 float calculo = (-gravedad * (2*p1.masa + p2.masa) * sin(p1.angulo) -
   p2.masa * gravedad * sin(p1.angulo - 2*p2.angulo) - 2 * sin(p1.angulo - p2.angulo) * 
   p2.masa * (p2.vel * p2.vel * p2.cuerda + p1.vel * p1.vel * p1.cuerda * cos(p1.angulo - p2.angulo)))
   / (p1.cuerda * (2*p1.masa + p2.masa - p2.masa * cos(2*p1.angulo - 2*p2.angulo))); 
   
 float calculo2 = 2 * sin(p1.angulo - p2.angulo) * ( p1.vel * p1.vel * p1.cuerda * (p1.masa + p2.masa)
   + gravedad * (p1.masa + p2.masa) * cos(p1.angulo) + p2.vel * p2.vel * p2.cuerda * p2.masa * cos(p1.angulo - p2.angulo))
   / (p2.cuerda * (2*p1.masa + p2.masa - p2.masa * cos(2*p1.angulo - 2*p2.angulo)));
   
  // Acelerar y dibujar
  p1.acelerar(calculo, frict);
  p2.acelerar(calculo2, frict);
  p1.dibujar();
  p2.dibujar(p1.x, p1.y);
  
  //Dibujar línea de trazo
  float drawX = p2.x + p1.x + anchorX;
  float drawY = p2.y + p1.y + anchorY;
  pg.beginDraw();
  if(draw){
    pg.line(old_x, old_y, drawX, drawY);
  } else draw = true;
  pg.endDraw();
  old_x = drawX;
  old_y = drawY;
  
}

void mouseClicked(){
  setup();
}

class Pendulo {
  float angulo, cuerda, masa, vel, x, y;
  
  Pendulo(){
   this(200, 10, PI/4);
  }
  
  Pendulo(float r1, float m1, float a1){
    cuerda = r1;
    masa = m1;
    angulo = a1;
    acelerar(0, 1);
  }
   
  void acelerar(float accel, float frict){
    vel += accel;
    angulo += vel;
    vel *= frict;
    x = cuerda * sin(angulo);
    y = cuerda * cos(angulo);
  }
  
  
  
  void dibujar(float x_off, float y_off){
    line(x_off, y_off, x + x_off, y + y_off);
    ellipse(x + x_off, y + y_off, 5*log(masa), 5*log(masa));
  }
  
  void dibujar(){
     dibujar(0, 0); 
  }
  
}
