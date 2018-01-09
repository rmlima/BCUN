/* 
 * File:   main.c
 * Author: rml
 *
 * Created on 06 de Maio de 2015, 13:06
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <mhash.h>
#include "hash.h"
#include "lbf.h"
/*
 * 
 */
#define SAMPLE 10
#define SIM 100
#define MAXCONF 30
#define KEYSIZE 16 //Hash key size
#define LOG 0
#define MAX 65536

void generateResources(double god[], int maxelem);
void showGOD(double god[], int maxelem);
int copyGODtoLBF(int sim, double god[], short unsigned int lbf[], int lbfsize, int maxelem, int num_hash,  int conf_bits);
//int genElemFill(short unsigned int lbf[], int lbfsize,int num_hash,int conf_bits, int fill);

int main(int argc, char** argv) {

short unsigned int lbf[MAX];  //Linear Bloom Filter
double god[MAX]; // -1 Unused
    
FILE *file;
int i,j,sim;
time_t mytime;
mytime = time(NULL);

char start[30];
strcpy(start,ctime(&mytime));
int maxelem,lbfsize,conf_bits;
int resID, resLBFtotal, resLBF = 0;
double statSUM,statRMS,statFILL,statGOD;


//double stats[SIM][4] = { {0 } };
double media[MAXCONF]={0};
double rms[MAXCONF]={0};
double fillratio[MAXCONF]={0};
char datafile[64];
int num_hash=7;
int bits_init=1;
int bits_end=16;
int lbfmaxsize=(1<<12); //LBF size 2^12
statGOD=0;
int count=0;
int percent, max, elements;
double ratio, ratio2=0;


for(i=0; i<1000; i++) god[i]=1;

// STARTING PROGRAM
for (percent=30; percent<=70; percent+=10) {
//if(argc == 2)
//{
    //Studing Scenario
    for(conf_bits=bits_init ; conf_bits<=bits_end; conf_bits++) {
        lbfsize=(int) ceil((double)lbfmaxsize/conf_bits); //Recalculate LFB size
        //statSUM=0;
        //statRMS=0;
        //statFILL=0;
        elements=0;
        ratio2=0;
        for (sim=0; sim<SIM; sim++) {
            max=10;
            for (i=0 ; i<MAX; i++) lbf[i]=0;
            ratio=0;
            while (ratio<=percent)
            {
                copyGODtoLBF(sim,god,lbf,lbfsize,max,num_hash,conf_bits);
                ratio=fillratioLBF(lbf,lbfsize);
                max++;     
            }
            ratio2+=ratio;
            elements+=max;
        }
        media[conf_bits]=(double)elements/SIM;
        fillratio[conf_bits]=(double)ratio2/SIM;
        
        printf("############ CONF_BITS=%d Elements=%f ratio=%f #############\n",conf_bits,media[conf_bits],fillratio[conf_bits]);
        
    } // END Conf_Bits
    if (LOG) printf("###########################################\n");
    if (LOG) printf("#####     Write data do DATALOG      ######\n");
    if (LOG) printf("###########################################\n");
    sprintf (datafile, "dataP%d.log",percent);
    file = fopen(datafile, "w");
    if (file == NULL) {
        printf("Error! Can't create sim.dat\n");
        exit(1);
    }
    fclose(file);
    file = fopen(datafile, "a");

    for (conf_bits=bits_init;conf_bits<=bits_end;conf_bits++) {
        fprintf(file,"%d\t%f\t%f\n",conf_bits,media[conf_bits],fillratio[conf_bits]);
        }
    fclose(file);
} // END maxelem
if (LOG) printf("############################################\n");
if (LOG) printf("#####     Write Status to SIM.LOG      #####\n");
if (LOG) printf("############################################\n");
file = fopen("sim.log", "w");
if (file == NULL) {
    printf("Error! Can't create data.log\n");
    exit(1);
}
fclose(file);
file = fopen("sim.log","a");
fprintf(file,"############################################\n");
fprintf(file,"#####     Write Status to SIM.LOG      #####\n");
fprintf(file,"############################################\n");
fprintf(file,"## Starting Time:%s",start);
mytime = time(NULL);
fprintf(file,"## .....END TIME:%s", ctime(&mytime));
fprintf(file,"## Number of Iterations:%d\n",SIM);
fprintf(file,"## LBF: size m=%d bits with variable bits per cell; k=%d hash functions\n",lbfmaxsize,num_hash);
fclose(file);  
//}
//else printf("ERROR!: Wrong number of parameters)\n");
printf("Iteration = %d\n",SIM);
return (EXIT_SUCCESS);
}

/*
int genElemFill(short unsigned int lbf[], int lbfsize,int num_hash,int conf_bits, int fill)
{
    double god[MAX];
    double ratio=0;
    int maxelem=10;
    int i=0;

    while (ratio<fill)
    {
        for(i=0; i<maxelem; i++) god[i]=1;
        copyGODtoLBF(god,lbf,lbfsize,maxelem,num_hash,conf_bits);
        ratio=floor(fillratioLBF(lbf,lbfsize));
        maxelem++;
    }
    return maxelem;
}
*/

void generateResources(double god[], int maxelem)
{
    int i;
    
    /* initialize random seed: */
    srand (time(NULL));
    for (i=0;i<MAX;i++) god[i]=-1;
    
    god[0]=0;
    for (i=1;i<=maxelem;i++) {
        god[i]=drand48();
        while (god[i]<= (double)1/1000) god[i]=drand48();
            }
}

void showGOD(double god[], int maxelem)
{
    int i;
    
    printf("################## GOD Data ######################\n");
    printf("GOD:\n");
    for (i=1;i<=maxelem;i++) printf("%f ",god[i]);
    printf("\n");
}


int copyGODtoLBF(int sim, double god[MAX], short unsigned int lbf[], int lbfsize, int maxelem, int num_hash, int conf_bits)
{
    int i, resLBF=0;
    
    for (i=0 ; i<MAX; i++) lbf[i]=0;
    
    for (i=1;i<=maxelem;i++)
            if (god[i]!=-1)  {
                if (queryLBF(sim,i,lbf,num_hash,lbfsize,conf_bits)==0)
                    resLBF++; //No overlaping counter;
                insLBF(sim,i,god[i],lbf,num_hash,lbfsize,conf_bits);
            }
    return resLBF;
}
