/*
  GrowthGuardian - the autonomous planter

  sensors used:
  - ASAIR AHT25 Temperature and Humidity Sensor
  - capacitive soil moistue sensor v2.0
  - water level sensor
  - TEMT6000 Light Sensor Module 

  other components connected to arduino
  - 2N2222A transistor
  - under water pump horizontal 3-6V
  - external power supply to power arduino and pump

  School project for minor sensor technologie at HSLeiden
  made by:
  - Hugo Heijmans
  - Michiel Kramers
  - Bjorn Meurkes

*/
#include <Wire.h>
#include <AHT20.h>
#include <PubSubClient.h>
#include <WiFiNINA.h>
#include "arduino_secrets.h"

AHT20 aht20;
// pins
/* analog pins used
  soil moisture sensor = 0
  light sensor = 2
  temprature/humidity sensor = 4 and 5
  hall effect sensors = 1, 3, 6, 7
*/
#define PUMP_DIGITAL_PIN 2
#define HALL_POWER_PIN_FULL 7
#define HALL_POWER_PIN_66 6
#define HALL_POWER_PIN_33 5
#define HALL_POWER_PIN_EMPTY 4
#define HALL_SENSOR_FULL_ANALOG_PIN A1
#define HALL_SENSOR_66_ANALOG_PIN A3
#define HALL_SENSOR_33_ANALOG_PIN A6
#define HALL_SENSOR_EMPTY_ANALOG_PIN A7
#define SOIL_MOISTURE_POWER_PIN 12
#define SOIL_MOISTURE_ANALOG_PIN A0
#define LIGHT_SENSOR_PIN A2
#define LIGHT_SENSOR_POWER_PIN 8
#define TEMP_SENSOR_POWER_PIN 10

// constants
const String plantPotID = "0000001";
const long interval = 60000;
const long pumpTime = 2000;
const int N_MEASUREMENTS = 100;
const int soilMoistureDry = 590;
const int soilMoistureWet = 186;
byte hallPins[] = {HALL_SENSOR_FULL_ANALOG_PIN, HALL_SENSOR_66_ANALOG_PIN, HALL_SENSOR_33_ANALOG_PIN, HALL_SENSOR_EMPTY_ANALOG_PIN};
byte hallPowerPins[] = {HALL_POWER_PIN_FULL, HALL_POWER_PIN_66, HALL_POWER_PIN_33, HALL_POWER_PIN_EMPTY};

// variables 
unsigned long uniqueID = 1;
int waterLevelValue = -1;
int waterLevelPercentage = -1;
int hallSensorValue[] = {-1, -1, -1, -1} ;
int soilMoistureValue = -1;
int soilMoisturePercentage = -1;
int lightValue = -1.0;
float analogLightValue = 0.0;
int temperatureValue = -1.0;
int humidityValue = -1.0;
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;
unsigned long pumpMillis = 0;
String sensorData = "";
char ssid[] = SECRET_SSID;    // network SSID from arduino_secrets.h
char pass[] = SECRET_PASS;    // network password from arduino_secrets.h

IPAddress server();//fill in ip address

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

WiFiClient wifiClient;
PubSubClient client(wifiClient);

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("arduinoClient", "name", "pass")) { // fill in name and pass of the account you are using
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial) {}
  //set all the power pins of the sensors as output
  pinMode(PUMP_DIGITAL_PIN, OUTPUT);
  digitalWrite(PUMP_DIGITAL_PIN, LOW);
  for(int p=0;p<4;p++){
    pinMode(hallPowerPins[p], OUTPUT);
    digitalWrite(hallPowerPins[p], LOW);
  }
  pinMode(SOIL_MOISTURE_POWER_PIN, OUTPUT);
  digitalWrite(SOIL_MOISTURE_POWER_PIN, LOW);
  pinMode(LIGHT_SENSOR_POWER_PIN, OUTPUT);
  digitalWrite(LIGHT_SENSOR_POWER_PIN, LOW);
  pinMode(TEMP_SENSOR_POWER_PIN, OUTPUT);
  digitalWrite(TEMP_SENSOR_POWER_PIN, HIGH);

  //set mqtt client
  client.setServer(server, 1883);
  client.setCallback(callback);

  // connect to aht25 temprature and moisture sensor
  Wire.begin(); //join I2C bus
  if (aht20.begin() == false)
  {
    Serial.println("AHT20 not detected. Please check wiring. Freezing.");
    while (1);
  }
  Serial.println("AHT25 working");

  //connect to wifi
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // failed, retry
    Serial.print(".");
    delay(5000);
  }
  Serial.println("You're connected to the network");
}

void pumpOn(){
  if(soilMoisturePercentage <= 20 && waterLevelValue < 3){
    if (digitalRead(PUMP_DIGITAL_PIN) == false) {
      digitalWrite(PUMP_DIGITAL_PIN, HIGH);
      pumpMillis = currentMillis;
    }
    else if(digitalRead(PUMP_DIGITAL_PIN) && currentMillis - pumpMillis >= pumpTime ){
      digitalWrite(PUMP_DIGITAL_PIN, LOW);
      Serial.println();
    }
  }
  else {
    digitalWrite(PUMP_DIGITAL_PIN, LOW);
  }
  if (currentMillis - pumpMillis < 0){
    pumpMillis = 0;
  }
  waterLevelSensor();
  soilMoistureSensor();
  Serial.print(waterLevelValue);
  Serial.print(",");
  Serial.print(soilMoistureValue);
}

void waterLevelSensor(){
    for(int w = 0; w < 4; w++){
      digitalWrite(hallPowerPins[w], HIGH);
      delay(10);
      //Serial.println(hallPins[w]);
      hallSensorValue[w] = analogRead(hallPins[w]);
      
      if (hallSensorValue[w] >= 550) {
        waterLevelValue = w;
      }
      digitalWrite(hallPowerPins[w], LOW);
    }
    switch (waterLevelValue) {
      case 0:
      // water level is full
        waterLevelPercentage = 100;
        break;
      case 1:
        waterLevelPercentage = 66;
        break;
      case 2:
        waterLevelPercentage = 33;
        break;
      case 3:
        waterLevelPercentage = 0;
        break;
    }
}

void soilMoistureSensor(){
  soilMoistureValue = 0;
  digitalWrite(SOIL_MOISTURE_POWER_PIN, HIGH);
  delay(10);
  for(int s = 0; s < N_MEASUREMENTS; s++){
  soilMoistureValue += analogRead(SOIL_MOISTURE_ANALOG_PIN); //connect sensor to Analog 0
  }
  soilMoistureValue = soilMoistureValue / N_MEASUREMENTS; 
  soilMoisturePercentage = map(soilMoistureValue, soilMoistureDry, soilMoistureWet, 0, 100);
  digitalWrite(SOIL_MOISTURE_POWER_PIN, LOW);
}

void lightSensor(){
  digitalWrite(LIGHT_SENSOR_POWER_PIN, HIGH);
  delay(10);
  for(int l = 0; l < N_MEASUREMENTS; l++){
  analogLightValue += analogRead(LIGHT_SENSOR_PIN); //Read light level
  }
  analogLightValue = analogLightValue / N_MEASUREMENTS;
  float volt = analogLightValue * 3.3 / 1023.0;
  float amps = volt / 10000.0;
  float microAmps = amps * 1000000.0;
  lightValue = microAmps * 2.0;
  digitalWrite(LIGHT_SENSOR_POWER_PIN, LOW);
}

void temperatureSensor(){
  if (aht20.available() == true)
  {
    //Get the new temperature and humidity value
    temperatureValue = aht20.getTemperature();
    humidityValue = aht20.getHumidity();
  }
  else{
    temperatureSensor();
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  currentMillis = millis();

  if (currentMillis - previousMillis >= interval ){
    previousMillis = currentMillis;
    waterLevelSensor();
    soilMoistureSensor();
    lightSensor();
    temperatureSensor();

    sensorData = plantPotID;
    sensorData += ";UUID,";
    sensorData += uniqueID;
    sensorData += ",waterniveau,";
    sensorData += waterLevelPercentage;
    sensorData += ",licht,";
    sensorData += lightValue;
    sensorData += ",temperatuur,";
    sensorData += temperatureValue;
    sensorData += ",bodemvocht,";
    sensorData += soilMoisturePercentage;
    sensorData += ",luchtvochtigheid,";
    sensorData += humidityValue;
    Serial.println(sensorData);
    Serial.println("----------------------------");

    client.beginPublish("sensordata", sensorData.length(), false);
    client.print(sensorData);
    client.endPublish();
    uniqueID++;   
  }
  if (currentMillis - previousMillis < 0){
    previousMillis = 0;
  }
  pumpOn();
}
