/* 
 * File:   resources.h
 * Author: rml
 *
 * Created on March 28, 2015, 10:49 AM
 */

#ifndef RESOURCES_H
#define	RESOURCES_H
#define HOPMAX 60
#define R 1

extern int god[HOPMAX][R*HOPMAX];



int maxResources(int maxhop, int r)
{
    int i, j, resTotal;
    
    resTotal=0;
    for (i=1;i<=maxhop;i++) {
        //res=pow(RESSTART,i);
        resTotal+=r*i;
    }
    return resTotal+1;
}

void generateResources(int maxhop, int r)
{
    int i, j, res, resTotal;
    
    resTotal=maxResources(maxhop,r);
    
    /* initialize random seed: */
    srand (time(NULL));
    
    for (i=0;i<=HOPMAX;i++)
        for (j=0; j<HOPMAX*R; j++)
            god[i][j]=-1;
    
    //god[0][0]= rand()%resTotal + 1;
    god[0][0]= (int) round(drand48() * resTotal);
    for (i=1;i<=maxhop;i++) {
        //res=pow(RESSTART,(i+1));
        res=r*i;
        for (j=0; j<res; j++) {
             //god[i][j]= rand()% resTotal + 1;
            god[i][j]= (int) round(drand48() * resTotal);
            }
    }
}

void showGOD(int maxhop, int r)
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


int hopsGOD(int elem, int maxhop, int r)
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




#endif	/* RESOURCES_H */

