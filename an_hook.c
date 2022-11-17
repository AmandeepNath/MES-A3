/*
* FILE : an_hook.c
* PROJECT : SENG2010 - Assignment #3
* PROGRAMMER : Amandeep Nath
* FIRST VERSION : 2022-10-06
* DESCRIPTION : This program will allow the user to play a simple game. The user can specify a delay, pattern, and target.
*               This pattern will repeat until the user presses a button, if the button is pressed on the target, the user
*               wins. If the button is not pressed on the target, the user loses. All lights will blink twice if it is a win.
*               The target light will stay on until the next game if the user loses.
* 
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

// Prototype for the blinking game function
//int a3_Game(int delay, char *pattern, int target);



//void _an_A3(int action)
//{
//
//  // The prompt that is shown when the user uses the help command with anGame 
//  if(action==CMD_SHORT_HELP) return;
//  if(action==CMD_LONG_HELP) {
//    printf("Play the blinking lights game!\n\n"
//	   "This function will allow you to play the blinking lights game\n"
//	   );
//
//    return;
//  }
//
//
//
//  // first argument for the delay parameter
//  uint32_t delay;
//
//  int fetch_status;
//
//  fetch_status = fetch_uint32_arg(&delay);
//
//  if(fetch_status) {
//  	// default delay
//  	delay = 0x1F4;
//  }
//
//
//
//  // Second argument for the pattern
//  char *pattern;
//
//  fetch_status = fetch_string_arg(&pattern);
//
//  if(fetch_status) {
//      // Default pattern
//      pattern = "43567011";
//  }
//
//
//  // Third argument for the target parameter
//  uint32_t target;
//
//  fetch_status = fetch_uint32_arg(&target);
//
//  if(fetch_status) {
//  	// default target
//  	target = 6;
//  }
//
//
//  // Call the game function
//  a3_Game(delay, pattern, target);
//
//  printf("Play again?\n\n");
//
//
//}
//ADD_CMD("anGame", _an_A3,"Play the blinking lights game")


int lab6(int user_input);

void _an_lab6(int action)
{

  // The prompt that is shown when the user uses the help command with lab6 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Check accelerometer\n\n"
	   "This function will allow you to check the accelerometer\n"
	   );

    return;
  }

  uint32_t user_input;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&user_input);

  if(fetch_status) {
  	// default target
  	user_input = 0;
  }


  for (int i = 0; i < 100; i++)
  {
    printf("Accel Value: %d\n\n", lab6(user_input));
  }



}
ADD_CMD("lab6", _an_lab6,"Accelerometer Test")





int _an_lab_setup(int lab7_input);


void _an_lab7(int action)
{

  // The prompt that is shown when the user uses the help command with lab7 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Tick Handler\n\n"
	   "This function will allow you to play with the tick handler\n"
	   );

    return;
  }

  uint32_t lab7_input;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&lab7_input);

  if(fetch_status) {
  	// default value
  	lab7_input = 5000;
  }


  
  printf("Tick handler: %d\n\n", _an_lab_setup(lab7_input));
  



}
ADD_CMD("lab7", _an_lab7,"Tick Handler")








int _an_lab_tick();

void lab7tick(int action)
{

  // The prompt that is shown when the user uses the help command with lab7 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Tick Handler\n\n"
	   "This function will allow you to play with the tick handler\n"
	   );

    return;
  }



  
  printf("Tick handler: %d\n\n", _an_lab_tick());
  



}
ADD_CMD("ticktest", lab7tick,"Tick Handler")