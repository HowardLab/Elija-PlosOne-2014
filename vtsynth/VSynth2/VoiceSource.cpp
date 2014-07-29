// VoiceSource.cpp: implementation of the CVoiceSource class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "VoiceSource.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CVoiceSource::CVoiceSource()
{
}

CVoiceSource::CVoiceSource(double samprate)
{

}

CVoiceSource::~CVoiceSource()
{

}

double CVoiceSource::GlottalArea()
{
	return 0;
}

BOOL CVoiceSource::IsAtEndOfCycle()
{
	return 1;
}

void CVoiceSource::Reset()
{

}

void CVoiceSource::SetParams(double period, double contact)
{

}

void CVoiceSource::SetParamsVoice(double period, double contact, double VQ)
{

}
