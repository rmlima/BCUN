/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t; -*- */

#include "bciragent.h"
#include "bcirproto.cc"

#define MAX(x,y) (x > y ? x : y)
#define NOW Scheduler::instance().clock()


BcirAgent::BcirAgent() : Agent(PT_BCIR),
			 listMsgs_(0),
 			 listBytes_(0),
			 recvMsgs_(0),
			 recvBytes_(0),
			 recvHops_(0),
			 sentMsgs_(0),
			 sentBytes_(0),
			 sumRecvDelay_(0.0),
			 maxRecvDelay_(0.0),
			 rcvhead_(0),rcvtail_(0),
			 uid_(0),policy(-1) {
	max_jitter=nodelay_retransmit_prob=pwr_retransmit_maxpwr=1.0;
	max_rnd_delay=pwr_mul_factor=-1.0;
	nmsgs_retransm_maxcnt=delpwr_retransm_maxcnt=0xFFFF;
	tQueueHead_=NULL;
	logtarget=NULL;
	show=TRUE;
	relay_search_=FALSE;
	relay_answer_=FALSE;
	relay_cancel_=FALSE;
	hasresource_=FALSE;
	bzero(recvdmsgs_,BCIR_MAXNODES*BCIR_BYTES_PER_SOURCE);
}

int BcirAgent::command(int argc,const char*const* argv) {
	/* <proto> <size>  
	if(!(strcmp(argv[1],"flood")  strcmp(argv[1],"bers") || strcmp(argv[1],"bcir")) && argc==3) {
		int size;
		char dummy;
		if(sscanf(argv[2],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size>\n");
			return (TCL_ERROR);
		}
//              fprintf(stderr,"Argumentos Size = %d Dummy =%cmmm",size,dummy);
		if (!strcmp(argv[1],"flood")) searchPacket(size,1);
		if (!strcmp(argv[1],"bers")) searchPacket(size,2);
		if (!strcmp(argv[1],"bcir")) searchPacket(size,3);
		return (TCL_OK);
	}
	else
	{
		fprintf(stderr,"BcirAgent: Traffile with unknown "
				"command: %s\n",argv[1]);
		return (TCL_ERROR);
	}*/

/* mmmm  */

		//Default parameters
		int size=1000, M=1;
		double delay=1, jitter=.1;

	        if(!strcmp(argv[1],"flood") && argc==5) {

		char dummy;
		policy=PROP_POLICY_PWR;
		if(sscanf(argv[2],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[3],"%lf%c",&delay,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[4],"%lf%c",&jitter,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		searchPacket(size,1,delay,jitter,1);
                return (TCL_OK);
	}
        if(!strcmp(argv[1],"bers") && argc==5) {

		char dummy;
		policy=PROP_POLICY_PWR;
		if(sscanf(argv[2],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[3],"%lf%c",&delay,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[4],"%lf%c",&jitter,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter>\n");
			return (TCL_ERROR);
		}
		searchPacket(size,2,delay,jitter,1);
                return (TCL_OK);
        }
        if(!strcmp(argv[1],"bcir") && argc==6) {

		char dummy;
		policy=PROP_POLICY_PWR;
		if(sscanf(argv[2],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter> <M>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[3],"%lf%c",&delay,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter> <M>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[4],"%lf%c",&jitter,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter> <M>\n");
			return (TCL_ERROR);
		}
		if(sscanf(argv[5],"%d%c",&M,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay> <jitter> <M>\n");
			return (TCL_ERROR);
		}
		searchPacket(size,4,delay,jitter,M);
                return (TCL_OK);
        }
        if(!strcmp(argv[1],"bcir2") && argc==4) {

		char dummy;
		policy=PROP_POLICY_PWR;
		if(sscanf(argv[2],"%d%lf%c",&size,&delay,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in traffile. "
				"Format: <proto> <size> <delay>\n");
			return (TCL_ERROR);
		}
		searchPacket(size,5,delay,jitter,1);
                return (TCL_OK);
        }

	/* set resources */
	if(!strcmp(argv[1],"resource") && argc==2) {
		hasresource_=TRUE;
		return (TCL_OK);
	}


	/* set up the policy */
	if(!strcmp(argv[1],"policy-nodelay") && argc==3) {
		policy=PROP_POLICY_PROB;
		char c;
		if(sscanf(argv[2],"%lf %lf%c",
			  &max_jitter,&nodelay_retransmit_prob,&c)!=2) {
			fprintf(stderr,"Wrong arguments in policy-nodelay");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-pwr") && argc==3) {
		policy=PROP_POLICY_PWR;
		char c;
		if(sscanf(argv[2],"%lf %lf%c",
			  &max_rnd_delay,&pwr_retransmit_maxpwr,&c)!=2) {
			fprintf(stderr,
				"Wrong arguments in policy-pwr");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-nmsgs") && argc==3) {
		policy=PROP_POLICY_NMSGS;
		char c;
		if(sscanf(argv[2],"%lf %d%c",&max_rnd_delay,
			  &nmsgs_retransm_maxcnt,&c)!=2) {
			fprintf(stderr,
				"Wrong arguments in policy-nmsgs");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-delpwr") && argc==3) {
		policy=PROP_POLICY_DELPWR;
		char c;
		if(sscanf(argv[2],"%lf %d %c",
			  &pwr_mul_factor,&delpwr_retransm_maxcnt,&c)!=2) {
			fprintf(stderr,
				"Wrong arguments in policy-delpwr");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-bdelpwr") && argc==3) {
		policy=PROP_POLICY_BDELPWR;
		char c;
		if(sscanf(argv[2],"%lf %d %lf %lf%c",
			  &pwr_mul_factor,&delpwr_retransm_maxcnt,
			  &max_delay,&max_jitter,&c)!=4) {
			fprintf(stderr,
				"Wrong arguments in policy-bdelpwr");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-hcab") && argc==3) {
		policy=PROP_POLICY_HCOUNT;
		char c;
		if(sscanf(argv[2],"%lf%c",&max_rnd_delay,&c)!=1) {
			fprintf(stderr,
				"Wrong maximum random delay in policy-hcab");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-flood") && argc==3) {
		policy=PROP_POLICY_FLOOD;
		char c;
		if(sscanf(argv[2],"%lf%c",&max_rnd_delay,&c)!=1) {
			fprintf(stderr,
				"Wrong maximum random delay in policy-flood");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-bers") && argc==3) {
		policy=PROP_POLICY_BERS;
		char c;
		if(sscanf(argv[2],"%lf%c",&max_rnd_delay,&c)!=1) {
			fprintf(stderr,
				"Wrong maximum random delay in policy-bers");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"policy-bers2") && argc==3) {
		policy=PROP_POLICY_BERS2;
		char c;
		if(sscanf(argv[2],"%lf%c",&max_rnd_delay,&c)!=1) {
			fprintf(stderr,
				"Wrong maximum random delay in policy-bers2");
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}
	if(!strcmp(argv[1],"log-target") && argc==3) {
		logtarget=(Trace*)TclObject::lookup(argv[2]);
		if(!logtarget) {
			fprintf(stderr,"BcirAgent: log target %s not "
				"found\n",argv[2]);
			return (TCL_ERROR);
		}
		return (TCL_OK);
	}

	if(!strcmp(argv[1],"dump-stats") && argc==3) {
		Trace* out=(Trace*)TclObject::lookup(argv[2]);
		if(!out) {
			fprintf(stderr,"BcirAgent: log target %s not "
				"found for state dumping\n",argv[2]);
			return (TCL_ERROR);
		}
		printState(out);
		return (TCL_OK);
	}

	//if (strcmp(argv[1],"resource") == 0) {
	//	resource_ = TRUE;
        //        return (TCL_OK);
        //}

	return Agent::command(argc,argv);
}

void BcirAgent::searchPacket(int size, int proto, double delay, double jitter, int M) {
	Packet* pkt=createBcirPkt(size);
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

	bcirhdr->msgtype_=1;		// Searching Message


	bcirhdr->source_=addr();      // Originator of the packet
        bcirhdr->uid_=uid_++;         // Unique ID (at the originator)
        bcirhdr->size_=size;          // "Real" size of the packet
	                              // (from a simulation point of view)
	bcirhdr->timesent_=NOW;       // time at the sender of the packet

	bcirhdr->nHops_=1;            // First Hop

	printf("searchPacket: Searching MesgUID=%d: HeaderUID: %d proto: %d size: %d initial_delay: %lf M:%d\n",uid_,bcirhdr->uid_,proto,size,delay,M);

	// Register the packet so that we don't treat it as a new one
	prevRecvd(pkt);

	sentMsgs_++;
	sentBytes_+=size;
	bcirhdr->cbnodes_=0;
	bcirhdr->proto_=proto;
	bcirhdr->initial_delay_=delay;
	bcirhdr->jitter_=jitter;
	bcirhdr->M_=M;
        //bcirhdr->bnodes_[0]=NULL;

        bcirhdr->initiator_=addr();

	printf("Searching - Initiator = %d\n",bcirhdr->initiator_);
	relay_search_=TRUE;
	send(pkt,0);
	if(logtarget) {
                        sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                                "-Res %d -Node %d -Proto %d -Nl AGT Search START"
                                ,NOW,bcirhdr->resource_,addr(),proto);
                        logtarget->pt_->dump();
                        }
	if (show) {showheader('i',pkt);};
}



void BcirAgent::answerPacket(int size, int proto, int bnodes[BCIR_MAXNODES], int cbnodes, double delay, double jitter) {
	int i;
	Packet* pkt=createBcirPkt(size);
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

	bcirhdr->msgtype_=2;		// ANSWER PACKET
	bcirhdr->resource_=addr();	// ANSWER PACKET



	bcirhdr->source_=addr();      // Originator of the packet
        bcirhdr->uid_=uid_++;         // Unique ID (at the originator)
        bcirhdr->size_=size;          // "Real" size of the packet 
	                              // (from a simulation point of view)
	bcirhdr->timesent_=NOW;       // time at the sender of the packet

	bcirhdr->nHops_=1;            // number of hops already traveled


	printf("Answer Message: UID=%d Sent by: NODE=%d\n",uid_,addr());
	// Register the packet so that we don't treat it as a new one
	prevRecvd(pkt);

	sentMsgs_++;
	sentBytes_+=size;
	bcirhdr->proto_=proto;
	bcirhdr->initial_delay_=delay; //No delay to answer
	bcirhdr->jitter_=jitter;

	for (i=0;i<cbnodes;i++)
		bcirhdr->bnodes_[i]=bnodes[i];
	bcirhdr->cbnodes_=cbnodes;
	if (show) {showheader('j',pkt);};
	relay_answer_=TRUE;

        double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
        insertInTQueue(waittime,pkt);
//	send(pkt,0);
}

void BcirAgent::cancelPacket(int size, int proto, int resource, int bnodes[BCIR_MAXNODES], int cbnodes, double delay, double jitter) {
	int i;
	double waittime;
	Packet* pkt=createBcirPkt(size);
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

	bcirhdr->msgtype_=3;		// CANCELLATION PACKET
	bcirhdr->resource_=resource;    // CANCELLATION PACKET

	bcirhdr->source_=addr();      // Originator of the packet
        bcirhdr->uid_=uid_++;         // Unique ID (at the originator)
        bcirhdr->size_=size;          // "Real" size of the packet 
	                              // (from a simulation point of view)
	bcirhdr->timesent_=NOW;       // time at the sender of the packet

	bcirhdr->nHops_=1;            // number of hops already traveled


	// Register the packet so that we don't treat it as a new one
	prevRecvd(pkt);

	sentMsgs_++;
	sentBytes_+=size;
	bcirhdr->proto_=proto;
        bcirhdr->initial_delay_=delay; //FIX delay to answer
        bcirhdr->jitter_=jitter;



	 for (i=0;i<cbnodes;i++)
                bcirhdr->bnodes_[i]=bnodes[i];
        bcirhdr->cbnodes_=cbnodes;

	if (show) {showheader('k',pkt);};
	relay_cancel_=TRUE;

	//if (bcirhdr->proto_==4) waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
	//else waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);

	waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);

	insertInTQueue(waittime,pkt);

//	send(pkt,0);

}


void BcirAgent::recv(Packet* pkt,Handler*) {
        hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

        //printf("3:bcir uid: %d\n",bcirhdr->uid_);
	listMsgs_++;
	listBytes_+=bcirhdr->size_;


	switch( bcirhdr->proto_ ) {
        	case 1: return recvflood(pkt);	// FLOOD
        	case 2: return recvbers(pkt);	// BERS
    //    	case 3: return recvbers(pkt);	// BERS*
        	case 4: return recvbcir(pkt);	// BCIR
		case 5: return recvbcir(pkt);   // BCIR*
        	case 6: return recvbcirRing(pkt); // RING
    		default :
			fprintf(stderr,"Incorrectly defined searching protocol proto_: %d\n",bcirhdr->proto_);
			exit(1);
	}
}


double BcirAgent::calcDelayHop(int proto, double hopcount, double initial_delay, double jitter, int M) {
	fix_delay_min=0.001;

	double tmp = rng.uniform(fix_delay_min,jitter);

	//printf("CalcDelayHop: initial_delay = %lf uniform = %f waittime = %f\n",initial_delay,tmp,2*(hopcount)*initial_delay+tmp);
	switch(proto) {
		case 1  : return initial_delay+tmp; break;//FLOOD
		case 2  : return (2*(hopcount)*initial_delay)+tmp; break;//BERS and BCIR
		case 3  : return (hopcount+1)*initial_delay+tmp; break;//BERS* and BCIR*
		case 4  : return (((hopcount/2)+(3/2))*initial_delay)+tmp; break;//BCIR2
		case 5  : return (((hopcount/4)+(7/4))*initial_delay)+tmp; break;//BCIR fast
		case 6  : if (hopcount==1)  return initial_delay+tmp;
				else return (hopcount-1)*initial_delay+tmp; break;//BCIRn c/ n=1
//		case 7  : return initial_delay+rng.uniform((jitter*.5),jitter); break;//BCIR - ACK and Cancellation DELAYS
//		case 7  : return 2*((hopcount+1)*initial_delay)+tmp; break;		  //BCIR 2*Dellay no primeiro HOP
		case 7  : return rng.uniform(fix_delay_min,jitter/10); break; // Speed Cancellation 
		case 8  : return rng.uniform(jitter,2*jitter); break; // Prof. Hugo rml  Só poupa as mensagens de ACK.

		default :
 			fprintf(stderr,"Error calcDelayBcir: %d\n",proto);
                	exit(1);
		}
	/*switch(policy) {
	//case PROP_POLICY_FLOOD  : return rng.uniform(max_rnd_delay);
	case PROP_POLICY_FLOOD  : return max_rnd_delay;
	case PROP_POLICY_BERS  : return 2*(hopcount+1)*0.05;
	case PROP_POLICY_BERS2  : return hopcount;
	default :
		fprintf(stderr,"Incorrectly defined BCIR policy: %d\n",policy);
		exit(1);
	}*/
}

double BcirAgent::calcDelay(double rxpwr) {
	
//rml: When PAMAP Disable
	policy=PROP_POLICY_PWR;
	max_rnd_delay=0.05;

	switch(policy) {
	case PROP_POLICY_NMSGS  :
	case PROP_POLICY_PWR    :
	case PROP_POLICY_HCOUNT : return rng.uniform(max_rnd_delay);
	case PROP_POLICY_DELPWR : return rxpwr*pwr_mul_factor;
	case PROP_POLICY_PROB   : return rng.uniform(max_jitter);
	case PROP_POLICY_BDELPWR : 
		return rxpwr*pwr_mul_factor <= max_delay ?
			rxpwr*pwr_mul_factor : max_delay+rng.uniform(max_jitter);
	default :
		fprintf(stderr,"Incorrectly defined policy: %d\n",policy);
		exit(1);
	}
}



bool BcirAgent::isin(int node, int bnodes[BCIR_MAXNODES], int cbnodes) {
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

void BcirAgent::showheader(char opt, Packet* pkt) {
        hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
/*
	printf("%c - uid=%d nHops=%d sentMsgs=%d res=%d "
        "msgtype=%d cbnodes=%d nodes={", opt, bcirhdr->uid_,bcirhdr->nHops_, sentMsgs_,
        bcirhdr->resource_, bcirhdr->msgtype_, bcirhdr->cbnodes_);
        for (i=0; i< bcirhdr->cbnodes_; i++)
        	printf("%d,",bcirhdr->bnodes_[i]);
        printf("}\n");
*/
	if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"%c -t %11.9f "
                                "-Node %d -MsgType %d -Proto %d -Res %d"
                                ,opt,NOW,addr(),bcirhdr->msgtype_,bcirhdr->proto_,bcirhdr->resource_);
                        logtarget->pt_->dump();
                        }

}

/*
double BcirAgent::calcDelayPower(double rxpwr) {
	switch(policy) {
	case PROP_POLICY_NMSGS  :
	case PROP_POLICY_PWR    :
	case PROP_POLICY_HCOUNT : return rng.uniform(max_rnd_delay);
	case PROP_POLICY_DELPWR : return rxpwr*pwr_mul_factor;
	case PROP_POLICY_PROB   : return rng.uniform(max_jitter);
	case PROP_POLICY_BDELPWR :
		return rxpwr*pwr_mul_factor <= max_delay ?
			rxpwr*pwr_mul_factor : max_delay+rng.uniform(max_jitter);
	default :
		fprintf(stderr,"Incorrectly defined policy: %d\n",policy);
		exit(1);
	}
}
*/

//void BcirAgent::rmFutureTQueue(double time) {}

void BcirAgent::rmFutureTQueue(double time) {
if (tQueueHead_ != NULL) {
		printf("Nao VAZIA\n");
		TQueue* tmp=tQueueHead_;
		TQueue* tmpnext=tmp->next_;

		if (hdr_bcir::access(tmp->origpkt_)->msgtype_ == 1) {
			tQueueHead_=tmp->next_;
			free(tmp);
printf("BOI2\n");
			return;
		}

		printf("BOI\n");
		while (tmp->next_ != NULL) {
			if(hdr_bcir::access(tmpnext->origpkt_)->msgtype_ == 1) {
				tmp->next_=tmpnext->next_;
				free(tmpnext);
				}
			tmp = tmp->next_;
		}
	}
	else
	{
//	printf("VAZIA\n");
}
		//resched(NOW);
		//resched(0);
}


/*void BcirAgent::rmFutureTQueue(double time) {
		TQueue* tmp=tQueueHead_;
		TQueue* tmp2
		while (tQueueHead_ != NULL) { 			
			tmp2=tmp->next_;
			if (hdr_bcir::access(tmp->origpkt_)->msgtype_ != 3) free(tmp);
		}
		//resched(0);
}*/



/*void BcirAgent::insertInTQueue(double waittime,Packet* pkt) {
	TQueue* newmsg=new TQueue(NOW+waittime,pkt);

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

	if(tQueueHead_)
		resched(tQueueHead_->expires_-NOW);
}*/


void BcirAgent::insertInTQueue(double waittime,Packet* pkt) {
	TQueue* newmsg=new TQueue(NOW+waittime,pkt);
	if(!tQueueHead_ || (hdr_bcir::access(newmsg->origpkt_)->msgtype_ == 3))
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
	if(tQueueHead_)
		resched(tQueueHead_->expires_-NOW);
}


void BcirAgent::updateInTQueue(Packet* pkt) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

	// Search for the record of the packet
	TQueue* iter=tQueueHead_;
	bool found=false;

	while(!found && iter) {
		found =
			(hdr_bcir::access(iter->origpkt_)->source_==bcirhdr->source_) && 
			(hdr_bcir::access(iter->origpkt_)->uid_==bcirhdr->uid_);
		if(!found)
			iter=iter->next_;
	}

	// Update the data if found (i.e. the timer did not expired yet 
	// for this message)
	if(found) {
		iter->maxPwrReplicas_=MAX(iter->maxPwrReplicas_,pkt->txinfo_.RxPr);
		iter->nRetransm_++;
		iter->maxLHops_=MAX(iter->maxLHops_,
				    hdr_bcir::access(pkt)->nHops_);
	}
}

void BcirAgent::expire(Event*) {
	while(tQueueHead_ && tQueueHead_->expires_ <= NOW) {
		if(shouldSend(tQueueHead_)) {
			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"f -t %11.9f "
					"-Hs %d -Nl AGT -Ii %d -It searchagent "
					"r %s",NOW,addr(),
					hdr_cmn::access(tQueueHead_->origpkt_)->uid(),
					justifyFaith(tQueueHead_));
				logtarget->pt_->dump();
			}
			hdr_bcir* hdrold=hdr_bcir::access(tQueueHead_->origpkt_);
			Packet* rebroad=createBcirPkt(hdrold->size_);
			hdr_bcir* hdrnew=hdr_bcir::access(rebroad);
			copyBcirHdr(hdrold,hdrnew);
			hdrnew->nHops_++;

			sentMsgs_++;
			sentBytes_+=hdrold->size_;
			if (hdrnew->msgtype_==1) {
				hdrnew->cbnodes_++;
				hdrnew->bnodes_[hdrnew->cbnodes_-1]=addr();
			}
			if (show) {showheader('z',rebroad);};
			if (hdrnew->msgtype_ == 1) relay_search_=true;
			if (hdrnew->msgtype_ == 3) relay_cancel_=true;
			send(rebroad,0);
		}
		else {
			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"c -t %g "
					"-Hs %d -Nl AGT -Ii %d -It searchagent "
					"r %s",NOW,addr(),
					hdr_cmn::access(tQueueHead_->origpkt_)->uid(),
					justifyFaith(tQueueHead_));
				logtarget->pt_->dump();
			}
		}

		TQueue* tmp=tQueueHead_;
		tQueueHead_=tQueueHead_->next_;
		delete tmp;
	}
	if(tQueueHead_)
		resched(tQueueHead_->expires_-NOW);
}

bool BcirAgent::shouldSend(TQueue* msg) {
	bool send;
/*
	switch(policy) {
	case PROP_POLICY_PROB :
		send=rng.uniform(1.0)<=nodelay_retransmit_prob;
		break;
	case PROP_POLICY_PWR :
		send=msg->maxPwrReplicas_ < pwr_retransmit_maxpwr;
		break;
	case PROP_POLICY_NMSGS :
		send=msg->nRetransm_ < nmsgs_retransm_maxcnt;
		break;
	case PROP_POLICY_DELPWR :
	case PROP_POLICY_BDELPWR :
		send=msg->nRetransm_ < delpwr_retransm_maxcnt;
		break;
	case PROP_POLICY_HCOUNT :
		send=msg->maxLHops_==hdr_bcir::access(msg->origpkt_)->nHops_;
		break;
	case PROP_POLICY_FLOOD :
		send=true;
                break;
	case PROP_POLICY_BERS :
		//send=hdr_bcir::access(msg->origpkt_)->resource_==true;
		send=true;
		break;
	default :
		fprintf(stderr,"Bcir: wrong forwarding policy: %d\n",policy);
		exit(1);
	}*/
	send = TRUE;
	return send;
}
 
Packet* BcirAgent::createBcirPkt(int size) {
	Packet* pkt=allocpkt();

	hdr_ip::access(pkt)->daddr()=IP_BROADCAST;
	hdr_ip::access(pkt)->dport()=BCIR_PORT;
	hdr_cmn::access(pkt)->size()=size;

	return pkt;
}

void BcirAgent::copyBcirHdr(hdr_bcir* src,hdr_bcir* dst) {
	int i;

	dst->source_=src->source_;
	dst->uid_=src->uid_;
	dst->size_=src->size_;
	dst->timesent_=src->timesent_;
	dst->nHops_=src->nHops_;
//BCIR:
	dst->initiator_=src->initiator_;
	dst->resource_=src->resource_;
	dst->msgtype_=src->msgtype_;
	dst->cbnodes_=src->cbnodes_;
	dst->proto_=src->proto_;
	dst->initial_delay_=src->initial_delay_;
	dst->jitter_=src->jitter_;
	dst->M_=src->M_;
	for (i=0; i< src->cbnodes_; i++)
		dst->bnodes_[i]=src->bnodes_[i];
}

// bool PampaAgent::prevRecvd(Packet* pkt) {
// 	hdr_pampa *pampahdr=hdr_pampa::access(pkt);
// 	bool found=false;
//         int last = rcvtail_ < rcvhead_ ? rcvtail_+PAMPA_RCVBUFSIZE : rcvtail_;
// 	int i;
//         for(i=rcvhead_;!found && i<last;i++)
//                 found=(pampahdr->source_==rcvbuf_[i%PAMPA_RCVBUFSIZE].source_) &&
//                         (pampahdr->uid_==rcvbuf_[i%PAMPA_RCVBUFSIZE].uid_);

//         if(!found) {
//                 rcvbuf_[rcvtail_].source_=pampahdr->source_;
//                 rcvbuf_[rcvtail_].uid_=pampahdr->uid_;
//                 rcvtail_=(rcvtail_+1)%PAMPA_RCVBUFSIZE;
//                 if(rcvtail_==rcvhead_)
//                         rcvhead_=(rcvhead_+1)%PAMPA_RCVBUFSIZE;
//         }
// 	return found;
// }

bool BcirAgent::prevRecvd(Packet* pkt) {
	hdr_bcir *bcirhdr=hdr_bcir::access(pkt);

	int elem=bcirhdr->uid_/sizeof(unsigned char);
	unsigned char bit=((unsigned char)1)<<(bcirhdr->uid_%sizeof(unsigned char));
	bool found=*(recvdmsgs_+(BCIR_BYTES_PER_SOURCE*bcirhdr->source_)+elem) & bit;
	*(recvdmsgs_+(BCIR_BYTES_PER_SOURCE*bcirhdr->source_)+elem) |= bit;
	if(!found && logtarget) {
		sprintf(logtarget->pt_->buffer(),"a -t %11.9f "
			"-Hs %d -Nl AGT -Ii %d -It searchagent "
			"-source %d -uid %d",NOW,addr(),
			hdr_cmn::access(pkt)->uid(),
			bcirhdr->source_,bcirhdr->uid_);
		logtarget->pt_->dump();
	}

	return found;
}

const char* BcirAgent::justifyFaith(TQueue* msg) {
	static char text[100];
	/*switch(policy) {
	case PROP_POLICY_PROB : 
		sprintf(text,"prob");
		break;
	case PROP_POLICY_PWR : 
		sprintf(text,"thrsh pwr: %g, max pwr: %g",
			pwr_retransmit_maxpwr,msg->maxPwrReplicas_);
		break;
	case PROP_POLICY_NMSGS :
		sprintf(text,"nmsgs thrsh msgs: %d, list msgs: %d",
			nmsgs_retransm_maxcnt,msg->nRetransm_);
		break;
	case PROP_POLICY_DELPWR : 
	case PROP_POLICY_BDELPWR :
		sprintf(text,"delpwr thrsh msgs: %d, list msgs: %d",
			delpwr_retransm_maxcnt,msg->nRetransm_);
		break;
	case PROP_POLICY_HCOUNT :
		sprintf(text,"shops: %d, lhops: %d",
			hdr_bcir::access(msg->origpkt_)->nHops_,
			msg->maxLHops_);
		break;
	case PROP_POLICY_FLOOD : 
		sprintf(text,"flood");
		break;
        case PROP_POLICY_BERS :
                sprintf(text,"BERS - Resource: %d",
                        hdr_bcir::access(msg->origpkt_)->resource_);
                break;
	default :
		fprintf(stderr,"Wrong policy detected in justifyFaith\n");
		exit(1);
	}*/
	sprintf(text,"JustifyFaith - Resource: %d",
                        hdr_bcir::access(msg->origpkt_)->resource_);
	return text;
}

void BcirAgent::printState(Trace* out) {
	sprintf(out->pt_->buffer(),"-Hs %d -t %g -sent %d -tsentm %d "
		"-tsentb %ld -recvm %d -recvh %d "
		"-listm %d -recvb %ld -listb %ld -sumRecvDelay %g "
		"-maxRecvDelay %g",addr(),NOW,
		uid_, sentMsgs_, sentBytes_, recvMsgs_,recvHops_,listMsgs_,
		recvBytes_,listBytes_,
		sumRecvDelay_,maxRecvDelay_);
	out->pt_->dump();
}

/*********************************************************************
 *
 * TCL binding stuff 
 *
 *********************************************************************/

int hdr_bcir::offset_;

static class BcirHeaderClass : public PacketHeaderClass {
public:
        BcirHeaderClass() : PacketHeaderClass("PacketHeader/BCIR",
//        BcirHeaderClass() : PacketHeaderClass("PacketHeader/Bcir",
					      sizeof(hdr_bcir)) {
                bind_offset(&hdr_bcir::offset_);
        };
} class_BcirHeader;

static class BcirAgentClass : public TclClass {
public:
	BcirAgentClass() : TclClass("Agent/BCIR") {};
//	BcirAgentClass() : TclClass("Agent/BcirAgent") {};
	TclObject* create(int,const char*const*) {
		return (new BcirAgent);
	}
} class_BcirAgent;
