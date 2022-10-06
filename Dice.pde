ArrayList <Die> dice = new ArrayList<Die> ();

void setup() {
  size(1280, 720);
}

void draw() {
  background(157, 202, 240);
  for (Die die : dice) {
    die.transform.velocity.y += 0.2;
    die.draw();
  }
  if (dice.size() > 15) {
    dice.remove(0);
  }
  for (int i = 0; i < dice.size(); i++) {
    if (dice.get(i).markedForDeletion) {
      dice.remove(i);
    }
  }

  //Platform
  fill(100, 100, 100);
  rect(0, 650, 300, height-650);

  //Cannon
  pushMatrix();
  translate(150, 500);
  rotate(atan2(mouseY-500, mouseX-150));
  rect(-100, -40, 200, 80);
  popMatrix();
  rect(120, 500, 60, 150);
  arc(150, 500, 60, 60, PI, 2*PI);

  //Text
  int sum = 0;
  for (Die die : dice) {
    sum += die.num;
  }
  fill (255, 255, 255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Sum: " + sum, 0, 650, 300, height-650);
  
  fill(100,100,100, 100);
  rect (500, 650, width-500, height - 650);
  fill (255, 255, 255);
  textSize(18);
  boolean crit = false;
  boolean critFail = false;
  for (Die die : dice) {
    if (die.num == 1 && die.numSides == 20)
      critFail = true;
    else if (die.num == 20)
      crit = true;
  }
  if (critFail) {
    text("You rolled a one: Aiming for your enemies, you accidentally slash yourself in the leg D:", 500, 650, width-500, height - 650);
  }
  else if  (crit) {
    text("You rolled a twenty: You succesfully jumped over a chasm and with the impact of your landing, you knock over 15 enemies in a row!", 500, 650, width-500, height - 650);
  }
  
  
}

void mousePressed() {
  if (Math.random() > 0.1) {
    Die newDie = new Die(new Transform(new Position(100*cos(atan2(mouseY-500, mouseX-150))+150, 100*sin(atan2(mouseY-500, mouseX-150))+500), new Velocity(20*cos(atan2(mouseY-500, mouseX-150)), 20*sin(atan2(mouseY-500, mouseX-150)))), 50, color((int)(Math.random()*128)+128, (int)(Math.random()*128)+128, (int)(Math.random()*128)+128));
    newDie.roll();
    dice.add(newDie);
  } else {
    Die newDie = new D20(new Transform(new Position(100*cos(atan2(mouseY-500, mouseX-150))+150, 100*sin(atan2(mouseY-500, mouseX-150))+500), new Velocity(20*cos(atan2(mouseY-500, mouseX-150)), 20*sin(atan2(mouseY-500, mouseX-150)))), 50, color((int)(Math.random()*128)+128, (int)(Math.random()*128)+128, (int)(Math.random()*128)+128));
    newDie.roll();
    dice.add(newDie);
  }
}

class Die {

  Transform transform;

  int size, num, numBounces = 0;
  color myColor;
  boolean markedForDeletion = false;
  int numSides;

  Die(Transform m_transform, int m_Size, color m_Color) {
    transform = m_transform;
    size = m_Size;
    myColor = m_Color;
    numSides = 6;
  }

  void roll() {
    num = (int)(Math.random()*6)+1;
  }
  void draw() {
    drawDie();
    transform.update();
    if (transform.position.y+size/2 >= height) {
      transform.velocity.y = -Math.abs(transform.velocity.y);
      if (transform.velocity.y >= -1) {
        markedForDeletion = true;
      }
    }
    if (transform.position.x+size/2 >= width) {
      transform.velocity.x = -Math.abs(transform.velocity.x);
    }
    if (transform.position.x-size/2 <= 0) {
      transform.velocity.x = Math.abs(transform.velocity.x);
    }
  }
  void drawDie() {
    fill(myColor);
    stroke(0, 0, 0);
    rect(transform.position.x-size/2, transform.position.y-size/2, size, size);
    fill(0, 0, 0);
    if (num == 1 || num == 3 || num == 5) {
      ellipse(transform.position.x, transform.position.y, size/5, size/5);
      if (num != 1) {
        ellipse(transform.position.x+size/4, transform.position.y+size/4, size/5, size/5);
        ellipse(transform.position.x-size/4, transform.position.y-size/4, size/5, size/5);
      }
      if (num == 5) {
        ellipse(transform.position.x-size/4, transform.position.y+size/4, size/5, size/5);
        ellipse(transform.position.x+size/4, transform.position.y-size/4, size/5, size/5);
      }
    } else {
      ellipse(transform.position.x+size/4, transform.position.y+size/4, size/5, size/5);
      ellipse(transform.position.x-size/4, transform.position.y-size/4, size/5, size/5);
      if (num != 2) {
        ellipse(transform.position.x+size/4, transform.position.y-size/4, size/5, size/5);
        ellipse(transform.position.x-size/4, transform.position.y+size/4, size/5, size/5);
      }
      if (num == 6) {
        ellipse(transform.position.x+size/4, transform.position.y, size/5, size/5);
        ellipse(transform.position.x-size/4, transform.position.y, size/5, size/5);
      }
    }
  }
}

class D20 extends Die {

  D20(Transform m_transform, int m_Size, color m_Color) {
    super(m_transform, m_Size, m_Color);
    numSides = 20;
  }

  void roll() {
    num = (int)(Math.random()*20)+1;
  }

  void drawDie() {
    fill(myColor);
    stroke(0, 0, 0);
    beginShape();
    vertex(transform.position.x, transform.position.y - size);
    vertex(transform.position.x + size*sqrt(3)/2, transform.position.y - size/2);
    vertex(transform.position.x + size*sqrt(3)/2, transform.position.y + size/2);
    vertex(transform.position.x, transform.position.y + size);
    vertex(transform.position.x - size*sqrt(3)/2, transform.position.y + size/2);
    vertex(transform.position.x - size*sqrt(3)/2, transform.position.y - size/2);
    endShape(CLOSE);
    textSize(32);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text("" + num, transform.position.x - size*sqrt(3)/2, transform.position.y - size/2, size*sqrt(3), size);
  }
}

class Transform {
  Position position;
  Velocity velocity;

  Transform(Position pos, Velocity vel) {
    position = pos;
    velocity = vel;
  }
  Transform(Position pos) {
    position = pos;
    velocity = new Velocity(0, 0);
  }

  void update() {
    position.x += velocity.x;
    position.y += velocity.y;
  }
}

class Position {
  float x;
  float y;

  Position(float m_x, float m_y) {
    x = m_x;
    y = m_y;
  }
}

class Velocity {
  float x;
  float y;

  Velocity(float m_x, float m_y) {
    x = m_x;
    y = m_y;
  }
}
