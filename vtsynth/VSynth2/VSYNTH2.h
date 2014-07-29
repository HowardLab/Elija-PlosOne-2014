
// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the VTSYNTH_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// VSYNTH2_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.
#ifdef VSYNTH2_EXPORTS
#define VSYNTH2_API __declspec(dllexport)
#else
#define VSYNTH2_API __declspec(dllimport)
#endif

/////////////////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C"{/* start extern "C" */
#endif
#include "VTdefs.h"

VSYNTH2_API int VTS_GetVersion(double *version, double *date);
VSYNTH2_API int VTS_Initialise(int samprate,int decimation,int vtsize);
VSYNTH2_API void VTS_Close();
VSYNTH2_API void VTS_Reset(int flags);

VSYNTH2_API double VTS_SynthSample(double *aparam,int nparam);
VSYNTH2_API int VTS_SynthBlock(double *aparam,int nparam,double *block,int nsample);
VSYNTH2_API int VTS_SynthBlockPP(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt);

VSYNTH2_API double VTS_SynthSampleVoice(double *aparam,int nparam);
VSYNTH2_API int VTS_SynthBlockVoice(double *aparam,int nparam,double *block,int nsample);
VSYNTH2_API int VTS_SynthBlockPPVoice(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt);

VSYNTH2_API int VTS_AnalyseBlock(double *block,int nsample,double *aanal);
VSYNTH2_API int VTS_AcousticAnalysis(int flags,int size,int lofreq,int hifreq);
VSYNTH2_API int VTS_SynthAnal(int flags,double *aparam,int nparam,int nsample,double *aanal);
VSYNTH2_API int VTS_GetTractShape(double *upperx,double *uppery,double *lowerx,double *lowery);
VSYNTH2_API int VTS_SetTractShape(double *aparam);

//VSYNTH2_API int VTS_Analyse(double *block,int nsample,double *aanal);

#ifdef __cplusplus
} /* end extern "C" */
#endif

/////////////////////////////////////////////////////////////////////////////////////////

