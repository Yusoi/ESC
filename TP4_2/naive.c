//
// Naive matrix multiplication
//
 
//
// Author:  P.J. Drongowski
// Date:    10 June 2013
//
// Copyright (c) 2013 Paul J. Drongowski
//
 
#include <stdlib.h>
#include <stdio.h>

#define MSIZE 500
 
float matrix_a[MSIZE][MSIZE] ;
float matrix_b[MSIZE][MSIZE] ;
float matrix_r[MSIZE][MSIZE] ;

void initialize_matrices()
{
  int i, j ;
 
  for (i = 0 ; i < MSIZE ; i++) {
    for (j = 0 ; j < MSIZE ; j++) {
      matrix_a[i][j] = (float) rand() / RAND_MAX ;
      matrix_b[i][j] = (float) rand() / RAND_MAX ;
      matrix_r[i][j] = 0.0 ;
    }
  }
}
 
void multiply_matrices()
{
  int i, j, k ;
 
  for (i = 0 ; i < MSIZE ; i++) {
    for (j = 0 ; j < MSIZE ; j++) {
      float sum = 0.0 ;
      for (k = 0 ; k < MSIZE ; k++) {
        sum = sum + (matrix_a[i][k] * matrix_b[k][j]) ;
      }
      matrix_r[i][j] = sum ;
    }
  }
}
 
int main(int argc, char* argv[])
{
  initialize_matrices() ;
  multiply_matrices() ;
  return( EXIT_SUCCESS ) ;
}
