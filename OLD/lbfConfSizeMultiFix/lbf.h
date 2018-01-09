/* 
 * File:   bloom.h
 * Author: rml
 *
 * Created on 24 de Março de 2015, 18:26
 */
#ifndef BLOOM_H
#define	BLOOM_H

float dis2value(int dis, int conf_bits )
{
    //max=(1<<conf_bits)-1;
    if (dis>(1<<conf_bits)) {
        printf("ERRO: DIS to high\n");
        exit(1);
    }
    else return (float)(dis+1)/(1<<conf_bits); 
}

unsigned short int value2dis(float confidence, int conf_bits)
{
    float inc,value;
    unsigned short int i=0;
    
    inc=(float)1/(1<<conf_bits);
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

void insLBF(int elem, float value, short unsigned int lbf[], int num_hash, int lbfsize, int conf_bits)
{
int j,idx1,idx2,c,g;
unsigned char key[KEYSIZE];

md5(elem,key);
//mostra_md5(elem,key);
//printf("ResourceID: %d ", elem);
for (j=0 ; j<num_hash*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    idx2=(int)floor((idx1*lbfsize)/(1<<16));
    //printf("PosNew: %d Forward %d \n",idx2,value2dis(value,conf_bits));
    lbf[idx2]=max(value2dis(value,conf_bits),lbf[idx2]);
   }
//printf("\n");
}


//Estimated value for resource elem.
float queryLBF(int elem,short unsigned int lbf[], int num_hash, int lbfsize, int conf_bits)
{
int j,idx1,idx2,c,g,result;
unsigned char key[KEYSIZE];

md5(elem,key);
result=(int)(1<<conf_bits);

for (j=0 ; j<num_hash*2; j+=2) {
    idx2=0;
    idx1=256*key[j]+key[j+1];
    idx2=(int)floor((idx1*lbfsize)/(1<<16));
    result=min(result,lbf[idx2]);
   }
return dis2value(result, conf_bits);
}

float fillratioLBF(short unsigned int lbf[], int lbfsize)
{
int i, nozero=0;

for (i=0 ; i<lbfsize; i++) {
    if (lbf[i]!=0) nozero++;
    }

if (nozero) return (float)nozero/lbfsize*100;
    else printf("ERRO: LBF is null\n");
}
#endif	/* BLOOM_H */