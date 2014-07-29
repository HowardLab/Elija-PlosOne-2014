// Fant.h: interface for the Fant class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_LFMODEL_H__495F3315_917C_432D_A35D_048A9A0BBA99__INCLUDED_)
#define AFX_LFMODEL_H__495F3315_917C_432D_A35D_048A9A0BBA99__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "VoiceSource.h"

class CLFModel : public CVoiceSource
{
public:
	CLFModel();
	CLFModel(double samprate);
	virtual ~CLFModel();

private:
	/* sampling rate */
	double	srate;
	BOOL	m_SetParamsVoice;

	/* glottal cycle parameters */
	double	F0;			/* target F0 in Hz */
	int		T0;			/* duration in samples */
	double	nextP0;		/* next period duration in seconds */
	int		odd;		/* odd/even period */
	double	A0;			/* contact parameter */
	double	nextA0;		/* next contact parameter */
	int		n;			/* position in cycle */

	double	nextVQ;		/* next VQ */
	double	VQ;			/* next VQ */

	double	nextLP;		/* next LP */
	double	LP;			/* next LP */

	/* LF base parameters */
	double	OQ;			/* open quotient 0-1, default 0.6 */
	double	SR;			/* sloperatio 0-1, default 0.1 */
	double	CT;			/* closure time 0-1, default 0.2 */
	double	Vscale;		/* voicing scale factor */
	double	GAbase;		/* base glottal area - unvoiced sounds > 0 */
	double	dGAbase;	/* delta GA base */
	double	DP;			/* diplophonia assymmetry */

	/* LF derived parameters */
	double	te;
	double	mtc;
	double	wa;
	double	a;
	double	rb;
	double	e0,e1;			/* scaling factors for two halves of cycle */

public:
	void Reset();
	BOOL IsAtEndOfCycle();
	void	SetParams(double period, double contact);
	void	SetParamsVoice(double period, double contact, double voiceQuality, double lungPressure);
	double	GlottalArea(void);
	double	GetF0() { return F0; };

private:
	void	CalcParams(void);
	void	CalcParamsVoice(void);
	void	CalcParamsOld(void);
};

#endif
