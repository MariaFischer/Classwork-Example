/* chat server in c++ */

#include <cstdio>
#include <cstdlib>
#include <cstring>      // memset
#include <sys/socket.h> // socket functions
#include <netdb.h>      // socket functions
#include <unistd.h>
#include <arpa/inet.h>

int main(int argc, char **argv)
{
	int port = atoi(argv[1]), listenfd = 0, sockfd = 0, n;
	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	char bufsend[500], bufrcv[500];
	
	//Socket setup.
	listenfd = socket(AF_INET, SOCK_STREAM, 0);
	memset(&server_address, 0, sizeof(server_address));
	
	server_address.sin_family = AF_INET;
	server_address.sin_addr.s_addr = htonl(INADDR_ANY); 
	//User specifies port with the first argument of main
	server_address.sin_port = htons(port);	
	
	if (bind(listenfd, (struct sockaddr *)&server_address, sizeof(server_address)) != 0){
		perror("Something broke.");
		exit(-1);
	}
	
	listen(listenfd, 500);
	sockfd = accept(listenfd, NULL, NULL);
	
	//Data exchange here
	for(;;){
		memset(&bufrcv, '\0', 500);
		memset(&bufsend, '\0', 500);
		if( (n = recv(sockfd, bufrcv, 500, NULL)) == 0){
				//nothing was read, end of "file"
				shutdown(sockfd, 2);
				break;
			}
		fputs(bufrcv, stdout);
		fgets(bufsend, 500, stdin);
		// If the quit command is typed, quit.
		if(strstr(bufsend, "\\quit") != NULL){
			close(sockfd);
			break;
		}
		//Otherwise, send transmission.
		else{
			send(sockfd, bufsend, n, NULL);
		}
	}
	return 0;
}
