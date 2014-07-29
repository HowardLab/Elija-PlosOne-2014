// VTract.h: interface for the CVTract class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VTRACT_H__D5CD29CE_D0DC_4167_91B2_4AF675C6889A__INCLUDED_)
#define AFX_VTRACT_H__D5CD29CE_D0DC_4167_91B2_4AF675C6889A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#pragma warning (disable : 4244 4101 4305)

/************************( global )****************************/

/* Number of articulatory parameters */

#define	JAW	1	/* number of jaw parameter */
#define	LIP	2	/* number of intrinsic lip parameters (HT and PR) */
#define	TNG	3	/* number of intrinsic tongue parameters */
#define	LRX	1	/* number of intrinsic larynx parameter (height) */

/* Number of variables (for arrays) */

#define	M4	 31		/* =m1 + m2 + m3, total number of semi-polar grids */
#define	NVRS_LIP  4	/* = nvrs_lip  */
#define	NVRS_TNG 26	/* = nvrs_tng  */
#define	NVRS_LRX  5	/* = nvrs_lrx  */
#define NVRS_WAL 25	/* = nvrs_wal  */
#define NP	 29		/* = np        */

#if !defined(AREA_FUNCTION)
#define AREA_FUNCTION area_function
typedef struct{float A, x;}AREA_FUNCTION;
#endif
typedef	struct{ int x, y;} int2D;
#ifndef TYPE2D
#define TYPE2D
typedef	struct{ float x, y;} float2D;
#endif

class CVTract  
{
public:
	CVTract();
	virtual ~CVTract();

/***************( global variables specified by data file )*************/

	/* Semi-polar specification */
	int		m1, m2, m3;			/* # of grids in the 3 regions          */
	float	dl, omega, theta;	/* grid spacing in cm and degree        */
	int		ix0, iy0;			/* the origin on 4095*4095 TEK space    */
	float	TEKvt, TEKlip;		/* from cm to TEK unit map (points/cm)  */
	float	alph[M4],beta[M4];	/* alpha-beta sagittal-area coefficients */

	/* Lip-tube specification */
	int		nvrs_lip;				/* number of variables            */
	int		jaw_lip;				/* number of jaw variables(0 or 1)*/
	char	flab_lip[JAW+LIP][3];	/* labals for factors (parameters)*/
	float	u_lip[NVRS_LIP];		/* mean values in TEK unit        */
	float	s_lip[NVRS_LIP];		/* standard deviations in TEK unit*/
	float	inci_x, inci_y;			/* mean maxillary incisor position*/
	float	A_lip[NVRS_LIP][JAW+LIP];   /* factor patterns (loadings) */

	/* tongue-contour specification */
	int		nvrs_tng;			/* number of variables            */
	int		jaw_tng;			/* number of jaw variables(0 or 1)*/
	int		iniva_tng;			/* coordinate number of initial point     */
	int		lstva_tng;			/* coorninate number of last point        */
	char	flab_tng[JAW+TNG][3];	/* labals for factors (parameters)*/
	float	u_tng[NVRS_TNG];	/* mean values in TEK unit        */
	float	s_tng[NVRS_TNG];	/* standard deviations in TEK unit*/
	float	A_tng[NVRS_TNG][JAW+TNG];   /* factor patterns (loadings) */

	/* Larynx-tube specification */
	int		nvrs_lrx;			/* number of variables            */
	int		jaw_lrx;			/* number of jaw variables(0 or 1)*/
	int		iniva_lrx;			/* coordinate number of initial point     */
	int		lstva_lrx;			/* coordinate number of last point        */
	char	flab_lrx[JAW+LRX][3];	/* labals for factors (parameters)*/
	float	u_lrx[NVRS_LRX];	/* mean values in TEK unit        */
	float	s_lrx[NVRS_LRX];	/* standard deviations in TEK unit*/
	float	A_lrx[NVRS_LRX][JAW+LRX];   /* factor patterns (loadings) */

	/* Wall-contour specification */
	int		nvrs_wal;			/* number of variables            */
	int		jaw_wal;			/* number of jaw variables(0 or 1)*/
	int		iniva_wal;			/* coordinate number of initial point     */
	int		lstva_wal;			/* coorninate number of last point        */
	float	u_wal[NVRS_WAL];	/* mean values in TEK unit        */

/*************************( global variables )***************************/

	/* Semi-polar coordinate and VT contours */
	float	vp_map;				/* viewport map coef. (cm/point)  */
	float	size_correction;	/* 10% size increase              */
	float	vp_width_cm;		/* viewport height in cm          */
	float2D	igd[M4], egd[M4];	/* Semi-polar coordinate grids    */
	float2D	vtos[M4];			/* vector to semi-polar map       */
	float	inci_lip;			/* (cm) dist. btwn. incisor and upper lip */
	float	inci_lip_vp;		/* inci_lip in viewport unit      */
	float	lip_w, lip_h;		/* lip-tube width and height      */

	/* memories for plotting functions */
	int2D	ivt_pix[NP], evt_pix[NP], lip_pix[21];

public:
	int	np;						/* number of points               */
	float2D	ivt[NP];			/* VT inside contours             */
	float2D	evt[NP];			/* VT exterior contours           */

private:
	void	semi_polar ( void );
	void	convert_scale ( void );
	float	amo (float2D p, float2D q);
public:
	void SetSize(double size);
	void	sagittal_to_area (
		int	*ns,		/* number of sections */
		area_function	*af);	/* af.A = cross-sectional area (cm**2) */
	void	appro_area_function (
		int		ns1,	/* number of sections */
		area_function	*af1,	/* input area function with ns1 sections */
		int		ns2,	/* number of fixed sections */
		area_function	*af2 );	/* output areas function */

	void	lam ( float *pa );		/* a set of JAW+TNG+LIP+LRX */

};

// the single VTract object
extern class CVTract VTract;


#endif // !defined(AFX_VTRACT_H__D5CD29CE_D0DC_4167_91B2_4AF675C6889A__INCLUDED_)
