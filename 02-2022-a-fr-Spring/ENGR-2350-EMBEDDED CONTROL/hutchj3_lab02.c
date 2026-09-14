/**********************************************************************/
// ENGR-2350 Template Project
// Name: Joseph Hutchinson and Hayden Fuller
// RIN: 662022852 and 662028619
// This is the base project for several activities and labs throughout
// the course.  The outline provided below isn't necessarily *required*
// by a C program; however, this format is required within ENGR-2350
// to ease debugging/grading by the staff.
/**********************************************************************/

// We'll always add this include statement. This basically takes the
// code contained within the "engr_2350_msp432.h" file and adds it here.
#include "engr2350_msp432.h"
#include <stdlib.h>

// Add function prototypes here, as needed.
void Timer_Init();
void GPIO_Init();
void UpdateTime();
void Timer_ISR();
void Game_Start();
int RGB_Input();
void Display_All();
int Play_Game();


// Add global variables here, as needed.
Timer_A_UpModeConfig config;
uint16_t timearray[2];
uint8_t timer_flag=0;
uint8_t gamearray[10];
uint8_t bp0=0;
uint8_t bp1=0;
uint8_t bp2=0;
uint8_t bp3=0;
uint8_t bp4=0;
uint8_t bp5=0;
uint8_t push=0;


int main(void) /* Main Function */
{
    // Add local variables here, as needed.

    // We always call the "SysInit()" first to set up the microcontroller
    // for how we are going to use it.
    SysInit();

    // Printing out initial game instructions
    printf("\rWelcome to Ti-mon Says!\n\r");
    printf("In this game, try your best to match a sequence of colors blinked at you by the RGB light.\n\r"
            "Each color has a corresponding bumper switch on the car.\n\r"
            "Once the sequence has been shown, repeat it by pressing the correct colored bumpers in the correct order.\n\r"
            "Win by successfully matching all sequences up to a total of 10 colors!\n\n\r"
            "Before playing, try each of the 6 bumpers to see which colors they represent.\n\n\r"
            "TO START: Press the black pushbutton.\n\n\r");

    // Place initialization code (or run-once) code here
    GPIO_Init();
    Timer_Init();



    // Continuous loop here
    while(1){
        RGB_Input();
        // CHANGE THIS ACCORDINGLY:
        push = !GPIO_getInputPinValue(GPIO_PORT_P2, GPIO_PIN3);
        if(push){
            // 1 second delay (main 24Hz clock), NOT our timer
            __delay_cycles(240e6);
            printf("Game Started!");

            if(Play_Game()) {
                printf("You Win!!!");
                //flash green 0.5s
                while(push==0) {
                    // Check pushbutton and update if needed:
                    push = GPIO_getInputPinValue(GPIO_PORT_P2, GPIO_PIN3);

                    // Turn ON and Green
                    GPIO_setOutputHighOnPin(GPIO_PORT_P3, GPIO_PIN2);
                    GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN3);
                    // write 0.25 sec delay here
                    // Turn OFF
                    GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN2);
                    // write 0.25 sec delay here
                    // Check pushbutton and update if needed:
                    push = GPIO_getInputPinValue(GPIO_PORT_P2, GPIO_PIN3);
                }

            }else {
                printf("INCORRECT!");
                //flash red 0.25s
                while(push==0) {
                    // Turn ON and Red
                    GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN2);
                    GPIO_setOutputHighOnPin(GPIO_PORT_P3, GPIO_PIN3);
                    // write 0.25 sec delay here
                    // Turn OFF
                    GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN3);
                    // write 0.25 sec delay here

                    // Check pushbutton and update if needed:
                    push = GPIO_getInputPinValue(GPIO_PORT_P2, GPIO_PIN3);
                }
            }


        }
    }
}

// Add function declarations here as needed

void GPIO_Init(){ // Function to initialize BMP buttons as inputs, pushbutton as input, and all pins for LED
    // Set [4.0, 4.2, 4.3, 4.5, 4.6, 4.7] to inputs, for the switches [BMP0, BMP1, BMP2, BMP3, BMP4, BMP5] respectively
    GPIO_setAsInputPinWithPullUpResistor( GPIO_PORT_P4, GPIO_PIN0|GPIO_PIN2|GPIO_PIN3|GPIO_PIN5|GPIO_PIN6|GPIO_PIN7 );

    // Set pushbutton P2.3 as input
    GPIO_setAsInputPin(GPIO_PORT_P2, GPIO_PIN3);

    //Set RGB LED pins as outputs
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN0);//R
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN1);//G
    GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);//B

    //Set BiLED pin outputs
    GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN2);
    GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN3);
}


void Timer_Init(){ // Initialize the config for TimerA1 (0.25 sec reset)
    config.clockSource = TIMER_A_CLOCKSOURCE_SMCLK;
    config.clockSourceDivider = TIMER_A_CLOCKSOURCE_DIVIDER_64;
    config.timerPeriod = 18750;
    config.timerInterruptEnable_TAIE = TIMER_A_TAIE_INTERRUPT_ENABLE; // Enable the Interrupt

    // Configure TimerA1 to use the config settings
    Timer_A_configureUpMode( TIMER_A1_BASE, &config);
    // Register function "ISR" as the one to be called by the interrupt hardware automatically
    Timer_A_registerInterrupt( TIMER_A1_BASE , TIMER_A_CCRX_AND_OVERFLOW_INTERRUPT , Timer_ISR );
    // Start counting on TimerA1, using counting UP mode
    Timer_A_startCounter(TIMER_A1_BASE, TIMER_A_UP_MODE);
}


void UpdateTime(){ // Function to update the time array after every 50 ms has passed
    timearray[0] = timearray[0] + 5;  // Increment milliseconds
    if(timearray[0] == 100){  // If a whole second has passed...
        timearray[0] = 0;    // Reset milliseconds
        timearray[1]++;      // And increment seconds
        if(timearray[1] == 128){ // If 3 seconds have passed...
            timearray[1] = 0;   // Reset seconds

        }
    }

    printf("%u . %u    \r", timearray[1], timearray[0]);
    //printf("%u \r", timearray[1]);
}

void Game_Start() { // Function to generate color array at start of each/every game
    uint8_t len;
    // Set timer array to 0,0 so that there's a "blank slate" for the game
    timearray[0] = 0;
    timearray[1] = 0;

    // Generate random color sequence for game, in a 10-element array
    srand(rand());
    for(len=0;len<10;len++) {
        gamearray[len] = rand()%6;
    }
}

int RGB_Input() {
    uint8_t pressed = 8;
    uint8_t held = 0;
    while(pressed==8 || held) { //sets bp0-5 as bumper values, checks if any are true and sets that as pressed value,
                                //sets LED to that color and waits for release
        if(!held || bp0){
            bp0 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN0);}
        if(!held || bp1){
            bp1 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN2);}
        if(!held || bp2){
            bp2 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN3);}
        if(!held || bp3){
            bp3 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN5);}
        if(!held || bp4){
            bp4 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN6);}
        if(!held || bp5){
            bp5 = !GPIO_getInputPinValue(GPIO_PORT_P4, GPIO_PIN7);}

        if(bp0) {
            // RED
            __delay_cycles(240e3);
            pressed = 0;
            held = 1;
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(bp1) {
            // GREEN
            __delay_cycles(240e3);
            pressed = 1;
            held = 1;
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(bp2) {
            // BLUE
            __delay_cycles(240e3);
            pressed = 2;
            held = 1;
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(bp3) {
            // YELLOW
            __delay_cycles(240e3);
            pressed = 3;
            held = 1;
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(bp4) {
            // MAGENTA
            __delay_cycles(240e3);
            pressed = 4;
            held = 1;
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(bp5) {
            // CYAN
            __delay_cycles(240e3);
            pressed = 5;
            held = 1;
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else {
            held = 0;
            // Turn off RGB LED entirely
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0|GPIO_PIN1|GPIO_PIN2);
        }
    }
    return pressed;
}

void Display_All() {
    uint8_t len;
    for(len=0;len<10;len++) {
        if(gamearray[len]==0) {//R
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1|GPIO_PIN2);
        } else if(gamearray[len]==1) {//G
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(gamearray[len]==2) {//B
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0|GPIO_PIN1);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(gamearray[len]==3) {//Y
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0|GPIO_PIN1);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(gamearray[len]==4) {//M
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);
        } else if(gamearray[len]==5) {//C
            GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
            GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1|GPIO_PIN2);
        }
        //timer wait
    }
}

int Play_Game() {
    Game_Start();
    uint8_t len;
    uint8_t disp;
    for(len=0;len<10;len++) {
        for(disp=0;disp<len;disp++) {

        }
        return 0; // messed up or ran out of time
    }
    return 1; //got through everything correctly
}

// Add interrupt functions last so they are easy to find

void Timer_ISR(){ // General ISR function which will be automatically called by hardware upon overflow
    Timer_A_clearInterruptFlag(TIMER_A1_BASE);
    UpdateTime();
}

