int maxPressureList[] = {100, 350, 600, 900, 1500};

float firstHoleX, secondHoleX, thirdHoleX, fourthHoleX, openHolesY, holeWidth;
float holesX, holesY, holesWidth, holesHeight;
float numberLocX, scoreLocX, scoreLocY;
float fontSizeScore; 
float fluteY, fluteWidth, fluteHeight, middleFlute, outsideFlute;

PrintWriter output;


void initGameLoc() {
    firstHoleX = 131.0 * widthAdj;
    secondHoleX = 374.0 * widthAdj;
    thirdHoleX = 616.0 * widthAdj;
    fourthHoleX = 858.0 * widthAdj;
    openHolesY = 748.0 * heightAdj;
    holeWidth = 170.0 * widthAdj;
    
    holesX = 130.0 * widthAdj;
    holesY = 750.0 * heightAdj;
    holesWidth = 900.0 * widthAdj;
    holesHeight = 43.0 * heightAdj;

    numberLocX = 1790.0 * widthAdj;
    scoreLocX = 1600.0 * widthAdj;
    scoreLocY = 200.0 * heightAdj;
    
    fontSizeScore = 60 * widthAdj;
    
    fluteY = 680.0 * heightAdj;
    fluteWidth = 1500.0 * widthAdj;
    fluteHeight = 370.0 * heightAdj;
    middleFlute = 800.0 * widthAdj;
    outsideFlute = 1500.0 * widthAdj;
}


class Game {
    private PImage flute = loadImage(IMAGES_DIR + "flute.png");
    private PImage openHole = loadImage(IMAGES_DIR + "openHole.png");
    private PImage holeOutLine = loadImage(IMAGES_DIR + "holeOutLine.png");
    private ArrayList<Note> notes = new ArrayList<Note>();
    private JSONArray notesJsons;
    private JSONObject nextNote; 
    private int maxPressure; 
    private long clock;
    private float second = frameRate * displayDensity();
    
    /**
     * Create instance of a game.
     *  file: path to the json file that contains the level's instructions.
     *  difficulty: an int between 0 to 4, when 0 is the easiest difficulty
     *              (smallest pressure needed to make the notes move).   
     */
    Game(String file, int difficulty) {
        notesJsons = loadJSONArray(file);
        maxPressure = maxPressureList[difficulty%5];
        clock = 0;
        score = 0;
        levelMaxScore = notesJsons.size() * 10;
        nextNote = notesJsons.getJSONObject(0);
        notesJsons.remove(0);
        player.get(level).rewind();
        player.get(level).play();
        output = createWriter("logs/" + levels.getJSONObject(level).getString("TITLE") + "_" + (difficulty+1) + "_" + 
                              day() + "-" + month() + "-" + year() + "-" + hour() + "_" + minute() + ".txt");
    }
    
    /**
     * level's routine. Manage the process of the game.
     * Call this function in ```draw()```.
     */
    boolean play() {
        if (!boolean(int(clock % second))) {
            output.println(hour() + ":" + minute() + ":" + second() + "    " + pressure);
        }
        image(exitButton, exitButtonX, cornerButtonY, cornerButtonWidth, cornerButtonHeight);
        image(homeButton, helpButtonX, homeButtonY, cornerButtonWidth, homeButtonHeight);
        image(flute, 0, fluteY, fluteWidth, fluteHeight);
        openHole();
        if (nextNote != null && nextNote.getFloat("time") * second <= clock) {
            notes.add(new Note(nextNote.getInt("button"), maxPressure));
            if (boolean(notesJsons.size())){
                nextNote = notesJsons.getJSONObject(0);
                notesJsons.remove(0);
            }
            else {
                nextNote = null;
            }
        }
        boolean fluteEmpty = true;
        Predicate<Note> p = n -> (!n.exists);
        notes.removeIf(p); 
        for (Note note: notes) {
            note.move();
            fluteEmpty &= !note.inside;
        }
        if (fluteEmpty) {
            resetBMP = true;
        }
        image(holeOutLine, holesX, holesY, holesWidth, holesHeight);
        clock++;
        if (!player.get(level).isPlaying() && notes.isEmpty()) {
            output.println("score:  " + score + " out of:  " + levelMaxScore);
            output.flush();
            output.close();
            return false;
        }
        return true;
    }
    
    private void openHole() {
        if (firstPressed || noBottoms) {
            image(openHole, firstHoleX, openHolesY, holeWidth, holesHeight);
        }
        if (secondPressed || noBottoms) {
            image(openHole, secondHoleX, openHolesY, holeWidth, holesHeight);
        }
        if (thirdPressed || noBottoms) {
            image(openHole, thirdHoleX, openHolesY, holeWidth, holesHeight);
        }
        if (fourthPressed || noBottoms) {
            image(openHole, fourthHoleX, openHolesY, holeWidth, holesHeight);
        }
    } 
  
    void updateScore() {
        fill(0, 0, 0);
        textAlign(CENTER, CENTER);
        textFont(font);
        text("SCORE: ", scoreLocX, scoreLocY);
        text(str(score), numberLocX, scoreLocY);
    }
}
