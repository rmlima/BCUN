#!/usr/bin/awk -f
BEGIN{
    FS = " ";
    OFS = "\t";
    glbcnt[""]=0;
    glbacc[""]=0;
    glbprcn[""]=0;
}
{
	k[$3]=$2;
	e[$3":"NR]=$2;
	n=NR;
}
END{

for(i in k){
        for (j=0;++j<=n;){
            if (e[i":"j]=="") continue
            glbacc[i]+=e[i":"j];
            glbcnt[i]++;
        }
    }

    for(o in k){
        for (p=0;++p<=n;){
            if (e[o":"p]=="") continue
            delta[o":"p]=(e[o":"p]-glbacc[o]);
            sumdelta[o]+=(delta[o":"p]^2);
        }
    }

    for(d in glbacc){
        if(d=="") continue
        glbacc[d] = glbacc[d]/glbcnt[d];
	drift[d]=sqrt(sumdelta[d]/glbcnt[d]);
        print d,"\t",glbacc[d],"\t",drift[d];
    }

}
