/* chat client in c*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>     // memset
#include <sys/socket.h> // socket functions
#include <netdb.h>      // socket functions

int main(int argc, char **argv)
{
	int port = atoi(argv[2]), sockfd = 0, n;
	struct sockaddr_in server_address;
	char bufsend[500], bufrcv[500], handle[10];
	
	//Copy only first ten characters entered into handle field, this will be the prompt and the prepention to messages.
	strncpy(handle, argv[1], 10);
	
	//Socket setup.
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	
	memset(&server_address, 0, sizeof(server_address));
	server_address.sin_family = AF_INET;
	//User specifies port with the second argument of main
	server_address.sin_port = htons(port); 	
	inet_pton(AF_INET, argv[2], &server_address.sin_addr.s_addr);
	
	connect(sockfd, (struct sockaddr *)&server_address, sizeof(server_address));
	
	//Data exchange here
	printf("%s:> ", handle);
	while(fgets(bufsend, 500, stdin) != NULL){
		memset(bufrcv, 0, 500);
		//Properly setup buffer to be sent:
		char* bsend = malloc(510);
		//Prepend handle (given in main arguments)
		strcpy(bsend, handle);
		//add a seperator
		strcat(bsend, ":> ");
		//add stdin.
		strcat(bsend, bufsend);
		
		// If the quit command is typed, quit.
		if(strstr(bufsend, "\\quit") != NULL){
			close(sockfd);
			break;
		}
		//Otherwise, send transmission.
		else{
			write(sockfd, bsend, strlen(bsend) + 1);
			if(read(sockfd, bufrcv, 500) == 0){
				perror("Something broke or if '\\quit' was typed the connection was severed.");
				exit(-1);
			}
			fputs(bufrcv, stdout);
			printf("%s:> ", handle);
		}
	}

	return 0;
	
}