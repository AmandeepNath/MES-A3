/*
* FILE : an_hook.c
* PROJECT : SENG2010 - Assignment #4
* PROGRAMMER : Amandeep Nath
* FIRST VERSION : 2022-11-17
* DESCRIPTION : This program will allow the user to play a simple game. In this game the user can use the board
*               to move an LED in cricle. If they land the LED and hold it on the target, the user wins.
*               If they are unable to do this in the specified time, they lose.
* 
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

// Prototype for the tilt game function
int _an_a4_tick_setup(int delay, int target, int game_time);




/*
* FUNCTION    : _an_a4
*
* DESCRIPTION : This function is used to setup the tilt game
*
* PARAMETERS  :	delay				: target			: game_time
*				        int delay	        : delay
*				        int target	      : target
*			          int	game_time		  : game time
* 
* RETURNS	  : NONE
*/
void _an_a4(int action)
{

  // The prompt that is shown when the user uses the help command with xxTilt 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Tilt Game\n\n"
	   "This function will allow you to play the tilt game\n"
	   );

    return;
  }

  uint32_t delay;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// default value
  	delay = 500;
  }

  uint32_t target;

  fetch_status = fetch_uint32_arg(&target);

  if(fetch_status) {
  	// default value
  	target = 7;
  }

  uint32_t game_time;

  fetch_status = fetch_uint32_arg(&game_time);

  if(fetch_status) {
  	// default value
  	game_time = 5;
  }


  
  _an_a4_tick_setup(delay, target, game_time);


  printf("Play Again?\n\n");
  

}
ADD_CMD("anTilt", _an_a4,"Tilt Game")





// Prototype for the tickfunction
int _an_a4_tick();


/*
* FUNCTION    : a4_tick
*
* DESCRIPTION : This function is used to run a tick
*
* PARAMETERS  :	NONE
* 
* RETURNS	  : NONE
*/
void a4_tick(int action)
{

  // The prompt that is shown when the user uses the help command with A4tick 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("A4 Tick Handler\n\n"
	   "This function will allow you to play with the tick handler\n"
	   );

    return;
  }


  printf("A4 Tick handler: %d\n\n", _an_a4_tick());
  

}
ADD_CMD("A4tick", a4_tick,"A4 Tick Handler")