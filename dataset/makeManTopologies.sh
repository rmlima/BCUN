BMPATH=~/work/bonnmotion-2.1.3/bin
BM=${BMPATH}/bm

XMAX=2000
YMAX=2500

RUASH=6
RUASV=4

NOS=250

NSCENARIOS=500


# Por alguma razão estranha o nam usa sempre mais uma do que o pedido no argumento
((RUASH--))
((RUASV--))

DESTDIR=~/work/dataset/Manhattan
SIMPREFIX=mg

for ((I=0;I<${NSCENARIOS};I++)); do
    FILE=${DESTDIR}/${SIMPREFIX}-${NOS}-${I}
    ${BM} -f ${FILE} ManhattanGrid -e 0 -m 0 -o 3600 -d 0 -n ${NOS} -x ${XMAX} -y ${YMAX} -u ${RUASV} -v ${RUASH}
    ${BM} NSFile -f ${FILE}
    rm ${FILE}.params ${FILE}.movements.gz
done
