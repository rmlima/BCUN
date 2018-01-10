# -*- coding: utf-8 -*-
import networkx as nx
import random as rnd
import simflood
import graficos

def geradorrandom(numnodos, raio, mostrar):
        # Graph generator
        G=nx.random_geometric_graph(numnodos,raio,dim=2)
                        
                        
        #G=nx.balanced_tree(folhas, altura)
        while not nx.is_connected(G):

            G=nx.random_geometric_graph(numnodos,raio)                                
            if mostrar: print "Graph in not full connected - Generate a new one"               
     
        return G
        #END

def geradorerdos(numnodos,prob,mostrar):
    
    G = nx.erdos_renyi_graph(numnodos,prob)

    while not nx.is_connected(G):
        G = nx.erdos_renyi_graph(numnodos,prob)                               
        if mostrar: print "Graph in not full connected - Generate a new one"               
  
    return G

def geradorbarabasi(numnodos,ligacoes,mostrar):
    
    G = nx.barabasi_albert_graph(numnodos,ligacoes)
    
    while not nx.is_connected(G):
        G = nx.barabasi_albert_graph(numnodos,ligacoes)                               
        if mostrar: print "Graph in not full connected - Generate a new one"               
  
    return G

def geradorpath(numnodos,mostrar):
    
    G=nx.path_graph(numnodos)
    
    while not nx.is_connected(G):
        G = nx.path_graph(numnodos)
        if mostrar: print "Graph in not full connected - Generate a new one"
    
    return G

def raiominimo(numnodos):

    raio=2
    resultado=raio
    sentinela=0    
   
    iteracoes=50
    raios=[]
    
    for a in range(1,50):
        while sentinela < iteracoes:
            G=nx.random_geometric_graph(numnodos,raio,dim=2)        
            menorraio=raio                
            while not nx.is_connected(G):

                G=nx.random_geometric_graph(numnodos,raio)
                sentinela+=1
                if sentinela>iteracoes:
                    break        
            raio-=0.01
        raios.append(menorraio)
    raiosoma=0
    for i in range(0,len(raios)-1):
        raiosoma+=raios[i]
    
    resultado=raiosoma/len(raios)
    return resultado

def probminima(numnodos):
    prob=1
    resultado=prob
    sentinela=0
    iteracoes=100
    probabilidades=[]
    
    for a in range(1,100):
        while sentinela < iteracoes:
            G=nx.erdos_renyi_graph(numnodos,prob)        
            menorprob=prob                
            while not nx.is_connected(G):

                G=nx.erdos_renyi_graph(numnodos,prob)
                sentinela+=1
                if sentinela>iteracoes:
                    break        
            prob-=0.01
        probabilidades.append(menorprob)
    probsoma=0
    for i in range(0,len(probabilidades)-1):
        probsoma+=probabilidades[i]
    
    resultado=probsoma/len(probabilidades)
    return resultado