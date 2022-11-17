/*
* FILE : an_hook.c
* PROJECT : SENG2010 - Assignment #4
* PROGRAMMER : Amandeep Nath
* FIRST VERSION : 2022-11-17
* DESCRIPTION : This program will allow the user to play a simple game.
* 
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

// Prototype for the blinking game function
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