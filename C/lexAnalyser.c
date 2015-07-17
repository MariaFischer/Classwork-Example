#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include <regex.h>

struct element{
  char* dataToken;
  char* dataType;
  struct element *next;
};

struct hashTable{
  struct element **chain;
  int size;
  int count;
};

typedef struct hashTable *hashTable;

// Create an empty hash table.
hashTable createHT(int size){
	hashTable ht;
	int i;
	
	ht = malloc(sizeof(*ht));
	assert(ht != 0);
	
	ht->size = size;
	ht->count = 0;
	ht->chain = malloc(sizeof(struct element *) * ht->size);

	assert(ht->chain != 0);
 
	for(i = 0; i < ht->size; i++){ 
		ht->chain[i] = 0;
	}

	return ht;
}
// Destroy a hash table.
void destroyHashTable(hashTable ht){
	int i;
	struct element *e;
	struct element *next;

	for(i = 0; i < ht->size; i++) {
		for(e = ht->chain[i]; e != 0; e = next) {
			next = e->next;
			free(e->dataToken);
			free(e->dataType);
			free(e);
		}
	}
	free(ht->chain);
	free(ht);
}
// Hash function, to find storage location withhin hash table.
static unsigned long hashFunc(const char *dataToken){
	unsigned const char *s;
	unsigned long hash;
	hash = 0;
	
	for(s = (unsigned const char *) dataToken; *s; s++){
		hash = hash * 97 + *s;
	}
	return hash;
}
// Searcch the hash table for a token.
const char* searchHashTable(hashTable ht, const char *fToken){
	struct element *e;

	for(e = ht->chain[hashFunc(fToken) % ht->size]; e != 0; e = e->next) {
		if(!strcmp(e->dataToken, fToken)) {
			//found token
			return e->dataType;
		}
	}
	//didnt find token
	return 0;
}
// Insert a token into the hash table.
void insertHashTable(hashTable ht, const char *dToken, const char *dType){
	struct element *newE;
	unsigned long h;
	//give newE the proper allocation of space
	newE = malloc(sizeof(*newE));
	//check if the values given are valid
	assert(dToken);
	assert(dType);
	assert(newE);
	//set values in newE
	newE->dataToken = strdup(dToken);
	newE->dataType = strdup(dType);
	//find newE's future location
	h = hashFunc(dToken) % ht->size;
	//Insert newE into ht
	newE->next = ht->chain[h];
	ht->chain[h] = newE;
	//increment element count
	ht->count++;
}
// Delete a token from the hash table.
void deleteHashTable(hashTable ht, const char *fToken){
	struct element **prev;
	struct element *eDelete;
	for(prev = &(ht->chain[hashFunc(fToken) % ht->size]); *prev != 0; prev = &((*prev)->next)){
		if(!strcmp((*prev)->dataToken, fToken)) {
			//found token
			eDelete = *prev;
			*prev = eDelete->next;
			//free eDelete	
			free(eDelete->dataToken);
			free(eDelete->dataType);
			free(eDelete);
			//decrement element count
			ht->count--;
			return;
		}
	}
}
// Pre-populate the hash table with keywords, operaors, etc.
void prePopulateHashTable(hashTable ht){
	insertHashTable(ht, "bool", "BOOL");
	insertHashTable(ht, "int", "INT");
	insertHashTable(ht, "real", "REAL");
	insertHashTable(ht, "string", "STRING");
	insertHashTable(ht, "stdout", "STDOUT");
	insertHashTable(ht, "if", "IF");
	insertHashTable(ht, "while", "WHILE");
	insertHashTable(ht, "true", "TRUE");
	insertHashTable(ht, "false", "FALSE");
	insertHashTable(ht, "and", "AND");
	insertHashTable(ht, "or", "OR");
	insertHashTable(ht, "not", "NOT");
	insertHashTable(ht, "sin", "SIN");
	insertHashTable(ht, "cos", "COS");
	insertHashTable(ht, "tan", "TAN");
	insertHashTable(ht, "(", "LEFTPAREN");
	insertHashTable(ht, ")", "RIGHTPAREN");
	insertHashTable(ht, "+", "ADD");
	insertHashTable(ht, "-", "SUBTRACT");
	insertHashTable(ht, "*", "MULT");
	insertHashTable(ht, "/", "DIVIDE");
	insertHashTable(ht, "%", "MOD");
	insertHashTable(ht, "^", "POWER");
	insertHashTable(ht, "=", "EQU");
	insertHashTable(ht, "<", "LTHAN");
	insertHashTable(ht, ">", "GTHAN");
	insertHashTable(ht, "<=", "LEQU");
	insertHashTable(ht, ">=", "GEQU");
	insertHashTable(ht, "!=", "NEQU");
	insertHashTable(ht, ":=", "ASSIGN");
	insertHashTable(ht, "var-list", "var-list");
	insertHashTable(ht, "var-name", "var-name");
	insertHashTable(ht, "type", "type");
	insertHashTable(ht, "atom", "atom");
	insertHashTable(ht, "expression", "expression");
	insertHashTable(ht, "true", "true");
	insertHashTable(ht, "false", "false");
	insertHashTable(ht, "while", "while");
	insertHashTable(ht, "let", "let");
	insertHashTable(ht, "assign", "assign");
	insertHashTable(ht, "lvalue", "lvalue");
	insertHashTable(ht, "rvalue", "rvalue");
}
// Print a hash table element to a file.
void printValToOut(FILE *fpO, char *data){			
	fprintf(fpO, "<terminal, %s> \n", data);
}
// Print (for parser) with tabbing correct.
void printTab(int tC, char *buff, FILE *fpO){
	char pBuff[60];
	strcpy(pBuff, ".");
	for(int outter = 0; outter < (tC*2); outter++){
		strcat(pBuff, ".");
	}
	// TABBING: printBuff -> setup - add token.
	strcat(pBuff, buff);
	strcat(pBuff, "\n");
	// TABBING: printBuff -> print
	fputs(pBuff, fpO);
} 

 
//Takes file in and returns a file with all tokens within the input file. 
void tokenizer(char *fileNameIn, char *fileNameOut){
	hashTable ht;
	FILE *fpO, *fp;
	char buff[20], *buffTok, *find;
	long buffSize;
	int reti, numCt, qCt, rCt, subCt, c;
	regex_t regex, regexString, regexReal, regexInt, regexIdentifier;
	
	// Create and pre-populate the hash table.
	ht = createHT(512);
	prePopulateHashTable(ht);
	unsigned long hashNum;
	
	// Initialize regexs for string, int, real and identifier.
	reti = regcomp(&regexString, "\"([^\\\"]|\\.)*\"", 0);
	if( reti ){ fprintf(stderr, "Could not compile regex\n"); exit(1); }
	reti = regcomp(&regexReal, "[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?", 0);
    if( reti ){ fprintf(stderr, "Could not compile regex\n"); exit(1); }
	reti = regcomp(&regexInt, "[-+]?[1-9][0-9]*", 0);
    if( reti ){ fprintf(stderr, "Could not compile regex\n"); exit(1); }
	reti = regcomp(&regexIdentifier, "^_|[a-z]|[A-Z][a-zA-Z0-9]+_?", 0);
    if( reti ){ fprintf(stderr, "Could not compile regex\n"); exit(1); }
	
	// Open output file.
	fpO = fopen(fileNameOut,"w+"); // write mode
 	if( fpO == NULL ){
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}
	
	// Open input file.
	fp = fopen(fileNameIn,"r"); 
 	if( fp == NULL ){
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}
	// Read and perform operations on the input file.
	else{
		while(1){
			c = fgetc(fp);
			char ch = (char)c;
			if(feof(fp)){
				break;
			}
			// Identifier checking
			if(isalpha(c)){
				strcpy(buff, "");
				// Loop to get the rest of the identifier.
				numCt = 0;
				while(isalnum(c) || c == "\"" || c == "."){
				//Add c to buff, and count numbers.
					strcat(buff, &c);
					if(isdigit(c)!= 0){
						numCt++;
					}
					c = fgetc(fp);
				}
				// If there are no numbers it could be a keyword, search hash table for it.
				if(numCt == 0){				
					find = searchHashTable(ht, buff);
					// The token is in the hash table, print to output file.
					if(find != 0){
						printValToOut(fpO, find);
					}
					// Not in hash table so token must be an identifier, print to output file.
					else{				
						buffTok = malloc(sizeof(char) * strlen(buff)+15);
						strcpy(buffTok, "<identifier, ");
						strcat(buffTok, buff);
						strcat(buffTok,">\n");
						fputs(buffTok, fpO);				
					}
				}
				// If there are numbers in the token.
				else{
					// The fist character is alphabetical, identifiers can have numbers, just not begin with them, print to output file.
					if(isalpha(buff[0])){
						buffTok = malloc(sizeof(char) * strlen(buff)+15);
						strcpy(buffTok, "<identifier, ");
						strcat(buffTok, buff);
						strcat(buffTok,">\n");
						fputs(buffTok, fpO);
					}
				}
			}
			// String checking.
			else if(ch == '\"'){
				strcpy(buff, "\"");
				c = fgetc(fp);
				ch = (char)c;
				// Loop to get the rest of the "string"
				while(ch != '\"'){
				// Add c to buff.
					strcat(buff, &c);
					c = fgetc(fp);
					ch = (char)c;
				} 
				// Print the sstring, with quotation marks, to the output file.
				buffTok = malloc(sizeof(char) * strlen(buff)+15);
				strcpy(buffTok, "<string, ");
				strcat(buffTok, buff);
				strcat(buffTok,"\">\n");
				fputs(buffTok, fpO);
			}
			// Real number / Integer checking.
			else if(isdigit(c) || ch == '.' || ch == '-' || ch == 'e'){
				subCt = 0;
				strcpy(buff, &c);
				c = fgetc(fp);
				ch = (char)c;
				// Increment the '-' counter if the token begins with a '-'.
				if(ch == '-'){
					subCt++;
				}
				// While c is a potential part of a real number ( +, -, ., e, digit), loop to get the rest of the real number.
				while(isdigit(c) || ch == '.' || ch == 'e'){
					strcat(buff, &c);
					c = fgetc(fp);
					ch = (char)c;
					if(ch == '.'){
						rCt++;
					}
					// If the character is an e, then we are allowed to have another '-', '.', or 'e', continue loop.
					if(ch == 'e'){
						while(isdigit(c) || ch == '.' || ch == 'e' || ch == '-'){
							strcat(buff, &c);
							c = fgetc(fp);
							ch = (char)c;
							if(ch == '-'){
								subCt++;
							}
						}
					}
				}
				if(subCt == 0){
					//Integer check.
					reti = regexec(&regexInt, &buff, 0, NULL, 0);
					if(reti == 1){
						find = searchHashTable(ht, &buff);
						// If the token is only a + or -, find in the hash table and print to output file.
						if(find != 0){
							printValToOut(fpO, find);
						}
						// Other wise this is an integer, print to output file.
						else{
							buffTok = malloc(sizeof(char) * strlen(buff)+15);
							strcpy(buffTok, "<int, ");
							strcat(buffTok, buff);
							strcat(buffTok,">\n");
							fputs(buffTok, fpO);
						}
					}
				}
				else{
					//Real check
					reti = regexec(&regexReal, &buff, 0, NULL, 0);
					if(reti == 1){
						find = searchHashTable(ht, &buff);
						// If the token is only a + or -, find in the hash table and print to output file.
						if(find != 0){
							printValToOut(fpO, find);
						}
						// Other wise this is a real number, print to output file.
						else{
							buffTok = malloc(sizeof(char) * strlen(buff)+15);
							strcpy(buffTok, "<real, ");
							strcat(buffTok, buff);
							strcat(buffTok,">\n");
							fputs(buffTok, fpO);
						}
					}
				}
			}
			// Other terminals
			else{
				// If <=, >=, !=, :=
				if(c == '<' || c == '>' || c == ':' || c == '!'){
					strcpy(buff, &c);
					c = fgetc(fp);
					// If the next character is an '=', search the hash table and if found, print to output file.
					if( c == '='){
						strcat(buff, &c);
						find = searchHashTable(ht, &buff);
						if(find != 0){
							printValToOut(fpO, find);
						}
					}
					// Otherwise search the hash table and if found, print to output file.
					else{
						find = searchHashTable(ht, &buff);
						if(find != 0){
							printValToOut(fpO, find);
						}
					}
				}
				// Otherwise, search the hash table and if found, print to output file.
				else{
					find = searchHashTable(ht, &c);
					if(find != 0){
						printValToOut(fpO, find);
					}
				}
			}
		} 
		fclose(fp);
	}
	fclose(fpO);	
}

int getNextBuff(char* buff, FILE *fp){
	int c;
	c = fgetc(fp);
	char ch = (char)c;
	if(feof(fp)){
		return 1;
	}
	// Read a token.
	strcpy(buff, "");
	while(c != '\n'){
		strcat(buff, &c);
		c = fgetc(fp);
		char ch = (char)c;
	}
	return 0;
}
// Checks input file to make sure token order and setting matches the grammar, returns an output file.
int recurseOPER(char *tok, int tabCt, FILE *fp, FILE *fpO){
	printf("O %d %s\n", tabCt, tok);
	char buff[30];
	if(tabCt < 0) {
		fputs("ERROR: too many right parens.\n", fpO);
		exit(1);
	}
	else if(strcmp(tok, "<terminal, LEFTPAREN> ")  == 0){
		printTab(tabCt, tok, fpO);
		// While not end of token 'order'
		if(getNextBuff(buff, fp) == 1){
			fputs("ERROR: EOF", fpO);
			exit(1);
		}
		while(strcmp(buff, "<terminal, RIGHTPAREN> ")  != 0){
			if(strcmp(buff, "<terminal, LEFTPAREN> ")  == 0){
				tabCt++;
				recurseOPER(buff, tabCt, fp, fpO);
			}
			//STDOUT - Yes
			else if(strstr(buff, "STDOUT") != NULL){
				printTab(tabCt, buff, fpO);
				if(getNextBuff(buff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					if(strstr(buff, "string") != NULL || strstr(buff, "int") != NULL || strstr(buff, "real") != NULL || strstr(buff, "identifier") != NULL){
						printTab(tabCt, buff, fpO);
						if(getNextBuff(buff, fp) == 1){
							fputs("ERROR: EOF", fpO);
							exit(1);
						}
						else if(strcmp(buff, "<terminal, RIGHTPAREN> ")  == 0){
							recurseOPER(buff, tabCt, fp, fpO);
						}
						else{
							fputs("ERROR: STDOUT must end with paren (only one oper)", fpO);
							exit(1);
						}
					}
					else if( strcmp(buff, "<terminal, LEFTPAREN> ")  == 0){
						recurseOPER(buff, tabCt, fp, fpO);
					}
					else{
						fputs("ERROR: STDOUT must have OPER parameter.", fpO);
						exit(1);
					}
				}
			}
			// ASSIGN - Yes
			else if(strstr(buff, "ASSIGN") != NULL){
				printTab(tabCt, buff, fpO);
				if(getNextBuff(buff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					printTab(tabCt, buff, fpO);
					if(strstr(buff, "identifier") != NULL){
						if(getNextBuff(buff, fp) == 1){
							fputs("ERROR: EOF", fpO);
							exit(1);
						}
						else{
							while(strcmp(buff, "<terminal, RIGHTPAREN> ")  != 0){
								printTab(tabCt, buff, fpO);
								if(getNextBuff(buff, fp) == 1){
									fputs("ERROR: EOF", fpO);
									exit(1);
								}
								else if(strcmp(buff, "<terminal, LEFTPAREN> ")  != 0 || strstr(buff, "string") == NULL || strstr(buff, "int") == NULL || strstr(buff, "real") == NULL || strstr(buff, "identifier") == NULL ){
									fputs("ERROR: ASSIGN must have identifier followed by OPER.", fpO);
									exit(1);
								}
								else{
									recurseOPER(buff, tabCt, fp, fpO);
								}
							}
							if(strcmp(buff, "<terminal, RIGHTPAREN> ")  == 0){
								printTab(tabCt, buff, fpO);
								tabCt--;
								if(getNextBuff(buff, fp) == 1){
									fputs("ERROR: EOF", fpO);
									exit(1);
								}
								else{	
									recurseOPER(buff, tabCt, fp, fpO);
								}
							}
						}
					}
					else{
						fputs("ERROR: an identifier must immediately follow ASSIGN.", fpO);
						exit(1);
					}
				}
			}
			// BINOPS - Yes
			else if(strstr(buff, "ADD") != NULL || strstr(buff, "SUBTRACT") != NULL || strstr(buff, "MULT") != NULL ||strstr(buff, "DIVIDE") != NULL || strstr(buff, "MOD") != NULL || strstr(buff, "POWER") != NULL || strstr(buff, "EQU") != NULL || strstr(buff, "LTHAN") != NULL || strstr(buff, "GTHAN") != NULL || strstr(buff, "LEQU") != NULL || strstr(buff, "GEQU") != NULL || strstr(buff, "NEQU") != NULL){
				printTab(tabCt, buff, fpO);
				if(getNextBuff(buff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					recurseOPER(buff, tabCt, fp, fpO);
				}
			}
			// UNOPS - Yes
			else if(strstr(buff, "NOT") != NULL || strstr(buff, "SIN") != NULL || strstr(buff, "COS") != NULL || strstr(buff, "TAN") != NULL  ){
				printTab(tabCt, buff, fpO);
				if(getNextBuff(buff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					recurseOPER(buff, tabCt, fp, fpO);
				}
			}
	
		}
		// Ends with ')' - Yes
		if(strcmp(buff, "<terminal, RIGHTPAREN> ")  == 0){
			printTab(tabCt, buff, fpO);
			tabCt--;
			if(getNextBuff(buff, fp) == 1){
				fputs("ERROR: EOF", fpO);
				exit(1);
			}
			else{		
				recurseEXPR(buff, tabCt, fp, fpO);
			}
		}
	}
	// Constant || Name - Yes
	else if (strstr(tok, "string") != NULL || strstr(tok, "int") != NULL || strstr(tok, "real") != NULL || strstr(tok, "identifier") != NULL || strstr(tok, "ADD") != NULL || strstr(tok, "SUBTRACT") != NULL || strstr(tok, "MULT") != NULL ||strstr(tok, "DIVIDE") != NULL || strstr(tok, "MOD") != NULL || strstr(tok, "POWER") != NULL || strstr(tok, "EQU") != NULL || strstr(tok, "LTHAN") != NULL || strstr(tok, "GTHAN") != NULL || strstr(tok, "LEQU") != NULL || strstr(tok, "GEQU") != NULL || strstr(tok, "NEQU") != NULL || strstr(tok, "NOT") != NULL || strstr(tok, "SIN") != NULL || strstr(tok, "COS") != NULL || strstr(tok, "TAN") != NULL){
		printTab(tabCt, tok, fpO);
		if(getNextBuff(buff, fp) == 1){
			fputs("ERROR: EOF", fpO);
			exit(1);
		}
		else{
			recurseOPER(buff, tabCt, fp, fpO);
		}
	}
	// End Paren - Yes
	else if(strcmp(tok, "<terminal, RIGHTPAREN> ")  == 0){
		printTab(tabCt, tok, fpO);
		tabCt--;
		if(getNextBuff(buff, fp) == 1){
			fputs("ERROR: EOF", fpO);
			exit(1);
		}
		else{
			recurseOPER(buff, tabCt, fp, fpO);
			/* if(strcmp(buff, "<terminal, LEFTPAREN> ")  == 0){
				recurseEXPR(buff, tabCt, fp, fpO);
			}
			else{
				recurseOPER(buff, tabCt, fp, fpO);
			} */
		}
	}
	return 0;
}

int recurseEXPR(char *tok, int tabCt, FILE *fp, FILE *fpO){
	char Ebuff[30];
	printf("%d\n", tabCt);
	if(tabCt < 0){
		fputs("ERROR: too many right parens.\n", fpO);
		exit(1);
	}
	else if(strcmp(tok, "<terminal, LEFTPAREN> ")  == 0){
		printTab(tabCt, tok, fpO);
		tabCt++;
		printf("E0 %d, %s\n", tabCt, tok);
		// While not end of token 'order'
		int temp = getNextBuff(Ebuff, fp);
		if(temp == 1){
			fputs("ERROR: EOF", fpO);
			exit(1);
		}
		while(strcmp(Ebuff, "<terminal, RIGHTPAREN> ")  != 0){
			if(strcmp(Ebuff, "<terminal, LEFTPAREN> ")  == 0){
				recurseEXPR(Ebuff, tabCt, fp, fpO);
			} 
			//IF
			if(strstr(Ebuff, "IF") != NULL){
				if(getNextBuff(Ebuff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					recurseEXPR(Ebuff, tabCt, fp, fpO);
				}
			}			
			// WHILE
			else if(strstr(Ebuff, "WHILE") != NULL){
				if(getNextBuff(Ebuff, fp) == 1){
					fputs("ERROR: EOF", fpO);
					exit(1);
				}
				else{
					//func
					if(strcmp(tok, "<terminal, LEFTPAREN> ")  == 0){
						printTab(tabCt, tok, fpO);
						tabCt++;
						if(getNextBuff(Ebuff, fp) == 1){
							fputs("ERROR: EOF", fpO);
							exit(1);
						}
						//oper
						else if(strstr(Ebuff, "string") != NULL || strstr(Ebuff, "int") != NULL || strstr(Ebuff, "real") != NULL || strstr(Ebuff, "identifier") != NULL || strstr(Ebuff, "ADD") != NULL || strstr(Ebuff, "SUBTRACT") != NULL || strstr(Ebuff, "MULT") != NULL ||strstr(Ebuff, "DIVIDE") != NULL || strstr(Ebuff, "MOD") != NULL || strstr(Ebuff, "POWER") != NULL || strstr(Ebuff, "EQU") != NULL || strstr(Ebuff, "LTHAN") != NULL || strstr(Ebuff, "GTHAN") != NULL || strstr(Ebuff, "LEQU") != NULL || strstr(Ebuff, "GEQU") != NULL || strstr(Ebuff, "NOT") != NULL || strstr(Ebuff, "NEQU") != NULL || strstr(Ebuff, "SIN") != NULL || strstr(Ebuff, "COS") != NULL || strstr(Ebuff, "TAN") != NULL || strstr(Ebuff, "ASSIGN") != NULL){
							int temp = recurseOPER(Ebuff, tabCt, fp, fpO);
							if(temp == 1){
								fputs("ERROR: recurseOPER not functioning", fpO);
								exit(1);
							}
						}
						//stmts
						else if(strstr(Ebuff, "WHILE") != NULL || strstr(Ebuff, "IF") != NULL || strstr(Ebuff, "STDOUT") != NULL){
							recurseEXPR(Ebuff, tabCt, fp, fpO);
						}
						else{
							fputs("ERROR: must be OPER or STMT", fpO);
							exit(1);
						}
					}
				}
			}		
			// STDOUT || OPER - yes
			else if (strstr(Ebuff, "STDOUT") != NULL || strstr(Ebuff, "string") != NULL || strstr(Ebuff, "int") != NULL || strstr(Ebuff, "real") != NULL || strstr(Ebuff, "identifier") != NULL || strstr(Ebuff, "ADD") != NULL || strstr(Ebuff, "SUBTRACT") != NULL || strstr(Ebuff, "MULT") != NULL ||strstr(Ebuff, "DIVIDE") != NULL || strstr(Ebuff, "MOD") != NULL || strstr(Ebuff, "POWER") != NULL || strstr(Ebuff, "EQU") != NULL || strstr(Ebuff, "LTHAN") != NULL || strstr(Ebuff, "GTHAN") != NULL || strstr(Ebuff, "LEQU") != NULL || strstr(Ebuff, "GEQU") != NULL || strstr(Ebuff, "NOT") != NULL || strstr(Ebuff, "NEQU") != NULL || strstr(Ebuff, "SIN") != NULL || strstr(Ebuff, "COS") != NULL || strstr(Ebuff, "TAN") != NULL || strstr(Ebuff, "ASSIGN") != NULL){
				int temp = recurseOPER(Ebuff, tabCt, fp, fpO);
				if(temp == 0){
					if(getNextBuff(Ebuff, fp) == 1){
						fputs("ERROR: EOF", fpO);
						exit(1);
					}
					else{
						recurseEXPR(Ebuff, tabCt, fp, fpO);
					}
				}
			}
		}
		// Ends with ')'
		if(strcmp(Ebuff, "<terminal, RIGHTPAREN> ")  == 0){
			tabCt--;
		printf("E2 %d, %s\n", tabCt, Ebuff);
			printTab(tabCt, Ebuff, fpO);
//		if(getNextBuff(Ebuff, fp) == 1){
//			fputs("ERROR: EOF", fpO);
//			exit(1);
//		}
//		else{
			recurseEXPR(Ebuff, tabCt, fp, fpO);
//		}
		}
	}
	else if(strcmp(tok, "<terminal, RIGHTPAREN> ")  == 0){
		tabCt--;
		printf("E3 %d, %s\n", tabCt, Ebuff);
		printTab(tabCt, Ebuff, fpO);
		if(getNextBuff(Ebuff, fp) == 1){
			fputs("ERROR: EOF", fpO);
			exit(1);
		}
		else{
			recurseEXPR(Ebuff, tabCt, fp, fpO);
		}
	}
	return 0;
	
}

void parser(char *fileNameIn, char *fileNameOut){
	FILE *fpO, *fp;
	char buff[30]; 
	int c, tabCt = 0, tokCt = 0;
	// Open output file.
	fpO = fopen(fileNameOut,"w+"); // write mode
 	if( fpO == NULL ){
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}
	// Open input file.
	fp = fopen(fileNameIn,"r"); 
 	if( fp == NULL ){
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}
	else{
		while(1){
			if(getNextBuff(buff, fp) == 1){
				break;
			}
			else if(strcmp(buff, "<terminal, RIGHTPAREN> ")  == 0){
				tabCt--;
			}
			//FIRST TOKEN IN FILE: must be: '(' || const || name, testing...
			else if(tokCt == 0){
				// If token is not '(' or string, or int or float(real), error.
				char *strS = strstr(buff, "string");
				char *strIn = strstr(buff, "int");
				char *strF = strstr(buff, "real");
				char *strId = strstr(buff, "identifier");
				if(strcmp(buff, "<terminal, LEFTPAREN> ")  != 0 && strS == NULL && strIn == NULL && strF == NULL && strId == NULL){
					fprintf(fpO, "Error: does not being with '(' or constant or name", tabCt);
					break;
				}
				else{
				}
			}
			// Anything after first token
			else {
				tabCt++;
				printTab(tabCt, buff, fpO);
				int temp = recurseEXPR(buff, tabCt, fp, fpO);
				printf("%d\n", temp);
				if(temp == 1){
					fprintf(fpO, "Error.", tabCt);
					break;
				}

			}
			//TABBING: If the tab count is negative, error.
			
			if(tabCt < 0){
				fprintf(fpO, "Error: %d more right paren than left paren\n", tabCt);
				break;
			}
			
			// TABBING: If token is a left paren: increase tab count.
			// if(strcmp(buff, "<terminal, LEFTPAREN> ")  == 0 && tokCt != 0){
				// tabCt++;
			// }
			// else if(strcmp(buff, "<terminal, LEFTPAREN> ")  == 0 && tokCt == 0){
				// tabCt++;
			// }
			tokCt++;
		}
	}
}



int main(){
	FILE *fp;
	char fileName[30];
	int x;
	// Get the file name and open it in read mode
	printf("Enter the name of the file.\n");
	gets(fileName);
	// File operations here:
	tokenizer(fileName, "tokenizerOut.txt");
	parser("tokenizerOut.txt", "parserOut.txt");
	return 0;
}





