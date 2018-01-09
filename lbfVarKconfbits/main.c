/* 
 * File:   main.c
 * Author: rml
 *
 * Created on 24 de Março de 2015, 12:41
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
#define SIM 1000
#define MAXCONF 60 //
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
double media[MAXCONF][MAXCONF]={0};
double rms[MAXCONF][MAXCONF]={0};
double fillratio[MAXCONF][MAXCONF]={0};
char datafile[64];
int num_hash;
int bits_init=1;
int bits_end=8;
int lbfmaxsize=(1<<12); //LBF size 2^12
statGOD=0;
int count=0;

// STARTING PROGRAM

maxelem=60;


if (LOG) printf("###########################################\n");
if (LOG) printf("#####     Write data do DATALOG      ######\n");
if (LOG) printf("###########################################\n");
sprintf (datafile, "data3D.log");
file = fopen(datafile, "w");
if (file == NULL) {
    printf("Error! Can't create data3D.log\n");
    exit(1);
}
fclose(file);
file = fopen(datafile, "a");

for (conf_bits=bits_init; conf_bits<=bits_end; conf_bits++) {
//if(argc == 2)
//{
    //Studing Scenario
    for(num_hash=1 ; num_hash<=10; num_hash++) {
   
        lbfsize=(int) ceil((double)lbfmaxsize/conf_bits); //Recalculate LFB size
        statSUM=0;
        statRMS=0;
        statFILL=0;
        
        for (sim=0; sim<SIM; sim++) {

            if (LOG) printf("####################################\n");
            if (LOG) printf("##### Insert Random Resources ######\n");
            if (LOG) printf("####################################\n");

            generateResources(god,maxelem);

            if (LOG) printf("LBF size = %d\n",lbfsize);

            if (LOG) showGOD(god,maxelem);
        
            resLBF=copyGODtoLBF(sim,god,lbf,lbfsize,maxelem,num_hash,conf_bits);
            resLBFtotal+=resLBF;

            if (LOG) showLBF(lbf,lbfsize);

            if (LOG) printf("##########################################\n");
            if (LOG) printf("##### GOD vs ESTIMATOR for location ######\n");
            if (LOG) printf("##########################################\n");
            if (LOG) resID=rand() % maxelem + 1;
            if (LOG) for (i=0;i<SAMPLE;i++) {
                while ( god[resID]==-1) resID=rand() % maxelem + 1;
                printf("##GOD: ResourceID=%d \t at  Value=%f \t ",resID,god[resID]);
                if (queryLBF(sim,resID,lbf,num_hash,lbfsize,conf_bits)-god[resID]<=(double)1/100) printf("Estimator: OK\n");
                else printf("Estimator ERROR - Extimated Value=%f\n",queryLBF(sim,resID,lbf,num_hash,lbfsize,conf_bits));
                resID=rand() % maxelem + 1;
                }
            

            if (LOG) printf("###########################################\n");
            if (LOG) printf("#####           ESTIMATOR            ######\n");
            if (LOG) printf("###########################################\n");
            for (i=1;i<=maxelem;i++) { // Query all inserted elements
                 if (god[i] != -1) {
                     statSUM+=queryLBF(sim,i,lbf,num_hash,lbfsize,conf_bits);
                     statRMS+=pow(queryLBF(sim,i,lbf,num_hash,lbfsize,conf_bits)-god[i],2);
                     statFILL+=fillratioLBF(lbf,lbfsize);
                     statGOD+=god[i];
                     if (LOG) printf("####  statSUM=%f \t statRMS=%f \t statFILL=%f \t statGOD=%f #######\n",statSUM,statRMS,statFILL,statGOD);
                     count++;
                    } else printf("ERROR: Estimator with god=-1\n");
               }
        } //End Simulation Scenario
       
        media[conf_bits][num_hash]=statSUM/(SIM * maxelem);
        rms[conf_bits][num_hash]=statRMS/(SIM * maxelem);
        fillratio[conf_bits][num_hash]=statFILL/(SIM * maxelem);
        
        printf("##########  NELEM=%d \t CONF_BITS=%d \t AVG=%f \t NHASH=%d #############\n",maxelem,conf_bits,media[conf_bits][num_hash],num_hash);
        
        fprintf(file,"%d\t%d\t%f\t%f\t%f\n",conf_bits,num_hash,media[conf_bits][num_hash],rms[conf_bits][num_hash],fillratio[conf_bits][num_hash]);
        fprintf(file,"%d\t%d\t%f\t%f\t%f\n",conf_bits,num_hash,media[conf_bits][num_hash],rms[conf_bits][num_hash],num_hash,conf_bits);

    } // END num_hash
} // END conf_bits
fclose(file);

if (LOG) printf("############################################\n");
if (LOG) printf("#####     Write Status to SIM.LOG      #####\n");
if (LOG) printf("############################################\n");
file = fopen("sim3D.log", "w");
if (file == NULL) {
    printf("Error! Can't create sim3D.log\n");
    exit(1);
}
fclose(file);
file = fopen("sim3D.log","a");
fprintf(file,"############################################\n");
fprintf(file,"#####     Write Status to SIM.LOG      #####\n");
fprintf(file,"############################################\n");
fprintf(file,"## Starting Time:%s",start);
mytime = time(NULL);
fprintf(file,"## .....END TIME:%s", ctime(&mytime));
fprintf(file,"## Number of Iterations:%d\n",SIM);
fprintf(file,"## LBF: size m=%d bits with variable bits per cell; k=%d hash functions\n",lbfmaxsize,num_hash);
fprintf(file,"## LBF number of bits per cell starting from %d to %d\n",bits_init,bits_end);
fprintf(file,"## Total overlaping elements : %d\n",count-resLBFtotal);
fprintf(file,"## Total Queries: %d\n",count);
fprintf(file,"## Average GOD value: %f\n",statGOD/count);
fclose(file);  
//}
//else printf("ERROR!: Wrong number of parameters)\n");
printf("Elements = %d  GOD Average= %f\n",count,statGOD/count);
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
        //god[i]=drand48();
        god[i]=drand48();
        //while (god[i]<= 1/1000) god[i]=drand48();
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
