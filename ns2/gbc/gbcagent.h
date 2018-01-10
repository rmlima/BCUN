/* -*-  Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */
 
#ifndef GBCAGENT_H
#define GBCAGENT_H
//#ifndef __bcir_h__
//#define __bcir_h__

#include <agent.h>
#include <trace.h>
#include <cmu-trace.h>

#include "hdr_gbc.h"
#include <mhash.h>

// for ns-2
#define GBC_PORT 1234

#define GBC_RCVBUFSIZE 500

#define GBC_BYTES_PER_SOURCE 32


class GbcAgent : public Agent, TimerHandler {
public:
	virtual int command(int argc,const char*const* argv);
	virtual void recv(Packet* pkt,Handler* =0);
	virtual void expire(Event*);
	GbcAgent();

private:
	RNG rng;

	// Messages received: only the first copy is accounted
	unsigned      int recvMsgs_;
	// Messages sent
	unsigned      int sentMsgs_;

	//int uid_; //Para remover não estou a usar

	struct QStatus {
		int  query_id;
		bool resource_found;
		bool query_initiator;
		bool cancel_initiator;
		bool answer_initiator;
		bool relay_search;
		bool relay_cancel;
		bool relay_answer;
		bool pre_relay_search;
		bool pre_relay_cancel;
		bool pre_relay_answer;
	};
	
	QStatus queries_[GBC_MAXQ];
	int cqueries_;
	
	int resources_[GBC_MAXR];
	double delay_;
	double jitter_;
	int mode;
	
	//LOG
	bool show;
	void statusNode();
	void showheader(char opt, Packet* pkt);
		
	bool hasresource(int resource);
	double calcDelayHop(int proto, double hop, int M);
	
	int getpos(int query_id);
	bool prevSearch(int query_id);
	bool prevCancel(int query_id);
	bool prevAnswer(int query_id);

	void searchPacket(int query_id, int size, int proto, int M, int resource);
	void cancelPacket(Packet* pkt, int resource);
	void answerPacket(Packet* pkt);

	void recvflood(Packet* pkt);
	void recvbcir(Packet* pkt);
	void recvgbc(Packet* pkt);
	
	bool isin(int node, int bnodes[MAXNODES], int cbnodes);
	

	// Message waiting queue
	struct TQueue {
		double  expires_;
		int     maxLHops_;
		Packet* origpkt_;
		TQueue* next_;

		TQueue(double expires,Packet* pkt) : 
			expires_(expires),
			maxLHops_(hdr_gbc::access(pkt)->nHops_),
			origpkt_(pkt),
			next_(NULL) {};
		~TQueue() {
			Packet::free(origpkt_);
		}
	};

	TQueue* tQueueHead_;
	void insertInTQueue(double waittime,Packet* pkt);


	// Packet utils
	Packet* createGbcPkt(int size);
	void copyGbcHdr(hdr_gbc* src,hdr_gbc* dst);

    unsigned char chave[KEYSIZE];
	//Gradient stuff
	int md5(char *recurso, unsigned char hash[KEYSIZE]);
	int mostra_md5(char *recurso, unsigned char chave[KEYSIZE]);
	void mostra_bloom(float *bloom);
	void insertBloom(char *elem,float p);
	void bloomMerge(float att);
	float bloomSearch(char *elem);
	float bloomSearchRcv(char *elem);
	char *decimal_to_binary(int n);
	void bloomcpy(float *src, float *dst);
	float bloomRes[BLOOM_M];  //Filtro Recursos Próprios
	float bloomRcv[BLOOM_M];  //Gradiente recebido
	float bloomSnt[BLOOM_M]; //Adicao da informação própria ao gradiente existente
	float p,att;
	float min(float i, float j);
	void log_bloom();
	void log_gradient(Packet* pkt);

	// State output
	Trace* logtarget;
	void printState(Trace* out);
};

#endif
