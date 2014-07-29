// VoiceSource.h: interface for the CVoiceSource class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VOICESOURCE_H__7748217B_7B6D_40F0_A345_B93258210E2D__INCLUDED_)
#define AFX_VOICESOURCE_H__7748217B_7B6D_40F0_A345_B93258210E2D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CVoiceSource  
{
public:
	virtual void SetParams(double period,double contact);
	virtual void SetParamsVoice(double period,double contact,double VQ);
	virtual void Reset();
	virtual BOOL IsAtEndOfCycle();
	virtual double GlottalArea();
	CVoiceSource();
	CVoiceSource(double samprate);
	virtual ~CVoiceSource();

};

#endif // !defined(AFX_VOICESOURCE_H__7748217B_7B6D_40F0_A345_B93258210E2D__INCLUDED_)
