#!/usr/sbin/dtrace -qs

uint64_t m_size;
uint64_t m_gen_time;
uint64_t alg_time;
uint64_t sleep_time[id_t];

self int iteration_start;
self int copy_start;
self string write_path;

this int it_time;
this int copy_time;
this int calc_time;

dtrace:::BEGIN
{
    printf("Tracer is ready!\n");
}

heattimer*:::query-matrix_generation
{
    m_gen_time = timestamp; 
    m_size = arg0;
}

heattimer*:::query-start_calc
{
    m_gen_time = timestamp - m_gen_time;
    alg_time = timestamp;
}

heattimer*:::query-start_iteration
{
    self->iteration_start = timestamp;
}

heattimer*:::query-start_copy
{
    self->copy_start = timestamp;
}

heattimer*:::query-end_iteration
{
    this->it_time = timestamp - self->iteration_start;
    this->copy_time = timestamp - self->copy_start;
    this->calc_time = this->it_time - this->copy_time;
    /*printf("Iteration %d finished on PROCESS: %d, THREAD: %d\n\tTime spent on calculations: %d\n\tTime spent on copies: %d\n\tTime spent on the whole iteration: %d\n",
           arg0,
	       pid,
           tid,
           this->calc_time,
           this->copy_time,
           this->it_time);*/

    @avg_calc_time = avg(this->calc_time);
    @max_calc_time = max(this->calc_time);
    @avg_copy_time = avg(this->copy_time);
    @max_copy_time = max(this->copy_time);
    @avg_it_time = avg(this->it_time);
    @max_it_time = max(this->it_time);
}

heattimer*:::query-end_calc
{
    printf("Program stopped calculating\n");
    alg_time = timestamp - alg_time;
}

syscall::open*:entry
/execname == "openmp"/
{
    self->open_path = copyinstr(arg1);
    printf("Opened the matrix file: %s\n",self->open_path);
}

syscall::pwrite*:entry
/execname == "openmp"/
{
    self->write_path = copyinstr(arg1);
    printf("Started writing in file: %s\n",self->write_path);
}

syscall::pwrite*:return
/execname == "openmp"/
{
    printf("Finished writing in file: %s\n",self->write_path);
}

sched:::on-cpu
/execname == "openmp"/
{
    /*printf("Thread %d started running\n",tid);*/
}

sched:::off-cpu
/execname == "openmp"/
{
    /*printf("Thread %d stopped running\n",tid);*/
}

sched:::sleep
/execname == "openmp"/
{
    sleep_time[tid] = timestamp;
}

sched:::wakeup
/execname == "openmp" && sleep_time[tid] != 0/
{
    @sleep[tid] = sum(timestamp - sleep_time[tid]);
    sleep_time[tid] = 0;
}

lockstat:::adaptive-block
/execname == "openmp"/
{
    @blocks = count();
}

proc:::exec
/execname == "openmp"/
{
    printf("Process %d started executing\n",pid);
}

proc:::exec-failure
/execname == "openmp"/
{
    printf("Process %d exectued unsuccessfully\n",pid);
}

proc:::exec-success
/execname == "openmp"/
{
    printf("Process %d executed correctly\n",pid);
}


dtrace:::END
{
    printf("---------------------- Final Report ----------------------\n");
    printf("Generated Matrices with size:            %dx%d\n",m_size,m_size);
    printf("Time spent generating matrices:          %d\n",m_gen_time);
    printf("Time spent running the main algorithm:   %d\n",alg_time);
    printf("Iteration time:\n");
    printa("    Average:                             %@d\n",@avg_it_time);
    printa("    Maximum:                             %@d\n",@max_it_time);
    printf("Calculation time:\n");
    printa("    Average:                             %@d\n",@avg_calc_time);
    printa("    Maximum:                             %@d\n",@max_calc_time);
    printf("Copying time:\n");
    printa("    Average:                             %@d\n",@avg_copy_time);
    printa("    Maximum:                             %@d\n",@max_copy_time);
    printa("Total number of threads locked:          %@d\n",@blocks);
    printa("Time spent sleeping by thread %d         %@d\n",@sleep);
}
