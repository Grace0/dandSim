class Particle { 

  ArrayList<FloatList> traj;

  private boolean left, fall, isInit;

  private float sway = 0.0;
  private float xPos, yPos, diameter, xVel, yVel, gravity;
  private float maxSpeed = 1.0;

  private int swayCount, swayInterval, resetInc;

  private int state;
  private final int SLOW = 0;
  private final int FALL = 1;
  private final int STOP = 2;

  Particle(float xp, float yp, float dia, float xv, float yv) { 
    xPos = xp;
    yPos = yp;
    diameter = dia;
    xVel = xv;
    yVel = yv;
    swayInterval = round(random(10, 80));
    gravity = random(0.1f, 0.6f);
    isInit = false;
    state = 0;

    traj = new ArrayList<FloatList>();
  }

  void display() {
    fill(255);
    ellipse(xPos, yPos, diameter, diameter);
  }

  void move() {

    switch (state) {
    case SLOW:
      if (abs(xVel) > 0 || abs(yVel) > 0) {
        yVel *= 0.98f;
        xVel *= 0.98f;
        if (abs(xVel) <= 0.05 && abs(yVel) <= 0.05) {
          state = 1;
        }
      }
      yPos += gravity;
      xPos += xVel;
      yPos += yVel;
      break;
    case FALL:
      swayCount++;
      gravity += 0.002f * speedChange;
      if (swayCount > swayInterval) {
        left =! left;
        swayInterval = round(random(10, 80)); //reset it
        swayCount = 0;
      }
      if (left && xVel > -maxSpeed) {
        xVel-= sway;
      } else if (!left && xVel < maxSpeed) {
        xVel+= sway;
      }
      sway += 0.0001f;
     
      if (yPos >= bottomRow) {
        state = STOP;
      } else {
         xPos += xVel;
         yPos += (yVel + gravity);
      }
      break;
    case STOP:
      yVel = 0;
      xVel = 0;
      break;
    }

    FloatList point = new FloatList();
    point.append(xPos);
    point.append(yPos);
    traj.add(point);
    resetInc = traj.size()-1;
  }

  boolean init(boolean attract) { 
    theta = atan2((mouseY-yPos), (mouseX-xPos)); 

    if (attract) {
      yVel = 1.0 * sin(theta)*2.5f;
      xVel = 1.0 * cos(theta)*2.5f;
    } else {
      yVel = -1.0 * sin(theta)*2.5f;
      xVel = -1.0 * cos(theta)*2.5f;
    }

    return true;
  }

  void reset() {
    if (resetInc >= 0) {
      xPos = traj.get(resetInc).get(0);
      yPos = traj.get(resetInc).get(1);
    }
    resetInc--;
  }

}