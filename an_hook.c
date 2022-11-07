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

int string_test(char *p);


void _an_lab3(int action)
{
  int fetch_status;

  char *destptr;

  fetch_status = fetch_string_arg(&destptr);

  if(fetch_status) {
      // Default logic here
      destptr = "Test";
  }


  ;

  printf("%d\n\n", string_test(destptr));


}
ADD_CMD("Lab3", _an_lab3,"Test the new lab 3 function")

