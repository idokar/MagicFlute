import java.util.function.Predicate;
import processing.serial.*;
import ddf.minim.*;

Minim minim;
Serial arduinoPort;

String IMAGES_DIR = "images/";
float heightAdj;
float widthAdj;

//arduino serial variables
boolean connect = false;
boolean resetBMP = false;
boolean firstPressed = false;
boolean secondPressed = false;
boolean thirdPressed = false;
boolean fourthPressed = false;
float pressure = 0;

//game variables
Game game;
boolean noBottoms = false;
boolean levelStarted = false;
PFont font;
int level = 0;
int score = 0;
int levelMaxScore = 0;
JSONArray levels;
ArrayList<AudioPlayer> player = new ArrayList<AudioPlayer>();


void setup() {
    arduinoPort = new Serial(this, Serial.list()[0], 9600);
    arduinoPort.bufferUntil('\n');
    fullScreen();
    heightAdj = height / 1080.0;
    widthAdj = width / 1920.0;
    initMenusLoc();
    initNoteLoc();
    initGameLoc();
    levels = loadJSONArray("levels.json");
    font = createFont(IMAGES_DIR + "SourceSerifPro-Semibold.otf", fontSizeScore);
    minim = new Minim(this);
    for (int i = 0; i < levels.size(); i++) {
        player.add(minim.loadFile(levels.getJSONObject(i).getString("SONG"), 2048));
    }    
}


/**
 * This is an event function, that responsible for the connection with 
 * the arduino and the parsing of the data from the arduino. 
 */
void serialEvent(Serial arduinoPort) {
    String rc = arduinoPort.readStringUntil('\n');
    if (rc != null) {
        rc = trim(rc);
        if (!connect) {
            if (rc.equals("A")) {
                arduinoPort.clear();
                connect = true;
                arduinoPort.write("A");
            }
        }
        else {
            firstPressed = rc.charAt(0) == '1';
            secondPressed = rc.charAt(1) == '1';
            thirdPressed = rc.charAt(2) == '1';
            fourthPressed = rc.charAt(3) == '1';
            pressure = float(rc.substring(5));
            if (Float.isNaN(pressure)) {
                println("BMP280 ERROR");
                exit();
            }
            if (resetBMP) {
            arduinoPort.write('1');
            resetBMP = false;
            }
        }
    }
}


void draw() {
    background(230, 212, 192);
    if (!levelStarted) {
        if (helpMenu){
            image(helpBG, 0, 0, width, height);
        }
        else {
            image(startBG, 0, 0, width, height);
            if (!noBottoms) {
                image(useButtons, useButtonsX, useButtonsY, useButtonsWidth, useButtonsHeight);
            }
            image(difficulties[difficulty], difficultyNumX, difficultyNumY, difficultyNumWidth, difficultyNumHeight);
            fill(0, 0, 0);
            textAlign(CENTER, CENTER);
            textFont(font);
            textSize(fontSizeLevel);
            text(levels.getJSONObject(level).getString("TITLE"), levelLocX, levelLocY, levelWidth, levelHeight);
        }
    }
    else if (levelCompleted) {
        image(levelCompleteBG, 0, 0, width, height);
        image(stars[score == 0 ? 0:int(map(float(score) / float(levelMaxScore), 0.0, 1.0, 1.0, 5.0))],
              starsLocX, starsLocY, starsWidth, starsHeight);
        fill(0, 0, 0);
        textAlign(CENTER, CENTER);
        textFont(font);
        text(score + " / " + levelMaxScore, levelLocX, resultY, levelWidth, levelHeight);
    }
    else {
        levelCompleted = !game.play();
        game.updateScore();
    }
}
