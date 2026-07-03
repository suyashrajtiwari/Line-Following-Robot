/**********************************************************************
 * Line Following Robot using ESP32
 * Sensor : RLS08 Digital IR Sensor Array
 * Motor Driver : L298N
 * Controller : ESP32
 **********************************************************************/

//==================== PIN DEFINITIONS ====================//

#define ENA 23
#define IN1 18
#define IN2 19

#define ENB 5
#define IN3 21
#define IN4 22

//RLS08 Sensor Pins

#define S1 13
#define S2 12
#define S3 14
#define S4 27
#define S5 26
#define S6 25
#define S7 33
#define S8 32

//==================== PID CONSTANTS ====================//

float Kp = 18.0;
float Ki = 0.0;
float Kd = 12.0;

float error = 0;
float previousError = 0;
float integral = 0;
float derivative = 0;

int correction = 0;

//==================== MOTOR SPEED ====================//

int baseSpeed = 150;
int maxSpeed = 255;

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;

//==================== SENSOR ARRAY ====================//

int sensor[8];

int weights[8] =
{
    -3500,
    -2500,
    -1500,
    -500,
     500,
    1500,
    2500,
    3500
};

long position = 0;

//==================== MOTOR FUNCTIONS ====================//

void setMotor(int left,int right)
{

    if(left>=0)
    {
        digitalWrite(IN1,HIGH);
        digitalWrite(IN2,LOW);
    }
    else
    {
        digitalWrite(IN1,LOW);
        digitalWrite(IN2,HIGH);
        left=-left;
    }

    if(right>=0)
    {
        digitalWrite(IN3,HIGH);
        digitalWrite(IN4,LOW);
    }
    else
    {
        digitalWrite(IN3,LOW);
        digitalWrite(IN4,HIGH);
        right=-right;
    }

    left=constrain(left,0,maxSpeed);
    right=constrain(right,0,maxSpeed);

    analogWrite(ENA,left);
    analogWrite(ENB,right);

}

//==================== SENSOR READING ====================//

void readSensors()
{

    sensor[0]=digitalRead(S1);
    sensor[1]=digitalRead(S2);
    sensor[2]=digitalRead(S3);
    sensor[3]=digitalRead(S4);
    sensor[4]=digitalRead(S5);
    sensor[5]=digitalRead(S6);
    sensor[6]=digitalRead(S7);
    sensor[7]=digitalRead(S8);

}

//==================== LINE POSITION ====================//

long calculatePosition()
{

    long sum=0;
    int active=0;

    for(int i=0;i<8;i++)
    {

        //black line assumed LOW

        if(sensor[i]==LOW)
        {
            sum+=weights[i];
            active++;
        }

    }

    if(active==0)
    {

        if(previousError>0)
            return 4000;
        else
            return -4000;

    }

    return sum/active;

}

//==================== PID CONTROLLER ====================//

void calculatePID()
{

    position=calculatePosition();

    error=position;

    integral+=error;

    derivative=error-previousError;

    correction=
            (Kp*error)
          + (Ki*integral)
          + (Kd*derivative);

    previousError=error;

}

//==================== MOTOR UPDATE ====================//

void updateMotors()
{

    leftMotorSpeed=
            baseSpeed-correction;

    rightMotorSpeed=
            baseSpeed+correction;

    leftMotorSpeed=
            constrain(leftMotorSpeed,
                      -maxSpeed,
                      maxSpeed);

    rightMotorSpeed=
            constrain(rightMotorSpeed,
                      -maxSpeed,
                      maxSpeed);

    setMotor(leftMotorSpeed,
             rightMotorSpeed);

}
//==================== ROBOT RECOVERY ====================//

void recoverLine()
{

    readSensors();

    int active = 0;

    for(int i = 0; i < 8; i++)
    {
        if(sensor[i] == LOW)
        {
            active = 1;
            break;
        }
    }

    if(active)
        return;

    // Rotate in previous direction

    if(previousError > 0)
    {
        setMotor(-120,120);
    }
    else
    {
        setMotor(120,-120);
    }

}

//==================== SENSOR DEBUG ====================//

void printSensors()
{

    for(int i = 0; i < 8; i++)
    {
        Serial.print(sensor[i]);
        Serial.print(" ");
    }

    Serial.print(" Position : ");
    Serial.print(position);

    Serial.print(" Error : ");
    Serial.print(error);

    Serial.print(" Correction : ");
    Serial.print(correction);

    Serial.print(" Left : ");
    Serial.print(leftMotorSpeed);

    Serial.print(" Right : ");
    Serial.println(rightMotorSpeed);

}

//==================== INITIALIZATION ====================//

void setup()
{

    Serial.begin(115200);

    pinMode(ENA,OUTPUT);
    pinMode(IN1,OUTPUT);
    pinMode(IN2,OUTPUT);

    pinMode(ENB,OUTPUT);
    pinMode(IN3,OUTPUT);
    pinMode(IN4,OUTPUT);

    pinMode(S1,INPUT);
    pinMode(S2,INPUT);
    pinMode(S3,INPUT);
    pinMode(S4,INPUT);
    pinMode(S5,INPUT);
    pinMode(S6,INPUT);
    pinMode(S7,INPUT);
    pinMode(S8,INPUT);

    analogWrite(ENA,0);
    analogWrite(ENB,0);

    delay(1000);

    Serial.println("--------------------------------");
    Serial.println("Line Following Robot Started");
    Serial.println("--------------------------------");

}

//==================== MAIN LOOP ====================//

void loop()
{

    readSensors();

    int count = 0;

    for(int i = 0; i < 8; i++)
    {
        if(sensor[i] == LOW)
            count++;
    }

    // Line Lost

    if(count == 0)
    {
        recoverLine();
        return;
    }

    // PID Calculation

    calculatePID();

    // Update Motor Speed

    updateMotors();

    // Optional Debug

    printSensors();

    delay(5);

}

//==================== END ====================//
