/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t; -*- */
#define MAX(x,y) (x > y ? x : y)
#define NOW Scheduler::instance().clock()

void BcirAgent::recvflood(Packet* pkt) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
	hdr_cmn* cmnhdr=hdr_cmn::access(pkt);

	switch( bcirhdr->msgtype_ )
	{
    	case 1: // Searching

	if(hasresource_ && !relay_answer_) {
		bcirhdr->resource_=addr();
		if(logtarget) {
                        sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                        	"-Res %d -Node %d -Proto 1 -Hops %d -Nl AGT FLOOD Resource Found"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        logtarget->pt_->dump();
			}
		answerPacket(bcirhdr->size_,bcirhdr->proto_,bcirhdr->bnodes_,bcirhdr->cbnodes_,bcirhdr->initial_delay_,bcirhdr->jitter_);
		relay_answer_=TRUE;
		// Seen before: update data on the info
                //if(bcirhdr->source_!=addr())
                //	updateInTQueue(pkt);
                //Packet::free(pkt);
	}

	if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && !relay_search_) {
			// New packet. Consider it received and see what to do with it
			recvMsgs_++;
			recvBytes_+=bcirhdr->size_;
			recvHops_+=bcirhdr->nHops_;

			double delay=NOW-bcirhdr->timesent_;
			sumRecvDelay_+=delay;
			maxRecvDelay_=MAX(maxRecvDelay_,delay);

			//double waittime=calcDelay(pkt->txinfo_.RxPr);
			double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
			//printf("OI\n");
			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It FloodSearchF "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        	logtarget->pt_->dump();
				}
			relay_search_=TRUE;
			insertInTQueue(waittime,pkt);
		}
		else {
			// Seen before: update data on the info
			//if(bcirhdr->source_!=addr())
			//	updateInTQueue(pkt);
			Packet::free(pkt);
		}



		break;
    	case 2: // Answer
		if(addr()==bcirhdr->initiator_) {
			if(logtarget) {
                        		sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                                	"-Res %d -Node %d -Proto 1 -Hops %d -Nl AGT FLOOD Resource at Initiator"
					,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        		logtarget->pt_->dump();
				}
			// Seen before: update data on the info
                                //if(bcirhdr->source_!=addr())
                                //        updateInTQueue(pkt);
                                Packet::free(pkt);
			}
		else
		{
	  		if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && isin(addr(),bcirhdr->bnodes_,bcirhdr->cbnodes_) && !relay_answer_) {
				// New packet. Consider it received and see what to do with it
				recvMsgs_++;
				recvBytes_+=bcirhdr->size_;
				recvHops_+=bcirhdr->nHops_;

				double delay=NOW-bcirhdr->timesent_;
				sumRecvDelay_+=delay;
				maxRecvDelay_=MAX(maxRecvDelay_,delay);

				//double waittime=calcDelay(pkt->txinfo_.RxPr);
				//double waittime=0.001; // No waiting time
				double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);

				if(logtarget) {
					sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                		"-Hs %d -Nl AGT -Ii %d -It FloodAnswerF "
                                		"-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        		logtarget->pt_->dump();
				}
				relay_answer_=TRUE;
				insertInTQueue(waittime,pkt);
			}
			else {
				// Seen before: update data on the info
				//if(bcirhdr->source_!=addr())
				//	updateInTQueue(pkt);
				Packet::free(pkt);
			}
		}
		break;

    	default :
		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
		exit(1);
	}

}


void BcirAgent::recvbers(Packet* pkt) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
	hdr_cmn* cmnhdr=hdr_cmn::access(pkt);
	double waittime;

	switch( bcirhdr->msgtype_ )
	{
    	case 1: // Searching

	if(hasresource_ && !relay_answer_) {
		bcirhdr->resource_=addr();
		if(logtarget) {
                        sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                        	"-Res %d -Node %d -Proto 2 -Hops %d -Nl AGT BERS Resource Found"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        logtarget->pt_->dump();
			}
		relay_answer_=TRUE;
		answerPacket(bcirhdr->size_,bcirhdr->proto_,bcirhdr->bnodes_,bcirhdr->cbnodes_,bcirhdr->initial_delay_,bcirhdr->jitter_);

		// Seen before: update data on the info
                //if(bcirhdr->source_!=addr())
                //	updateInTQueue(pkt);
                Packet::free(pkt);
	}
	else
	{
		if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && !relay_search_ ) {
			// New packet. Consider it received and see what to do with it
			recvMsgs_++;
			recvBytes_+=bcirhdr->size_;
			recvHops_+=bcirhdr->nHops_;

			double delay=NOW-bcirhdr->timesent_;
			sumRecvDelay_+=delay;
			maxRecvDelay_=MAX(maxRecvDelay_,delay);

			waittime=calcDelayHop(2, bcirhdr->nHops_, bcirhdr->initial_delay_,bcirhdr->jitter_,1);
//			if (bcirhdr->nHops_==1) waittime=calcDelayHop(7,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,bcirhdr->M_);
//			else
//				waittime=calcDelayHop(2,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,bcirhdr->M_);

			//printf("BERS: %f\n",waittime);
			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        	logtarget->pt_->dump();
				}
			//relay_search_=TRUE;
			insertInTQueue(waittime,pkt);
		}
		else {
			// Seen before: update data on the info
			//if(bcirhdr->source_!=addr())
			//	updateInTQueue(pkt);
			Packet::free(pkt);
		}
	}

	break;
    	case 2: // Answer
    		//if(status()==TIMER_PENDING) cancel();

		if(addr()==bcirhdr->initiator_ && !relay_cancel_) {
			if(logtarget) {
                        		sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                                	"-Res %d -Node %d -Proto 2 -Hops %d -Nl AGT BERS Resource at Initiator"
					,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        		logtarget->pt_->dump();
				}
			// Start Cancellation
			relay_cancel_=TRUE;
			cancelPacket(bcirhdr->size_,bcirhdr->proto_,addr(),bcirhdr->bnodes_,bcirhdr->cbnodes_,bcirhdr->initial_delay_,bcirhdr->jitter_);
			// Seen before: update data on the info
                                //if(bcirhdr->source_!=addr())
                                //        updateInTQueue(pkt);
                                Packet::free(pkt);
			}
		else
		{
	  		if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && isin(addr(),bcirhdr->bnodes_,bcirhdr->cbnodes_) && !relay_answer_) {
				// New packet. Consider it received and see what to do with it
				recvMsgs_++;
				recvBytes_+=bcirhdr->size_;
				recvHops_+=bcirhdr->nHops_;

				double delay=NOW-bcirhdr->timesent_;
				sumRecvDelay_+=delay;
				maxRecvDelay_=MAX(maxRecvDelay_,delay);

				double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
				if(logtarget) {
					sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                		"-Hs %d -Nl AGT -Ii %d -It searchagent "
                                		"-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        		logtarget->pt_->dump();
				}
				relay_answer_=TRUE;
				insertInTQueue(waittime,pkt);
			}
			else {
				// Seen before: update data on the info
				//if(bcirhdr->source_!=addr())
				//	updateInTQueue(pkt);
				Packet::free(pkt);
			}
		}
		break;


    	case 3: // Cancellation BERS
    		if(status()==TIMER_PENDING && !relay_cancel_) cancel();

		if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && relay_search_ && !relay_cancel_) {

		// Remove future searching messages
		//rmFutureTQueue(NOW);
		//if(status()==TIMER_PENDING) cancel();
		//if(bcirhdr->resource_!=addr() && !forward_ && status()==TIMER_PENDING) cancel();

		// New packet. Consider it received and see what to do with it
		recvMsgs_++;
		recvBytes_+=bcirhdr->size_;
		recvHops_+=bcirhdr->nHops_;

		double delay=NOW-bcirhdr->timesent_;
		sumRecvDelay_+=delay;
		maxRecvDelay_=MAX(maxRecvDelay_,delay);

		//double waittime=calcDelay(pkt->txinfo_.RxPr);
		double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);

		if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        logtarget->pt_->dump();
		}
		relay_cancel_=TRUE;
		insertInTQueue(waittime,pkt);
	}
	else {
		// Seen before: update data on the info
		//if(bcirhdr->source_!=addr())
		//	updateInTQueue(pkt);
		Packet::free(pkt);
	}
	break;
    	default :
		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
		exit(1);
	}

}

void BcirAgent::recvbcir(Packet* pkt) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
	hdr_cmn* cmnhdr=hdr_cmn::access(pkt);
	double waittime;

	switch( bcirhdr->msgtype_ )
	{
    	case 1: // Searching BCIR

	if(hasresource_ && !relay_cancel_) {
		bcirhdr->resource_=addr();
		if(logtarget) {
                        sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                        	"-Res %d -Node %d -Proto 3 -Hops %d -Nl AGT BCIR Resource Found"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        logtarget->pt_->dump();
			}
		//answerPacket(bcirhdr->size_,bcirhdr->proto_,bcirhdr->bnodes_,bcirhdr->cbnodes_);
		 relay_cancel_=TRUE;
        	cancelPacket(bcirhdr->size_,bcirhdr->proto_,addr(),bcirhdr->bnodes_,bcirhdr->cbnodes_,bcirhdr->initial_delay_,bcirhdr->jitter_);
		// Seen before: update data on the info
                //if(bcirhdr->source_!=addr())
                //	updateInTQueue(pkt);
                Packet::free(pkt);
	}
	else
	{
		if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && !relay_search_ && !relay_cancel_) {
			// New packet. Consider it received and see what to do with it
			recvMsgs_++;
			recvBytes_+=bcirhdr->size_;
			recvHops_+=bcirhdr->nHops_;

			double delay=NOW-bcirhdr->timesent_;
			sumRecvDelay_+=delay;
			maxRecvDelay_=MAX(maxRecvDelay_,delay);

		//	if (bcirhdr->nHops_==1) waittime=calcDelayHop(7,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,bcirhdr->M_);
		//	else
				waittime=calcDelayHop(1+bcirhdr->M_,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,bcirhdr->M_);

			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g Hop %d",NOW,addr(),cmnhdr->uid(),waittime,bcirhdr->nHops_);
                        	logtarget->pt_->dump();
				}
			//relay_search_=TRUE;
			insertInTQueue(waittime,pkt);
		}
		else {
			// Seen before: update data on the info
			//if(bcirhdr->source_!=addr())
			//	updateInTQueue(pkt);
			Packet::free(pkt);
		}
	}

	break;

    	case 2: // Answer
 		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
                exit(1);
		break;

    	case 3: // Cancellation
		if(status()==TIMER_PENDING && !relay_cancel_) cancel();

        	if (addr()==bcirhdr->initiator_)
			{
			if(logtarget) {
                        	sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                                "-Res %d -Node %d -Proto 3 -Hops %d -Nl AGT BCIR Resource at Initiator"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        	logtarget->pt_->dump();
				}
			}

	//if(bcirhdr->resource_!=addr() && !forward_ && status()==TIMER_PENDING) cancel();
	if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && relay_search_ && !relay_cancel_) {
		//printf("rmF\n");
		//rmFutureTQueue(NOW);
		//if(status()==TIMER_PENDING) cancel();


		// New packet. Consider it received and see what to do with it
		recvMsgs_++;
		recvBytes_+=bcirhdr->size_;
		recvHops_+=bcirhdr->nHops_;

		double delay=NOW-bcirhdr->timesent_;
		sumRecvDelay_+=delay;
		maxRecvDelay_=MAX(maxRecvDelay_,delay);

		double waittime=calcDelayHop(1,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
		//double waittime=calcDelay(pkt->txinfo_.RxPr);
//		double waittime=0;

		if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        logtarget->pt_->dump();
		}
		relay_cancel_=TRUE;
		insertInTQueue(waittime,pkt);

	}
	else {
		Packet::free(pkt);
		}
	break;
    	default :
		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
		exit(1);
	}

}


void BcirAgent::recvbcirRing(Packet* pkt) {
	hdr_bcir* bcirhdr=hdr_bcir::access(pkt);
	hdr_cmn* cmnhdr=hdr_cmn::access(pkt);

	switch( bcirhdr->msgtype_ )
	{
    	case 1: // Searching

	if(hasresource_ && !relay_cancel_) {
		bcirhdr->resource_=addr();
		if(logtarget) {
                        sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                        	"-Res %d -Node %d -Proto 3 -Hops %d -Nl AGT BCIR2 Resource Found"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        logtarget->pt_->dump();
			}
		//answerPacket(bcirhdr->size_,bcirhdr->proto_,bcirhdr->bnodes_,bcirhdr->cbnodes_);
		 relay_cancel_=TRUE;
                  cancelPacket(bcirhdr->size_,bcirhdr->proto_,addr(),bcirhdr->bnodes_,bcirhdr->cbnodes_,bcirhdr->initial_delay_,bcirhdr->jitter_);
		// Seen before: update data on the info
                //if(bcirhdr->source_!=addr())
                //	updateInTQueue(pkt);
                Packet::free(pkt);
	}
	else
	{
		if(bcirhdr->source_!=addr() && !prevRecvd(pkt)) {
			// New packet. Consider it received and see what to do with it
			recvMsgs_++;
			recvBytes_+=bcirhdr->size_;
			recvHops_+=bcirhdr->nHops_;

			double delay=NOW-bcirhdr->timesent_;
			sumRecvDelay_+=delay;
			maxRecvDelay_=MAX(maxRecvDelay_,delay);

			double waittime=calcDelayHop(2,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);
			//double waittime=calcDelayHop(3, bcirhdr->nHops_);

			if(logtarget) {
				sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        	logtarget->pt_->dump();
				}
			insertInTQueue(waittime,pkt);
		}
		else {
			// Seen before: update data on the info
			//if(bcirhdr->source_!=addr())
			//	updateInTQueue(pkt);
			Packet::free(pkt);
		}
	}
		break;

    	case 2: // Answer
 		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
                exit(1);
		break;

    	case 3: // Cancellation
	if(addr()==bcirhdr->initiator_) {
		if(logtarget) {
                        	sprintf(logtarget->pt_->buffer(),"e -t %11.9f "
                                "-Res %d -Node %d -Proto 3 -Hops %d -Nl AGT BCIR Resource at Initiator"
				,NOW,bcirhdr->resource_,addr(),bcirhdr->nHops_);
                        	logtarget->pt_->dump();
		}
	}
	// Remove future searching messages
	if(status()==TIMER_PENDING) cancel();
	//if(bcirhdr->resource_!=addr() && !forward_ && status()==TIMER_PENDING) cancel();
	if(bcirhdr->source_!=addr() && !prevRecvd(pkt) && relay_search_ && !relay_cancel_ ) {
		// New packet. Consider it received and see what to do with it
		recvMsgs_++;
		recvBytes_+=bcirhdr->size_;
		recvHops_+=bcirhdr->nHops_;

		double delay=NOW-bcirhdr->timesent_;
		sumRecvDelay_+=delay;
		maxRecvDelay_=MAX(maxRecvDelay_,delay);

		double waittime=calcDelayHop(3,bcirhdr->nHops_,bcirhdr->initial_delay_,bcirhdr->jitter_,1);

		//double waittime=calcDelay(pkt->txinfo_.RxPr);
//		double waittime=0;

		if(logtarget) {
			sprintf(logtarget->pt_->buffer(),"t -t %11.9f "
                                "-Hs %d -Nl AGT -Ii %d -It searchagent "
                                "-delay %g",NOW,addr(),cmnhdr->uid(),waittime);
                        logtarget->pt_->dump();
		}
		insertInTQueue(waittime,pkt);
	}
	else {
		// Seen before: update data on the info
		//if(bcirhdr->source_!=addr())
		//	updateInTQueue(pkt);


		Packet::free(pkt);

	}
	break;

    	default :
		fprintf(stderr,"Incorrectly defined message type msgtype_: %d\n",bcirhdr->msgtype_);
		exit(1);
	}
}


