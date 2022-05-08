int slow = 3;
int medium = 4;
int fast = 5;
int thrill[] = {-3, -3, -2, -2, -1, -1, 1, 1, 2, 2, 3, 3, 2, 2, 1, 1, -1, -1, -2, -2};
float firstLocX, secondLocX, thirdLocX, fourthLocX;
float firstPoppedX, secondPoppedX, thirdPoppedX, fourthPoppedX;
float noteHeight, noteWidth, poppedNoteWidth;


void initNoteLoc() {
  firstLocX = 170.0 * widthAdj;
  secondLocX = 415.5 * widthAdj;
  thirdLocX = 660.0 * widthAdj;
  fourthLocX = 905.5 * widthAdj;
  firstPoppedX = 126.0 * widthAdj;
  secondPoppedX = 372.0 * widthAdj;
  thirdPoppedX = 617.0 * widthAdj;
  fourthPoppedX = 861.0 * widthAdj;
  noteWidth = 100.0 * widthAdj;
  noteHeight = 150.0 * heightAdj;
  poppedNoteWidth = 143.0 * widthAdj;
}

class Note {
  boolean inside, outside, exists;
  private int destButton, popTimer, i;
  private float x, y, popLocX, fading, maxPressure;
  private boolean holeOpen;
  private PImage noteIm = loadImage(IMAGES_DIR + "note.png");
  private PImage popingNote = loadImage(IMAGES_DIR + "popingNote.png");
  
    /**
     * Create an instance of a note. The note first appear right before the screen starts at the top, and slide in.
     *   buttonNum: an int between 1 to 4, that represents the destination button of the note.
     *   pressure: a float number that represents the max pressure needed to make the
     *             note move fast to the exit of the flute.
     *             The minimum pressure to make the note move is pressure / 3.
     */
    Note(int buttonNum, float pressure) {
        destButton = buttonNum;
        maxPressure = pressure;
        switch(buttonNum) {
            case 1:
                x = firstLocX;
                popLocX = firstPoppedX;
                break;
            case 2:
                x = secondLocX;
                popLocX = secondPoppedX;
                break;
            case 3:
                x = thirdLocX;
                popLocX = thirdPoppedX;
                break;
            default:
                x = fourthLocX;
                popLocX = fourthPoppedX;
                break;
        }
        y = -noteHeight;
        popTimer = 0;
        fading = 350;
        inside = false;
        outside = false;
        holeOpen = false;
        exists = true;
    }
  
    /** 
     * Note's routine. Called to move the note in the process of the level. 
     */
    void move() {
        if (fading <= 0 || (y <= 0 && outside) || !exists) {
            exists = false;
            return;
        }
        if (y + noteHeight < holesY + 4 && !outside) {
            image(noteIm, x, y, noteWidth, noteHeight);
            y += slow;
            if (y + noteHeight >= holesY && buttonPressed()) {
                holeOpen = true;
            } 
        }
        if (y + noteHeight >= holesY + 4 && !holeOpen) {
            if (popTimer < round(frameRate)/2) {
                image(popingNote, popLocX, y, poppedNoteWidth, noteHeight);
            }
            else {
                exists = false;
            }
            popTimer++;
            return;
        }
        else if (y + noteHeight >= holesY + 4 && holeOpen && !inside) {
            if (y <= middleFlute) {
                y += fast;
                image(noteIm, x, y, noteWidth, noteHeight);
            }
            else {
                inside = true;
            }
        }
        tint(255, fading);
        if (inside && exists && !outside) {
            y += thrill[i%20];
            i++;
            if (pressure >= maxPressure/3) {
                x += int(min(map(pressure, 0, maxPressure, 0, 5), 5));
            }
            image(noteIm, x, y, noteWidth, noteHeight);
            fading -= 1;
            if (x >= outsideFlute) {
                score += 10;
                outside = true;
                return;
            }      
        }
        if (outside) {
            x += thrill[i%20] * 1.5;
            y -= slow;
            if (x < scoreLocX) {
                x += slow;
            }
            image(noteIm, x, y, noteWidth, noteHeight);
            i++;
            fading -= 2;
        }
        noTint();
    }
  
    /**
     * Private method to check if the destination button is pressed.
     */
    private boolean buttonPressed() {
        if (noBottoms) {
            return true;
        }
        switch(destButton) {
            case 1:
                return firstPressed;
            case 2:
                return secondPressed;
            case 3:
                return thirdPressed;
            case 4:
                return fourthPressed;
            default: 
                return false;
        }
    }
}
