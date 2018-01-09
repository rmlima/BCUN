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
#include "resources.h"
/*
 * 
 */
#define SAMPLE 10
#define SIM 1000
#define LOG 0


int god[HOPMAX][HOPMAX*R] = { {0 } };

int copyGODtoLBF(float bloom[], float att, int maxhop, int r)
{
    int i, j;
    int resLBF=0;
    
    for (i=0;i<=M;i++)
        bloom[i]=0;
            
  
    for (i=0;i<=maxhop;i++)
        for (j=0; j<maxhop*r; j++)
            if (god[i][j]!=-1)  {
                if (searchLBF(god[i][j],bloom)==0) resLBF++;
                insLBF(god[i][j],pow(att,i),bloom);
            }
    return resLBF;
}

int main(int argc, char** argv) {

FILE *file;
int i,j,sim, maxhop;
time_t mytime;
mytime = time(NULL);

char *start;
start=ctime(&mytime);

int resID, resTotal, resLBF, resLBFtotal = 0;
//float confidence;
float att=0.9;
float lbf[M];  //Linear Bloom Filter
char datafile[64];

int sum[HOPMAX+1][2] = { {0 } };


//if(argc == 2)
//{
    //SIM=
    for(maxhop=20; maxhop<=HOPMAX; maxhop+=5) {
        // Cleaning
        for (i=0 ; i<HOPMAX+1; i++) {
            sum[i][0]=0;
            sum[i][1]=0;
        }
        resLBFtotal=0;
        
        for (sim=0; sim<SIM; sim++) {
            // Cleaning
            for (i=0 ; i<M; i++) lbf[i]=0;
           

            if (LOG) printf("####################################\n");
            if (LOG) printf("##### Insert Random Resources ######\n");
            if (LOG) printf("####################################\n");
            generateResources(maxhop,R);
            resTotal=maxResources(maxhop,R);
            if (LOG) printf("Total resources = %d\n",resTotal);

            if (LOG) showGOD(maxhop,R);

            resLBF=copyGODtoLBF(lbf,att,maxhop,R);
            resLBFtotal+=resLBF;

            if (LOG) showLBF(lbf);


            if (LOG) printf("##########################################\n");
            if (LOG) printf("##### GOD vs ESTIMATOR for location ######\n");
            if (LOG) printf("##########################################\n");
            resID=rand() % resTotal + 1;
            for (i=0;i<SAMPLE;i++) {
                while ( hopsGOD(resID,maxhop,R)==-1) {
                    resID=rand() % resTotal + 1;
                    }
                if (LOG) printf("##GOD: ResourceID=%d \t at H=%d \t ",resID,hopsGOD(resID,maxhop,R));
                if (LOG) if (hopsLBF(resID,lbf,att)-hopsGOD(resID,maxhop,R)==0) printf("Estimator: OK\n");
                    else printf("Estimator ERROR : %d hops\n",hopsLBF(resID,lbf,att));
                resID=rand() % resTotal + 1;
            }


            if (LOG) printf("###########################################\n");
            if (LOG) printf("#####           ESTIMATOR            ######\n");
            if (LOG) printf("###########################################\n");
            for (i=0;i<=maxhop;i++) {
                for (j=0; j<maxhop*R; j++) {
                     if (god[i][j] != -1) {
                         if (hopsGOD(god[i][j],maxhop,R)==-1) {
                             printf("Error! HOPSGOD must exist in GOD\n");
                             exit(1);
                         }
                         sum[hopsGOD(god[i][j],maxhop,R)][0]+=hopsLBF(god[i][j],lbf,att);
                         sum[hopsGOD(god[i][j],maxhop,R)][1]++;
                        }
                    }
                }
        } //End Program

        if (LOG) for (i=0;i<=maxhop;i++) {
            printf("HOP=%d\t Sum=%d\t Count=%d\t Estimator=%f\n",i,sum[i][0],sum[i][1],(float)(sum[i][0])/(sum[i][1]));
            }
        
        if (LOG) printf("###########################################\n");
        if (LOG) printf("#####     Write data do DATALOG      ######\n");
        if (LOG) printf("###########################################\n");
        
        sprintf (datafile, "data%d.log", maxhop);
        file = fopen(datafile, "w");

        if (file == NULL) {
            printf("Error! Can't create data.log\n");
            exit(1);
        }
        fclose(file);
        file = fopen(datafile, "a");
        
        for (i=0;i<=maxhop;i++) {
            fprintf(file,"%d\t%f\t%d\n",i,(float)(sum[i][0])/(sum[i][1]),sum[i][1]);
            }
        fclose(file);
        
        
        
        
        if (LOG) printf("###########################################\n");
        if (LOG) printf("#####     Write Status to SIMLOG      #####\n");
        if (LOG) printf("###########################################\n");
        

        sprintf (datafile,"sim%d.log",maxhop);
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
        fprintf(file,"## .....END TIME:%s", ctime(&mytime));
        fprintf(file,"## Simulations Iterations:%d\n",SIM);
        fprintf(file,"## LBF with size m=%d and using k=%d hash functions\n",M,K);
        fprintf(file,"## HOPMAX=%d\n",maxhop);
        fprintf(file,"## Arithmetic progression with rate R=%d\n",R);
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

