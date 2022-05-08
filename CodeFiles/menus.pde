PImage startBG;
PImage helpBG;
PImage levelCompleteBG;
PImage exitButton; 
PImage homeButton; 
PImage useButtons; 
PImage[] difficulties = new PImage[5];
PImage[] stars = new PImage[6];

int difficulty = 0;
boolean helpMenu = false;
boolean levelCompleted = false;

float exitButtonX, helpButtonX, homeButtonY, cornerButtonY, cornerButtonWidth, cornerButtonHeight, homeButtonHeight;
float startButtonX, startButtonY, startButtonWidth, startButtonHeight;
float leftButtonX, rightButtonX, arrowButtonY, arrowButtonWidth, arrowButtonHeight;
float plusButtonX, minusButtonX, difficultyButtonY, difficultyButtonWidth, difficultyButtonHeight;
float difficultyNumX, difficultyNumY, difficultyNumWidth, difficultyNumHeight;
float useButtonsX, useButtonsY, useButtonsWidth, useButtonsHeight;
float levelLocX, levelLocY, levelWidth, levelHeight;
float fontSizeLevel; 
float starsLocX, starsLocY, starsWidth, starsHeight, resultY;


void initMenusLoc() {
    exitButtonX = 1821.0 * widthAdj;
    helpButtonX = 23.0 * widthAdj;
    homeButtonY = 25.0 * heightAdj;
    cornerButtonY = 33.0 * heightAdj;
    cornerButtonWidth = 58.0 * widthAdj;
    cornerButtonHeight = 58.0 * heightAdj;
    homeButtonHeight = 68.0 * heightAdj;
    
    startButtonX = 835.0 * widthAdj;
    startButtonY = 800.0 * heightAdj;
    startButtonWidth = 260.0 * widthAdj;
    startButtonHeight = 90.0 * heightAdj;
    
    leftButtonX = 600.0 * widthAdj;
    rightButtonX = 1243.0 * widthAdj;
    arrowButtonY = 394.0 * heightAdj;
    arrowButtonWidth = 75.0 * widthAdj;
    arrowButtonHeight = 152.0 * heightAdj;
    
    plusButtonX = 1009.0 * widthAdj;
    minusButtonX = 853.0 * widthAdj;
    difficultyButtonY = 701.0 * heightAdj;
    difficultyButtonWidth = 58.0 * widthAdj;
    difficultyButtonHeight = 30.0 * heightAdj;
    difficultyNumX = 955.0 * widthAdj;
    difficultyNumY = 704.0 * heightAdj;
    difficultyNumWidth = 18.0 * widthAdj;
    difficultyNumHeight = 29.0 * heightAdj;
    
    useButtonsX = 64.5 * widthAdj;
    useButtonsY = 974.0 * heightAdj;
    useButtonsWidth = 48.0 * widthAdj;
    useButtonsHeight = 43.0 * heightAdj;
    
    levelLocX = 725.0 * widthAdj;
    levelLocY = 400.0 * heightAdj;
    levelWidth = 475.0 * widthAdj;
    levelHeight = 145.0 * heightAdj;
    
    fontSizeLevel = 40.0 * widthAdj;

    starsLocX = 692.5 * widthAdj;
    starsLocY = 400.0 * heightAdj;
    starsWidth = 535.0 * widthAdj;
    starsHeight = 90.0 * heightAdj;
    resultY = 550.0 * heightAdj;
    
    startBG = loadImage(IMAGES_DIR + "startMenu.png");
    helpBG = loadImage(IMAGES_DIR + "helpBG.png");
    levelCompleteBG = loadImage(IMAGES_DIR + "levelComplete.png");
    exitButton = loadImage(IMAGES_DIR + "exit.png");
    homeButton = loadImage(IMAGES_DIR + "home.png");
    useButtons = loadImage(IMAGES_DIR + "useButtons.png");
    difficulties[0] = loadImage(IMAGES_DIR + "1.png");
    difficulties[1] = loadImage(IMAGES_DIR + "2.png");
    difficulties[2] = loadImage(IMAGES_DIR + "3.png");
    difficulties[3] = loadImage(IMAGES_DIR + "4.png");
    difficulties[4] = loadImage(IMAGES_DIR + "5.png");
    stars[0] = loadImage(IMAGES_DIR + "zeroStars.png");
    stars[1] = loadImage(IMAGES_DIR + "oneStar.png");
    stars[2] = loadImage(IMAGES_DIR + "twoStars.png");
    stars[3] = loadImage(IMAGES_DIR + "threeStars.png");
    stars[4] = loadImage(IMAGES_DIR + "fourStars.png");
    stars[5] = loadImage(IMAGES_DIR + "fiveStars.png");
}


void mouseClicked() {
    if (mouseX >= exitButtonX && mouseX <= exitButtonX + cornerButtonWidth &&
        mouseY >= cornerButtonY && mouseY <= cornerButtonY + cornerButtonHeight) {
        exit();
    }
    if (mouseX >= startButtonX && mouseX <= startButtonX + startButtonWidth &&
        mouseY >= startButtonY && mouseY <= startButtonY + startButtonHeight) {
        if (!levelStarted && !helpMenu) {
            levelStarted = true;
            game = new Game(levels.getJSONObject(level).getString("INSTRUCTIONS"), difficulty);
            return;
        }
        else if (!helpMenu && levelCompleted) {
            player.get(level).pause();
            levelCompleted = false;
            levelStarted = false;
        }
    }
    if (mouseX >= helpButtonX && mouseX <= helpButtonX + cornerButtonWidth &&
        mouseY >= cornerButtonY && mouseY <= cornerButtonY + cornerButtonHeight) {
        if (!levelStarted) {
            helpMenu = !helpMenu;
        }
        else if (!levelCompleted) {
            levelStarted = false;
            player.get(level).pause();
            output.flush();
            output.close();
        }
    }
    if (!levelStarted && !helpMenu) {
        if (mouseX >= useButtonsX && mouseX <= useButtonsX + useButtonsWidth &&
            mouseY >= useButtonsY && mouseY <= useButtonsY + useButtonsHeight) {
            noBottoms = !noBottoms;
        }
        if (mouseX >= plusButtonX && mouseX <= plusButtonX + difficultyButtonWidth &&
            mouseY >= difficultyButtonY && mouseY <= difficultyButtonY + difficultyButtonHeight) {
            difficulty = (difficulty + 1)%5;
        }
        if (mouseX >= minusButtonX && mouseX <= minusButtonX + difficultyButtonWidth &&
            mouseY >= difficultyButtonY && mouseY <= difficultyButtonY + difficultyButtonHeight) {
            difficulty = (difficulty <= 0) ? 4: (difficulty - 1);
        }
        if (mouseX >= leftButtonX && mouseX <= leftButtonX + arrowButtonWidth &&
            mouseY >= arrowButtonY && mouseY <= arrowButtonY + arrowButtonHeight) {
            level = (level + 1)%(levels.size());      
        }
        if (mouseX >= rightButtonX && mouseX <= rightButtonX + arrowButtonWidth &&
            mouseY >= arrowButtonY && mouseY <= arrowButtonY + arrowButtonHeight) {
            level = (level <= 0) ? levels.size() - 1: (level - 1);
        }
    }
}
