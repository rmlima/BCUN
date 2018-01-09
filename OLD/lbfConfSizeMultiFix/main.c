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
#define SIM 10000
#define MAXCONF 20
#define KEYSIZE 16 //Hash key size
#define LOG 0
#define MAX 65536
#define MAXLBF 65536 

void generateResources(float god[], int max);
void showGOD(float god[], int max);
int copyGODtoLBF(float god[MAX], short unsigned int lbf[], int lbfsize, int max, int num_hash,  int conf_bits);
int genElemFill(short unsigned int lbf[], int lbfsize,int num_hash,int conf_bits, int fill);

int main(int argc, char** argv) {

short unsigned int lbf[MAXLBF];  //Linear Bloom Filter
float god[MAX]; // -1 Unused
    
FILE *file;
int i,j,sim;
time_t mytime;
mytime = time(NULL);

char start[30];
strcpy(start,ctime(&mytime));

float stats[SIM][3] = { {0 } };
float media[MAXCONF]={0};
float rms[MAXCONF]={0};
float fillratio[MAXCONF]={0};

int resID, resLBFtotal, resLBF = 0;
float incr;

char datafile[64];

int num_hash=4;
int conf_bits;
int bits_init=2;
int bits_end=12;

int max=50;
int lbfmaxsize=(1<<bits_end);
int lbfsize;
int percent;



for (percent=10; percent<60; percent+=10) {

//if(argc == 2)
//{
    //Studing Scenario
    for(conf_bits=bits_init ; conf_bits<=bits_end; conf_bits++) {
        
        incr=(float)1/(1<<conf_bits);
        lbfsize=(int) ceil(lbfmaxsize/conf_bits);
        
        //generateResources(god,max);
        
        //Simulation in the same scenario
        // Cleaning
        for (i=0 ; i<SIM; i++) {
            stats[i][0]=0;
            stats[i][1]=0;
            stats[i][2]=0;
        }
        
        max=genElemFill(lbf, lbfsize,num_hash,conf_bits, percent);
        //printf("Elements=%d Conf %d\n",max,conf_bits);
        
        for (sim=0; sim<SIM; sim++) {
            
            for (i=0 ; i<MAXLBF; i++) lbf[i]=0;
           

            if (LOG) printf("####################################\n");
            if (LOG) printf("##### Insert Random Resources ######\n");
            if (LOG) printf("####################################\n");
         
            generateResources(god,max);
         
            if (LOG) printf("LBF size = %d\n",lbfsize);

            if (LOG) showGOD(god,max);
        
            resLBF=copyGODtoLBF(god,lbf,lbfsize,max,num_hash,conf_bits);
            resLBFtotal+=resLBF;

            if (LOG) showLBF(lbf,lbfsize);

            if (LOG) printf("##########################################\n");
            if (LOG) printf("##### GOD vs ESTIMATOR for location ######\n");
            if (LOG) printf("##########################################\n");
            resID=rand() % max + 1;
            for (i=0;i<SAMPLE;i++) {
                while ( god[resID]==-1) resID=rand() % max + 1;
                if (LOG) printf("##GOD: ResourceID=%d \t at  Value=%f \t ",resID,god[resID]);
                if (LOG) if (queryLBF(resID,lbf,num_hash,lbfsize,conf_bits)-god[resID]<=(float)1/100) printf("Estimator: OK\n");
                else printf("Estimator ERROR - Extimated Value=%f\n",queryLBF(resID,lbf,num_hash,lbfsize,conf_bits));
                resID=rand() % max + 1;
            }
            

            if (LOG) printf("###########################################\n");
            if (LOG) printf("#####           ESTIMATOR            ######\n");
            if (LOG) printf("###########################################\n");
            for (i=0;i<max;i++) {
                 if (god[i] != -1) {
                     stats[sim][0]+=queryLBF(i,lbf,num_hash,lbfsize,conf_bits);
                     stats[sim][1]+=pow(queryLBF(i,lbf,num_hash,lbfsize,conf_bits)-god[i],2);
                     stats[sim][2]+=fillratioLBF(lbf,lbfsize);
                    } else printf("ERROR: Estimator with god=-1\n");
               }
        } //End Simulation Scenario
        for (i=0;i<SIM;i++) {
            if (stats[i][2]!=0) {
            media[conf_bits]+=stats[i][0];
            rms[conf_bits]+=stats[i][1];
            fillratio[conf_bits]+=stats[i][2];
            }
        }
        media[conf_bits]=media[conf_bits]/(SIM * max);
        rms[conf_bits]=rms[conf_bits]/(SIM * max);
        fillratio[conf_bits]=fillratio[conf_bits]/(SIM * max);
        
        if (LOG) printf("###########################################\n");
        if (LOG) printf("#####     Write Status to SIMLOG      #####\n");
        if (LOG) printf("###########################################\n");
        sprintf (datafile,"sim%d.log",conf_bits);
        file = fopen(datafile, "w");
        if (file == NULL) {
            printf("Error! Can't create data.log\n");
            exit(1);
        }
        fclose(file);
        
        file = fopen(datafile,"a");
        fprintf(file,"###########################################\n");
        fprintf(file,"#####     Write Status to SIMLOG      #####\n");
        fprintf(file,"###########################################\n");
        fprintf(file,"## Starting Time:%s",start);
        mytime = time(NULL);
        fprintf(file,"## .....END TIME:%s", ctime(&mytime));
        fprintf(file,"## Number of Iterations:%d\n",SIM);
        fprintf(file,"## LBF: size m=%d bits ; k=%d hash functions\n",lbfsize,num_hash);
        fprintf(file,"## LBF number of bits per cell=%d and minimal increment=%f\n",conf_bits,incr);
        fprintf(file,"## Elements available in GOD mode: %d\n",max);
        fprintf(file,"## Toatl inserted elements in LBF: %d\n",resLBFtotal);
        fprintf(file,"## Total Queries: %d\n",max*SIM);
        fclose(file);
        printf("############ CONF_BITS=%d MAX=%d OK #############\n",conf_bits,max);
        
    } // Fim Conf_Bits
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
        fprintf(file,"%d\t%f\t%f\t%f\t%d\n",conf_bits,media[conf_bits],rms[conf_bits],fillratio[conf_bits],(SIM * max));
        }
    fclose(file);        
}
       
//}
//else printf("ERROR!: Wrong number of parameters)\n");
return (EXIT_SUCCESS);
}


int genElemFill(short unsigned int lbf[], int lbfsize,int num_hash,int conf_bits, int fill)
{
    float god[MAX];
    float ratio=0;
    int max=10;
    int i=0;

    while (ratio<fill)
    {
        for(i=0; i<max; i++) god[i]=1;
        copyGODtoLBF(god,lbf,lbfsize,max,num_hash,conf_bits);
        ratio=floor(fillratioLBF(lbf,lbfsize));
        max++;
    }
    return max;
}

void generateResources(float god[], int max)
{
    int i;
    
    /* initialize random seed: */
    srand (time(NULL));
    for (i=0;i<MAX;i++) god[i]=-1;
    
    god[0]=0;
    for (i=1;i<max;i++) {
        god[i]=drand48();
        while (god[i]== 0) god[i]=drand48();
            }
}

void showGOD(float god[], int max)
{
    int i;
    
    printf("################## GOD Data ######################\n");
    printf("GOD:\n");
    for (i=0;i<max;i++) printf("%f ",god[i]);
    printf("\n");
}


int copyGODtoLBF(float god[MAX], short unsigned int lbf[], int lbfsize, int max, int num_hash, int conf_bits)
{
    int i, resLBF=0;
    
    for (i=0;i<=lbfsize;i++)
        lbf[i]=0;
    
    for (i=0;i<max;i++)
            if (god[i]!=-1)  {
                if (queryLBF(god[i],lbf,num_hash,lbfsize,conf_bits)==0) resLBF++; //Distinct resource counter
                insLBF(i,god[i],lbf,num_hash,lbfsize,conf_bits);
            }
    return resLBF;
}