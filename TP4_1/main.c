#include <stdio.h>
#include <stdlib.h>
#include <time.h>



#include "sort.h"

static int ini_vector (int **v, int n);
static int alloc_vector (int **v, int n);
static int copy_vector (int *v1, int *v2, int n);
static int free_vector (int **v);


int main (int argc, char *argv[]) {
  //long long start_usec, end_usec, elapsed_usec, min_usec=0L;

    int *a, *master;//, *b, *master;

  // read parameters
  if (argc != 4) {
//    fprintf (stdout, "prog algorithm runs size \n");
    fprintf (stdout, "sort int int int \n");

      return 1;
  }
  int alg = atoi(argv[1]);
  int runs = atoi(argv[2]);
  int arraySize = atoi(argv[3]);
    
    
  // ini Master vector
//  fprintf (stdout, "Initializing Vector with %d elements ... ", arraySize);
  if (!ini_vector (&master, arraySize)) return 0;
//  fprintf (stdout, "done!\n");

  // alloc sorting vector a
//  fprintf (stdout, "Alloc sort vector ...");
  if (!alloc_vector (&a, arraySize)) return 0;
//  fprintf (stdout, "done!\n");

  // alloc buffer vector b for radix sort
  //fprintf (stdout, "Alloc buffer vector ...");
  //if (!alloc_vector (&b, MAX_ELEM)) return 0;
  //fprintf (stdout, "done!\n");

  // loop for different lenghts of the vector (n)

// for (n = MIN_ELEM ; n <= MAX_ELEM ; n <<= VEC_SIZE_SHIFT) {

   for (int run=0 ; run < runs ; run++) {

     // copy n elements of master to a
     copy_vector (master, a, arraySize);
  
 //    fprintf (stderr, "run=%d ... ;", run);
       
     switch (alg)
     {
           case 1:
               sort1(a, 0, arraySize);
               break;
           case 2:
               sort2(a, arraySize);
               break;
           case 3:
               sort3(a, arraySize);
               break;
           case 4:
               sort4(a, 0, arraySize);
               break;
           default:
               fprintf (stderr, "Insert correct option...");
     }
       
       
   } // end runs
//   fprintf (stdout, " Done!\n");
 //  printf ("Wall clock time: %lld usecs\n", min_usec);
  
//  } // end different algorithms
// }  // end different sizes loop (n)

  //free_vector (&b);
  free_vector (&a);
  free_vector (&master); 

//  printf ("That's all, folks\n");
  return 1;
}

int alloc_vector (int **v, int n) {

	*v = (int *) malloc (n*sizeof(int));
	if (!(*v)) {
		fprintf (stderr, "Could not allocate memory for vector!");
		return 0;
	}
	return 1;
}

int ini_vector (int **v, int n) {
 	int i;
	int *ptr;

	if (!alloc_vector (v, n)) return 0;
	for (i=0 , ptr = (*v) ; i<n ; i++ , ptr++) {
		*ptr = rand() % 100000000;
	}
	return 1;
} 

int free_vector (int **v) {
  free (*v);
  *v = NULL;
  return 1;
}

int copy_vector (int *v1, int *v2, int n) {
 	int i;

	for (i=0 ; i<n ; i++ , v1++, v2++) {
		*v2 = *v1;
	}
	return 1;
} 


