#include <unistd.h>
#include <stdio.h>

int main( void )
{
    int filedes[2];
    char buf[80];
    int pid;
    pipe( filedes );
    if ( (pid=fork()) > 0 )
    {
        cprintf( "This is in the father process,here write a string to the pipe.\n" );
        char s[] = "Hello world , this is write by pipe.\n";
        write( filedes[1], s, sizeof(s) );
        close( filedes[0] );
        close( filedes[1] );
    }
    else
    {
        cprintf( "This is in the child process,here read a string from the pipe.\n" );
        read( filedes[0], buf, sizeof(buf) );
        cprintf( "%s\n", buf );
        close( filedes[0] );
        close( filedes[1] );
    }
    waitpid( pid, NULL, 0 );
    return 0;
}
