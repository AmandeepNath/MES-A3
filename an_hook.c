/*
* FILE : an_hook.c
* PROJECT : SENG2010 - Assignment #3
* PROGRAMMER : Amandeep Nath
* FIRST VERSION : 2022-10-06
* DESCRIPTION : 
* 
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int a3_Game(int delay, char *pattern, int target);


void _an_A3(int action)
{

  // The prompt that is shown when the user uses the help command with anGame 
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Play the blinking lights game!\n\n"
	   "This function will allow you to play the blinking lights game\n"
	   );

    return;
  }




  int fetch_status;

  char *destptr;



  fetch_status = fetch_string_arg(&destptr);

  if(fetch_status) {
      // Default logic here
      destptr = "Test";
  }


  ;

  printf("%d\n\n", a3_Game(destptr));


}
ADD_CMD("anGame", anGame,"Play the blinking lights game")

