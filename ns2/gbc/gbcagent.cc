/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t; -*- */

#include "gbcagent.h"
#include "gbcproto.cc"
#include "gbcbloom.cc"

#define MAX(x,y) (x > y ? x : y)
#define MIN(x,y) (x < y ? x : y)
#define NOW Scheduler::instance().clock()



GbcAgent::GbcAgent() : Agent(PT_GBC),
		recvMsgs_(0),
		sentMsgs_(0),
		cqueries_(0),
		delay_(0.01),
		jitter_(0.09) {
	tQueueHead_=NULL;
	logtarget=NULL; 
	show=TRUE;
	//bind("mode", &mode);
}

int GbcAgent::command(int argc,const char*const* argv) {

	char dummy;

	//Default parameters
	int size=1000, M=1, query_id, query_elem, res, i;


	//SEARCH command : Used in traffile
	if((!strcmp(argv[1],"gbcsearch") || !strcmp(argv[1],"bcirsearch")  || !strcmp(argv[1],"bcir2search") || !strcmp(argv[1],"floodsearch")) && argc==6) {
		if(sscanf(argv[2],"%d%c",&query_id,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
			"Format: <query_id> <query_elem> <size> <M> \n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[3],"%d%c",&query_elem,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
			"Format: <query_id> <query_elem> <size> <M> \n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[4],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
			"Format: <query_id> <query_elem> <size> <M> \n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[5],"%d%c",&M,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
			"Format: <query_id> <query_elem> <size> <M> \n");
			return (TCL_ERROR);
		}
	}
	if(!strcmp(argv[1],"gbcsearch")) {
		searchPacket(query_id,size,6,M,query_elem);
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"bcirsearch")) {
		searchPacket(query_id,size,2,M,query_elem);
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"bcir2search")) {
		searchPacket(query_id,size,3,M,query_elem);
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"floodsearch")) {
		searchPacket(query_id,size,1,M,query_elem);
		return (TCL_OK);
	}


	// Set resources in nodes/Agents
	if(!strcmp(argv[1],"resource") && argc==3) {
		if(sscanf(argv[2],"%d%c",&res,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile."
			"Format: gbc_(<node>) resource <resource_id>\n");
			return (TCL_ERROR);
		} else  
		{  //insert head array resources - drop first
		for (i=GBC_MAXR-1; i>0; i--)
			resources_[i]=resources_[i-1];
		resources_[0]=res;
		//strcpy(buffer, "resource");
		//strcat(buffer, buffer2);
		//sprintf(buffer, "%d",res);
		//printf("\n***** %s *******\n",buffer);
		//insertBloom(buffer,1);
		insertBloom(decimal_to_binary(res),1);
		//mostra_bloom(bloomRes);
		log_bloom();
			}
	return (TCL_OK);
	}

	
	// Set delay in nodes/Agents
	if(!strcmp(argv[1],"delay") && argc==3) {
		if(sscanf(argv[2],"%lf%c",&delay_,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile."
			"Format: gbc_(<node>) delay <delay>\n");
			return (TCL_ERROR);
		}
	return (TCL_OK);
	}

	// Set jitter in nodes/Agents
	if(!strcmp(argv[1],"jitter") && argc==3) {
		if(sscanf(argv[2],"%lf%c",&jitter_,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile."
			"Format: gbc_(<node>) jitter <jitter>\n");
			return (TCL_ERROR);
		}
	return (TCL_OK);
	}
		
	
	
	// Results LOG
	if(!strcmp(argv[1],"log-target") && argc==3) {
		logtarget=(Trace*)TclObject::lookup(argv[2]);
		if(!logtarget) {
			fprintf(stderr,"gbcAgent: log target %s not "
					"found\n",argv[2]);
			return (TCL_ERROR);
		}
		return (TCL_OK);
        }
	return Agent::command(argc,argv);
}


void GbcAgent::searchPacket(int query_id, int size, int proto,
				 int M, int query_elem) {
					
	Packet* pkt=createGbcPkt(size);
	hdr_gbc* gbchdr=hdr_gbc::access(pkt);

    //Carregar o cabeçalho das mensagens
    gbchdr->query_id_=query_id; // Identify the query
    gbchdr->size_=size;         // "Real" size of the packet (from a simulation point of view)
    gbchdr->proto_=proto;
	gbchdr->M_=M; 				//Parametro não usado mas sugerido pelo Carlos
	gbchdr->query_elem_=query_elem;
	
	gbchdr->source_=addr();     // Originator of the packet (initiator)
	gbchdr->timesent_=NOW;      // time at the sender of the packet
	gbchdr->nHops_=1;           // First Hop
	gbchdr->msgtype_=1;			// Searching Message
	//printf("*********** Mode %d\n\n",mode);
	
	//printf("searchPacket: Start - Qid:%d Node:%d Qele:%d "
		//		"Proto:%d Size:%d Initial_delay:%lf M:%d"
			//	" \n",query_id,gbchdr->source_,query_elem,proto,size,delay_,M);
		
	if (getpos(query_id)==-1) { //SE EXISTIR ESTA MAL
		queries_[cqueries_].query_initiator=true;		
		queries_[cqueries_].cancel_initiator=false;
		queries_[cqueries_].answer_initiator=false;
		queries_[cqueries_].query_id=query_id;
		queries_[cqueries_].relay_search=true;
		queries_[cqueries_].relay_cancel=false;
		queries_[cqueries_].relay_answer=false;
		queries_[cqueries_].pre_relay_search=true;
		queries_[cqueries_].pre_relay_cancel=false;
		queries_[cqueries_].pre_relay_answer=false;
		queries_[cqueries_].resource_found=false;
		cqueries_++;
		
		bloomcpy(bloomSnt,gbchdr->gradient_);
		send(pkt,0);
	
		//statusNode();
		//Node data memory
		sentMsgs_++;
		//Write to LOG file
		if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
					"-Qid %d -Qel %d -Initiator %d -Proto %d -Nl AGT Search START"
					,NOW,query_id,query_elem,gbchdr->source_,proto);
			logtarget->pt_->dump();
			}
			
	    //Send header to  terminal
		if (show) {showheader('i',pkt);};
	}
	else {
			printf("QueryID Error: Start an Previous Query\n");
			exit(1);
		}
}


void GbcAgent::cancelPacket( Packet* pkt, int noderesource) {
	double waittime;
	hdr_gbc* gbchdrold=hdr_gbc::access(pkt);
	Packet* pktnew=createGbcPkt(gbchdrold->size_);
	hdr_gbc* gbchdrnew=hdr_gbc::access(pktnew);
	copyGbcHdr(gbchdrold,gbchdrnew);

	gbchdrnew->msgtype_=3;			// CANCELLATION PACKET
    	gbchdrnew->timesentCancel_=NOW; 
    	gbchdrnew->noderesource_=noderesource;
	//Node data memory    
	//sentMsgs_++;
	
	//Compute added delay for the fist cancellation transmission
	waittime=calcDelayHop(1,1,1);
	//Cancellation transmission as soon as possible!
	//waittime=0.001;
	
	insertInTQueue(waittime,pktnew);   //send(pkt,0);

	//Send header to terminal
	if (show) {showheader('k',pktnew);};
}

void GbcAgent::answerPacket(Packet* pkt) {
	double waittime;
	hdr_gbc* gbchdrold=hdr_gbc::access(pkt);
	Packet* pktnew=createGbcPkt(gbchdrold->size_);
	hdr_gbc* gbchdrnew=hdr_gbc::access(pktnew);
	copyGbcHdr(gbchdrold,gbchdrnew);

	gbchdrnew->msgtype_=2;			// ANSWER PACKET
    	gbchdrnew->timesentAnswer_=NOW;       // time at the sender of the packet
	//Node data memory
	//sentMsgs_++; Não incrementar aqui!

	
	//Compute added delay for the first answer transmission - DEVERIA SER SO O JITTER
	waittime=calcDelayHop(1,1,1);
	
	insertInTQueue(waittime,pktnew);   //send(pktnew,0);
	
	//Recycle
	//Packet::free(pkt);

	//Send header to terminal
	if (show) {showheader('k',pktnew);};
}


void GbcAgent::recv(Packet* pkt,Handler*) {
        hdr_gbc* gbchdr=hdr_gbc::access(pkt);

	bloomcpy(gbchdr->gradient_,bloomRcv);
	bloomMerge(0.9);

//Select forward protocol - Now is only available GBC
	switch( gbchdr->proto_ ) {
		case 1: return recvflood(pkt);	// FLOOD
		case 2: return recvbcir(pkt);	// BCIR
		case 3: return recvbcir(pkt);	// BCIR*
		//case 4: return recvbers(pkt);	// BERS
		//case 5: return recvbers(pkt);   // BERS*
		case 6: // GBC
			recvgbc(pkt);
			break;
		default :
			fprintf(stderr,"Incorrectly defined searching protocol proto_: %d\n",gbchdr->proto_);
			exit(1);
	}
}

double GbcAgent::calcDelayHop(int proto, double hopcount, int M) {
	
	double fix_delay_min=0;

	double tmp = rng.uniform(0,jitter_);

	//printf("CalcDelayHop: delay_ = %lf tmp = %f\n",delay_,tmp);
	switch(proto) {
		//case 1  : return delay_+tmp; break;//FLOOD Primeira mensagem de cancelamento
		case 1  : return delay_+tmp; break;//FLOOD e mensagem de cancelamento
		case 2  : return (2*(hopcount-1)*delay_)+tmp; break;//BERS and BCIR
		case 3  : return (hopcount-1)*delay_+tmp; break;//BERS* and BCIR*
		case 4  : return (((hopcount/2)+(3/2))*delay_)+tmp; break;//BCIR2
		case 5  : return (((hopcount/4)+(7/4))*delay_)+tmp; break;//BCIR fast
		case 6  : if (hopcount==1)  return delay_+tmp;
				else return (hopcount-1)*delay_+tmp; break;//GBC
//		case 7  : return initial_delay+rng.uniform((jitter*.5),jitter); break;//BCIR - ACK and Cancellation DELAYS
//		case 7  : return 2*((hopcount+1)*initial_delay)+tmp; break;		  //BCIR 2*Dellay no primeiro HOP
		case 7  : return rng.uniform(fix_delay_min,jitter_/10); break; // Speed Cancellation 
		case 8  : return rng.uniform(jitter_,2*jitter_); break; // Prof. Hugo rml  Só poupa as mensagens de ACK.
		//case 9  : return 10*(delay_+tmp); break;//return 10*(delay_+tmp); break;//Delay Tolerant
		//case 9  : return 2*hopcount*(delay_+tmp); break;//return 10*(delay_+tmp); break;//Delay Tolerant

//		case 9  : if (hopcount==1)  return delay_+tmp;
//				else return (2*(hopcount-1)*delay_)+tmp; break;//FBC* 
		case 9  : return MAX(2*(hopcount-1)*delay_+tmp,delay_+tmp); break;//ABC 
		default :
 			fprintf(stderr,"Error calcDelayGbc: %d\n",proto);
                	exit(1);
		}
}

//Not efficient
bool GbcAgent::hasresource(int find) {
int i=0;
bool found=false;

for (i=0; i<GBC_MAXR; i++)
	if (resources_[i]==find)
	    found=true;

return found;	
}


void GbcAgent::showheader(char opt, Packet* pkt) {
        hdr_gbc* gbchdr=hdr_gbc::access(pkt);

if(logtarget) {
	sprintf(logtarget->pt_->buffer(),"%c -t %11.9f "
            "-Qid %d -Qel %d -Node %d -MsgType %d -Proto %d"
            ,opt,NOW,gbchdr->query_id_,gbchdr->query_elem_,addr(),gbchdr->msgtype_,gbchdr->proto_);
    logtarget->pt_->dump();
    }
}

void GbcAgent::insertInTQueue(double time,Packet* pkt) {
	TQueue* newmsg=new TQueue(time,pkt);
	if(!tQueueHead_)
                tQueueHead_=newmsg;
        else {
	 		if(tQueueHead_->expires_>newmsg->expires_) {
	                        newmsg->next_=tQueueHead_;
	                        tQueueHead_=newmsg;
	                }
			else {
				TQueue* iter=tQueueHead_;
				while(iter->next_ && 
					  iter->next_->expires_ < newmsg->expires_)
						iter=iter->next_;
				newmsg->next_=iter->next_;
				iter->next_=newmsg;
			}
		}
	if(tQueueHead_) resched(tQueueHead_->expires_);
	//resched(0);

}


void GbcAgent::expire(Event*) {
		while(tQueueHead_) {
			hdr_gbc* hdrold=hdr_gbc::access(tQueueHead_->origpkt_);
			Packet* rebroad=createGbcPkt(hdrold->size_);
			hdr_gbc* hdrnew=hdr_gbc::access(rebroad);
			copyGbcHdr(hdrold,hdrnew);
						
			if (show) {showheader('z',rebroad);};
			
			if (hdrnew->msgtype_==1)
			{
				queries_[getpos(hdrnew->query_id_)].relay_search=true;
				//Learn route for answer
				hdrnew->cbnodes_++;
                		hdrnew->bnodes_[hdrnew->cbnodes_-1]=addr();
                
				if(logtarget) {
					sprintf(logtarget->pt_->buffer(),"f -t %11.9f -Qid %d "
						//"-Qid %d -Hs %d -Nl AGT -Ii %d -It searchagent "
						"-Hs %d -Nl AGT -Ii %d -It searching expire "
						,NOW,hdrnew->query_id_,addr(),
						hdr_cmn::access(tQueueHead_->origpkt_)->uid());
					logtarget->pt_->dump();
					hdrnew->nHops_++; 	//Only count searching Hops
				}

			}
			if (hdrnew->msgtype_==2)
			{
				queries_[getpos(hdrnew->query_id_)].relay_answer=true;
				hdrnew->bnodes_[hdrnew->cbnodes_]=addr();
				hdrnew->cbnodes_++;
				if(logtarget) {
					sprintf(logtarget->pt_->buffer(),"f -t %11.9f -Qid %d "
						//"-Qid %d -Hs %d -Nl AGT -Ii %d -It searchagent "
						"-Hs %d -Nl AGT -Ii %d -It acknowledgment expire "
						,NOW,hdrnew->query_id_,addr(),
						//hdr_cmn::access(tQueueHead_->origpkt_)->query_id_,
						hdr_cmn::access(tQueueHead_->origpkt_)->uid());
					logtarget->pt_->dump();
				}

			}
			if (hdrnew->msgtype_==3)
			{
				queries_[getpos(hdrnew->query_id_)].relay_cancel=true;
				if(logtarget) {
					sprintf(logtarget->pt_->buffer(),"f -t %11.9f -Qid %d "
						//"-Qid %d -Hs %d -Nl AGT -Ii %d -It searchagent "
						"-Hs %d -Nl AGT -Ii %d -It cancellation expire "
						,NOW,hdrnew->query_id_,addr(),
						//hdr_cmn::access(tQueueHead_->origpkt_)->query_id_,
						hdr_cmn::access(tQueueHead_->origpkt_)->uid());
					logtarget->pt_->dump();
				}
			}
			//statusNode();
			bloomcpy(bloomSnt,hdrnew->gradient_);
			hdrnew->timesent_=NOW;
			//if (addr()==6 || addr()==2) log_gradient(rebroad);
			send(rebroad,0);
			
			sentMsgs_++;
			
			//Recycle
			Packet::free(tQueueHead_->origpkt_);
			
			TQueue* tmp=tQueueHead_;
			tQueueHead_=tQueueHead_->next_;
			delete tmp;

			if(tQueueHead_) resched(tQueueHead_->expires_);
			
			
		}
}


bool GbcAgent::isin(int node, int bnodes[MAXNODES], int cbnodes) {
int i;
   for (i=0; i<cbnodes; i++)
   {
	 if (bnodes[i] == node)
	 {
	    return(TRUE);  /* it was found */
	 }
   }
   return(FALSE);  /* if it was not found */
}

Packet* GbcAgent::createGbcPkt(int size) {
	Packet* pkt=allocpkt();

	hdr_ip::access(pkt)->daddr()=IP_BROADCAST;
	hdr_ip::access(pkt)->dport()=GBC_PORT;
	hdr_cmn::access(pkt)->size()=size;

	return pkt;
}


void GbcAgent::copyGbcHdr(hdr_gbc* src,hdr_gbc* dst) {
	int i;
	
	dst->source_=src->source_;
	dst->query_id_=src->query_id_;
	dst->size_=src->size_;
	dst->timesent_=src->timesent_;
	dst->timesentCancel_=src->timesentCancel_;
	dst->nHops_=src->nHops_;
	dst->cbnodes_=src->cbnodes_;
	for (i=0; i<src->cbnodes_; i++)
		dst->bnodes_[i]=src->bnodes_[i];
	//gbc:
	dst->proto_=src->proto_;
	dst->query_elem_=src->query_elem_;
	dst->noderesource_=src->noderesource_;
	dst->msgtype_=src->msgtype_;
	dst->M_=src->M_;
	bloomcpy(src->gradient_, dst->gradient_);
}

void GbcAgent::statusNode() {
int i=0;
printf("###########\n");
printf("NO: %d\n",addr());
printf("Cqueries: %d\n",cqueries_);
for (i=0; i<cqueries_; i++) {
	if (queries_[i].query_initiator) printf("Iniciador\n"); else
			printf("Nao Iniciador\n");
	if (queries_[i].cancel_initiator) printf("Iniciador do cancelamento \n"); else
			printf("Nao Iniciador de cancelamento\n");	
	if (queries_[i].answer_initiator) printf("Iniciador da resposta FLOOD \n"); else
			printf("Nao Iniciador de resposta FLOOD\n");				
	printf("query_id=%d\n",queries_[i].query_id);
	if (queries_[i].relay_search) printf("Relay Search\n");
	if (queries_[i].relay_cancel) printf("Relay Cancel\n");
	if (queries_[i].relay_answer) printf("Relay Answer\n");				
	}	
}


/*
void GbcAgent::printState(Trace* out) {
	sprintf(out->pt_->buffer(),"-Hs %d -t %g -uid %d -sentMsg %d "
		"-recvb %d",addr(),NOW,
		uid_, sentMsgs_, recvMsgs_);
	out->pt_->dump();
}*/

/*********************************************************************
 *
 * TCL binding stuff 
 *
 *********************************************************************/

int hdr_gbc::offset_;

static class GbcHeaderClass : public PacketHeaderClass {
public:
        GbcHeaderClass() : PacketHeaderClass("PacketHeader/GBC",
					      sizeof(hdr_gbc)) {
                bind_offset(&hdr_gbc::offset_);
        };
} class_GbcHeader;

static class GbcAgentClass : public TclClass {
public:
	GbcAgentClass() : TclClass("Agent/GBC") {};
	TclObject* create(int,const char*const*) {
		return (new GbcAgent);
	}
} class_GbcAgent;
