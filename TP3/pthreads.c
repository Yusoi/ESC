#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <stdint.h>
#include "heattimer.h"

#define N_MAX 1000
#define MAT_SIZE 1024
#define M_SIZE MAT_SIZE + 2
#define N_THREADS 8
#define M_DIV MAT_SIZE / N_THREADS

int **G1, **G2;
pthread_barrier_t barrier;

void *heat_dispersion(void* tnum_void){
    int tnum = (intptr_t) tnum_void;
    //------------------------------------------------------------------------------------------
    //Iterações sobre a difusão de calor
    for (int it = 0; it < N_MAX; it++)
    {

        if(tnum == 0)
            if(HEATTIMER_QUERY_START_ITERATION_ENABLED())
                HEATTIMER_QUERY_START_ITERATION();

        for (int i = (tnum * M_DIV) + 1; i < ((tnum + 1) * M_DIV) + 1; i++)
        {
            for (int j = 1; j < M_SIZE - 1; j++)
            {
                G2[i][j] = (G1[i - 1][j] + G1[i + 1][j] + G1[i][j - 1] + G1[i][j + 1] + G1[i][j]) / 5; 
            }
        }

        pthread_barrier_wait(&barrier);

        if(tnum == 0)
            if(HEATTIMER_QUERY_START_COPY_ENABLED())
                    HEATTIMER_QUERY_START_COPY();

        for (int i = (tnum * M_DIV) + 1; i < ((tnum + 1) * M_DIV) + 1; i++)
        {
            for (int j = 1; j < M_SIZE - 1; j++)
            {
                G1[i][j] = G2[i][j]; 
            }
        }

        pthread_barrier_wait(&barrier);

        if(tnum == 0)
            if(HEATTIMER_QUERY_END_ITERATION_ENABLED())
                    HEATTIMER_QUERY_END_ITERATION(it);
    }
}

int main()
{

    printf("Press ENTER to start the program: ");
    scanf("*");

    FILE *file = fopen("result.txt", "w+");

    if(HEATTIMER_QUERY_MATRIX_GENERATION_ENABLED())
        HEATTIMER_QUERY_MATRIX_GENERATION(MAT_SIZE);

    G1 = (int **)malloc(sizeof(int *) * M_SIZE);
    G2 = (int **)malloc(sizeof(int *) * M_SIZE);

    for (int i = 0; i < M_SIZE; i++)
    {
        G1[i] = (int *)malloc(sizeof(int) * M_SIZE);
        G2[i] = (int *)malloc(sizeof(int) * M_SIZE);
    }

    for (int i = 0; i < M_SIZE; i++)
    {
        for (int j = 0; j < M_SIZE; j++)
        {
            G1[i][j] = 0;
            G2[i][j] = 0;
        }
    }

    //Filling the lower line of the matrix with the highest heat
    for (int i = 0; i < M_SIZE; i++)
    {
        G1[i][0] = 0xffffff; //Hexcode ffffff
    }

    pthread_t* thread_handles = (pthread_t*) malloc(N_THREADS * sizeof(pthread_t));
    pthread_barrier_init(&barrier, (pthread_barrierattr_t*) NULL, 8);

    if(HEATTIMER_QUERY_START_CALC_ENABLED())
        HEATTIMER_QUERY_START_CALC();

    for(int thread = 0; thread < N_THREADS; thread++){
        pthread_create(&thread_handles[thread], (pthread_attr_t*) NULL,
                       heat_dispersion, (void*) (intptr_t) thread);
    }

    for(int thread = 0; thread < N_THREADS; thread++){
        pthread_join(thread_handles[thread],NULL);
    }

    free(thread_handles);
    pthread_barrier_destroy(&barrier);

    if(HEATTIMER_QUERY_END_CALC_ENABLED())
        HEATTIMER_QUERY_END_CALC();

    //Prints results to a file
    for (int i = 0; i < M_SIZE; i++)
    {
        for (int j = 0; j < M_SIZE; j++)
            fprintf(file, "%d|", G1[i][j]);
    }
    fprintf(file, "\n");
}
