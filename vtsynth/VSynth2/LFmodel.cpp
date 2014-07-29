// LFModel.cpp: implementation of the LFModel class.
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "LFModel.h"
#include "math.h"
#include "stdio.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#ifndef M_PI
#define M_PI		3.14159265358979323846
#endif


// LF parameter mapping table:
//  input= glottal contact parameter -1 .. +1
//  output= settings for LF parameters
struct lf_param_rec {
	double	contact;		/* input contact parameter */
	double	OQ;				/* LF model open quotient */
	double	SR;				/* LF model slope ratio */
	double	CT;				/* LF model close time */
	double	Vscale;			/* scaling parameter for LF output */
	double	GAbase;			/* base glottal area added to LF model */
	double	DP;				/* diplophonia asymmetry */
} 

//#define NEWLFTABLE
#ifdef NEWLFTABLE
lftab[]={
	{ -10.0,  1.0, 0.1, 0.2, 0.0,  0.0, 0.0 },		/* guard value */
	{  -1.0,  1.0, 0.1, 0.2, 0.0,  0.0, 0.0 },		
	{  -0.9,  1.0, 0.1, 0.2, 0.0,  0.05, 0.0 },
	{  -0.75, 0.8, 0.1, 0.2, 0.0,  0.1, 0.0 },		/* -1.0 .. -0.9 = wide open = silent */
	{  -0.5,  0.8, 0.1, 0.2, 0.0,  0.005, 0.001 },	/* -0.9 .. -0.5 = voiceless frication */
	{  -0.33, 0.8, 0.1, 0.2, 0.05, 0.0, 0.005 },		/* -0.5 .. -0.33 = breathy voice */
	{   0.0,  0.6, 0.1, 0.2, 0.05, 0.0, 0.05 },		/* -0.33 .. 0.0 = normal phonation */
	{   0.5,  0.5, 0.1, 0.2, 0.075,0.0, 0.08 },		/*  0.0 ..  1.0 = normal phonation */
	{   1.0,  0.4, 0.1, 0.2, 0.1, 0.0, 0.1 },		/*  0.0 ..  1.0 = normal phonation */
	{  10.0,  0.4, 0.1, 0.2, 0.1, 0.0, 0.1 }		/* guard value */
};
# else
// as used in Motor control paper
lftab[]={
	{ -10.0,  1.0, 0.1, 0.2, 0.0,  0.0, 0.0 },		/* guard value */
	{  -1.0,  1.0, 0.1, 0.2, 0.0,  0.05, 0.0 },
	{  -0.75, 0.8, 0.1, 0.2, 0.0,  0.1, 0.0 },		/* -1.0 .. -0.9 = wide open = silent */
	{  -0.5,  0.8, 0.1, 0.2, 0.0,  0.005, 0.0 },		/* -0.9 .. -0.5 = voiceless frication */
	{  -0.33, 0.8, 0.1, 0.2, 0.05, 0.0, 0.0 },		/* -0.5 .. -0.33 = breathy voice */
	{   0.0,  0.6, 0.1, 0.2, 0.05, 0.0, 0.0 },		/* -0.33 .. 0.0 = normal phonation */
	{   0.5,  0.5, 0.1, 0.2, 0.075,0.0, 0.0 },		/*  0.0 ..  1.0 = normal phonation */
	{   1.0,  0.4, 0.1, 0.2, 0.1, 0.0, 0.1 },		/*  0.0 ..  1.0 = normal phonation */
	{  10.0,  0.4, 0.1, 0.2, 0.1, 0.0, 0.1 }		/* guard value */
};
#endif


#define LFTABSIZE (sizeof(lftab)/sizeof(struct lf_param_rec))


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CLFModel::CLFModel()
{
	srate=24000;
	Reset();
	m_SetParamsVoice=0;

}

CLFModel::CLFModel(double samprate)
{
	srate=samprate;
	Reset();
}

CLFModel::~CLFModel()
{

}

void CLFModel::CalcParams()
{
	// decode 
	if(m_SetParamsVoice)
	{	// 2d control variable
		CalcParamsVoice();
	}
	else
	{
		//1d control variable
		CalcParamsOld();
	}
}

void CLFModel::CalcParamsVoice()
{
	int	i;

	A0 = nextA0;
	VQ = nextVQ;
	LP = nextLP;

	if(nextP0 >0)
	{
		F0 = 1.0/nextP0;
	}
	else
	{
		F0=1000;
	}
	

	T0 = (int)(0.5+nextP0*srate);

	// default parameters
	OQ = 0.6;
	SR = 0.1;
	CT = 0.2;
	DP = 0.0;

	// map A0 (-1..+1) to LF parameters */
	for (i=0;i<LFTABSIZE-1;i++) {
		if ((lftab[i].contact <= A0) && (A0 < lftab[i+1].contact)) {
			double m=(A0-lftab[i].contact)/(lftab[i+1].contact-lftab[i].contact);
			OQ=(1-m)*lftab[i].OQ + m*lftab[i+1].OQ;
			SR=(1-m)*lftab[i].SR + m*lftab[i+1].SR;
			CT=(1-m)*lftab[i].CT + m*lftab[i+1].CT;
			//DP=(1-m)*lftab[i].DP + m*lftab[i+1].DP;
			//Vscale=(1-m)*lftab[i].Vscale + m*lftab[i+1].Vscale;
			double tGAbase=(1-m)*lftab[i].GAbase + m*lftab[i+1].GAbase;
			if (tGAbase != GAbase) {
				if (A0 < -0.5) T0=(int)(srate/100);
				dGAbase=(tGAbase-GAbase)/T0;
			}
			else
				dGAbase=0;

			//if (odd)
			//	T0 = (int)(0.5+(1+DP)*nextP0*srate);
			//else
			//	T0 = (int)(0.5+(1-DP)*nextP0*srate);
			break;
		}
	}



	// map VQ (-1..+1) to LF parameters */
	for (i=0;i<LFTABSIZE-1;i++) {
		if ((lftab[i].contact <= VQ) && (VQ < lftab[i+1].contact)) {
			double m=(VQ-lftab[i].contact)/(lftab[i+1].contact-lftab[i].contact);

			//OQ=(1-m)*lftab[i].OQ + m*lftab[i+1].OQ;
			//SR=(1-m)*lftab[i].SR + m*lftab[i+1].SR;
			//CT=(1-m)*lftab[i].CT + m*lftab[i+1].CT;
			DP=(1-m)*lftab[i].DP + m*lftab[i+1].DP;
			//Vscale=(1-m)*lftab[i].Vscale + m*lftab[i+1].Vscale;
			//double tGAbase=(1-m)*lftab[i].GAbase + m*lftab[i+1].GAbase;
			//if (tGAbase != GAbase) {
			//	if (A0 < -0.5) T0=(int)(srate/100);
			//	dGAbase=(tGAbase-GAbase)/T0;
			//}
			//else
			//	dGAbase=0;
			if (odd)
				T0 = (int)(0.5+(1+DP)*nextP0*srate);
			else
				T0 = (int)(0.5+(1-DP)*nextP0*srate);
			break;
		}
	}


	// map LP (-1..+1) to LF parameters */
	for (i=0;i<LFTABSIZE-1;i++) {
		if ((lftab[i].contact <= LP) && (LP< lftab[i+1].contact)) {
			double m=(LP-lftab[i].contact)/(lftab[i+1].contact-lftab[i].contact);

			//OQ=(1-m)*lftab[i].OQ + m*lftab[i+1].OQ;
			//SR=(1-m)*lftab[i].SR + m*lftab[i+1].SR;
			//CT=(1-m)*lftab[i].CT + m*lftab[i+1].CT;
			//DP=(1-m)*lftab[i].DP + m*lftab[i+1].DP;
			Vscale=(1-m)*lftab[i].Vscale + m*lftab[i+1].Vscale;
			//double tGAbase=(1-m)*lftab[i].GAbase + m*lftab[i+1].GAbase;
			//if (tGAbase != GAbase) {
			//	if (A0 < -0.5) T0=(int)(srate/100);
			//	dGAbase=(tGAbase-GAbase)/T0;
			//}
			//else
			//	dGAbase=0;
			//if (odd)
			//	T0 = (int)(0.5+(1+DP)*nextP0*srate);
			//else
			//	T0 = (int)(0.5+(1-DP)*nextP0*srate);
			//break;
		}
	}


	te=OQ;
	mtc=te-1;
	e0=1;
	wa=M_PI/(te*(1-CT));
	a=-log(-SR*sin(wa*te))/te;
	double inta=e0*((wa/tan(wa*te)-a)/SR+wa)/(a*a+wa*wa);

	double rb0=SR*inta;
	rb=rb0;

	for (i=0;i<4;i++) {
		double kk=1-exp(mtc/rb);
		double err=rb+mtc*(1/kk-1)-rb0;
		double derr=1-((1-kk)*(mtc/rb/kk)*(1-kk)*(mtc/rb/kk));
		rb=rb-err/derr;
	}
	e1=1/(SR*(1-exp(mtc/rb)));

	n  = 0;
}


void CLFModel::CalcParamsOld()
{
	int	i;

	A0 = nextA0;

	if(nextP0 >0)
	{
		F0 = 1.0/nextP0;
	}
	else
	{
		F0=1000;
	}
	

	T0 = (int)(0.5+nextP0*srate);

	// default parameters
	OQ = 0.6;
	SR = 0.1;
	CT = 0.2;
	DP = 0.0;

	// map A0 (-1..+1) to LF parameters */
	for (i=0;i<LFTABSIZE-1;i++) {
		if ((lftab[i].contact <= A0) && (A0 < lftab[i+1].contact)) {
			double m=(A0-lftab[i].contact)/(lftab[i+1].contact-lftab[i].contact);
			OQ=(1-m)*lftab[i].OQ + m*lftab[i+1].OQ;
			SR=(1-m)*lftab[i].SR + m*lftab[i+1].SR;
			CT=(1-m)*lftab[i].CT + m*lftab[i+1].CT;
			DP=(1-m)*lftab[i].DP + m*lftab[i+1].DP;
			Vscale=(1-m)*lftab[i].Vscale + m*lftab[i+1].Vscale;
			double tGAbase=(1-m)*lftab[i].GAbase + m*lftab[i+1].GAbase;
			if (tGAbase != GAbase) {
				if (A0 < -0.5) T0=(int)(srate/100);
				dGAbase=(tGAbase-GAbase)/T0;
			}
			else
				dGAbase=0;
			if (odd)
				T0 = (int)(0.5+(1+DP)*nextP0*srate);
			else
				T0 = (int)(0.5+(1-DP)*nextP0*srate);
			break;
		}
	}

	te=OQ;
	mtc=te-1;
	e0=1;
	wa=M_PI/(te*(1-CT));
	a=-log(-SR*sin(wa*te))/te;
	double inta=e0*((wa/tan(wa*te)-a)/SR+wa)/(a*a+wa*wa);

	double rb0=SR*inta;
	rb=rb0;

	for (i=0;i<4;i++) {
		double kk=1-exp(mtc/rb);
		double err=rb+mtc*(1/kk-1)-rb0;
		double derr=1-((1-kk)*(mtc/rb/kk)*(1-kk)*(mtc/rb/kk));
		rb=rb-err/derr;
	}
	e1=1/(SR*(1-exp(mtc/rb)));

	n  = 0;
}



void CLFModel::SetParams(
	double period,	/* period in seconds */
	double contact	/* contact parameter -1 .. +1 */
)
{
	nextA0 = contact;
	nextP0 = period;
	m_SetParamsVoice=0;
}

void CLFModel::SetParamsVoice(
	double period,			/* period in seconds */
	double contact,			/* contact parameter -1 .. +1 */
	double voiceQuality,	/* voice quality -1 .. +1 */
	double lungPressure		/* lung pressure -1 .. +1 */
)
{
	nextA0 = contact;
	nextP0 = period;
	nextVQ = voiceQuality;
	nextLP = lungPressure;
	m_SetParamsVoice=1;
}


double	CLFModel::GlottalArea()
{
	double	amp;

	/* reset at end of cycle */
	if (n >= T0) {
		odd = 1-odd;
		CalcParams();
	}

	double t=(double)n/T0;
	if (t < te) {
		amp = e0*(exp(a*t)*(a*sin(wa*t)-wa*cos(wa*t))+wa)/(a*a+wa*wa);
	}
	else {
		amp = e1*(exp(mtc/rb)*(t-1-rb)+exp((te-t)/rb)*rb);
	}
	n++;

	GAbase += dGAbase;
	return(GAbase+amp*Vscale);
}

BOOL CLFModel::IsAtEndOfCycle()
{
	return (GAbase > 0) || (n==T0);
}

void CLFModel::Reset()
{
	nextVQ = 0;
	nextA0 = 0;
	nextLP = 0;
	nextP0 = 1.0/150;
	GAbase = 0;
	dGAbase = 0;
	odd=0;
	CalcParams();
}
