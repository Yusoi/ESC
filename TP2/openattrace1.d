#!/usr/sbin/dtrace -qs
/*
*inline int O_WRONLY = 1;
*inline int O_RDWR = 2;
*inline int O_APPEND = 8;
*inline int O_CREAT = 256;
*/

this string return_out;
this string flags_out;
self string path;
self int flags;

dtrace:::BEGIN
{	
	printf("############################################\n");
	printf("#               Openat Tracer              #\n");
	printf("############################################\n");
	printf("%6s %6s %6s %15s %20s %70s\n", "PID", "UID", "GID", "RETURN", "FLAGS", "PATH");
}

syscall::openat:entry
/(int)arg0 == -3041965/
{
	self->path = copyinstr(arg1);
	self->flags = arg2;	
}

syscall::openat:return
{

	this->return_out = arg0 == -1 ? "UNSUCCESSFUL" : "SUCCESSFUL";

	this->flags_out = strjoin(self->flags & O_WRONLY ? "O_WRONLY"
				  			 : self->flags & O_RDWR ? "O_RDWR"
							       		 	: "O_RDONLY",
				  strjoin(self->flags & O_APPEND ? "|O_APPEND"
					 			 : "",
					  self->flags & O_CREAT ? "|O_CREAT"
					 			: ""));

	

	printf("%6d %6d %6d %15s %20s %70s\n",pid, uid, gid, this->return_out, this->flags_out, self->path);
}
