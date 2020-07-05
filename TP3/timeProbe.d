#!/usr/sbin/dtrace -qs

int m_size;
int m_gen_time;
int alg_time;

self int iteration_start;
self int copy_start;
self string write_path;
self int sleep_time;
self int asleep;

this int it_time;
this int copy_time;
this int calc_time;

dtrace:::BEGIN
{
    printf("Tracer is ready!\n");
}

heattimer*:::query-matrix_generation
{
    m_gen_time = walltimestamp; 
    m_size = arg0;
}

heattimer*:::query-start_calc
{
    m_gen_time = walltimestamp - m_gen_time;
    alg_time = walltimestamp;
}

heattimer*:::query-start_iteration
{
    self->iteration_start = walltimestamp;
}

heattimer*:::query-start_copy
{
    self->copy_start = walltimestamp;
}

heattimer*:::query-end_iteration
{
    this->it_time = walltimestamp - self->iteration_start;
    this->copy_time = walltimestamp - self->copy_start;
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
    printf("Program stopped running at this time\n");
    alg_time = walltimestamp - alg_time;
}

syscall::open*:entry
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    self->open_path = copyinstr(arg1);
    printf("Opened the matrix file: %s\n",self->open_path);
}

syscall::pwrite*:entry
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    self->write_path = copyinstr(arg1);
    printf("Started writing in file: %s\n",self->write_path);
}

syscall::pwrite*:return
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    printf("Finished writing in file: %s\n",self->write_path);
}

sched:::on-cpu
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    /*printf("Thread %d started running\n",tid);*/
}

sched:::off-cpu
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    /*printf("Thread %d stopped running\n",tid);*/
}

sched:::sleep
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    self->sleep_time = walltimestamp;
    self->asleep = 1;
}

sched:::wakeup
/(execname == "seq" || execname == "openmp" || execname == "mpi") && self->asleep == 1/
{
    @sleep[tid] = sum(walltimestamp - self->sleep_time);
    self->asleep = 0;
}

lockstat:::adaptive-block
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    @blocks = count();
}

proc:::exec
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    printf("Process %d started executing\n",pid);
}

proc:::exec-failure
/execname == "seq" || execname == "openmp" || execname == "mpi"/
{
    printf("Process %d exectued unsuccessfully\n",pid);
}

proc:::exec-success
/execname == "seq" || execname == "openmp" || execname == "mpi"/
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
