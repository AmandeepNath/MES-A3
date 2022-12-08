/*
* FILE : an_hook.c
* PROJECT : SENG2010 - Assignment #5
* PROGRAMMER : Amandeep Nath
* FIRST VERSION : 2022-11-29
* DESCRIPTION : This program will allow the user to blink all LED's forever.
*               After that they can stop the watchdog with the user button
*               and the board will restart.
* 
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"
#include "watchdog.h"



// Prototype for setup function

int _an_watchdog_start(int timeout, int delay);

/*
* FUNCTION    : _an_a5
*
* DESCRIPTION : This function is used to setup the infinite blinking, initialize and start watchdog 
*
* PARAMETERS  :	timeout				    : delay			
*				        int timeout	      : timeout
*				        int delay	        : delay
* 
* RETURNS	  : NONE
*/
void _an_A5(int action)
{

  // The prompt that is shown when the user uses the help command with anWatch 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Infinite blinking for A5\n\n"
	   "This command sets up the tick function\n"
	   );

    return;
  }


  // first argument for the timeout parameter
  uint32_t timeout;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&timeout);

  if(fetch_status) {
  	// Use a default value
  	timeout = 2000;
  }


  // second argument for the delay parameter
  uint32_t delay;

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// Use a default value
  	delay = 500;
  }

  mes_InitIWDG(timeout);
  mes_IWDGStart();

  _an_watchdog_start(timeout, delay);


  
  printf("Started Blinking\n\n");


}
ADD_CMD("anWatch", _an_A5,"Blinking forever")





int _an_a5_tick_handler();

void _an_A5_tick(int action)
{

  // The prompt that is shown when the user uses the help command with anWatch 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Test tick\n\n"
	   "This command is used to test one tick\n"
	   );

    return;
  }

  _an_a5_tick_handler();

  printf("Test tick\n\n");


}
ADD_CMD("anTick", _an_A5_tick,"Test tick")