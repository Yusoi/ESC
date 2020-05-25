#!/usr/sbin/dtrace -qs

self uint64_t start_time;

dtrace:::BEGIN
{	
	printf("############################################\n");
	printf("#               Custom STrace              #\n");
	printf("############################################\n");
	printf("%-20s %10s %10s\n", "System Call", "#", "Time(ns)");
}

syscall:::entry
/execname == $$1/
{
	@num[probefunc] = count();
	self->start_time = timestamp;
}

syscall:::return
/execname == $$1 && self->start_time != 0/
{
	@time[probefunc] = sum(timestamp-self->start_time);
}

dtrace:::END
{
	printa("%-20s %@10d %@10d\n",@num,@time);
}
