#!/usr/sbin/dtrace -qs
/*
*inline int O_WRONLY = 1;
*inline int O_RDWR = 2;
*inline int O_APPEND = 8;
*inline int O_CREAT = 256;
*/


self uint64_t start_time;

dtrace:::BEGIN
{	
	printf("############################################\n");
	printf("#               Custom STrace              #\n");
	printf("############################################\n");
	printf("%-20s %10s %10s\n", "System Call", "#", "Time(ns)");
}

syscall:::entry
/execname == $1/
{
	@num[probefunc] = count();
	self->start_time = timestamp;
}

syscall:::return
/execname == $1/
{
	@time[probefunc] = sum(timestamp-self->start_time);
}

dtrace:::END
{
	printa("%-20s %@10d %@10d\n",@num,@time);
}
