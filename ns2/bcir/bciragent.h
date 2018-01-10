/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */
 
#ifndef BCIRAGENT_H
#define BCIRAGENT_H
//#ifndef __bcir_h__
//#define __bcir_h__

#include <agent.h>
#include <trace.h>
#include <cmu-trace.h>

#include "hdr_bcir.h"


// for ns-2
#define BCIR_PORT 1234

#define BCIR_RCVBUFSIZE 500

#define BCIR_BYTES_PER_SOURCE 32

// No resource nodes
//#define BCIR_RESOURCE 0

// The list of policies
#define PROP_POLICY_PROB   2 /* Probabilistic. Delay is jitter only. Active
				with command policy-nodelay. Requires a jitter
				and a probability of forwarding
			     */
#define PROP_POLICY_PWR    3 /* Distance-based [Tseng:02a] scheme. Active 
				with command policy-pwr. Requires a max-delay
				and a power threshold
			     */
#define PROP_POLICY_NMSGS  4 /* Counter-based [Tseng:02a] scheme. Active with
				command policy-nmsgs. Requires a max-delay
				and a number of messages threshold
			     */
#define PROP_POLICY_DELPWR 5 /* Power-aware delay, Active with command
				policy-delpwr. Requires pwr multiplication
				factor and a number of messages threshold
			     */

#define PROP_POLICY_BDELPWR 6 /* Power-aware with bounded delay. Active with
				 command policy-bdelpwr. Requires pwr
				 multiplication factor, number of messages
				 threshold, upper maximum delay and maximum
				 jitter (for maximum delay)
			      */

#define PROP_POLICY_HCOUNT 7  /* HCAB [Huang:06] algorithm. Active with
				 command policy-hcab. Requires a max-delay.
			      */

#define PROP_POLICY_FLOOD 8  /* Pure flood broadcast with fix delay 
			      */
#define PROP_POLICY_BERS 9  /* delay = 2* HOP.
			      */
#define PROP_POLICY_BERS2 10  /* delay = HOP.
			      */



class BcirAgent : public Agent, TimerHandler {
public:
	virtual int command(int argc,const char*const* argv);
	virtual void recv(Packet* pkt,Handler* =0);
	virtual void expire(Event*);
	BcirAgent();

private:
	RNG rng;

	// Stats
	// Messages listened: accounts with all copies
	unsigned      int listMsgs_;
	unsigned long int listBytes_;
	// Messages received: only the first copy is accounted
	unsigned      int recvMsgs_;
	unsigned long int recvBytes_;
	unsigned      int recvHops_;
	// Messages sent
	unsigned      int sentMsgs_;
	unsigned long int sentBytes_;
	// Delay of reception: how long the message took to arrive
	           double sumRecvDelay_;
		   double maxRecvDelay_;

	// The policy in use
	int policy;
	// Config parameters
	// For PROP_POLICY_PROB and PROP_POLICY_BDELPWR
	double max_jitter;
	// For PROP_POLICY_PROB
	double nodelay_retransmit_prob;
	// For PROP_POLICY_PWR
	double pwr_retransmit_maxpwr;
	// For PROP_POLICY_NMSGS
	int    nmsgs_retransm_maxcnt;
	// For PROP_POLICY_PWR, PROP_POLICY_NMSGS and PROP_POLICY_HCOUNT
	double max_rnd_delay; 
	// For PROP_POLICY_DELPWR and PROP_POLICY_BDELPWR
	double pwr_mul_factor;
	int    delpwr_retransm_maxcnt;
	// For PROP_POLICY_BDELPWR
	double max_delay;

//	double hop_delay;


	// BCIR - LOG
	bool show;
	// BCIR
	double fix_delay_min;
	double fix_delay_max;
	bool relay_search_;
	bool relay_cancel_;
	bool relay_answer_;
	bool hasresource_;
	double calcDelayHop(int proto, double hop, double delay, double jitter, int M);
	double calcDelay(double rxpwr);
	void searchPacket(int size, int proto, double delay, double jitter, int M);
	void cancelPacket(int size, int proto, int resource, int bnodes[100], int cbnodes, double delay, double jitter);
	void answerPacket(int size, int proto, int bnodes[100], int cbnodes, double delay, double jitter);
	bool isin(int node, int bnodes[100], int cbnodes);
	void showheader(char opt, Packet* pkt);
	void recvflood(Packet* pkt);
	void recvbers(Packet* pkt);
	void recvbcir(Packet* pkt);
	void recvbcir2(Packet* pkt);
	void recvbcirRing(Packet* pkt);



	// Message waiting queue
	struct TQueue {
		double  expires_;
		double  maxPwrReplicas_;
		int     nRetransm_;
		int     maxLHops_;
		Packet* origpkt_;
		TQueue* next_;

		TQueue(double expires,Packet* pkt) : 
			expires_(expires),
			maxPwrReplicas_(pkt->txinfo_.RxPr),
			nRetransm_(0),origpkt_(pkt),
			maxLHops_(hdr_bcir::access(pkt)->nHops_),
			next_(NULL) {};
		~TQueue() {
			Packet::free(origpkt_);
		}
	};

	TQueue* tQueueHead_;
	void rmFutureTQueue(double waittime);
	void insertInTQueue(double waittime,Packet* pkt);
	void updateInTQueue(Packet* pkt);
	
	// Messages listened circular array
        struct {
                nsaddr_t source_;
                int uid_;
        } rcvbuf_[BCIR_RCVBUFSIZE];
 	int rcvhead_,rcvtail_;

	unsigned char recvdmsgs_[BCIR_MAXNODES*BCIR_BYTES_PER_SOURCE];

	bool prevRecvd(Packet* pkt);

	// Packet utils
	int uid_;
	Packet* createBcirPkt(int size);
	void copyBcirHdr(hdr_bcir* src,hdr_bcir* dst);

	// Methods implementing the different protocols
	//double calcDelayPower(double rxpwr);
	bool shouldSend(TQueue* msg);
	void floodPacket(int size);

	// State output
	Trace* logtarget;
	const char* justifyFaith(TQueue* msg);
	void printState(Trace* out);
};

#endif
