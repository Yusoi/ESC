#include <iostream>
#include <thread>
#include <vector>
#include <mutex>
#include <condition_variable>
#include "heattimer.h"

#define N_MAX 1000
#define MAT_SIZE 1024
#define M_SIZE MAT_SIZE + 2
#define N_THREADS 8
#define M_DIV MAT_SIZE / N_THREADS

class Barrier{
    private:
        int counter = 0;
        std::mutex counter_mt;
        std::mutex wait_mt;
        std::condition_variable cv;
    public:
        void barrier(){
            counter_mt.lock();
            counter++;
            int c = counter;
            counter_mt.unlock();

            if(c != N_THREADS){
                printf("Barrier Wait! %d\n",c);
                fflush(stdout);
                std::unique_lock<std::mutex> wait_lock(wait_mt);
                cv.wait(wait_lock);
            } else {
                counter_mt.lock();
                counter = 0;
                counter_mt.unlock();
                printf("Barrier Free! %d\n",c);
                cv.notify_all();
            }
        }
};


void heat_dispersion(int tnum, int** G1, int** G2, Barrier *br){
    for (int it = 0; it < N_MAX; it++)
    {
        for (int i = (tnum * M_DIV) + 1; i < ((tnum + 1) * M_DIV) + 1; i++)
        {
            for (int j = 1; j < M_SIZE - 1; j++)
            {
                G2[i][j] = (G1[i - 1][j] + G1[i + 1][j] + G1[i][j - 1] + G1[i][j + 1] + G1[i][j]) / 5; 
            }
        }

        printf("Entering Barrier %d ------------- \n",tnum);
        br->barrier();

        for (int i = (tnum * M_DIV) + 1; i < ((tnum + 1) * M_DIV) + 1; i++)
        {
            for (int j = 1; j < M_SIZE - 1; j++)
            {
                G1[i][j] = G2[i][j]; 
            }
        }

        printf("Entering Barrier %d ------------- \n",tnum);
        br->barrier();
    }
}

int main()
{
    char c{};
    std::cout << "Press ENTER to start the program: ";
    scanf("*");

    FILE *file = fopen("result.txt", "w+");

    int **G1, **G2;

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

    std::thread threads[N_THREADS];

    //------------------------------------------------------------------------------------------
    //Iterações sobre a difusão de calor
    Barrier br;

    for(int i = 0; i < N_THREADS; i++){
        threads[i] = std::thread(heat_dispersion,i,G1,G2,&br);
    }
    
    for(int i = 0; i < N_THREADS; i++){
        threads[i].join();
    }

    //Prints results to a file
    for (int i = 0; i < M_SIZE; i++)
    {
        for (int j = 0; j < M_SIZE; j++)
            fprintf(file, "%d|", G1[i][j]);
    }
    fprintf(file, "\n");
}
