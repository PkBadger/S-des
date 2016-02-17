#include <string.h>
#include <stdio.h>
#include <stdlib.h>

//function declarations
char *encrypt(char *key, char *text);
char *pdiez(char *key);
char *pocho(char *key);
char *lshift1(char *key);
char *lshift2(char *key);
char *iper(char *key);
char *fk(char *key, char *plain);
char *epf(char *key);
char *xor(char *key, char *plain);

//Constant declarations
const char lshift1C[10] = "1234067895";
const char lshift2C[10] = "2340178956";
const char  p10[10]="35274a1986";
const char p8[8]="637485a9";
const char ip[8]="26314857";
const char ip1[8]="41357286";
const char ep[8]="41232341";
const char p4[4]="2431";
const char s0[4][4]={
{"1032"},
{"3210"},
{"0213"},
{"3132"}};
const char s1[4][4]={
{"0123"},
{"2013"},
{"3010"},
{"2103"}};


int main( int argc, char *argv[] )  {

   char key[10];
   char text[8];
   strcpy(text,argv[1]);
   strcpy(key,argv[2]);
   char *cipher=encrypt(key,text);
  // printf("%s\n",cipher);
   return(0);
}

char *encrypt(char *key, char *text){
  //<keys>
    printf("Key:\n" );
   char *key2 = pdiez(key);
   char *keyshift = lshift1(key2);
   char keyshiftcp[10];
   memcpy( keyshiftcp, &keyshift[0], 10 );

   char unokey[8];
   printf("keyshiftcp %s\n", keyshiftcp);
   char *keyuno = pocho(keyshiftcp);
   memcpy(unokey, &keyuno[0], 8 );
   unokey[8]='\0';
   printf("Key1 Final: %s\n",unokey);
   char *keyd = lshift2(keyshiftcp);
   char *keydos = pocho(keyd);
   char doskey[8];
   memcpy( doskey, &keydos[0], 8 );
   doskey[8]='\0';

   printf("Key2 Final: %s\n", doskey);

   //</keys><plain>
   printf("PlainText:\n" );
   char *plainip = iper(text);
   char *plainfk=fk(unokey,plainip);
   //</plain>
   return key2;
}

char *pdiez(char *key){
   char okey[10];
   memcpy( okey, &key[0], 10 );
   char key2[10];
   int i;

   for(i=0;i<10;i++){
       if(p10[i] == 'a'){
         key2[i]=okey[9];

       }else{
         key2[i] = okey[(p10[i]-'0')-1];
         //printf("%c\n",okey[(p10[i]-'0')-1] );
	  // printf("%c\n",key2[i]);
       }
   }
   key2[10] = '\0';
   char *keyr=key2;
   printf("P Diez= %s\n",keyr);
   return keyr;
}

char *lshift1(char *key){

  char okey[10];
  memcpy( okey, &key[0], 10 );

  char key2[10];
  int i;

  for(i=0;i<10;i++){
        key2[i] = okey[(lshift1C[i]-'0')];

  }
  key2[10] = '\0';
  char *keyr=key2;
  printf("L shift1= %s\n",keyr);
  return keyr;
}

char *lshift2(char *key){
  char okey[10];
  memcpy( okey, &key[0], 10 );

  char key2[10];
  int i;

  for(i=0;i<10;i++){

        key2[i] = okey[(lshift2C[i]-'0')];

  }
  key2[10] = '\0';
  char *keyr=key2;
  printf("L shift2= %s\n",keyr);
  return keyr;
}

char *fk(char *key, char *plain){
   char first[4];
   char complete[8];
   char second[4];

   memcpy( complete, &plain[0], 8 );
   int i;
   for(i=0;i<4;i++){
     first[i]=complete[i];
     second[i]=complete[i+4];
   }
   second[4]='\0';
   first[4]='\0';
   char *epplain = epf(second);
   char *xorplain = xor(key, epplain);
   return plain;
}

char *xor(char *key, char *plain){
  char okey[8];
  memcpy( okey, &key[0], 8 );
  char oplain[8];
  memcpy( oplain, &key[0], 8 );
  okey[8]='\0';
  oplain[8]='\0';
  printf("xorplain= %s\n",okey);
  printf("Xorkey= %s\n",oplain);
  char key2[8];
  int i=0;
  for(i=0;i<8;i++){
    if(okey[i] == oplain[i]){
      key2[i] = '0';
    }else{
      key2[i]='1';
    }
  }
  key2[8] = '\0';
  char *keyr=key2;
  printf("Xor= %s\n",keyr);
  return keyr;
}

char *epf(char *key){
  char okey[4];
  memcpy( okey, &key[0], 10 );
  char key2[8];
  int i;

  for(i=0;i<8;i++){
        key2[i] = okey[(ep[i]-'0')-1];

  }
  key2[8] = '\0';
  char *keyr=key2;
  printf("E/p= %s\n",keyr);
  return keyr;
}

char *pocho(char *key){
  char okey[10];
  memcpy( okey, &key[0], 10 );
  char key2[8];
  int i;

  for(i=0;i<8;i++){
      if(p8[i] == 'a'){
        key2[i]=okey[9];

      }else{
        key2[i] = okey[(p8[i]-'0')-1];

      }
  }
  key2[8] = '\0';
  char *keyr=key2;
  printf("P Ocho= %s\n",keyr);
  return keyr;
}

char *iper(char *key){
  char okey[8];
  memcpy( okey, &key[0], 8 );
  char key2[8];
  int i;

  for(i=0;i<8;i++){
        key2[i] = okey[(ip[i]-'0')-1];
  }
  key2[8] = '\0';
  char *keyr=key2;
  printf("Ip= %s\n",keyr);
  return keyr;
}
