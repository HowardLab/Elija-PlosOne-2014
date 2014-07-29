// VSYNTH2.cpp : Defines the entry point for the DLL application.
//
/************************( global )****************************/

#include "stdafx.h"
#include "VSYNTH2.h"
#include "VTMain.h"

// main class that supports all processing
VTMain m_vtmain;

BOOL APIENTRY DllMain( HANDLE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
    }
    return TRUE;
}


VSYNTH2_API int VTS_Initialise(int insamprate,int decimation,int vtsizeIn)
{
	return m_vtmain.VTS_Initialise(insamprate,decimation,vtsizeIn);
}

VSYNTH2_API void VTS_Close()
{
	m_vtmain.VTS_Close();
}

VSYNTH2_API int VTS_GetVersion(double *version, double *date)
{
	return m_vtmain.VTS_GetVersion(version, date);
}

VSYNTH2_API void VTS_Reset(int flags)
{
	m_vtmain.VTS_Reset(flags);
}

VSYNTH2_API double VTS_SynthSample(double *aparam,int nparam)
{
	return m_vtmain.VTS_SynthSample(aparam, nparam);
}

VSYNTH2_API int VTS_SynthBlock(double *aparam,int nparam,double *block,int nsample)
{
	return m_vtmain.VTS_SynthBlock(aparam, nparam, block, nsample);
}

VSYNTH2_API double VTS_SynthSampleVoice(double *aparam,int nparam)
{
	return m_vtmain.VTS_SynthSampleVoice(aparam, nparam);
}

VSYNTH2_API int VTS_SynthBlockVoice(double *aparam,int nparam,double *block,int nsample)
{
	return m_vtmain.VTS_SynthBlockVoice(aparam, nparam, block, nsample);
}


// generate short-term analysis
VSYNTH2_API int VTS_AnalyseBlock(double *data, int dataLen, double *aanal)
{
	return m_vtmain.VTS_AnalyseBlock(data, dataLen, aanal);
}

// assumes each sample has its own parameters
// also returns tube area for proprioception computation
VSYNTH2_API int VTS_SynthBlockPP(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt)
{
	return m_vtmain.VTS_SynthBlockPP(aparam, nparam, block, nsample, PP, PPDS, PPframeSize, PPframeCnt);
}

// assumes each sample has its own parameters
// also returns tube area for proprioception computation
VSYNTH2_API int VTS_SynthBlockPPVoice(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt)
{
	return m_vtmain.VTS_SynthBlockPPVoice(aparam, nparam, block, nsample, PP, PPDS, PPframeSize, PPframeCnt);
}


VSYNTH2_API int VTS_AcousticAnalysis(int flags,int size,int lofreq,int hifreq)
{
	return m_vtmain.VTS_AcousticAnalysis(flags, size, lofreq, hifreq);
}

VSYNTH2_API int VTS_SynthAnal(int flags,double *aparam,int nparam,int nsample,double *aanal)
{
		return m_vtmain.VTS_SynthAnal( flags, aparam, nparam, nsample, aanal);
}

VSYNTH2_API int VTS_GetTractShape(double *upperx,double *uppery,double *lowerx,double *lowery)
{		
	return m_vtmain.VTS_GetTractShape(upperx, uppery, lowerx, lowery);
}

VSYNTH2_API int VTS_SetTractShape(double *aparam)
{		
	return m_vtmain.VTS_SetTractShape(aparam);
}