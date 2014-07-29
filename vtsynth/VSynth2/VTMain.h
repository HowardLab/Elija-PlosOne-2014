#pragma once

#include "VTract.h"
#include "math.h"
#include "stdio.h"
#include "stdlib.h"
#include "LFModel.h"
#include "maeda.h"
#include "VTract.h"
#include "VTdefs.h"

extern "C"{
#include "sigproc.h"
}
#define __STDC__
#include "C:\Program Files\SFS\include\filter.h"


class VTMain
{
public:
	VTMain(void);
	virtual ~VTMain(void);

	// interface functions
	int VTS_GetVersion(double *version, double *date);
	int VTS_Initialise(int samprate,int decimation,int vtsize);
	void VTS_Close();
	void VTS_Reset(int flags);

	double VTS_SynthSample(double *aparam,int nparam);
	int VTS_AnalyseBlock(double *block,int nsample,double *aanal);
	int VTS_SynthBlock(double *aparam,int nparam,double *block,int nsample);
	int VTS_SynthBlockPP( double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt);

	double VTS_SynthSampleVoice(double *aparam,int nparam);
	int VTS_SynthBlockVoice(double *aparam,int nparam,double *block,int nsample);
	int VTS_SynthBlockPPVoice( double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt);

	int VTS_AcousticAnalysis(int flags,int size,int lofreq,int hifreq);
	int	VTS_SynthAnal(int flags,double *aparam,int nparam,int nsample,double *aanal);

	int VTS_GetTractShape(double *upperx,double *uppery,double *lowerx,double *lowery);
	int	VTS_SetTractShape(double *aparam);
private:
	#define SBUFSIZE	1024
	#define NP	 29		/* = np        */

	#if !defined(AREA_FUNCTION)
	#define AREA_FUNCTION area_function
		typedef struct{float A, x;}AREA_FUNCTION;
	#endif


	#ifndef PI
		#define PI      3.141592653589793
	#endif

	double	CalcF0(double param);

	area_function	tube[50];

	// Implementation
	CLFModel *pVoice;
	CMaeda	*pMaeda;

	int	m_samprate;
	int	m_vtsize;

	// analysis
	FILTER	**fbank;
	int		nfilt;
	int		donormalise;
	int		domeanenergy;
	int		dofx;
	int		dovdegree;
	int		naparam;

	// reset
	int		m_doreset;
};
