/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t; -*- */

#include "bciragent.h"

#define MAX(x,y) (x > y ? x : y)
//#define NOW(Scheduler::instance().clock())


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
	bzero(recvdmsgs_,BCIR_MAX_NODES*BCIR_BYTES_PER_SOURCE);
}

int BcirAgent::command(int argc,const char*const* argv) {
	/* bcast <size> */
	if(!strcmp(argv[1],"bcast") && argc==3) {
		int size;
		char dummy;
		if(sscanf(argv[2],"%d%c",&size,&dummy)!=1) {
			fprintf(stderr,"Wrong number of arguments in bcast. "
				"Format: bcast <size>\n");
			return (TCL_ERROR);
		}
//                fprintf(stderr,"Argumentos Size = %d Dummy =%cmmm",size,dummy);

		bcastPacket(size);
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

	return Agent::command(argc,argv);
}

void BcirAgent::bcastPacket(int size) {
	Packet* pkt=createBcirPkt(size);
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);

	bcirhdr->source_=addr();      // Originator of the packet
        bcirhdr->uid_=uid_++;         // Unique ID (at the originator)
        bcirhdr->size_=size;          // "Real" size of the packet 
	                              // (from a simulation point of view)
	bcirhdr->timesent_=NOW;       // time at the sender of the packet
	bcirhdr->nHops_=0;            // number of hops already traveled

	printf("0:internal uid: %d\n",uid_);
	printf("1:bcir uid: %d\n",bcirhdr->uid_);
	// Register the packet so that we don't treat it as a new one
	prevRecvd(pkt);

	sentMsgs_++;
	sentBytes_+=size;
        printf("2:bcir uid: %d\n",bcirhdr->uid_);
	send(pkt,0);
}

void BcirAgent::recv(Packet* pkt,Handler*) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
	hdr_cmn* cmnhdr=hdr_cmn::access(pkt);
        printf("3:bcir uid: %d\n",bcirhdr->uid_);
	listMsgs_++;
	listBytes_+=bcirhdr->size_;

	if(bcirhdr->source_!=addr() && !prevRecvd(pkt)) {
		// New packet. Consider it received and see what to do with it
		recvMsgs_++;
		recvBytes_+=bcirhdr->size_;
		recvHops_+=bcirhdr->nHops_;

		double delay=NOW-bcirhdr->timesent_;
		sumRecvDelay_+=delay;
		maxRecvDelay_=MAX(maxRecvDelay_,delay);

//		double waittime=calcDelay(pkt->txinfo_.RxPr);
		double waittime=calcDelayBcir(bcirhdr->nHops_);

		if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"t -t %g "
                                "-Hs %d -Nl AGT -Ii %d -It bciragent "
                                "w %g",NOW,addr(),cmnhdr->uid(),waittime);
                        logtarget->pt_->dump();
		}
		insertInTQueue(waittime,pkt);
	}
	else {
		// Seen before: update data on the info
		if(bcirhdr->source_!=addr())
			updateInTQueue(pkt);
		Packet::free(pkt);
	}
}


double BcirAgent::calcDelayBcir(double hopcount) {
	switch(policy) {
	//case PROP_POLICY_FLOOD  : return rng.uniform(max_rnd_delay);
	case PROP_POLICY_FLOOD  : return max_rnd_delay;
	case PROP_POLICY_BERS  : return 2*hopcount;
	case PROP_POLICY_BERS2  : return hopcount;
	default :
		fprintf(stderr,"Incorrectly defined BCIR policy: %d\n",policy);
		exit(1);
	}
}

double BcirAgent::calcDelay(double rxpwr) {
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

void BcirAgent::insertInTQueue(double waittime,Packet* pkt) {
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
				sprintf(logtarget->pt_->buffer(),"f -t %g "
					"-Hs %d -Nl AGT -Ii %d -It bciragent "
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

			send(rebroad,0);
		}
		else {
			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"d -t %g "
					"-Hs %d -Nl AGT -Ii %d -It bciragent "
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
	default :
		fprintf(stderr,"Bcir: wrong forwarding policy: %d\n",policy);
		exit(1);
	}
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
	dst->source_=src->source_;
	dst->uid_=src->uid_;
	dst->size_=src->size_;
	dst->timesent_=src->timesent_;
	dst->nHops_=src->nHops_;
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
		sprintf(logtarget->pt_->buffer(),"a -t %g "
			"-Hs %d -Nl AGT -Ii %d -It bciragent "
			"-source %d -uid %d",NOW,addr(),
			hdr_cmn::access(pkt)->uid(),
			bcirhdr->source_,bcirhdr->uid_);
		logtarget->pt_->dump();
	}

	return found;
}

const char* BcirAgent::justifyFaith(TQueue* msg) {
	static char text[100];
	switch(policy) {
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
	default :
		fprintf(stderr,"Wrong policy detected in justifyFaith\n");
		exit(1);
	}
	return text;
}

void BcirAgent::printState(Trace* out) {
	sprintf(out->pt_->buffer(),"-Hs %d -t %g -sent %d -tsentm %d "
		"-tsentb %d -recvm %d -recvh %d "
		"-listm %d -recvb %d -listb %d -sumRecvDelay %g "
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
