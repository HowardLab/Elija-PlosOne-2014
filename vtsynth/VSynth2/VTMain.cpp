// processing class for vocal tract synthesizer
// Called by VTmail to provide DLL interface

#include "StdAfx.h"
#include "VTMain.h"

// last changed information
#define	VERSIONNUMBER		106
#define VERSIONDATE			624

#define MAX_VTPARAMETERS	12

// global pointer to Maeda class
CMaeda *pMaeda_g;

// interface functions to other parts of VTSynth
int get_constriction_location()
{
	if (pMaeda_g)
	{
		return(pMaeda_g->get_constriction_location());
	}
	else
	{
		return(-1);
	}
}
double get_constriction_noise()
{
	if (pMaeda_g)
	{
		return(pMaeda_g->get_constriction_noise());
	}
	else
	{
		return(0.0);
	}
}

VTMain::VTMain(void)
{
	pMaeda=NULL;
	pMaeda_g=NULL;
	pVoice=NULL;
	m_doreset=0;
	naparam=0;
	m_samprate=24000;
	m_vtsize=0;
}

VTMain::~VTMain(void)
{

}

int VTMain::VTS_GetVersion(double *version, double *date)
{
	*(version)	=	VERSIONNUMBER;
	*(date)		=	VERSIONDATE;
	return(0);
}

int VTMain::VTS_Initialise(int samprate,int decimation,int vtsize)
{
	int		simfreq;
	int		simdecim;

	// use the parameters to set the values
	simfreq = m_samprate*decimation;
	simdecim = decimation;
	m_doreset=1;
	naparam=0;
	m_samprate = samprate;
	m_vtsize = vtsize;

	// create the synthesizer
	if (pMaeda==NULL) {
		pMaeda = new CMaeda(simfreq,simdecim);
		if(pMaeda == NULL){	
			// failed
			return(1);
		}
		pMaeda_g = pMaeda;
	}

	if (pVoice==NULL) {
		pVoice = new CLFModel(m_samprate);
		if(pVoice == NULL){	
			// failed
			return(1);
		}
	}

	switch(vtsize) {
		case VTS_SIZE_FEMALE:
			VTract.SetSize(1.0);
			break;
		case VTS_SIZE_CHILD:
			VTract.SetSize(0.8);
			break;
		default:
			VTract.SetSize(1.1);
			break;
	}

	return(0);
}

void VTMain::VTS_Close()
{
	if (pMaeda!=NULL) delete pMaeda;
	pMaeda=NULL;
	pMaeda_g=NULL;
	if (pVoice!=NULL) delete pVoice;
	pVoice=NULL;
}

void VTMain::VTS_Reset(int flags)
{
	m_doreset=1;
}

double VTMain::VTS_SynthSample(double *aparam,int nparam)
{
	double	samp;
	int		i;
	double	nextA0;
	double	nextF0;
	int		nvt;
	static	area_function	vtube[50];
	double	A0=0.0,F0=150;
	int	s;
	float	vtpars[MAX_VTPARAMETERS];

	// scale normalized Matlab parameters range of +-1
	// to internal Maeda range of +-3
	vtpars[0] = aparam[0]*3;		// JW
	vtpars[1] = aparam[1]*3;		// TP
	vtpars[2] = aparam[2]*3;		// TS
	vtpars[3] = aparam[3]*3;		// TA
	vtpars[4] = aparam[4]*3;		// LA
	vtpars[5] = aparam[5]*3;		// LP
	vtpars[6] = aparam[6]*3;		// LH

	vtpars[7] = aparam[7];		// GA 
	vtpars[8] = aparam[8];		// FX 
	vtpars[9] = aparam[9];		// NA

	// if reset requested
	if (m_doreset) {

		// use old calls
		m_doreset=0;
		pVoice->Reset();
		pMaeda->Reset(0.0,tube,17);
	}

	// now generate output
	VTract.lam(vtpars);
	VTract.sagittal_to_area(&nvt,vtube);
	VTract.appro_area_function(nvt,vtube,17,tube);

	/* generate sample */
	nextA0 = vtpars[7];
	nextF0 =  CalcF0(vtpars[8]);

	F0 = pVoice->GetF0();
	if (pVoice->IsAtEndOfCycle()) {
		A0 = nextA0;
		F0 += 0.05*(nextF0-F0);
	}
	pVoice->SetParams(1.0/F0,A0);
	samp = pMaeda->Synthesize(pVoice->GlottalArea(),tube,17,vtpars[9]);

	return(samp);
}

// synthesise sample
// now with 4 voice parameters
double VTMain::VTS_SynthSampleVoice(double *aparam,int nparam)
{
	double	samp;
	int		i;
	double	nextA0;
	double	nextF0;
	double	nextVQ;
	double	nextLP;
	int		nvt;
	static	area_function	vtube[50];
	double	A0=0.0, F0=150, VQ=0.0, LP=0.0;
	int	s;
	float	vtpars[MAX_VTPARAMETERS];

	// scale normalized Matlab parameters range of +-1
	// to internal Maeda range of +-3
	vtpars[0] = aparam[0]*3;		// JW
	vtpars[1] = aparam[1]*3;		// TP
	vtpars[2] = aparam[2]*3;		// TS
	vtpars[3] = aparam[3]*3;		// TA
	vtpars[4] = aparam[4]*3;		// LA
	vtpars[5] = aparam[5]*3;		// LP
	vtpars[6] = aparam[6]*3;		// LH
	vtpars[7] = aparam[7]*3;		// NA

	vtpars[8] = aparam[8];			// GA
	vtpars[9] = aparam[9];			// FX
	vtpars[10] = aparam[10];		// VQ Voice Quality
	vtpars[11] = aparam[11];		// LP lung pressure

	// if reset requested
	if (m_doreset) {

		// use old calls
		m_doreset=0;
		pVoice->Reset();
		pMaeda->Reset(0.0,tube,17);
	}

	// now generate output
	VTract.lam(vtpars);
	VTract.sagittal_to_area(&nvt,vtube);
	VTract.appro_area_function(nvt,vtube,17,tube);

	/* generate sample */
	nextA0 = vtpars[8];			// GA
	nextF0 = CalcF0(vtpars[9]); // Fx
	nextVQ = vtpars[10];		// VQ
	nextLP = vtpars[11];		// LP

	F0 = pVoice->GetF0();
	if (pVoice->IsAtEndOfCycle()) {
		A0 = nextA0;
		VQ = nextVQ;
		LP = nextLP;
		F0 += 0.05*(nextF0-F0);
	}
	pVoice->SetParamsVoice(1.0/F0,A0,VQ,LP);
	samp = pMaeda->Synthesize(pVoice->GlottalArea(),tube,17,vtpars[7]);

	return(samp);
}




double VTMain::CalcF0(double param)
{
	double F0;

	switch (m_vtsize) {
	case VTS_SIZE_FEMALE:
		F0 = 230 + 23*param;
		break;
	case VTS_SIZE_CHILD:
		F0 = 270 + 27*param;
		break;
	case VTS_SIZE_MALE:
	default:
		F0 = 140 + 17*param;
		break;
	}
	return(F0);
}

int VTMain::VTS_AnalyseBlock(double *data, int dataLen, double *aanal)
{
	double	samp;
	double	sum;
	double	sumsq;
	double	en[32];
	int		i,j;
	double	acoeff[2000];
	double	amax,zp,aval;
	int		imax;
	double	epsilon = 1e-5;

	int		windowsize=m_samprate/25;
	int		stepsize=m_samprate/100;
	int		offset;
	int		fcount=0;
	double	block[2000];
	FILTER	*lpfilt;

	/* normalise whole block */
	if (donormalise) normalise(data,dataLen);

	/* clear filters once only */
	for (i=0;i<nfilt;i++) filter_clear(fbank[i]);

	/* build a low-pass filter */
	lpfilt = filter_design(FILTER_LOW_PASS,4,50.0,0.0,m_samprate);

	/* for each complete frame */
	for (offset=0;(offset+windowsize)<dataLen;offset+=stepsize,fcount++,aanal+=naparam) {

		for (i=0;i<naparam;i++) aanal[i]=0;

		/* filter the signal and get energy */
		for (i=0;i<nfilt;i++) {

			filter_clear(lpfilt);
			for (j=0;j<stepsize;j++) {
				samp = filter_sample(fbank[i],data[offset+j]);
				samp = filter_sample(lpfilt,fabs(samp));
			}

			// catch zero values
			if(samp < epsilon)
			{
				samp = epsilon;
			}
			en[i] = 20*log10(samp);
		}

		/* subtract mean */
		if (domeanenergy >= 0) {
			sum=0;
			for (i=0;i<nfilt;i++) sum += en[i];
			sum /= nfilt;
			for (i=0;i<nfilt;i++) en[i] -= sum;
			aanal[domeanenergy]=sum;
		}

		/* copy energies */
		for (i=0;i<nfilt;i++) aanal[i] = en[i];

		/* do autocorrelation if required */
		if ((dofx >= 0) || (dovdegree >= 0))
			autoc(data+offset,windowsize,acoeff,(int)(m_samprate/800),(int)(m_samprate/25));

		/* do fundamental frequency */
		if (dofx >= 0) {
			/* find peak */
			amax=0.5;
			imax=0;
			for (i=(int)(m_samprate/800);i<(int)(m_samprate/50);i++) {
				aval = acoeff[i] - 0.1*acoeff[(3*i)/2];
				if (aval >= amax) {
					amax = aval;
					imax = i;
				}
			}
			aanal[dofx] = (imax==0) ? 150.0 : m_samprate/imax;
		}

		/* do voicing degree */
		if (dovdegree >= 0) {
			/* find peak */
			amax=0.0;
			for (i=(int)(m_samprate/800);i<(int)(m_samprate/50);i++) {
				if (acoeff[i] >= amax) {
					amax = acoeff[i];
				}
			}

			/* get zero crossing rate */
			zp = (float)(1.0/(1+exp((zeroc(data+offset,windowsize,m_samprate)-1000)/100)));

			aanal[dovdegree] = 10*amax * zp;
		}
	}

	filter_free(lpfilt);

	return (fcount);
}

// param range +-1
int VTMain::VTS_SynthBlock(double *aparam,int nparam,double *block,int nsample)
{
	int	i;
	int	sidx;

	for (i=0;i<nsample;i++)
		block[i] = VTS_SynthSample(aparam,nparam);

	return(0);
}

// param range +-1
int VTMain::VTS_SynthBlockVoice(double *aparam,int nparam,double *block,int nsample)
{
	int	i;
	int	sidx;

	for (i=0;i<nsample;i++)
		block[i] = VTS_SynthSampleVoice(aparam,nparam);

	return(0);
}

// param range +-1
int VTMain::VTS_SynthBlockPP(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt)
{
	int	sidx;
	int fidx;
	int	vidx;
	int	frameCnt;
	int	frameSize;

	// downsample
	frameCnt = (int)(nsample/PPDS);
	frameSize = 17;

	// init
	fidx=0;
	for (sidx=0;sidx < nsample;sidx++){

		// synth sample
		block[sidx] = VTS_SynthSample((aparam + sidx*nparam), nparam);

		// downsample
		if( ((int)sidx/(int)PPDS) * (int)PPDS == sidx){

			// for all elements in tube vector
			for(vidx=0; vidx < frameSize; vidx++){
				*(PP + vidx + fidx * frameSize) =  tube[vidx].A;
			}
			fidx++;
		}
	}

	*PPframeSize = frameSize;
	*PPframeCnt = fidx;

	return(0);
}


// param range +-1
int VTMain::VTS_SynthBlockPPVoice(double *aparam,int nparam,double *block,int nsample, double *PP, double PPDS, double *PPframeSize, double *PPframeCnt)
{
	int	sidx;
	int fidx;
	int	vidx;
	int	frameCnt;
	int	frameSize;

	// downsample
	frameCnt = (int)(nsample/PPDS);
	frameSize = 17;

	// init
	fidx=0;
	for (sidx=0;sidx < nsample;sidx++){

		// synth sample
		block[sidx] = VTS_SynthSampleVoice((aparam + sidx*nparam), nparam);

		// downsample
		if( ((int)sidx/(int)PPDS) * (int)PPDS == sidx){

			// for all elements in tube vector
			for(vidx=0; vidx < frameSize; vidx++){
				*(PP + vidx + fidx * frameSize) =  tube[vidx].A;
			}
			fidx++;
		}
	}

	*PPframeSize = frameSize;
	*PPframeCnt = fidx;

	return(0);
}


static double filtfreq[23][3]={
	{      88.4,       99.2,      111.4 },
	{     111.4,      125.0,      140.3 },
	{     140.3,      157.5,      176.8 },
	{     176.8,      198.4,      222.7 },
	{     222.7,      250.0,      280.6 },
	{     280.6,      315.0,      353.6 },
	{     353.6,      396.9,      445.4 },
	{     445.4,      500.0,      561.2 },
	{     561.2,      630.0,      707.1 },
	{     707.1,      793.7,      890.9 },
	{     890.9,     1000.0,     1122.5 },
	{    1122.5,     1259.9,     1414.2 },
	{    1414.2,     1587.4,     1781.8 },
	{    1781.8,     2000.0,     2244.9 },
	{    2244.9,     2519.8,     2828.4 },
	{    2828.4,     3174.8,     3563.6 },
	{    3563.6,     4000.0,     4489.8 },
	{    4489.8,     5039.7,     5656.9 },
	{    5656.9,     6349.6,     7127.2 },
	{    7127.2,     8000.0,     8979.7 },
	{    8979.7,    10079.4,    11313.7 },
	{   11313.7,    12699.2,    14254.4 },
	{   14254.4,    16000.0,    17959.4 },
};

static double vocfreq[26][3]={
	{   60, 120, 180 },
	{  180, 240, 300 },
	{  300, 360, 420 },
	{  420, 480, 541 },
	{  541, 604, 667 },
	{  667, 731, 795 },
	{  795, 862, 928 },
	{  928, 995,1066 },
	{ 1066,1139,1213 },
	{ 1213,1290,1367 },
	{ 1367,1449,1532 },
	{ 1532,1620,1708 },
	{ 1708,1802,1896 },
	{ 1896,1996,2097 },
	{ 2097,2206,2316 },
	{ 2316,2434,2552 },
	{ 2552,2691,2831 },
	{ 2831,2992,3153 },
	{ 3153,3354,3555 },
	{ 3555,3824,4093 },
	{ 4093,4362,4632 },
	{ 4632,4988,5344 },
	{ 5344,5775,6207 },
	{ 6207,6714,7221 },
	{ 7221,7728,8235 },
	{ 8235,8742,9249 }
};


int VTMain::VTS_AcousticAnalysis(int flags,int size,int lofreq,int hifreq)
{
	int	i,isize=size;
	int	lo,hi;
	FILE	*op;
	double	f,g;
	double	(*fptr)[3];

	// test hardcode flags
	// flags = VTS_THIRDOCTAVE|VTS_MEANENERGY|VTS_FX|VTS_VDEGREE|VTS_PRINT;

	naparam=size;

	i=0;
	if (flags & VTS_FX) isize--;
	if (flags & VTS_VDEGREE) isize--;
	if (flags & VTS_MEANENERGY) isize--;
	if (isize <= 0) return(1);

	fbank=(FILTER **)calloc(isize,sizeof(FILTER *));

	lo=0;
	if (flags & VTS_VOCODER) {
		fptr = vocfreq;
		hi=25;
	}
	else {
		fptr = filtfreq;
		hi=22;
	}

	while ((lo<hi) && (fptr[lo][0] < lofreq)) lo++;
	while ((hi>lo) && ((fptr[hi][2] > hifreq) || (fptr[hi][1] > 0.44*m_samprate))) hi--;

	nfilt=0;
	for (i=0;(lo+i<=hi)&&(isize > 0);i++) {
		fbank[i] = filter_design(FILTER_BAND_PASS,8,fptr[lo+i][0],fptr[lo+i][2],m_samprate);
		if (fbank[i]==NULL) {
			fprintf(stderr,"Failed to build filter from %g to %g at %g\n",fptr[lo+i][0],fptr[lo+i][2],m_samprate);
			getchar();
			exit(1);
		}

		nfilt++;
		isize--;
	}

	dofx = dovdegree = domeanenergy = -1;
	if (flags & VTS_MEANENERGY) domeanenergy = i++;
	if (flags & VTS_FX) dofx = i++;
	if (flags & VTS_VDEGREE) dovdegree = i++;
	if (flags & VTS_NORMALISE) donormalise=1; else donormalise=0;

	if (flags & VTS_PRINT) {
		printf("Acoustic analysis:\n");
		for (i=0;i<nfilt;i++)
			printf("Channel %2d : Filter CF %5dHz\n",i,(int)(fptr[lo+i][1]));
		if (flags & VTS_MEANENERGY) printf("Channel %2d : Mean Energy\n",(i=domeanenergy));
		if (flags & VTS_FX) printf("Channel %2d : Fx\n",(i=dofx));
		if (flags & VTS_VDEGREE) printf("Channel %2d : Voicing Degree\n",(i=dovdegree));
		++i;
		while (i < size) {
			printf("Channel %2d : Unused\n",i++);
		}
	}

	if (flags & VTS_RESPONSE) {
		op=fopen("bpfilt.txt","w");
		if (op) {
			for (f=5;f<0.5*m_samprate;f=f+5) {
				for (i=0;i<nfilt;i++) {
					g=filter_response(fbank[i],f,m_samprate);
					if (g > 1.0E-5)
						fprintf(op,"%g ",20.0*log10(g));
					else
						fprintf(op,"-100 ");
				}
				fprintf(op,"\n");
			}
			fclose(op);
		}
	}

	return(0);
}

// param range +-1
int VTMain::VTS_SynthAnal(int flags,double *aparam,int nparam,int nsample,double *aanal)
{
	double	*block;
	double	samp;
	double	sum;
	double	sumsq;
	double	en[32];
	int		i,j;
	double	acoeff[2000];
	double	amax,zp;
	int		imax;
	double	epsilon = 1e-5;
	int	sidx;

	block = (double *)calloc(nsample,sizeof(double));

	for (i=0;i<nsample;i++)
		block[i] = VTS_SynthSample(aparam,nparam);

	/* normalise */
	if (donormalise) normalise(block,nsample);

	/* filter the signal and get energies */
	for (i=0;i<nfilt;i++) {
		filter_clear(fbank[i]);
		sumsq=0;
		for (j=0;j<nsample;j++) {
			samp = filter_sample(fbank[i],block[j]);
			sumsq += samp * samp;
		}
		// catch zero values
		if(sumsq < epsilon)
		{
				sumsq = epsilon;
		}
		en[i] = 10*log10(sumsq/nsample);
	}

	/* subtract mean */
	if (domeanenergy >= 0) {
		sum=0;
		for (i=0;i<nfilt;i++) sum += en[i];
		sum /= nfilt;
		for (i=0;i<nfilt;i++) en[i] -= sum;
		aanal[domeanenergy] = sum;
	}

	/* copy energies */
	for (i=0;i<nfilt;i++) aanal[i] = en[i];

	/* cheat fundamental frequency */
	if (dofx >= 0) {
		aanal[dofx] = 150 + 90*aparam[8];
	}

	/* do voicing degree */
	if (dovdegree >= 0) {
		/* do autocorrelation */
		autoc(block,nsample,acoeff,(int)(m_samprate/800),(int)(m_samprate/50));

		/* find peak */
		amax=0.0;
		for (i=(int)(m_samprate/800);i<(int)(m_samprate/50);i++) {
			if (acoeff[i] >= amax) {
				amax = acoeff[i];
			}
		}

		/* get zero crossing rate */
		zp = (float)(1.0/(1+exp((zeroc(block,nsample,m_samprate)-1000)/100)));

		aanal[dovdegree] = 10*amax * zp;
	}

	free(block);
	return(0);
}


int VTMain::VTS_GetTractShape(double *upperx,double *uppery,double *lowerx,double *lowery)
{
	int	i;
	for (i=0;i<VTract.np;i++) {
		upperx[i] = VTract.ivt[i].x;
		uppery[i] = VTract.ivt[i].y;
		lowerx[i] = VTract.evt[i].x;
		lowery[i] = VTract.evt[i].y;
	}
	return(VTract.np);
}

int  VTMain::VTS_SetTractShape(double *aparam)
{
	float	vtpars[MAX_VTPARAMETERS];

	// copy input parameters
	for(int i=0; i < 10; i++)
	{
		vtpars[i] = 3 *aparam[i];
	}

	VTract.lam(vtpars);
	return 0;
}

