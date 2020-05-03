// import for background sound
import processing.sound.*;
//Initialize all image holders
PImage spaceship;
PImage asteroid;
PImage background;
// Position of main object (spaceship)
int x, y;
//Initialize the variables for the counting time
int milli;
int minutes; 
int seconds;
//Initialize the variable for the level
int level;
//Initialize the variables used for start game countdown
int startTimeMs;
final int startDelayMs = 5000; //Delay before the game starts
boolean atStartup = true;
//Initialize the prefered font holder
PFont pixelated;
//Create a asteroid object and an Array of type Astreoid to hold each drop
Asteroids asteroid1;
Asteroids[] drops;
//How many asteroid drop at the same time
int numDrops;
//Speed of falling astreoid
int speed;
//counter for for loop
int i;


/** ********** setup(): ************ */
void setup() {

  size(400, 600); // Set game window to 400 wide and 600 tall
  spaceship = loadImage("images/spaceship.png"); // load spaceship image to the variable   
  asteroid = loadImage("images/asteroid1.png"); // load asteroids image to the variable 
  background = loadImage("images/background.png"); // load background image to the variable 

  x=100;  
  y=500; // starting point of spaceship

  numDrops = 3; // set the number of asteroids to fall at same way
  drops = new Asteroids[numDrops]; // Declare and create the array

  speed = 5; // set starting speed of faliing asteroids

  //create each object -> the number of objects created is the same as the number of drops
  for (i = 0; i < drops.length; i++) {
    drops[i] = new Asteroids(); // Create each object
    asteroid1 = new Asteroids();
  }

  pixelated = createFont("pixelated.ttf", 32); // set the prefered font to pixelated font

  startTimeMs = millis(); // initialize the startTimeMs to the current millis when the game starts
}

/** ********** draw(): ************* */
void draw() {

  background(background); // set background to the prefered image


  if (atStartup) { // run only once in the start of the game
    int curTimeMs = millis(); // get the current time
    int startupTimeRemainingMs = startDelayMs - (curTimeMs - startTimeMs); // calculate how much time is left in the countdown
    startScreen(startupTimeRemainingMs);
    atStartup = startupTimeRemainingMs > 0; // keep it true as long as countdown time is bigger than 0
    return;
  }

  // draw black borders on all sides of the platform
  stroke(#000000);
  showBorders();

  // display spaceship in it start position
  image(spaceship, x, y);


  // get the time and show in on the screen with the prefered font and position of text
  get_time();
  textFont(pixelated);
  text(nf(minutes, 2) + ":" + nf(seconds, 2), 275, 30);

  // calculate each lavel based on time passes and show it on the screen
  level = minutes*6 + seconds/10 + 1;
  text("Level: " + level, 10, 30);


  // start showing every asteroid falling -> for represents each wave
  for (i = 0; i < drops.length; i++) {
    drops[i].fall();

    // check if the asteroid collide with the spaceship
    if (checkCollision()) {
      text("Game over! ", 100, 250); // show game over text
      stroke(#F0F0F0); // show white border
      showBorders(); // border on all side
      noLoop(); // freeze everything -> game is over
    }
  }

  speed = level*2; // change the speed based on current level to make the game harder as the time passes by
}

/** ********** Event Handlers: ****** */
/* respond to user input if he presses and UP/DOWN/LEFT/RIGHT
 and move the spaceship by 20 */
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) { 
      y -= 20;
    } else if (keyCode == DOWN) { 
      y += 20;
    } else if (keyCode == LEFT) { 
      x -= 20;
    } else if (keyCode == RIGHT) { 
      x += 20;
    }
  }
}

/** ********** Custom Functions: *** */
void startScreen(int remainingTimeMs) {
  // start screen
  textFont(pixelated);
  textSize(20);
  text("       Move the spaceship with \n arrow keys to avoid asteroids!", 0, 150);
  textSize(50);
  text("Get ready", 65, 300);
  text(ceil(remainingTimeMs/1000.0), 180, 375); // show the time left in seconds
}

boolean checkCollision() {
  // collision detection between asteroids and spaceship
  if ((drops[i].x-40 <= x && drops[i].x >= x) && (drops[i].y-40 <= y && drops[i].y >= y)) {
    return true;
  } else {
    return false;
  }
}

void get_time() {
  // calculate time in seconds and minutes
  //millis()-5000 to subtract the 5 second of countdown on start of the program
  milli = millis()-5000;
  seconds = milli / 1000;
  minutes = seconds / 60;
  // calculations to reset secons to 0, when a minutes passes by
  seconds = seconds - minutes * 60;
  milli   = milli - minutes * 60 * 1000 - seconds * 1000;
}

void showBorders() {
  // show borders on all sides
  strokeWeight(10);
  //left
  line(0, 0, 0, 600);
  //right
  line(400, 0, 400, 600);
  //top
  line(0, 0, 400, 0);
  //bottom
  line(0, 600, 400, 600);

  // check collision between spaceship and walls -> change color of border on collision
  if (x<0) {
    x = 0;
    stroke(#FF0000);
    strokeWeight(20);
    //left border red
    line(0, 0, 0, 600);
  }
  if (x>350) {
    x = 350;
    stroke(#FF0000);
    strokeWeight(20);
    //right border red
    line(400, 0, 400, 600);
  }
  if (y<0) {
    y = 0;
    stroke(#FF0000);
    strokeWeight(20);
    //top border right
    line(0, 0, 400, 0);
  }
  if (y>500) {
    y = 500;
    stroke(#FF0000);
    strokeWeight(20);
    //bottom border red
    line(0, 600, 400, 600);
  }
}

/** ********** Classes: ************ */
class Asteroids {
  // class to generate the objects holding asteroids
  int x = (int)random(350);
  int y = (int)random(-height);

  // fall method to show astroids falling
  void fall() {
    y = y + speed;
    image(asteroid, x, y);

    // if asteroids get out of screen reset them
    if (y>height) {
      x = (int)random(375);
      y = (int)random(-200);
    }
  }
}
