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



void _an_lab8test(int action)
{

  // The prompt that is shown when the user uses the help command with lab8test 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 8 watchdog\n\n"
	   "This function will allow you to test lab8 watchdog\n"
	   );

    return;
  }


  // first argument for the timeout parameter
  uint32_t timeout;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&timeout);

  if(fetch_status) {
  	// Use a default value
  	timeout = 500;
  }

  //hiwdg.Init.Reload = timeout;


  mes_InitIWDG(timeout);
  
  mes_IWDGStart();


  printf("Play Again?\n\n");
  

}
ADD_CMD("lab8test", _an_lab8test,"Lab8 Test")




int _an_watchdog_start(int timeout, int delay);


void _an_A5(int action)
{

  // The prompt that is shown when the user uses the help command with anWatch 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Watchdog for A5\n\n"
	   "This command stops the watchdog refresh\n"
	   );

    return;
  }


  // first argument for the timeout parameter
  uint32_t timeout;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&timeout);

  if(fetch_status) {
  	// Use a default value
  	timeout = 500;
  }


  // second argument for the delay parameter
  uint32_t delay;

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// Use a default value
  	delay = 500;
  }

  //hiwdg.Init.Reload = timeout;

  mes_InitIWDG(timeout);
  

  mes_IWDGStart();

  _an_watchdog_start(timeout, delay);

  printf("Stopped Watchdog\n\n");


}
ADD_CMD("anWatch", _an_A5,"Stop refreshing watchdog")