import pygtk
pygtk.require('2.0')
import gtk
import string
import simulador
import gerar
import graficos
import redesenhar
import matplotlib
import webkit
import gobject
matplotlib.use('WXAgg')
import random as rnd
import time
import networkx as nx
import os
import webbrowser as WEB
       	
class python:
    def lernodos(self,barranodos,data=None):
        a=barranodos.get_value()     
        #print "Numero de Nodos",a
        return int(a)
    def leriteracoes(self,entrada2,data=None):
        a=entrada2.get_text()    
        #print "Iteracoes",a
        return int(a)
        
    def lerraio(self,barra1,data=None):
        a=barra1.get_value()    
        #print "Raio",a
        return float(a)
        
    def mostra(self,checkmostrar,data=None):
        var=checkmostrar.get_active()
        #print "Mostra"
        return var

    def lerinicial(self,entrada3,data=None):        
        a=entrada3.get_text()
        #print "Inicial",a
        if a!="":
            return int(a)
        
        
    def lerfinal(self,entrada4,data=None):
        
        a=entrada4.get_text()
        #print "Final",a    
        if a!="":
            return int(a)
    def gerar(self,radiorandom,radioerdos,radiobarabasi,numdenodos,barra1,nrecursos,grafo,radiopath,data=None):
        recursos=[]
        resultados=[]
        varrandom=radiorandom.get_active()
        varerdos=radioerdos.get_active()
        varbarabasi=radiobarabasi.get_active()
        varpath=radiopath.get_active()
        initiator=rnd.randint(0,numdenodos-1)
        recursos=self.recursos(numdenodos,nrecursos)
        while initiator in recursos:
            initiator=rnd.randint(0,numdenodos-1)
        
        if varrandom==1:
            raio=self.lerraio(barra1)
            mostrar=None
            G=gerar.geradorrandom(numdenodos,raio,mostrar)    
            graficos.network_rand(G,initiator,recursos)

        if varerdos==1:
            prob=self.lerraio(barra1)
            mostrar=None
            G=gerar.geradorerdos(numdenodos,prob,mostrar)            
            graficos.network_erdos(G,initiator,recursos)
            
        if varbarabasi==1:
            ligacoes=int(self.lerraio(barra1))
            mostrar=None
            G=gerar.geradorbarabasi(numdenodos,ligacoes,mostrar)
            graficos.network_barabasi(G,initiator,recursos)
            
        if varpath==1:
            mostrar=None
            G=gerar.geradorpath(numdenodos,mostrar)
            graficos.network_path(G,initiator,recursos)
            
        resultados.append(G)
        resultados.append(numdenodos)
        resultados.append(initiator) 
        resultados.append(recursos)        
        
        return resultados
    def recursos(self,numnodos,nrecursos,data=None):       

        vectorrecursos=[]
        vectornodos=(range(0,numnodos))
        vectorrecursos=rnd.sample(vectornodos, nrecursos)
        
        for i in range(0,len(vectorrecursos)):
            vectorrecursos[i]=int(vectorrecursos[i])
        
        return vectorrecursos
    
    def selectfixar(self,widget,fixarrecursos,fixarrede,entrada5,entrada6,entrada7,entrada8,barranodos,data=None):
        varrecursos=fixarrecursos.get_active()
        varrede=fixarrede.get_active() 
        numdenodos=self.lernodos(barranodos)
        
        if varrecursos==1:
            entrada5.set_sensitive(True)
            entrada6.set_sensitive(False)
            entrada7.set_sensitive(False)
            entrada8.set_sensitive(False)
            
        if varrede==1:
            entrada5.set_sensitive(False)
            entrada6.set_sensitive(False)
            entrada7.set_sensitive(True)
            entrada8.set_sensitive(False)
                
    def simular(self,widget,barranodos,checkmostrar,entrada3,entrada4,radiorandom,radioerdos,radiobarabasi,barra1,entrada2,
                label5,label7,label9,label11,label13,label15,label17,progressbar,janela,label24,label25,label26,label27,label28,label29,
                label30,checkapagar,checkcancelar,checkmuf,checkcc,checktc,checkth,checkhuf,labelprogresso,checkflood,checkring,label33, 
                label34,label35,label36,label37,label38,label39,label42,label43,label44,label45,label46,barrarecursos,grafo,checkredesenhar,
                botaomuf,botaocc,botaotc,botaoth,botaohuf,botaocancelar,botaoredesenhar,checkns,checkpersonalizado,fixarrecursos,fixarrede,
                entrada5,entrada6,entrada7,entrada8,radiopath,labelredesenhar,checkver,data=None):
                       
        fvectormuf=[]
        fvectorcc=[]
        fvectortc=[]
        fvectorth=[]
        fvectorhuf=[]
                
        rvectormuf=[]
        rvectorcc=[]
        rvectortc=[]
        rvectorth=[]
        rvectorhuf=[]
        
        pvectormuf=[]
        pvectorcc=[]
        pvectortc=[]
        pvectorth=[]
        pvectorhuf=[]
        
        
        fvectormediahuf= []
        fvectormediath=[]
        fvectormediatc=[]
        fvectormediacc=[]
        fvectormediamuf=[]
        
        rvectormediahuf= []
        rvectormediath=[]
        rvectormediatc=[]
        rvectormediacc=[]
        rvectormediamuf=[]
        
        pvectormediahuf= []
        pvectormediath=[]
        pvectormediatc=[]
        pvectormediacc=[]
        pvectormediamuf=[]
        
        links=[]
        
        varrandom=radiorandom.get_active()
        varerdos=radioerdos.get_active()
        varbarabasi=radiobarabasi.get_active()
        varpath=radiopath.get_active()
        
        mostrar=self.mostra(checkmostrar)
        numnodos=self.lernodos(barranodos)
        parar=False
        percentagem=float(barrarecursos.get_value())
        self.progresso(progressbar,0.00)    
    
    
        if fixarrecursos.get_active()==True:
            legenda=1
            nrecursos=int((numnodos-1)*percentagem)
            if nrecursos < 1:
                nrecursos=1
            botaocancelar.set_sensitive(True)
            vectorx=[]
            #print vectornos
            primeira=True
            for i in range(int(entrada5.get_text()),int(entrada6.get_text())+1):
                
                for j in range(0,self.leriteracoes(entrada2)):                    

                    gerado=self.gerar(radiorandom,radioerdos,radiobarabasi,i,barra1,nrecursos,grafo,radiopath)

                    self.contaitera(labelprogresso,entrada2,j+1)
                    
                    while gtk.events_pending():
                        gtk.main_iteration(False)
                        
                    G=gerado[0]
                    numnodos=gerado[1]
                    initiator=gerado[2]
                    recursos=gerado[3]
                    pintar=recursos
                    
                    if checkflood.get_active()==True:
                        mecanismo=1                
                        resultadoflood=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        
                        fvectormuf.append(resultadoflood[2])
                        fvectorcc.append(resultadoflood[1])
                        fvectortc.append(resultadoflood[0])
                        fvectorth.append(resultadoflood[3])
                        fvectorhuf.append(resultadoflood[4])                        
                        
                        label9.set_text(str(resultadoflood[2]))
                        label11.set_text(str(resultadoflood[1]))
                        label13.set_text(str(resultadoflood[0]))
                        label15.set_text(str(resultadoflood[3]))
                        label17.set_text(str(resultadoflood[4]))                        
                            
                        
                    if checkring.get_active()==True:
                        mecanismo=2
                        resultadoring=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        
                        rvectormuf.append(resultadoring[2])
                        rvectorcc.append(resultadoring[1])
                        rvectortc.append(resultadoring[0])
                        rvectorth.append(resultadoring[3])
                        rvectorhuf.append(resultadoring[4])
                        
                        label35.set_text(str(resultadoring[2]))
                        label36.set_text(str(resultadoring[1]))
                        label37.set_text(str(resultadoring[0]))
                        label38.set_text(str(resultadoring[3]))
                        label39.set_text(str(resultadoring[4]))
                        
                        
                        
                        #print "Ring"
                    if checkpersonalizado.get_active()==True:
                        mecanismo=3
                        resultadoperso=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        
                        pvectormuf.append(resultadoperso[2])
                        pvectorcc.append(resultadoperso[1])
                        pvectortc.append(resultadoperso[0])
                        pvectorth.append(resultadoperso[3])
                        pvectorhuf.append(resultadoperso[4])
                        
                        label24.set_text(str(resultadoperso[2]))
                        label25.set_text(str(resultadoperso[1]))
                        label26.set_text(str(resultadoperso[0]))
                        label27.set_text(str(resultadoperso[3]))
                        label28.set_text(str(resultadoperso[4]))
                    
                    
                    
                    if checkcancelar.get_active()==True:
                        checkcancelar.set_active(False)
                        parar=True
                        break          
                grafo.set_from_file("grafico.png")
                self.progresso(progressbar,0.99999/(int(entrada6.get_text())+1-int(entrada5.get_text())))
                    
                vectorx.append(i)    
                
                if checkflood.get_active()==True:        
                    fvectormediahuf.append((sum(fvectorhuf)) / len(fvectorhuf))
                    fvectormediath.append((sum(fvectorth)) / len(fvectorth))
                    fvectormediatc.append((sum(fvectortc)) / len(fvectortc))
                    fvectormediacc.append((sum(fvectorcc)) / len(fvectorcc))
                    fvectormediamuf.append((sum(fvectormuf)) / len(fvectormuf))
                if checkring.get_active()==True:
                    rvectormediahuf.append((sum(rvectorhuf)) / len(rvectorhuf))
                    rvectormediath.append((sum(rvectorth)) / len(rvectorth))
                    rvectormediatc.append((sum(rvectortc)) / len(rvectortc))
                    rvectormediacc.append((sum(rvectorcc)) / len(rvectorcc))
                    rvectormediamuf.append((sum(rvectormuf)) / len(rvectormuf))             
                if checkpersonalizado.get_active()==True:
                    pvectormediahuf.append((sum(pvectorhuf)) / len(pvectorhuf))
                    pvectormediath.append((sum(pvectorth)) / len(pvectorth))
                    pvectormediatc.append((sum(pvectortc)) / len(pvectortc))
                    pvectormediacc.append((sum(pvectorcc)) / len(pvectorcc))
                    pvectormediamuf.append((sum(pvectormuf)) / len(pvectormuf))  
                
                
                if varrandom==1:
                    #pos=nx.graphviz_layout(G)
                    pos=nx.spring_layout(G)
                    exportarnodos=i
                    topologia=1
                    
                if varerdos==1:
                    #pos=nx.graphviz_layout(G)
                    pos=nx.spring_layout(G)
                    exportarnodos=i
                    topologia=2

                if varbarabasi==1:
                    #pos=nx.graphviz_layout(G)
                    pos=nx.spring_layout(G)
                    exportarnodos=i
                    topologia=2
                
                if varpath==1:
                    pos=nx.spring_layout(G)
                    #pos=nx.graphviz_layout(G)
                    exportarnodos=i
                    topologia=2
                
                entrada3.set_text(str(initiator))
                        
                if checkcancelar.get_active()==True or parar:
                    checkcancelar.set_active(False)
                    self.progresso(progressbar,1)
                    break    
              
                    
        if fixarrede.get_active()==True:
            legenda=2
            botaocancelar.set_sensitive(True)
            vectorx=[]
            nrecursos=int(entrada7.get_text())
            gerado=self.gerar(radiorandom,radioerdos,radiobarabasi,numnodos,barra1,nrecursos,grafo,radiopath)            
            G=gerado[0]
            
            if varrandom==1:
                pos=nx.spring_layout(G)
		#pos=nx.graphviz_layout(G)
                topologia=1
                
            if varerdos==1:
                pos=nx.spring_layout(G)
                #pos=nx.graphviz_layout(G)                
                topologia=2

            if varbarabasi==1:
                pos=nx.spring_layout(G)
                #pos=nx.graphviz_layout(G)
                topologia=2
            
            if varpath==1:
                pos=nx.spring_layout(G)
                #pos=nx.graphviz_layout(G)                
                topologia=2            
                                    
            numnodos=gerado[1]
            initiator=gerado[2]
            recursos=gerado[3]
                    
            for i in range(int(entrada7.get_text()),int(entrada8.get_text())+1):
                
                pintarinicial=initiator
                graficos.network_redesenhar(G,initiator,recursos,pos)
                grafo.set_from_file("grafico.png")
                pintar=recursos
                entrada3.set_text(str(initiator))
                
                while gtk.events_pending():
                    gtk.main_iteration(False)
                for j in range(0,self.leriteracoes(entrada2)):                    
                    initpinta=initiator
                    recpinta=recursos
                    self.contaitera(labelprogresso,entrada2,j+1)
                    
                    while gtk.events_pending():
                        gtk.main_iteration(False)
                    
                    if checkflood.get_active()==True:
                        mecanismo=1                                        
                        resultadoflood=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        fvectormuf.append(resultadoflood[2])
                        fvectorcc.append(resultadoflood[1])
                        fvectortc.append(resultadoflood[0])
                        fvectorth.append(resultadoflood[3])
                        fvectorhuf.append(resultadoflood[4])
                                            
                        label9.set_text(str(resultadoflood[2]))
                        label11.set_text(str(resultadoflood[1]))
                        label13.set_text(str(resultadoflood[0]))
                        label15.set_text(str(resultadoflood[3]))
                        label17.set_text(str(resultadoflood[4]))
                        
                    if checkring.get_active()==True:
                        mecanismo=2
                        resultadoring=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        
                        rvectormuf.append(resultadoring[2])
                        rvectorcc.append(resultadoring[1])
                        rvectortc.append(resultadoring[0])
                        rvectorth.append(resultadoring[3])
                        rvectorhuf.append(resultadoring[4])
                        
                        label35.set_text(str(resultadoring[2]))
                        label36.set_text(str(resultadoring[1]))
                        label37.set_text(str(resultadoring[0]))
                        label38.set_text(str(resultadoring[3]))
                        label39.set_text(str(resultadoring[4]))
                        
                    if checkpersonalizado.get_active()==True:
                        mecanismo=3
                        resultadoperso=simulador.simulador(G,initiator,recursos,mostrar,mecanismo)
                        
                        pvectormuf.append(resultadoperso[2])
                        pvectorcc.append(resultadoperso[1])
                        pvectortc.append(resultadoperso[0])
                        pvectorth.append(resultadoperso[3])
                        pvectorhuf.append(resultadoperso[4])
                        
                        label24.set_text(str(resultadoperso[2]))
                        label25.set_text(str(resultadoperso[1]))
                        label26.set_text(str(resultadoperso[0]))
                        label27.set_text(str(resultadoperso[3]))
                        label28.set_text(str(resultadoperso[4]))                       
                    #print "Recursos",i 
                                        
                    if i<numnodos:
                        vectorrecursos=[]
                        vectornodos=(range(0,numnodos))
                        vectornodos.remove(initiator)
                        recursos=rnd.sample(vectornodos, i)
                    else:
                        break
                    
                    if checkcancelar.get_active()==True:
                        checkcancelar.set_active(False)
                        parar=True
                        break                                               
                
                if i<numnodos:
                    vectorrecursos=[]
                    vectornodos=(range(0,numnodos))
                    vectornodos.remove(initiator)
                    recursos=rnd.sample(vectornodos, i)
                    
                
                graficos.network_redesenhar(G,initpinta,recpinta,pos)
                initiator=initpinta
                pintar=recpinta
                grafo.set_from_file("grafico.png")
                while gtk.events_pending():
                    gtk.main_iteration(False)
                
                self.progresso(progressbar,0.99999/(int(entrada8.get_text())+1-int(entrada7.get_text())))               
                
                vectorx.append(i)
                exportarnodos=numnodos  
                
                if checkflood.get_active()==True:        
                    fvectormediahuf.append((sum(fvectorhuf)) / len(fvectorhuf))
                    fvectormediath.append((sum(fvectorth)) / len(fvectorth))
                    fvectormediatc.append((sum(fvectortc)) / len(fvectortc))
                    fvectormediacc.append((sum(fvectorcc)) / len(fvectorcc))
                    fvectormediamuf.append((sum(fvectormuf)) / len(fvectormuf))
                if checkring.get_active()==True:
                    rvectormediahuf.append((sum(rvectorhuf)) / len(rvectorhuf))
                    rvectormediath.append((sum(rvectorth)) / len(rvectorth))
                    rvectormediatc.append((sum(rvectortc)) / len(rvectortc))
                    rvectormediacc.append((sum(rvectorcc)) / len(rvectorcc))
                    rvectormediamuf.append((sum(rvectormuf)) / len(rvectormuf))             
                if checkpersonalizado.get_active()==True:
                    pvectormediahuf.append((sum(pvectorhuf)) / len(pvectorhuf))
                    pvectormediath.append((sum(pvectorth)) / len(pvectorth))
                    pvectormediatc.append((sum(pvectortc)) / len(pvectortc))
                    pvectormediacc.append((sum(pvectorcc)) / len(pvectorcc))
                    pvectormediamuf.append((sum(pvectormuf)) / len(pvectormuf))
                
                if checkcancelar.get_active()==True or parar:
                    checkcancelar.set_active(False)
                    self.progresso(progressbar,1)
                    break
        
        links=graficos.ligar(G,numnodos)        
                    
        while checkapagar.get_active()==False:
            botaocancelar.set_sensitive(False)
            time.sleep(0.1)
            #print "A correr"
            initiator=self.lerinicial(entrada3)
            if checkns.get_active()==True:
                checkns.set_active(False)
                graficos.guardar(pos,exportarnodos,topologia,links)
            while gtk.events_pending():
                gtk.main_iteration(False)
            botaocancelar.set_sensitive(False)
            
            if checkver.get_active()==True:
                checkver.set_active(False)
                graficos.view(G,self.lerinicial(entrada3),recursos,pos)
            
            if checkredesenhar.get_active()==True:
                checkredesenhar.set_active(False)
                initiator=self.lerinicial(entrada3)
                
                recursosr=[]
                
                #
                                                
                self.janelaredesenhar(int(numnodos),initiator,pintar)
                recursosr=redesenhar.janelaredesenhar()
                recursos=recursosr
                pintar=recursosr
                
                #
                
                graficos.network_redesenhar(G,initiator,recursosr,pos)
                grafo.set_from_file("grafico.png")
                 
                if checkflood.get_active()==True:
                    mecanismo=1
                    resultadoflood=simulador.simulador(G,initiator,recursosr,mostrar,mecanismo)                                    
                    label9.set_text(str(resultadoflood[2]))
                    label11.set_text(str(resultadoflood[1]))
                    label13.set_text(str(resultadoflood[0]))
                    label15.set_text(str(resultadoflood[3]))
                    label17.set_text(str(resultadoflood[4]))
                if checkring.get_active()==True:
                    mecanismo=2
                    resultadoring=simulador.simulador(G,initiator,recursosr,mostrar,mecanismo)                                    
                    label35.set_text(str(resultadoring[2]))
                    label36.set_text(str(resultadoring[1]))
                    label37.set_text(str(resultadoring[0]))
                    label38.set_text(str(resultadoring[3]))
                    label39.set_text(str(resultadoring[4]))
                if checkpersonalizado.get_active()==True:
                    mecanismo=3
                    resultadoperso=simulador.simulador(G,initiator,recursosr,mostrar,mecanismo)                                   
                    label24.set_text(str(resultadoperso[2]))
                    label25.set_text(str(resultadoperso[1]))
                    label26.set_text(str(resultadoperso[0]))
                    label27.set_text(str(resultadoperso[3]))
                    label28.set_text(str(resultadoperso[4]))   
            
            if checkmuf.get_active()==True:
                checkmuf.set_active(False)
                if checkring.get_active()==True and checkflood.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,rvectormediamuf,1,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,fvectormediamuf,1,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results2v(vectorx,pvectormediamuf,1,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==False:
                    graficos.results3v(vectorx,fvectormediamuf,rvectormediamuf,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results3v(vectorx,fvectormediamuf,pvectormediamuf,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==True and checkpersonalizado.get_active()==True:                    
                    graficos.results3v(vectorx,rvectormediamuf,pvectormediamuf,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==True: 
                    graficos.results4v(vectorx,fvectormediamuf,rvectormediamuf,pvectormediamuf,1,legenda)
                    
            if checkcc.get_active()==True:
                checkcc.set_active(False)                    
                if checkring.get_active()==True and checkflood.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,rvectormediacc,2,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==False:
                     graficos.results2v(vectorx,fvectormediacc,2,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results2v(vectorx,pvectormediacc,2,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==False:
                    graficos.results3v(vectorx,fvectormediacc,rvectormediacc,2,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results3v(vectorx,fvectormediacc,pvectormediacc,2,legenda)
                if checkflood.get_active()==False and checkring.get_active()==True and checkpersonalizado.get_active()==True:                    
                    graficos.results3v(vectorx,rvectormediacc,pvectormediacc,2,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==True: 
                    graficos.results4v(vectorx,fvectormediacc,rvectormediacc,pvectormediacc,2,legenda)
                    
            if checktc.get_active()==True:
                checktc.set_active(False)
                if checkring.get_active()==True and checkflood.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,rvectormediatc,3,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,fvectormediatc,3,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results2v(vectorx,pvectormediatc,3,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==False:
                    graficos.results3v(vectorx,fvectormediatc,rvectormediatc,3,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results3v(vectorx,fvectormediatc,pvectormediatc,3,legenda)
                if checkflood.get_active()==False and checkring.get_active()==True and checkpersonalizado.get_active()==True:                    
                    graficos.results3v(vectorx,rvectormediatc,pvectormediatc,3,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==True: 
                    graficos.results4v(vectorx,fvectormediatc,rvectormediatc,pvectormediatc,3,legenda)
           
            if checkth.get_active()==True:
                checkth.set_active(False)
                if checkring.get_active()==True and checkflood.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,rvectormediath,4,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,fvectormediath,4,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results2v(vectorx,pvectormediath,4,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==False:
                    graficos.results3v(vectorx,fvectormediath,rvectormediath,4,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results3v(vectorx,fvectormediath,pvectormediath,4,legenda)
                if checkflood.get_active()==False and checkring.get_active()==True and checkpersonalizado.get_active()==True:                    
                    graficos.results3v(vectorx,rvectormediath,pvectormediath,4,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==True: 
                    graficos.results4v(vectorx,fvectormediath,rvectormediath,pvectormediath,4,legenda)
            
            if checkhuf.get_active()==True:
                checkhuf.set_active(False)
                if checkring.get_active()==True and checkflood.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,rvectormediahuf,5,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==False:
                    graficos.results2v(vectorx,fvectormediahuf,5,1,legenda)
                if checkflood.get_active()==False and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results2v(vectorx,pvectormediahuf,5,1,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==False:
                    graficos.results3v(vectorx,fvectormediahuf,rvectormediahuf,5,legenda)
                if checkflood.get_active()==True and checkring.get_active()==False and checkpersonalizado.get_active()==True:
                    graficos.results3v(vectorx,fvectormediahuf,pvectormediahuf,5,legenda)
                if checkflood.get_active()==False and checkring.get_active()==True and checkpersonalizado.get_active()==True:                    
                    graficos.results3v(vectorx,rvectormediahuf,pvectormediahuf,5,legenda)
                if checkflood.get_active()==True and checkring.get_active()==True and checkpersonalizado.get_active()==True: 
                    graficos.results4v(vectorx,fvectormediahuf,rvectormediahuf,pvectormediahuf,5,legenda)
                                    
            while gtk.events_pending():
                gtk.main_iteration(False)
            
        checkapagar.set_active(False)
        
    def delete_event(self, widget, event, data=None):        
        print "Janela fechada"
        return False
    def janelaredesenhar(self,numnodos,inicial,recursos,data=None):
        
        codigo=""
        codigo+="def ok(botao,check,data=None):\n"
        codigo+="\tcheck.set_active(True)\n"       
        
        codigo+="import pygtk\n"
        codigo+="pygtk.require('2.0')\n"
        codigo+="import gtk\n"
        codigo+="import string\n"
        codigo+="import time\n"
        
        codigo+="def janelaredesenhar(data=None):\n"
        codigo+="\twindow = gtk.Window(gtk.WINDOW_TOPLEVEL)\n"
        codigo+="\twindow.set_size_request(520, 290)\n"
        codigo+="\twindow.set_title('Choose Target Nodes')\n"
        codigo+="\twindow.set_border_width(10)\n"              
        n=numnodos+1
        
        codigo+="\tbotaook=gtk.Button('OK')\n"
        codigo+="\tbotaodes=gtk.Button('Uncheck')\n"
        
        for i in range(0,n-1):
            codigo+="\tbotao"+str(i)+"= gtk.CheckButton('"+str(i)+"')\n"
        codigo+="\tcheckok= gtk.CheckButton('')\n"
        codigo+="\tcheckdes= gtk.CheckButton('')\n"
        codigo+="\tfixo = gtk.Fixed()\n"
        codigo+="\tcaixav = gtk.VBox()\n"
        codigo+="\tcaixav.pack_start(fixo, expand=False, fill=True)\n"
        codigo+="\tbotaook.connect('clicked',ok,checkok)\n"
        codigo+="\tbotaodes.connect('clicked',ok,checkdes)\n"
        codigo+="\tbotao"+str(inicial)+".set_sensitive(False)\n"
        
        for i in range(0,len(recursos)):
            codigo+="\tbotao"+str(recursos[i])+".set_active(True)\n"
            
        x=20
        y=20
        for i in range(0,n-1):
            codigo+="\tfixo.put(botao"+str(i)+","+str(x)+","+str(y)+")\n"
            y+=20
            if y>200:
                y=20
                x+=45
        codigo+="\tfixo.put(botaook,20,230)\n"
        codigo+="\tfixo.put(botaodes,70,230)\n"
        codigo+="\twindow.add(caixav)\n"
        codigo+="\twindow.show_all()\n"
        
        codigo+="\twhile checkok.get_active()==False:\n"
        codigo+="\t\tcheckok.set_active(False)\n"
        codigo+="\t\twhile gtk.events_pending():\n"                
        codigo+="\t\t\tgtk.main_iteration(False)\n"
        codigo+="\t\ttime.sleep(0.1)\n"
      
        codigo+="\t\tvector=[]\n"
        
        codigo+="\t\tif checkdes.get_active()==True:\n"
        codigo+="\t\t\tcheckdes.set_active(False)\n"        
        for i in range(0,n-1):
            codigo+="\t\t\tbotao"+str(i)+".set_active(False)\n"
        
        
        codigo+="\t\tif checkok.get_active()==True:\n"       
        for i in range(0,n-1):
            codigo+="\t\t\tif botao"+str(i)+".get_active()==True:\n"
            codigo+="\t\t\t\tvector.append("+str(i)+")\n"
        codigo+="\t\t\tprint 'Acabou'\n"
        codigo+="\tcheckok.set_active(False)\n"
        codigo+="\tprint vector\n"
        codigo+="\twindow.destroy()\n"
        codigo+="\treturn vector\n"
        
        
        
        #print codigo
        
        texto = open("redesenhar.py","w")
        texto.write(str(codigo))
        texto.close()
        
        reload(redesenhar)
        
        
    def minimo(self,widget,radiorandom,radioerdos,barranodos,barra1,label19,data=None):    
        varrandom=radiorandom.get_active()
        varerdos=radioerdos.get_active()
        numdenodos=self.lernodos(barranodos)
        if varrandom==1:        
            resultado=gerar.raiominimo(numdenodos)
            adjustment = gtk.Adjustment(value=resultado, lower=resultado, upper=2.0, step_incr=0.05, page_incr=0, page_size=0)
            barra1.set_adjustment(adjustment)
            label19.set_text(str(resultado))
        if varerdos==1:
            resultado=gerar.probminima(numdenodos)
            adjustment = gtk.Adjustment(value=resultado, lower=resultado, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
            barra1.set_adjustment(adjustment)
            label19.set_text(str(resultado))
    
    
    
    def previsualizar(self,widget,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,barrarecursos,grafo,checkapagar,checkns,radiopath,data=None):
        recursos=[]
        links=[]
        varrandom=radiorandom.get_active()
        varerdos=radioerdos.get_active()
        varbarabasi=radiobarabasi.get_active()
        varpath=radiopath.get_active()
        numdenodos=self.lernodos(barranodos)
        initiator=rnd.randint(0,numdenodos-1)

        percentagem=float(barrarecursos.get_value()) 
        nrecursos=int((numdenodos-1)*percentagem)
        if nrecursos < 1:
            nrecursos=1 
        
        vectorrecursos=[]
        vectornodos=(range(0,numdenodos))
        vectorrecursos=rnd.sample(vectornodos, nrecursos)
        
        for i in range(0,len(vectorrecursos)):
            vectorrecursos[i]=int(vectorrecursos[i])        
      
        recursos=vectorrecursos
        
        #print recursos
        #print nrecursos    
            
        while initiator in recursos:
            initiator=rnd.randint(0,numdenodos-1)
        
        if varrandom==1:
            raio=self.lerraio(barra1)
            mostrar=None
            G=gerar.geradorrandom(numdenodos,raio,mostrar)    
            graficos.network_rand(G,initiator,recursos)
        if varerdos==1:
            prob=self.lerraio(barra1)
            mostrar=None
            G=gerar.geradorerdos(numdenodos,prob,mostrar)
            graficos.network_erdos(G,initiator,recursos)
        if varbarabasi==1:
            ligacoes=int(self.lerraio(barra1))
            mostrar=None
            G=gerar.geradorbarabasi(numdenodos,ligacoes,mostrar)
            graficos.network_barabasi(G,initiator,recursos)
        if varpath==1:
            mostrar=None
            G=gerar.geradorpath(numdenodos,mostrar)            
            graficos.network_path(G,initiator,recursos)
            
        grafo.set_from_file("grafico.png")
        
        if varrandom==1:
            pos=nx.spring_layout(G)
            #pos=nx.graphviz_layout(G)
            topologia=1
            
        if varerdos==1:
            pos=nx.spring_layout(G)
            #pos=nx.graphviz_layout(G)
            topologia=2

        if varbarabasi==1:
            pos=nx.spring_layout(G)
            #pos=nx.graphviz_layout(G)
            topologia=2
            
        if varpath==1:
            pos=nx.spring_layout(G)
            #pos=nx.graphviz_layout(G)
            topologia=2
        
        links=graficos.ligar(G,numdenodos)
        
        while checkapagar.get_active()==False:
            time.sleep(0.1)
            #print "Prévisualizar"            
            
            if checkns.get_active()==True:
                checkns.set_active(False)
                graficos.guardar(pos,numdenodos,topologia,links)
            
            while gtk.events_pending():
                gtk.main_iteration(False)
            
        checkapagar.set_active(False)
        
    def janelaacerca(self,widget,data=None):
        window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window.set_size_request(235, 300)
        window.set_title("About")
        window.set_border_width(10)
        image = gtk.Image()
        image.set_from_file("image.jpg")
        label1 = gtk.Label("SRS - Simulator")
        label2 = gtk.Label("Rui Lima")
        label3 = gtk.Label("MAPi")
        label4 = gtk.Label("2011")
        fixo = gtk.Fixed()
        caixa_acerca = gtk.VBox()
        frame2 = gtk.Frame("About")
        caixa_acerca.pack_start(fixo, expand=False, fill=True)
        fixo.put(label1, 20,20)
        fixo.put(label2, 75,200)
        fixo.put(label3, 75,220)
        fixo.put(label4, 85,240)
        fixo.put(image, 5, 40)
        frame2.add(caixa_acerca)
        window.add(frame2)
        window.show_all()

    def janelasumario(self,pmediamuf,pmediacc,pmediatc,pmediath,pmediahuf,resultado,data=None):
        window2 = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window2.set_size_request(500, 350)
        window2.connect("delete_event", self.delete_event)
        window2.set_title("Sumário")
        window2.set_border_width(10)
        fixo= gtk.Fixed()
        caixa_sumario = gtk.VBox()
        caixa_sumario.pack_start(fixo, expand=False, fill=True)
        frame1 = gtk.Frame("Resultados da simulação personalizada")
        label4 = gtk.Label("Inicial:")
        label5 = gtk.Label("0")
        label6 = gtk.Label("Final:")
        label7 = gtk.Label("0")
        label8 = gtk.Label("Messages Until Found:")
        label9 = gtk.Label("0")
        label10 = gtk.Label("Communication Complexity:")
        label11 = gtk.Label("0")
        label12 = gtk.Label("Time Complexity:")
        label13 = gtk.Label("0")
        label14 = gtk.Label("Total HOPs:")
        label15 = gtk.Label("0")
        label16 = gtk.Label("HOPs Until Found:")
        label17 = gtk.Label("0")
        label22 = gtk.Label("-")
        label23 = gtk.Label("-")
        label24 = gtk.Label("0")
        label25 = gtk.Label("0")
        label26 = gtk.Label("0")
        label27 = gtk.Label("0")
        label28 = gtk.Label("0")
        
        label31=gtk.Label("GRÁFICOS")
        label32=gtk.Label("NOMES")
        label29=gtk.Label("VALORES")
        label30=gtk.Label("MÉDIA")
                          
        botaomuf = gtk.Button("Gráfico")
        botaocc = gtk.Button("Gráfico")
        botaotc = gtk.Button("Gráfico")                   
        botaoth = gtk.Button("Gráfico")
        botaohuf = gtk.Button("Gráfico")
        
        checkmuf = gtk.CheckButton("")
        checkcc = gtk.CheckButton("")
        checktc = gtk.CheckButton("")                   
        checkth = gtk.CheckButton("")
        checkhuf = gtk.CheckButton("")
        
        label24.set_text(str(pmediamuf))
        label25.set_text(str(pmediacc))
        label26.set_text(str(pmediatc))
        label27.set_text(str(pmediath))
        label28.set_text(str(pmediahuf))
                            
        label5.set_text(str(resultado[5]))
        label7.set_text(str(resultado[6]))
        label9.set_text(str(resultado[2]))
        label11.set_text(str(resultado[1]))
        label13.set_text(str(resultado[0]))
        label15.set_text(str(resultado[3]))
        label17.set_text(str(resultado[4]))
        
        fixo.put(label4, 80, 60)
        fixo.put(label5, 270, 60)
        fixo.put(label6, 80, 90)
        fixo.put(label7, 270, 90)
        fixo.put(label8, 80, 120)
        fixo.put(label9, 270, 120)
        fixo.put(label10, 80, 150)
        fixo.put(label11, 270, 150)
        fixo.put(label12, 80, 180)
        fixo.put(label13, 270, 180)
        fixo.put(label14, 80, 210)
        fixo.put(label15, 270, 210)
        fixo.put(label16, 80, 240)
        fixo.put(label17, 270, 240)
        fixo.put(label22,340, 60)
        fixo.put(label23,340, 90)
        fixo.put(label24,340, 120)
        fixo.put(label25,340, 150)
        fixo.put(label26,340, 180)
        fixo.put(label27,340, 210)
        fixo.put(label28,340, 240)
        fixo.put(label29,255, 20)
        fixo.put(label30,320, 20)
        fixo.put(label31,10, 20)
        fixo.put(label32,130, 20)
        
        fixo.put(botaomuf,10,115)
        fixo.put(botaocc,10,145)
        fixo.put(botaotc,10,175)
        fixo.put(botaoth,10,205)
        fixo.put(botaohuf,10,235)
        
        frame1.add(caixa_sumario)
        window2.add(frame1)
        window2.show_all()
        
        #while 
    

    def janelaeditar(self,widget,data=None):    
        var = 'default.py'
        os.system('gedit '+var)

    
    def netbrowser(self,widget,data=None):
        WEB.open('http://www.google.pt')    
        
    def select(self,widget,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,label18,label3,label19,botaominimo,radiopath,data=None):
        varrandom=radiorandom.get_active()
        varerdos=radioerdos.get_active()
        varbarabasi=radiobarabasi.get_active()
        varpath=radiopath.get_active()
        numdenodos=self.lernodos(barranodos)
        if varrandom==1:
            label18.set_text("Minimum radius:")
            label3.set_text("Radius:")   
            adjustment = gtk.Adjustment(value=0.4, lower=0.3, upper=2.0, step_incr=0.05, page_incr=0, page_size=0)
            barra1.set_adjustment(adjustment)
            barra1.set_digits(2)
            botaominimo.set_sensitive(True)
            barra1.set_sensitive(True)
            label19.set_text("0")
        if varerdos==1:
            label18.set_text("Min. probability:") 
            label3.set_text("Probability:")
            adjustment = gtk.Adjustment(value=0.1, lower=0.05, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
            barra1.set_adjustment(adjustment)
            barra1.set_digits(2)
            botaominimo.set_sensitive(True)
            barra1.set_sensitive(True)
            label19.set_text("0")
        if varbarabasi==1:
            label18.set_text("Min. connections:") 
            label3.set_text("Connections:")
            adjustment = gtk.Adjustment(value=1, lower=1, upper=5, step_incr=1, page_incr=0, page_size=0)
            barra1.set_adjustment(adjustment)  
            barra1.set_digits(0)   
            botaominimo.set_sensitive(False)
            barra1.set_sensitive(True)
            label19.set_text("1")
            
        if varpath==1:
            botaominimo.set_sensitive(False)
            barra1.set_sensitive(False)
   
    def progresso(self,progressbar,valor,data=None):
        
        novovalor = progressbar.get_fraction() + valor
        if novovalor > 0.99998:
            novovalor = 0.0
        
        progressbar.set_fraction(novovalor)
        

        return True
   
    def apagar(self,botaoapagar,checkapagar,label24,label25,label26,label27,label28,label5,label7,label9,label11,label13,label15,label17,
               progressbar,grafo,label33,label34,label35,label36,label37,label38,label39,label42,label43,label44,label45,label46,botaomuf,
               botaocc,botaotc,botaoth,botaohuf,labelprogresso,data=None):
        checkapagar.set_active(True)
        botaomuf.set_sensitive(True)
        botaocc.set_sensitive(True)
        botaotc.set_sensitive(True)
        botaoth.set_sensitive(True)
        botaohuf.set_sensitive(True)
        labelprogresso.set_text("0/1")               
        label24.set_text("0")
        label25.set_text("0")
        label26.set_text("0")
        label27.set_text("0")
        label28.set_text("0")                            
        label5.set_text("0")
        label7.set_text("0")
        label9.set_text("0")
        label11.set_text("0")
        label13.set_text("0")
        label15.set_text("0")
        label17.set_text("0")
        label33.set_text("0")
        label34.set_text("0")
        label35.set_text("0")
        label36.set_text("0")
        label37.set_text("0")
        label38.set_text("0")
        label39.set_text("0")
        label42.set_text("0")
        label43.set_text("0")
        label44.set_text("0")
        label45.set_text("0")
        label46.set_text("0")
        self.progresso(progressbar,1.00)
        grafo.set_from_file("vazia.png")
    def cancelar(self,botaocancelar,checkcancelar,progressbar,data=None):
        checkcancelar.set_active(True)
        botaocancelar.set_sensitive(False)
        self.progresso(progressbar,1.00)
    #muf=1 cc=2 tc=3 th=4 huf=5
    def graficomuf(self,botaomuf,checkmuf,data=None):
        checkmuf.set_active(True)
    def graficocc(self,botaocc,checkcc,data=None):
        checkcc.set_active(True)
    def graficotc(self,botaotc,checktc,data=None):
        checktc.set_active(True)
    def graficoth(self,botaoth,checkth,data=None):
        checkth.set_active(True)
    def graficohuf(self,botaohuf,checkhuf,data=None):        
        checkhuf.set_active(True)
    def view(self,botaoview,checkview,data=None):
        checkview.set_active(True)
    def contaitera(self,labelprogresso,entrada2,valor,data=None):
        total=self.leriteracoes(entrada2)
        a=str(valor)+"/"+str(total)
        labelprogresso.set_text(a)
    def checkredesenha(self,botaoredesenhar,checkredesenhar,data=None):
        checkredesenhar.set_active(True)
    def ns(self,botaons,checkns,data=None):
        checkns.set_active(True)
    def actrecursos(self,barrarecursos,labelvalorrecurso,barranodos,entrada8,entrada5,fixarrede,fixarrecursos,data=None):
        numnodos=int(self.lernodos(barranodos))
        percentagem=float(barrarecursos.get_value())
        
        nrecursos=int(numnodos*percentagem)-1  
        
        minimo= 1.0000000/numnodos
               
        ajustamento = gtk.Adjustment(value=percentagem, lower=minimo, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
        barrarecursos.set_adjustment(ajustamento)
        
        a=int((numnodos-1)*percentagem)
        labelvalorrecurso.set_text(str(a))
        if a<1:
            labelvalorrecurso.set_text("1")        
        
        if fixarrecursos.get_active()==True:
            if a>=int(entrada5.get_text()):
                b=float(entrada5.get_text())/(numnodos+1)                
                ajustamento = gtk.Adjustment(value=b, lower=minimo, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
                if a<1:
                    b=1/numdodos
                    ajustamento = gtk.Adjustment(value=b, lower=minimo, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)                
                
                barrarecursos.set_adjustment(ajustamento)
                labelvalorrecurso.set_text(str(int(entrada5.get_text())-1)) 
        if fixarrede.get_active()==True: 
            entrada8.set_text(str(a))
            if a>=numnodos:
                b=numnodos-1
                labelvalorrecurso.set_text(str(b))
                entrada8.set_text(str(b))  
            if a<1:
                entrada8.set_text(str("1"))
        return a
    
    def actbarranodos(self,barranodos,barrarecursos,labelvalorrecurso,entrada6,data=None):
        numnodos=int(self.lernodos(barranodos))-1
        percentagem=float(barrarecursos.get_value())
        minimo= 1.0000000/numnodos
        
        a=int(numnodos*percentagem)
        if a!=0:
            labelvalorrecurso.set_text(str(a))
        
        ajustamento = gtk.Adjustment(value=minimo, lower=minimo, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
        barrarecursos.set_adjustment(ajustamento)
        
        entrada6.set_text(str(numnodos+1))
    
    def __init__(self):
        self.janela = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.janela.set_size_request(1275, 700)
        self.janela.set_title("Synchronous Round-based Simulator")
        caixa_v1 = gtk.VBox()
         
        #______MENUBAR______#
        mb = gtk.MenuBar()
        #1_MENU
        filemenu1 = gtk.Menu()
        filem1 = gtk.MenuItem("File")
        filem1.set_submenu(filemenu1)
        editar = gtk.MenuItem("Edit")
        editar.connect("activate", self.janelaeditar)
        filemenu1.append(editar)
        exportar=gtk.MenuItem("Export")        
        filemenu1.append(exportar)  
        sep1 = gtk.SeparatorMenuItem()
        filemenu1.append(sep1)   
        exit = gtk.MenuItem("Exit")
        exit.connect("activate", gtk.main_quit)
        filemenu1.append(exit)
        mb.append(filem1)
        #2_MENU
        #filemenu2 = gtk.Menu()
        #filem2 = gtk.MenuItem("Clock")
        #filem2.set_submenu(filemenu2)
        #stop = gtk.MenuItem("Stop")
        #stop.connect("activate", None)
        #filemenu2.append(stop)      
        #step = gtk.MenuItem("Step")
        #step.connect("activate", None)
        #filemenu2.append(step)
        #mb.append(filem2)
        #3_MENU
        #filemenu3 = gtk.Menu()
        #filem3 = gtk.MenuItem("Resultados")
        #filem3.set_submenu(filemenu3)
        #sumario = gtk.MenuItem("Sumário")
        #sumario.connect("activate", self.janelasumario)
        #filemenu3.append(sumario)      
        #mb.append(filem3)
        #4_MENU
        filemenu4 = gtk.Menu()
        filem4 = gtk.MenuItem("Help")
        filem4.set_submenu(filemenu4)
        acerca = gtk.MenuItem("About")
        acerca.connect("activate",self.janelaacerca)
        filemenu4.append(acerca) 
        #separador2
        sep2 = gtk.SeparatorMenuItem()
        filemenu4.append(sep2)
        ajudaonline = gtk.MenuItem("Online Help")
        ajudaonline.connect("activate",self.netbrowser)
        filemenu4.append(ajudaonline)
        mb.append(filem4)

        caixa_v1.pack_start(mb, expand=False, fill=True)
        fixo= gtk.Fixed()
        caixa_v1.pack_start(fixo, expand=False, fill=True)

        #____MENU TOPOLOGIA____#
        label0 = gtk.Label("TOPOLOGY:")
        label1 = gtk.Label("Number of Nodes:")
        barranodos = gtk.HScale()
        barranodos.set_draw_value(True)
        barranodos.set_digits(0)
        adjustment2 = gtk.Adjustment(value=10, lower=2, upper=100, step_incr=1, page_incr=0, page_size=0)
        barranodos.set_adjustment(adjustment2)
        barranodos.set_size_request(160,50)
        

        botaosimular = gtk.Button("Simulate")
        

        botaoprevisualizar = gtk.Button("Preview")
        

        label3 = gtk.Label("Radius:")

        checkmostrar = gtk.CheckButton("LOG")
        checkmostrar.connect("toggled", self.mostra)
        checkmostrar.set_active(False)
        
        botaominimo = gtk.Button("Calculate")
        

        label18 = gtk.Label("Minimum Radius:")
        label19 = gtk.Label("0")

        barra1 = gtk.HScale()
        barra1.set_draw_value(True)
        barra1.set_digits(2)
        adjustment = gtk.Adjustment(value=0.4, lower=0.3, upper=2.0, step_incr=0.05, page_incr=0, page_size=0)
        barra1.set_adjustment(adjustment)
        barra1.set_size_request(160,50)
        
        adjustmentresursos = gtk.Adjustment(value=0.12, lower=0.12, upper=1.0, step_incr=0.01, page_incr=0, page_size=0)
        barrarecursos = gtk.HScale(adjustmentresursos)
        barrarecursos.set_draw_value(True)
        barrarecursos.set_digits(2)
        barrarecursos.set_size_request(160,50)
        
        labelrecursos=gtk.Label("Resources(%):")
        labelnrecurso=gtk.Label("Resources:")
        labelvalorrecurso=gtk.Label("1")
        
        
        
        checkns = gtk.CheckButton("")
        
        checkapagar = gtk.CheckButton("")
        botaoapagar = gtk.Button("Delete Simulations")
        
        botaoview = gtk.Button("View")
        checkver = gtk.CheckButton("")
                                 

        #RADIOBUTTONS
        radiorandom = gtk.RadioButton(None, "Random Geometric")
        radiorandom.set_active(True)
        radioerdos = gtk.RadioButton(radiorandom, "Erdos Renyi")
        radiobarabasi = gtk.RadioButton(radiorandom, "Barabási-Albert")
        radiopath = gtk.RadioButton(radiorandom, "Path Graph")           
        radio2 = gtk.RadioButton(radiorandom, "Radio Button 2")           
        radio3 = gtk.RadioButton(radiorandom, "Radio Button 3")
   

        #____MENU PARAMETROS____#
        label02 = gtk.Label("Simulations Parameters:")

        label2 = gtk.Label("Runs:")
        entrada2 = gtk.Entry()
        entrada2.set_text("20")
        entrada2.set_size_request(60,30)
        
        label20 = gtk.Label("Starting Node:")
        label21 = gtk.Label("Target Node:")
        labelredesenhar = gtk.Label("Rebuild:")

        entrada3 = gtk.Entry()
        entrada3.set_text("0")
        
        entrada4 = gtk.Entry()
        entrada4.set_text("1")
        
        botaoredesenhar=gtk.Button("Choose Target Nodes") 
        
        
        adjustment = gtk.Adjustment(value=0, lower=0, upper=1, step_incr=0.01, page_incr=0, page_size=0)
        progressbar = gtk.ProgressBar(adjustment)
        progressbar.set_pulse_step(0.1)
        progressbar.set_fraction(0)
        
        labelprogresso=gtk.Label("0/1")
        
        botaomuf = gtk.Button("Graphic")
        botaocc = gtk.Button("Graphic")
        botaotc = gtk.Button("Graphic")                   
        botaoth = gtk.Button("Graphic")
        botaohuf = gtk.Button("Graphic")
        
        checkmuf = gtk.CheckButton("")
        checkcc = gtk.CheckButton("")
        checktc = gtk.CheckButton("")                   
        checkth = gtk.CheckButton("")
        checkhuf = gtk.CheckButton("")
        
        checkflood = gtk.CheckButton("Flooding")
        checkring = gtk.CheckButton("Expanding Ring")
        checkpersonalizado = gtk.CheckButton("Development")
        
        checkflood.set_active(True)
        
        fixarrecursos = gtk.RadioButton(None, "Lock Resources")           
        fixarrede = gtk.RadioButton(fixarrecursos, "Lock Network")
        
        label49 = gtk.Label("Range of Nodes:")
        entrada5 = gtk.Entry()
        entrada5.set_text("2")
        label50 = gtk.Label("a")
        entrada6 = gtk.Entry()
        entrada6.set_text("10")
        entrada6.set_sensitive(False)
        
        label51 = gtk.Label("Range of Resources:")
        entrada7 = gtk.Entry()
        entrada7.set_text("1")
        label52 = gtk.Label("a")
        entrada8 = gtk.Entry()
        entrada8.set_text("1")
        
        entrada7.set_sensitive(False)
        entrada8.set_sensitive(False)
        
        checkredesenhar=gtk.CheckButton("")
        
        checkcancelar = gtk.CheckButton("")
        botaocancelar = gtk.Button("Cancel")
        botaocancelar.set_sensitive(False)
        
        #____MENU RESULTADOS____#
        label04=gtk.Label("RESULTS FROM LAST TOPOLOGY: ")
        label31=gtk.Label("GRAPHICS")
        label32=gtk.Label("METRICS")
        label29=gtk.Label("FLOOD")
        label30=gtk.Label("RING")  
        label47=gtk.Label("DEV")
        #label48=gtk.Label("MÉDIA") 
        label4 = gtk.Label("Starting node:")
        label5 = gtk.Label("0")
        label6 = gtk.Label("Final node:")
        label7 = gtk.Label("0")
        label8 = gtk.Label("Messages Until Found:")
        label9 = gtk.Label("0")
        label10 = gtk.Label("Communication Complexity:")
        label11 = gtk.Label("0")
        label12 = gtk.Label("Time Complexity:")
        label13 = gtk.Label("0")
        label14 = gtk.Label("Total HOPs:")
        label15 = gtk.Label("0")
        label16 = gtk.Label("HOPs Until Found:")
        label17 = gtk.Label("0")
        
        #PERSONALIZADO
        label22 = gtk.Label("0")
        label23 = gtk.Label("0")
        label24 = gtk.Label("0")
        label25 = gtk.Label("0")
        label26 = gtk.Label("0")
        label27 = gtk.Label("0")
        label28 = gtk.Label("0")
        #RING
        label33 = gtk.Label("0")
        label34 = gtk.Label("0")
        label35 = gtk.Label("0")
        label36 = gtk.Label("0")
        label37 = gtk.Label("0")
        label38 = gtk.Label("0")
        label39 = gtk.Label("0")
        
        label40 = gtk.Label("-")
        label41 = gtk.Label("-")
        label42 = gtk.Label("0")
        label43 = gtk.Label("0")
        label44 = gtk.Label("0")
        label45 = gtk.Label("0")
        label46 = gtk.Label("0")
        
        grafo = gtk.Image()
        grafo.set_from_file("vazia.png")
        
        framegrafo = gtk.Frame("Graphic from the last simulation")
        framegrafo.add(grafo)
        
        
        
        #CONNECT'S                       
        botaosimular.connect('clicked',self.simular,barranodos,checkmostrar,entrada3,entrada4,radiorandom,radioerdos,radiobarabasi,barra1,entrada2,
                             label5,label7,label9,label11,label13,label15,label17,progressbar,self.janela,label24,label25,label26,label27,label28,label29,label30,
                             checkapagar,checkcancelar,checkmuf,checkcc,checktc,checkth,checkhuf,labelprogresso,checkflood,checkring,label33, 
                            label34,label35,label36,label37,label38,label39,label42,label43,label44,label45,label46,barrarecursos,grafo,checkredesenhar,botaomuf,
                            botaocc,botaotc,botaoth,botaohuf,botaocancelar,botaoredesenhar,checkns,checkpersonalizado,fixarrecursos,fixarrede,entrada5,entrada6,
                            entrada7,entrada8,radiopath,labelredesenhar,checkver)
        botaominimo.connect('clicked',self.minimo,radiorandom,radioerdos,barranodos,barra1,label19)
        botaoprevisualizar.connect('clicked', self.previsualizar,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,barrarecursos,grafo,checkapagar,checkns,radiopath)
        radiorandom.connect("toggled",self.select,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,label18,label3,label19,botaominimo,radiopath)
        radioerdos.connect("toggled",self.select,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,label18,label3,label19,botaominimo,radiopath)
        radiobarabasi.connect("toggled",self.select,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,label18,label3,label19,botaominimo,radiopath)
        radiopath.connect("toggled",self.select,radiorandom,radioerdos,radiobarabasi,barranodos,barra1,label18,label3,label19,botaominimo,radiopath)
        botaoapagar.connect('clicked', self.apagar,checkapagar,label24,label25,label26,label27,label28,label5,label7,label9,label11,label13,label15,label17,
                            progressbar,grafo,label33,label34,label35,label36,label37,label38,label39,label42,label43,label44,label45,label46,botaomuf,botaocc,
                            botaotc,botaoth,botaohuf,labelprogresso)
        botaocancelar.connect('clicked',self.cancelar,checkcancelar,progressbar)        
        botaomuf.connect('clicked',self.graficomuf,checkmuf)
        botaocc.connect('clicked',self.graficocc,checkcc)
        botaotc.connect('clicked',self.graficotc,checktc)
        botaoth.connect('clicked',self.graficoth,checkth)
        botaohuf.connect('clicked',self.graficohuf,checkhuf)
        botaoview.connect('clicked',self.view,checkver)
        barrarecursos.connect('value_changed',self.actrecursos,labelvalorrecurso,barranodos,entrada8,entrada5,fixarrede,fixarrecursos)
        barranodos.connect('value_changed',self.actbarranodos,barrarecursos,labelvalorrecurso,entrada6)        
        botaoredesenhar.connect('clicked',self.checkredesenha,checkredesenhar)
        exportar.connect("activate",self.ns,checkns)
        fixarrede.connect("toggled",self.selectfixar,fixarrecursos,fixarrede,entrada5,entrada6,entrada7,entrada8,barranodos)
        fixarrecursos.connect("toggled",self.selectfixar,fixarrecursos,fixarrede,entrada5,entrada6,entrada7,entrada8,barranodos)
        
        
        #FIXAR TOPOLOGIA

        #FIXAR TOPOLOGIA

        fixo.put(label0, 20, 20)
        fixo.put(radiorandom,30,40)
        fixo.put(radioerdos,30, 60)
        fixo.put(radiobarabasi,30, 80)
        fixo.put(radiopath,200,40)
        #fixo.put(radio2,180,60)
        #fixo.put(radio3,180,80)
        
        fixo.put(label1, 30, 150)
        fixo.put(barranodos, 170, 125)
        fixo.put(label3, 30, 200)
        fixo.put(barra1, 170, 175)
        fixo.put(label18, 30, 250)
        fixo.put(label19, 170, 250)
        fixo.put(botaominimo, 280,242)
        fixo.put(botaoprevisualizar, 30, 300)
        fixo.put(checkmostrar, 30, 360)
        fixo.put(botaosimular, 30, 330)
        fixo.put(botaoapagar, 130, 360)
        fixo.put(botaocancelar,130,330)
        fixo.put(barrarecursos,170,400)
        fixo.put(labelrecursos,30,425)
        fixo.put(labelnrecurso,30,450)
        fixo.put(labelvalorrecurso,100,450)        

        #FIXAR PARAMETROS
        fixo.put(label02,400,20)
        fixo.put(label2, 570, 90)
        fixo.put(entrada2, 650, 85)
        fixo.put(label20, 400, 375)
        fixo.put(entrada3, 500, 370)
        fixo.put(label21, 400, 405)
        fixo.put(labelredesenhar,460,340)
        #fixo.put(entrada4, 500, 360)
        fixo.put(botaoredesenhar, 500, 400)
        fixo.put(checkflood, 400, 60)
        fixo.put(checkring, 400, 90)
        fixo.put(checkpersonalizado,400,120)
        fixo.put(fixarrecursos, 400, 170)
        fixo.put(fixarrede, 570, 170)
        fixo.put(label49,400,200)
        fixo.put(entrada5,400,220)
        fixo.put(label50,400,255)
        fixo.put(entrada6,400,280)
        fixo.put(label51,570,200)
        fixo.put(entrada7,570,220)
        fixo.put(label52,570,255)
        fixo.put(entrada8,570,280)

        #FIXAR RESULTADOS
        fixo.put(label31,755, 50)
        fixo.put(label32,880, 50)
        fixo.put(label04, 800, 20)
        fixo.put(label29,1005,50)
        fixo.put(label30, 1080,50)
        fixo.put(label47, 1155,50)
        
        #fixo.put(label4, 830, 80)
        #fixo.put(label6, 830, 110)
        fixo.put(label8, 830, 170)
        fixo.put(label10, 830, 110)
        fixo.put(label12, 830, 140)
        fixo.put(label14, 830, 80)
        fixo.put(label16, 830, 200)        
        
        #RESULTADOS FLOOD
        #fixo.put(label5, 1020, 80)
        #fixo.put(label7, 1020, 110)
        fixo.put(label9, 1020, 170)
        fixo.put(label11, 1020, 110)
        fixo.put(label13, 1020, 140)
        fixo.put(label15, 1020, 80)
        fixo.put(label17, 1020, 200)
        
        #RESULTADOS RING
        #fixo.put(label33,1095, 80)
        #fixo.put(label34,1095, 110)
        fixo.put(label35,1095, 170)
        fixo.put(label36,1095, 110)
        fixo.put(label37,1095, 140)
        fixo.put(label38,1095, 80)
        fixo.put(label39,1095, 200)
        
        #RESULTADOS PERSONALIZADO
        #fixo.put(label22,1170, 80)
        #fixo.put(label23,1170, 110)
        fixo.put(label24,1170, 170)
        fixo.put(label25,1170, 110)
        fixo.put(label26,1170, 140)
        fixo.put(label27,1170, 80)
        fixo.put(label28,1170, 200)
        
        fixo.put(progressbar,800,560)
        fixo.put(labelprogresso,980,560)
        fixo.put(framegrafo,760, 230)
        
        fixo.put(botaoview,1030,555)     
        
        
        
        fixo.put(botaomuf,760,165)
        fixo.put(botaocc,760,105)
        fixo.put(botaotc,760,135)
        fixo.put(botaoth,760,75)
        fixo.put(botaohuf,760,195)

        self.janela.add(caixa_v1)
        self.janela.show_all()
def main():
    gtk.main()
    return 0

if __name__ == "__main__":
        python()
        main()
