//Game Variables
Image backgroundImage;          // Background image for the game
Image[] hearts = new Image[3];  // Array of hearts showing 3 lives
Image dog;                      // The dog image player character
int lives = 3, score = 0;       // Player score and number of lives
Text scoreText;                 // Text object to display score
Music backgroundMusic, successSound, failSound; // Music  sound effects
Image[] bones = new Image[2];   // Array of falling bones
float[] boneY = new float[2];   // Y positions of the falling bones
float boneSpeed = 3.2;            // Speed of falling bones
int dogSpeed = 18;              // Speed of dog movement
boolean gameOver = false;       // false for play true to end the game 
String endMessage = "";         // Message to show when game ends

//Setup Function
void setup() {
  size(1024, 512);  // Set window size

  // Load and set background image
  backgroundImage = new Image();
  backgroundImage.setImage("backgroundimg.png");
  backgroundImage.x = 0;
  backgroundImage.y = 0;
  backgroundImage.width = width;
  backgroundImage.height = height;
  
  // Initialize 3 hearts in the top bar
  for(int i = 0; i < hearts.length; i++) {
    hearts[i] = new Image();
    hearts[i].setImage("heartimg.png");
    hearts[i].width = 40;
    hearts[i].height = 40;
    hearts[i].x = 175 + i * 50;  // space them out
    hearts[i].y = 20;
  }

  // Load dog image and position it in the middle of the screen
  dog = new Image();
  dog.setImage("dogimg.png");
  dog.width = 110;
  dog.height = 120;
  dog.x = width / 2 - dog.width / 2; // center horizontally
  dog.y = 380;                       // starting vertical position

  // Initialize score text
  scoreText = new Text();
  scoreText.textSize = 32;
  scoreText.font = "Arial";
  scoreText.brush = color(255); // white
  scoreText.x = 20;
  scoreText.y = 52;

  // Load and start background music
  backgroundMusic = new Music();
  backgroundMusic.load("gameMusic.mp3");
  backgroundMusic.loop = true;
  backgroundMusic.play();

  // Initialize falling bones
  if (!gameOver) {
    for (int i = 0; i < bones.length; i++) {
      bones[i] = new Image();
      bones[i].setImage("boneimg.png");
      bones[i].width = 80;
      bones[i].height = 40;
      bones[i].x = int(random(0, width - bones[i].width)); // random X
      boneY[i] = -bones[i].height - i * 100;  // start offscreen above
    }
  }

  // Load success sound for catching bone
  successSound = new Music();
  successSound.load("positiveSound.mp3");

  // Load fail sound for missing bone
  failSound = new Music();
  failSound.load("negativeSound.mp3");
}

// Draw Function 
void draw() {
  // Draw background
  backgroundImage.draw();

  // Draw remaining hearts
  for (int i = 0; i < hearts.length; i++) {
    if (hearts[i] != null) {
      hearts[i].draw();
    }
  }

  // Update and draw score
  scoreText.text = "Points: " + score;
  scoreText.draw();


  updateBones();

  // If game ended, show win/lose message
  if (gameOver) {
    Text endText = new Text();
    endText.text = endMessage;
    endText.textSize = 64;
    endText.font = "Arial";
    endText.brush = color(255, 0, 0); // red
    endText.x = width / 2 - 150;
    endText.y = height / 2;
    endText.draw();
  }

  // Draw the dog
  dog.draw();
}

//Player Controls 
void keyPressed() {
  // If game is over, ignore input
  if (gameOver) return;

  // Move dog left or right
  if (keyCode == LEFT) {
    dog.x -= dogSpeed;
  } else if (keyCode == RIGHT) {
    dog.x += dogSpeed;
  }

  // Keep dog inside window bounds
  
  if (dog.x < 0) {
  dog.x = 0;
  }

  else if (dog.x > width - dog.width) {
  dog.x = width - dog.width;
  }
}



//Bones Update Function 

void updateBones() {
  for (int i = 0; i < bones.length; i++) {
    // Move bone downward each frame by its speed
    boneY[i] += boneSpeed;
    
    // Check if the bone is caught
   boolean caught = boneY[i] + bones[i].height >= dog.y && bones[i].x + bones[i].width > dog.x && bones[i].x < dog.x + dog.width;
   
                     
    if (caught) {
      if (!gameOver) {
        // Play success sound and increase score
        successSound.play();
        score += 1;
      }
      // If player reached winning score end the game with victory message
      if (score == 10) {
        gameOver = true;
        endMessage = "You Win!";
      }
      // Reset bone to top at a random X position
      boneY[i] = -bones[i].height;
      bones[i].x = int(random(0, width - bones[i].width));
    }
    
    
    // Check if the bone hits ground
    
    if (boneY[i] + bones[i].height >= 410) {
      if (!gameOver) {
        // Play fail sound when missing a bone
        failSound.play();

        // Remove one heart icon
        if (lives > 0) {
          hearts[lives - 1] = null;
          lives--;
        }

        // If no lives left end the game with Game Over
        if (lives == 0) {
          gameOver = true;
          endMessage = "Game Over!";
        }
      }

      // Reset bone to top at a random X position after hitting ground
      boneY[i] = -bones[i].height;
      bones[i].x = int(random(0, width - bones[i].width));
    }

   
    // Draw the bone only if game still running
    
    if (!gameOver) {
      bones[i].y = int(boneY[i]); // update bone current Y position
      bones[i].draw();            // render bone image
    }
  }
}
