/* 
 * File:   bloom.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 18:26
 */
#ifndef BLOOM_H
#define	BLOOM_H

#define DELTA 256

double dis2value(int dis, int conf_bits )
{
    if ((dis > (int)(1<<conf_bits)) || (conf_bits<=0)) {
        printf("ERROR: dis2value dis=%d conf_bits=%d\n",dis,1<<conf_bits);
        exit(1);
    }
    else 
    return ((double)(dis & ((1<<conf_bits)-1)))/((1<<conf_bits)-1); 
}

unsigned short int value2dis(double confidence, int conf_bits)
{
    double inc;
    
    if (conf_bits<=0 || confidence<0) {
        printf("ERROR: value2dis\n");
        exit(1);
    }
    if (confidence==0) return 0;
    if (confidence==1) return (1<<conf_bits)-1;
    
    inc=((double)1)/(1<<conf_bits);
   
    return ((unsigned short int) floor(confidence/inc)+1);
}


void showLBF(short unsigned int lbf[],int lbfsize)
{
    int i;
    printf("################## LBF Data ######################\n");
    printf("LBF with size:%d\n",lbfsize);
    for (i=0 ; i<lbfsize; i++) {
        printf("%d ",lbf[i]);
        if (!(i % 10)) { printf("\n");}
        }
    printf("\n");
}

void insLBF(int sim, int elem, double value, short unsigned int lbf[], int num_hash, int lbfsize, int conf_bits)
{
int j,idx1,idx2;
long long tmp;
unsigned char key[KEYSIZE];

tmp=(DELTA*elem)+(sim*1000000);
for (j=0 ; j<num_hash; j++) {
    tmp++;
    md5(tmp,key);
//mostra_md5(elem,key);
//printf("ResourceID: %d ", elem);
    idx2=0;
    idx1=256*key[1]+key[2];
    idx2=(int)floor( ((double)(idx1*lbfsize))/(1<<16));
    //printf("PosNew: %d Forward %d \n",idx2,value2dis(value,conf_bits));
    lbf[idx2]=max(value2dis(value,conf_bits),lbf[idx2]);
   }
//printf("\n");
}


//Estimated value for resource elem.
double queryLBF(int sim, int elem,short unsigned int lbf[], int num_hash, int lbfsize, int conf_bits)
{
int j,idx1,idx2,result;
unsigned char key[KEYSIZE];
long long tmp;

tmp=(DELTA*elem)+(sim*1000000);
result=(int)((1<<conf_bits)-1);

for (j=0 ; j<num_hash; j++) {
    tmp++;
    md5(tmp,key);
    idx2=0;
    idx1=256*key[1]+key[2];
    idx2=(int)floor(((double)(idx1*lbfsize))/(1<<16));
    result=min(result,lbf[idx2]);
   }
return dis2value(result, conf_bits);
}

double fillratioLBF(short unsigned int lbf[], int lbfsize)
{
int i, nozero=0;

for (i=0 ; i<lbfsize; i++) {
    if (lbf[i]!=0) nozero++;
    }

if (lbfsize!=0) return ((double)nozero)/lbfsize*100;
    else {
        printf("ERROR: fillratioLBF\n");
        exit(1);
    }
}

double dis2valueOLD(int dis, int conf_bits )
{
    //max=(1<<conf_bits)-1;
    if (dis>(1<<conf_bits)) {
        printf("ERROR: DIS to high\n");
        exit(1);
    }
    else return ((double)(dis+1))/(1<<conf_bits); 
}

unsigned short int value2disOLD(double confidence, int conf_bits)
{
    double inc,value;
    unsigned short int i=0;
    
    inc=((double)1)/(1<<conf_bits);
    if (confidence<inc) return 0;

    value=inc;
    while (confidence>value)
    {
        value+=inc;
        i++;
    	//printf("i=%d\t value=%f\n",i,value);
    }
    return i;
}

#endif	/* BLOOM_H */

