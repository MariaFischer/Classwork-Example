#include<stdio.h>
#include<math.h>

/* FUCNTION DEFINITIONS */

/* The sieveFunction listed below is my C implementation 
 *  of the Sieve of Eratosthenes function which identifies
 *  all of the prime numbers up to a specified number, n 
 *  in this case. It's input is: an integer to find all of 
 *  the primes below and a pointer to an array which
 *  will store all of the prime numbers up to the given int.
 */
int sieveFunction (int n, int *ptr);                               
 
int main( )
{
	int inputnum = 0;
	
	printf("Please enter a number.\n");
	scanf("%d", &inputnum);
	int ptrarray[inputnum];
	int temp1 = sieveFunction(inputnum, ptrarray);
	printf("The number of prime numbers before %d is: %d\n", inputnum ,temp1);

	printf("The number of prime numbers before %d are: ", inputnum);
	for(int j = 0; j < temp1; j++)
		printf("%d ", ptrarray[j]);
}

int sieveFunction(int n, int *ptr)
{
	int myarray[n];
	int primes[n];
	int primesindex = 0;
	/* Create an array of length n, that contains the values 1 - n. */
	for(int i = 0; i < (n - 1); i++)
		myarray[i] = i;
	/* Find the first number in the list of numbers 1 through n that has not */
	/* been identified as composite (0). */
	for(int k = 1; k <= sqrt(n); k++){
		for(int i = 0; i < n; i++){
			if (i > k && myarray[i] != 0){
				/* Add myarray value i to list of prime numbers. */
				primes[primesindex] = i; 
				primesindex++;
				/* Find the multiples of i and mark them as composites (0). */
				for(int x  = i; x < n; x++){
					int temp = x % i;
					if(temp == 0)
						myarray[x] = 0;
				}
			}
		}
	}
	/* Copy list of primes into the ptr given. */
	for(int i = 0; i < primesindex; i++)
		while(primes[i] != 0)
			ptr[i] = primes[i];
 
	return primesindex;
}