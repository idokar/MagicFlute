#include <Wire.h>
#include <SPI.h>
#include <Adafruit_BMP280.h>

Adafruit_BMP280 bmp;
float base;
bool calibrate = false;


/**
 * function that calculates the pressure change.
 *  calibration: if True will calibrate the base pressure to the current pressur.
 */
float get_pressure(bool calibration=false) {
    float sample = bmp.readPressure();
    if (calibration) {
        base = sample;
    }
    else {
        base = min(sample, base);
    }
    return sample - base;
}


/**
 * function to connect the arduino to processing.
 */
void establishContact() {
    while (Serial.available() <= 0) {
        Serial.println("A");
        delay(100);
    }
}


void setup() {
    pinMode(A0, INPUT);
    pinMode(A1, INPUT);
    pinMode(A2, INPUT);
    pinMode(A3, INPUT);
    Serial.begin(9600);
    while (!Serial) delay(100);  // check sirial
    establishContact();  // init connection
    if (!bmp.begin()) {
        Serial.println("BMP280_INIT_EROR");
        while (1);
    }
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                    Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_250); /* Standby time. */
    get_pressure(true);  // init base
}


void loop() {
    if (Serial.available() > 0) {
        calibrate = Serial.read() == '1';
    }

    Serial.print(digitalRead(A0));  // First button
    Serial.print(digitalRead(A1));  // Second button
    Serial.print(digitalRead(A2));  // Third button
    Serial.print(digitalRead(A3));  // Fourth button
    Serial.print(F(" "));
    Serial.println(get_pressure(calibrate));

    delay(300);
    calibrate = false;
}
