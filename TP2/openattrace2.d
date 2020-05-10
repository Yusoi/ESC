#!/usr/sbin/dtrace -qs
/*
*inline int O_WRONLY = 1;
*inline int O_RDWR = 2;
*inline int O_APPEND = 8;
*inline int O_CREAT = 256;
*/

int opens;
int creates;
int successful;

this int create;
this int successful;
this string return_out;
this string flags_out;
self string path;
self int flags;

dtrace:::BEGIN
{	
	printf("############################################\n");
	printf("#               Openat Tracer              #\n");
	printf("############################################\n");
	printf("%6s %20s %15s %15s %15s\n","PID", "CMD", "OPEN", "CREATE", "SUCCESSFUL");

	opens = 0;
	creates = 0;
	successful = 0;
}

syscall::openat:entry
/(int)arg0 == -3041965/
{
	self->flags = arg2;	
	@opens[pid] = count();
}

syscall::openat:return
{
	this->create = self->flags & O_CREAT ? 1 : 0;
	@creates[pid] = sum(this->create);

	this->successful = arg0 == -1 ? 0 : 1;
	@successful[pid] = sum(this->successful);
}

tick-1sec
{	

	printf("%-20Y\n",walltimestamp);
	printa("CREATES: %6d ",@creates);
	printf("%6d %20s %15d %15d %15d\n",pid, execname, opens, creates, successful);
	opens = 0;
	creates = 0;
	successful = 0;
}
