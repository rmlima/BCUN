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
#include "const.h"
#include "hash.h"
#include "lbf.h"
/*
 * 
 */



int maxResources(int maxhop, int r)
{
    int i, resTotal;
    
    resTotal=0;
    for (i=1;i<=maxhop;i++) resTotal+=r*i;
    return resTotal+1;
}

void generateResources(int god[HOPLIMIT][HOPLIMIT*RLIMIT], int maxhop, int r)
{
    int i, j, res, resTotal;
    
    resTotal=maxResources(maxhop,r);
    
    /* initialize random seed: */
    srand (time(NULL));
    
    for (i=0;i<=maxhop;i++)
        for (j=0; j<maxhop*r; j++)
            god[i][j]=-1;
    
    //god[0][0]= rand()%resTotal + 1;
    //god[0][0]= (int) round(drand48() * resTotal);
    god[0][0]=0;
    for (i=1;i<=maxhop;i++) {
        res=r*i;
        for (j=0; j<res; j++) {
             //god[i][j]= rand()% resTotal + 1;
            god[i][j]=(int) round(drand48() * resTotal);
            while (god[i][j] == 0)
                god[i][j]= (int) round(drand48() * resTotal);
            }
    }
}

void showGOD(int god[HOPLIMIT][HOPLIMIT*RLIMIT], int maxhop, int r)
{
    int i, j;
    
    printf("################## GOD Data ######################\n");
    printf("GOD:\n");
    for (i=0;i<=maxhop;i++) {
        printf("HOP:%d \t",i);
        for (j=0; j<maxhop*r; j++) {
             printf("%d ",god[i][j]);
            }
        printf("\n");
    }
}


int hopsGOD(int god[HOPLIMIT][HOPLIMIT*RLIMIT], int elem, int maxhop, int r)
{
int i,j;

for (i=0;i<=maxhop;i++) {
    for (j=0; j<maxhop*r; j++) {
         if (god[i][j] == elem) {
             return i;
            }
        }
    }
return -1;
}


int copyGODtoLBF(int god[HOPLIMIT][HOPLIMIT*RLIMIT], short unsigned int lbf[], int lbfsize, float att, int maxhop, int r,int num_hash, int hash_bits, int conf_bits)
{
    int i, j;
    int resLBF=0;
    
    for (i=0;i<=lbfsize;i++)
        lbf[i]=0;
            
  
    for (i=0;i<=maxhop;i++)
        for (j=0; j<maxhop*r; j++)
            if (god[i][j]!=-1)  {
                if (searchLBF(god[i][j],lbf,num_hash,hash_bits,conf_bits)==0) resLBF++; //Distinct resource counter
                insLBF(god[i][j],i,lbf,num_hash,hash_bits,conf_bits,att);
            }
    return resLBF;
}

int main(int argc, char** argv) {

short unsigned int lbf[MAXSIZE];  //Linear Bloom Filter
int god[HOPLIMIT][HOPLIMIT*RLIMIT] = { {-1 } }; // -1 Unused
    
FILE *file;
int i,j,sim;
//time_t mytime;
//mytime = time(NULL);
//char *start;
//start=ctime(&mytime);
clock_t start;
start = clock();

int stats[HOPLIMIT+1][3] = { {0 } };
float media=0;
float rms=0;


int resID, resTotal, resLBF, resLBFtotal = 0;
//float confidence;
float incr,att=0.9;

char datafile[64];
int r=1;
int num_hash=4;
//int conf_bits=6; // MAX HOPs 7
int conf_bits;
int maxhop=20;
int hash_bits=8;
int lbfsize;





//if(argc == 2)
//{
    //Studing Scenario
    for(conf_bits=11 ; conf_bits<=16; conf_bits++) {
        // Cleaning
        for (i=0 ; i<HOPLIMIT+1; i++) {
            stats[i][0]=0;
            stats[i][1]=0;
            stats[i][2]=0;
        }
        resLBFtotal=0;
        incr=(float)1/((1<<conf_bits)-1);
        lbfsize=(int)((1<<hash_bits)/conf_bits);
        
        
        //Simulation in the same scenario
        for (sim=0; sim<SIM; sim++) {
            // Cleaning
            for (i=0 ; i<MAXSIZE; i++) lbf[i]=0;
           

            if (LOG) printf("####################################\n");
            if (LOG) printf("##### Insert Random Resources ######\n");
            if (LOG) printf("####################################\n");
         
            generateResources(god,maxhop,r);
         
            resTotal=maxResources(maxhop,r);
            if (LOG) printf("Total resources = %d\n",resTotal);
            if (LOG) printf("LBF size = %d\n",lbfsize);

            if (LOG) showGOD(god,maxhop,r);
        
            resLBF=copyGODtoLBF(god,lbf,lbfsize,att,maxhop,r,num_hash,hash_bits,conf_bits);
            resLBFtotal+=resLBF;

            if (LOG) showLBF(lbf,lbfsize);

            if (LOG) printf("##########################################\n");
            if (LOG) printf("##### GOD vs ESTIMATOR for location ######\n");
            if (LOG) printf("##########################################\n");
            resID=rand() % resTotal + 1;
            for (i=0;i<SAMPLE;i++) {
                while ( hopsGOD(god,resID,maxhop,r)==-1) {
                    resID=rand() % resTotal + 1;
                    }
                if (LOG) printf("##GOD: ResourceID=%d \t at H=%d \t ",resID,hopsGOD(god,resID,maxhop,r));
                if (LOG) if (hopsLBF(resID,lbf,att,num_hash,hash_bits,conf_bits)-hopsGOD(god,resID,maxhop,r)==0) printf("Estimator: OK\n");
                else printf("Estimator ERROR: %d hops extimated\n",hopsLBF(resID,lbf,att,num_hash,hash_bits,conf_bits));
                resID=rand() % resTotal + 1;
            }


            if (LOG) printf("###########################################\n");
            if (LOG) printf("#####           ESTIMATOR            ######\n");
            if (LOG) printf("###########################################\n");
            for (i=0;i<=maxhop;i++) {
                for (j=0; j<maxhop*r; j++) {
                     if (god[i][j] != -1) {
                         if (hopsGOD(god,god[i][j],maxhop,r)==-1) {
                             printf("Error! HOPSGOD must exist in GOD\n");
                             exit(1);
                         }
                         stats[hopsGOD(god,god[i][j],maxhop,r)][0]+=hopsLBF(god[i][j],lbf,att,num_hash,hash_bits,conf_bits);
                         stats[hopsGOD(god,god[i][j],maxhop,r)][1]+=pow((hopsGOD(god,god[i][j],maxhop,r)-hopsLBF(god[i][j],lbf,att,num_hash,hash_bits,conf_bits)),2);
                         stats[hopsGOD(god,god[i][j],maxhop,r)][2]++;
                        }
                    }
                }
        } //End Simulatio Scenario

        if (LOG) for (i=0;i<=maxhop;i++) {
            printf("HOP=%d\t Sum=%d\t Count=%d\t Estimator=%f\n",i,stats[i][0],stats[i][1],(float)(stats[i][0])/(stats[i][1]));
            }
        
        if (LOG) printf("###########################################\n");
        if (LOG) printf("#####     Write data do DATALOG      ######\n");
        if (LOG) printf("###########################################\n");
        
        sprintf (datafile, "data%d.log", conf_bits);
        file = fopen(datafile, "w");

        if (file == NULL) {
            printf("Error! Can't create data.log\n");
            exit(1);
        }
        fclose(file);
        file = fopen(datafile, "a");
        
        for (i=0;i<=maxhop;i++) {
            media=(float)(stats[i][0])/(stats[i][2]);
            rms=(float)(stats[i][1])/(stats[i][2]);
            fprintf(file,"%d\t%f\t%f\t%d\n",i,media,rms,stats[i][2]);
            }

        
        fclose(file);
        
        
        
        
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
        //fprintf(file,"## Starting Time:%s",start);
        //fprintf(file,"## .....END TIME:%s", ctime(&mytime));
        fprintf(file,"## Execution time =%d clocks/seconds\n",((double) (clock() - start)));
        fprintf(file,"## Simulations Iterations:%d\n",SIM);
        fprintf(file,"## LBF with size m=%d and using k=%d hash functions\n",lbfsize,num_hash);
        fprintf(file,"## Number of used hash bits=%d\n",hash_bits);
        fprintf(file,"## LBF number of bits per cell=%d and minimal increment=%f\n",conf_bits,incr);
        fprintf(file,"## HOPMAX=%d\n",maxhop);
        fprintf(file,"## Arithmetic progression with rate R=%d\n",r);
        fprintf(file,"## Resources  Pool or Total:%d last iteration\n",resTotal);
        fprintf(file,"## Distinct  Resources LBF :%d last iteration\n",resLBF);
        fprintf(file,"## Total Queries with duplication:%d\n",resTotal*SIM);
        fprintf(file,"## Average Distinct Resources LBF:%3.2f\n",(float)resLBFtotal/SIM);
        fclose(file);
        printf("############ MAXHOP=%d OK #############\n",maxhop);
    }
    /*  
     *
        printf("##################################\n");
        printf("####### Getting Confidence #######\n");
        printf("##################################\n");
        printf("Searching in LBF for Resource 3 returns confidence value c=%f\n",confidence);

        if (confidence==1) printf("The query node owns the resource\n");
        else if (confidence==att) printf("Other neighbour node owns the resource\n");
        
        printf("#############################\n");
        printf("#### Estimator Resource ####\n");
        printf("#############################\n");
        h=hopsLBF(3,lbf, att);
        printf("LBF estimation for %s location = %d HOPs\n","Resource3",h);
        h=hopsLBF(4,lbf, att);
        printf("LBF estimation for %s location = %d HOPs\n","Resource4",h);
      */  
//}
//else printf("ERROR!: Wrong number of parameters)\n");


return (EXIT_SUCCESS);
}

