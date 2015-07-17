import sys 
import math
import os
import getopt

# 	The sieveFunction listed below is my C implementation 
#  		of the Sieve of Eratosthenes function which identifies
#  		all of the prime numbers up to a specified number, n 
#  		in this case. It's input is: an integer to find all of 
#  		the primes below and a pointer to an array which
#  		will store all of the prime numbers up to the given int.                              
def sieveFunction(n, ptr):
	primes = []
	primesindex = 0
	# Create an array of length n, that contains the values 1 - n.
	myarray = range(1, n)
	# Find the first number in the list of numbers 1 through n that has not 
	#	been identified as composite (0).
	k = 1
	while (k <= math.sqrt(n)):
		for a in myarray:
			if(k < a):
				if( a != 1):
					primes.append(a)
					primesindex += 1
					for x in myarray:
						if(x % a == 0):
							myarray[x-1] = 0
		k += 1
	# Copy list of primes into the ptr given. 
	p = 0
	while(p < primesindex): 
		ptr.append(primes[p])
		p += 1
	return primesindex;
	
#	This takes two matricies and multiplies them together after
#		checking to see if they fit the matrix multiplication 
#		requirements and returns the multiplied matrix.
def matrixFunction(matrixa, matrixb):
	# For my first ideas see: http://www.syntagmatic.net/matrix-multiplication-in-python/
	# Can the matricies be multiplied (mxn)(nxp)?
	if (len(matrixa) == len(matrixb[0])):
		returnmatrix = [[0 for arows in range(len(matrixa))] for bcolumns in range(len(matrixb[0]))]
		# Loop through matrices
		for marow in range(len(matrixa)):
			for mbcol in range(len(matrixb[0])):
				for mbrow in range(len(matrixb)):
					a = int(matrixa[marow][mbrow])
					b = int(matrixb[mbrow][mbcol])
					returnmatrix[marow][mbcol] += a*b
		return returnmatrix;
	else:
		print('Matrices must be in the (mxn)(nxp) format to be multiplied.');
	
	
# 	This takes in a term name and class name, and in the eecs file
#		creates the term directory with the class directory in it 
#		if it doesn't already exist. Then within the class directory 
#		it creates the sub directories: assignments, examples, exams, 
#		lecture_notes, and submissions. Then it creates a hard link 
#		to handin and a soft link to the public_html.
def createDirFunction(t, c):
	path1 = t 
	if os.path.isdir(path1):
		print('Sorry this directory already exisits.')
	else:
		path2 = "/" + c 
		path = path1 + path2
		if os.path.isdir(path):
			print('Sorry this directory already exists.')
		else:	
			os.makedirs(path, 0777)
			list = ["assignments","examples","exams","lecture_notes","submissions"]
			print(list)
			for l in list:
				print(l)
				path3 = path + "/" + l
				print(path3)
				if os.path.isdir(path3):
					print('Sorry this directory already exists.')
				else:
					os.mkdir(path3, 0777);
					
	srcsl = "/usr/local/classes/eecs/" + t + "/" + c + "/public_html"
	dstsl = 'website'
	os.symlink(srcsl, dstsl)
	
	src = "/usr/local/classes/eecs/" + t + "/" + c + "/handin/"
	dst = 'handin'
	os.symlink(src, dst)
	
#	This function takes in a dictionary and reverses the valuse and keys.

def recreateDictFunction(dictionary):
	d = {}
	for k, v in dictionary.items():
		d[v] = k
	return d
	
# 	This function takes the names in a text file given and sorts
#		them into alphabetical order, then gets the namevalue by
#		adding the value of each letter for the name and 
#		multiplying it by its position in the alphabetized list.
def	namesFunction(list):
	totalnamescores = 0;
	abcnumlist = {"\"" : 0, 'A' : 1,'B' : 2,'C' : 3,'D' : 4,'E' : 5,'F' : 6,'G' : 7,'H' : 8,'I' : 9,'J' : 10,'K' : 11,'L' : 12,'M' : 13,'N' : 14,'O' : 15,'P' : 16,'Q' : 17,'R' : 18,'S' : 19,'T' : 20,'U' : 21,'V' : 22,'W' : 23,'X' : 24,'Y' : 25,'Z' : 26}
	# Sort names.txt
	namesfile = open(list, "r")
	file = namesfile.read().split("\",\"")
	file.sort()
	namesfile.close()
	namescores = {}
	#get value of name
	namelistnum = 0
	for f in file:
		nameval = 0
		name = str(f)
		for ch in name:
			nameval += abcnumlist[ch]
		nameval *= namelistnum
		namelistnum += 1
		totalnamescores += nameval
	return totalnamescores
			
def main( ):
	try:
		opts, args = getopt.getopt(sys.argv[1:], 'smrdn', ['Sieve=','Matrix=','Directory=','Dictionary=','Names='])
	except getopt.GetoptError:
		print("BLAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
		sys.exit(2)
	for opt,arg in opts:
		if opt in ('-s', '--Sieve'):
			##****************Sieve Of Eratosthenes****************
			# Take in user input for number to find primes before
			inputnum = int(raw_input("Please enter a number: "))
			ptrarray = []
			temp1 = sieveFunction(inputnum, ptrarray)
			print('The number of prime numbers before ', inputnum, ' is: ', temp1)
			
			print('The number of prime numbers before ', inputnum, ' are: ')
			for j in ptrarray:
				 print j
		elif opt in ('-m', '--Matrix'):
				##****************Matrix Multiplication Function****************
				matrix1 = [[1,2,3],[1,2,3],[1,2,3],[1,2,3]]
				matrix2 = [[4,5,6,7],[4,5,6,7],[4,5,6,7]]
				matrix3 = [[7,8,9],[7,8,9],[7,8,9],[7,8,9]]
				
				print('matrix1 : ')
				for columns1 in matrix1:
					print columns1
				print('matrix2 : ')
				for columns2 in matrix2:
					print columns2
				print('matrix3 : ')
				for columns3 in matrix3:
					print columns3
				
				#ma = raw_input("Enter the first of the matrices you would like to multiply (matrix#): ")
				#mb = raw_input("Enter the second of the matrices you would like to multiply (matrix#): ")
				matrix = matrixFunction(matrix1, matrix2)
		elif opt in ('-r', '--Directory'):
			##****************Directory Creation Function****************
			termname = raw_input("Enter the term: ")
			classname = raw_input("Enter the class: ")
			createDirFunction(classname, termname)
		elif opt in ('-d', '--Dictionary'):
			##****************Dictionary Reversion Function****************
			old = {'a':'one', 'b':'two', 'c':'four', 'd':'five'}
			#oldD = raw_input("Enter the dd like t swap they keys and values of the dictionary you would like t swap the values for: ")
			new = recreateDictFunction(old)
			for key, val in new.items():
				print("KEYS : Values")
				print(new.items())
		elif opt in ('-n', '--Names'):
			##****************Names Function****************
			num = namesFunction("nmes.txt")
			print(num)
			print("FIVE")
		
if __name__ == '__main__':
	main()