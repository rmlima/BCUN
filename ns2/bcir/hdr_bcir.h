/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t; font-lock-mode:t -*- */

#ifndef _HDR_BCIR_H
#define _HDR_BCIR_H
#define BCIR_MAXNODES 1000

	// ns-2 stuff
struct hdr_bcir {
	static int  offset_;
	inline int& offset() { return offset_;}
	inline static hdr_bcir* access(const Packet* p) {
		return (hdr_bcir*) p->access(offset_);
	};

	// Our stuff

	nsaddr_t  source_;      // Originator of the packet
        int       uid_;         // Unique ID (at the originator)
        int       size_;        // "Real" size of the packet (from a simulation point of view)
	double    timesent_;    // time at the sender of the packet
	int       nHops_;       // number of hops already traveled

	//BCIR
	int proto_;		// 1 - FLOOD , 2 - BERS , 3 - BCIR
	int resource_;
	int msgtype_; 		// 1 - Searching , 2 - Answer , 3 - Cancel
	int bnodes_[BCIR_MAXNODES];
	int cbnodes_;
	int initiator_;
	double initial_delay_;
	double jitter_;
	int M_;
};

// Alterar em:
// vi common/packet.h 
// bugs:ns-2.28$ vi tcl/lib/ns-packet.tcl 
// bugs:ns-2.28$ vi trace/cmu-trace.h
// bugs:ns-2.28$ vi trace/cmu-trace.cc

// void CMUTrace::format_pampa(Packet* pkt,int offset) {
//         hdr_pampa *pampahdr=hdr_pampa::access(pkt);
//         sprintf(pt_->buffer() + offset,"-P pampa -Ps %d -Pi %d -Ps %d "
//                 "-Pt %g -Ph %d",
//                 pampahdr->source_,pampahdr->uid_,pampahdr->size_,
//                 pampahdr->timesent_,pampahdr->nHops_);
// }

#endif
