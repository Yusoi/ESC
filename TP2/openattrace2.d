#!/usr/sbin/dtrace -qs
/*
*O_WRONLY = 1;
*O_RDWR = 2;
*O_APPEND = 8;
*O_CREAT = 256;
*/

this int create;
this int successful;
self int flags;

dtrace:::BEGIN
{	
	printf("############################################\n");
	printf("#               Openat Tracer              #\n");
	printf("############################################\n");
	printf("%6s %30s %6s %6s %12s\n","PID", "CMD", "OPEN", "CREATE", "SUCCESSFUL");
}

syscall::openat:entry
/(int)arg0 == -3041965/
{
	self->flags = arg2;	
	@opens[pid,execname] = count();

}

syscall::openat:return
{
	this->create = self->flags & O_CREAT ? 1 : 0;
	@creates[pid,execname] = sum(this->create);

	this->successful = arg0 == -1 ? 0 : 1;
	@successful[pid,execname] = sum(this->successful);
}

tick-1sec
{	
	printf("%-20Y\n",walltimestamp);
	printa("%6d %30s %@6d %@6d %@12d\n",@opens,@creates,@successful);
}
