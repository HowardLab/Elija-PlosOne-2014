// Maeda.h: interface for the Maeda class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MAEDA_H__9B1962DA_79DC_4065_857F_7FF8D248A09F__INCLUDED_)
#define AFX_MAEDA_H__9B1962DA_79DC_4065_857F_7FF8D248A09F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/******
*	File :	vtsimul.h
*	Note :	An include file for acoustic simulation of the vocal
*		tract and articulatory model, to be included in a simulation
*		library.
******/

/*******************( Macros : option parameter values )******************/
#pragma warning (disable : 4244 4101 4305)

#define	OFF		0
#define	ON		1

#define AREA_MIN	0.001	/* minimum cross_sectional area cm**2 */

#define	TRACHEA		0	/* tract (VT section) correpondence */
#define	GLOTTIS		1
#define	PHARYNX		2
#define	MOUTH		3
#define	NOSE		4	/* fixed nasal tract	*/
#define	VOCAL_TRACT	5	/* PHARYNX + MOUTH = 5	*/
#define	N_PORT		6	/* nasal coupling section */

#define	RIGID		0	/* wall type		*/
#define	YIELDING	1
#define	FLOW		0	/* source type		*/
#define	PRESSURE	1
#define CLOSE		0	/* glottal condition	*/
#define OPEN		1
#define	SHORT_CIRCUIT	0	/* radiation load type	*/
#define RL_CIRCUIT	1
#define	BESSEL_FUNCTION	2

#define	TIME_VARYING	1	/* VT time property	*/
#define STATIONARY	0

#define	UNIFORM_TUBE	0	/* VT area function specification type */
#define	FROM_FILE	1
#define T2MODEL		2
#define	P3MODEL		3
#define	ART_MODEL	4

#define	NOISE_SOURCE_LEVEL 2.0e-8;

/***********************( structure definitions )************************/

#if !defined(AREA_FUNCTION)
#define AREA_FUNCTION area_function
typedef struct{float A, x;}AREA_FUNCTION;
#endif

typedef	struct{	
	int		Loc,	/* =0, in phrx+mouth, =1 mouth, =2 nose */
			N;	/* section number, noise source at the exit */
	float	A,	/* cross_sectional area (cm2)		*/
			x;	/* length (cm)				*/
}	constriction;

typedef	struct{ 			/* Uniform acoustic tube	*/
	float	area;		/* cross-sectional area, cm2	*/
	float	length;		/* length, cm			*/
}	Utube_par;

typedef	struct{				/* Two tube model		*/
	float	A1;		/* A1: 1-st section area, cm2	*/
	float	x1;		/* x1: 1-st section length, cm	*/
	float	A2;		/* A2: 2-nd section area, cm2	*/
	float	x2;		/* x2: 2-nd section length, cm	*/
} T2model_par;

typedef	struct{				/* Three parameter model	*/
	float	At;		/* Constriction area, cm2	*/
	int	Xt;		/* Constriction location, cm	*/
	float	Al;		/* Lip opening apperture, cm2	*/
} P3model_par;

typedef struct { 
	double	Rs,	/* series viscous (flow) resistance	*/
	Ls,	/* series inductance (acoustic mass)	*/
	els,	/* voltage source associated with Ls	*/
	Ns,	/* dipole noise pressure sources	*/
	Ca,	/* parallel capacitance (compliance)	*/
	ica,	/* current source associated with Ca	*/
	Ud,	/* parallel flow source du to dA/dt	*/
	Rw,	/* wall mechanical resistance		*/
	Lw,	/* wall mass (inductance)		*/
	elw,	/* voltage source associated with Lw	*/
	Cw,	/* wall compiance			*/
	ecw,	/* voltage source associated with Cw	*/
	Gw;	/* total wall conductance, 1/(Rw+Lw+Cw)	*/
}  td_acoustic_elements;

typedef	struct { 
	double	s,	/* forces (interlaced voltage-current sources)				*/
	w,	/* matrix coefficients			*/
	x,	/* variables (interlaced U and P's)	*/
	S,	/* s after elimination procedure	*/
	W;	/* w after elimination procedure	*/
}  td_linear_equation;

class CMaeda  
{
public:
	CMaeda(int samprate=30000,int decim=3);
	virtual ~CMaeda();

public:
	/************(Global variables which can be passed to main)**************/

	int	nAcc;			/* the main constriction section	*/

	double	Rg_v;		/* viscous resistance at glottis	*/
	double	Rg_k;		/* Bernoulli resistence at glottis	*/
	double	Rc_v;		/* viscous resistance at constriction	*/
	double	Rc_k;		/* Bernoulli resistance at constriction	*/
	double	Udc;		/* a DC air flow in cm3/s		*/
	double	Ug;			/* flow at glottis in cm3/s		*/
	double	Uac;		/* flow at supraglottal constriction	*/


private:
	/******( global constants and variables for functions in this file )*****/

	int	deci;	     /* decimation rate = simfrq/smpfrq */
	double	dt_sim;
	double	K_Bernoulli, K_viscous_glotte, K_viscous_const;
	double	La, Ca, Grad, Srad, Rw, Lw, Cw, Kr;
	double	Ag2, Ac2, rv_sum, rk_sum;    /* flow calculation*/
	double	Rt, Lt, Ct;		     /* tracheal walls  */
	double	Rlungs;		/* (No lung cavity simulated) */
	int	Ng;
	constriction	Ac_pharynx, Ac_mouth;
	constriction	Ac;	/* detected super_glottal constriction	*/

	/* vocal tract : {tracha} + glottis + pharynx + {mouth} */

	/** fixed tracheal tube **/
	int			ntr1;
	td_acoustic_elements	*actr;

	/** glotis (a single section) **/
	int			nglt0, nglt1;
	area_function		afglt[1], dafglt[1];
	td_acoustic_elements	acglt[2];

	/** vocal tract : pharynx + {mouth} **/
	int			nvt0, nvt1;
	area_function		*af, *daf;
	td_acoustic_elements	*ac;

	/** entire vocal tract : {trachea} +glottis + pharyx + {mouth} */
	int			n0, n2, n3, n4, n5;
	td_linear_equation	*eq;

	/** mouth (bucal) tube **/
	int			nbu0, nbu1, nbu3, nbu4, nbu5, nbu6;
	area_function		*afbu, *dafbu;
	td_acoustic_elements	*acbu;
	td_linear_equation	*eqbu;

	/** lip openng **/
	double			Grad_lip, Lrad_lip, iLrad_lip;
	double			U0_lip, U1_lip;

	/** total wall flow **/
	double			U0_wall, U1_wall;

	/* nasal tract */
	/** (fixed part) **/
	int			nna0, nna1;
	area_function		*afna;
	td_acoustic_elements	*acna;

	/** (nasal coupling section) **/
	int			nnc1;
	area_function		*afnc, *dafnc;
	td_acoustic_elements	*acnc;

	/** (entire nasal tract) **/
	int			nnt3, nnt4, nnt5, nnt6;
	td_linear_equation	*eqnt;

	/** nostrils **/
	double			Grad_nos, Lrad_nos, iLrad_nos;
	double			U0_nos, U1_nos;

	/* arrays for noise sources, scale factors and filter memories */
	// float	noiseScale;
	float	inMemGlt[4][3], outMemGlt[4][3], lowMemGlt;
	float	inMemAc[4][3], outMemAc[4][3], lowMemAc;

public:
/****************( Global variables declared in "main" )*****************/

	float	simfrq;		/* simulation frequency in Hz		*/
	float	smpfrq;		/* sampling freq. (simfrq = n*smpfrq)	*/

	float	Psub;		/* subglottal air pressure in cmH2O	*/
	float	lung_vol;	/* lung volume in cm3			*/

	int	ntr;		/* # of tracheal sections		*/
	area_function	aftr[20];	/* area function from lungs to glottis	*/

	float	Ag;		/* grottis area in cm**2		*/
	float	xg;		/* glottis thickness in cm (=0.3 cm)	*/
	float	lg;		/* fold length in cm			*/

	int	nvt;		/* # of vocal tract sections		*/
	area_function	*afvt;	/* AF from glottis to lips (or to nbp)	*/

	int	nbp;	/* (nasal branch point) = # of paryngeal sections*/
	int	nnc;		/* # of coupling sections		*/
	int	nnt;		/* # of fixed nasal tract sections	*/
	area_function	*afnt;	/* fixed AF from left to right(nostrils)*/
	float	sinus_vol;	/* volume of the nasal side cavity (cm3)*/
	float	sinus_apt;	/* aperture of the sinus canal (cm2)	*/
	float	sinus_len;	/* length of the sinus canal (cm)	*/
	int	sinus_pos;	/* sinus position in sections from nbp	*/

	/*( simulation options )*/

	int	subGLTsystem;		/* = OFF or ON			*/
	int	nasal_tract;		/* = OFF or ON			*/
	int	sinus_cavity;		/* = OFF or ON			*/
	int	wall;			/* = YIELDING or RIGID		*/
	int	rad_boundary;		/* = RL_CIRCUIT or SHORT_CIRCUIT*/
	int	wall_radiation;		/* = Off or ON			*/
	int	vocal_tract;		/* = STATIONARY or TIME_VARYING	*/
	int	dynamic_term;		/* = OFF or ON			*/

	int	noise_source;		/* = OFF or ON			*/
	int	noiseSourceLoc;		/* = # of sections downstream	*/
	/*   from Ac.N			*/
	float	noiseAmp;		/* = bound for noise source:
								for glottal noise, -16dB	*/

	/*( an extra heat loss factor in the nasal tract )*/
	float	extra_loss_factor;	/* = normally 50 % */

	float	Anc;		/* area of nasal coupling section in cm2 - NOT USED? */

	/*( physical constants )*/

	float	ro;		/* = 1.14e-3; air density, gm/cm**3	*/
	float	c;		/* = 3.5e+4; sound velocity, cm/s	*/
	float	eta;		/* = 1.4; adiabatic constant		*/
	float	cp;		/* = 0.24; specific heat, cal/gm.degree	*/
	float	lamda;		/* = 5.5e-5; heat conduction, cal/cm.sec.degree */
	float	mu;		/* = 1.86e-4; viscosity coef, dyne.sec/cm**2 */
	float	wall_resi;	/* = 1600.; wall resistance, gm/s/cm2	*/
	float	wall_mass;	/* = 1.5; wall mass per area, gm/cm2	*/
	float	wall_comp;	/* = 3.0e+5; wall compliance		*/
	float	trachea_resi;	/*   for walls of the tracheal tube	*/
	float	trachea_mass;
	float	trachea_comp;
	float	H2O_bar;
	float	Kc;		/* a coeff. for Bernoulli resistance	*/

private:
	int	count_decim;
	int	q_decim, p_decim;	/* q = (p-1)/2 + 1 */
	float	h_decim[51],  v_decim[101];

private:
	void	clear_sources (
					   int	ns1,			/* # of sections + 1 */
					   td_acoustic_elements  e[] );	/* acoustic elements */

	void	clear_PU (
				  int	ns5,			/* =2*ns+3, ou ns = # of sections */
				  td_linear_equation  eq[]);	/* matrix elements */
	float	nonzero_t( float x );
	void	copy_initial_af_t(void);
	void	dax (void);
	void	find_constriction(void);
	void	refresh_af(void);
	void	acous_elements_t (
						  int			tract_typ,	/* TRACHEA, VOCAL_TRACT etc.*/
						  int			ns,		/* # of sections	*/
						  area_function		AF[],
						  td_acoustic_elements	e[]);
	void	NTacous_elements_t(
						   int			ns,		/* # of sections	*/
						   area_function		AF[],
						   td_acoustic_elements	e[]);
	void	refresh_acoustic_elements(void);
	void	eq_elements_t (
					   int			tract_typ,
					   int			*k1,		/* index of right arm */
					   int			ns,		/* # of sections */
					   td_acoustic_elements	e[],
					   td_linear_equation	q[]);
	void	force_constants (
						 int			tract_type,
						 int			*k1,
						 int			ns,		/* # of sections */
						 td_acoustic_elements	e[],
						 td_linear_equation	q[] );
	void	forward_elimination_t(
							  int			n_fin,		/* final index */
							  td_linear_equation	q[]);
	void	backward_substitution_t(
								int			n_ini,		/* initial index */
								td_linear_equation	q[] );
	void	backward_elimination_t(
							   int			n_ini,		/* initial index	 */
							   td_linear_equation	q[]);
	void	forward_substitution_t(
							   int			n_fin,		/* final index */
							   td_linear_equation	q[] );
	int	decim_init( void );
	float	decim(
			  int   out_flag,	/* = 0 for storing x, = 1 for filtering */
			  float x   );	/* input sample with the rate of simfrq Hz */
	void	filter2(
				float	*x,		/* input buffer, x[0] is input	*/
				float	*y,		/* output buffer, y[0] is output*/
				float	*a,		/* coefficints of denominator, a[0]=1	*/
				float	*b);		/* coefficints of numerator	*/
	float	frictionNoise3(
					   int	Entry,		/* if =0, initialization */
					   float	mem1[4][3],	/* fixed work array (input memories) */
					   float	mem2[4][3],     /* fixed work array (output memories)*/
					   float	*mem);		/* fixed memory for lowcut filter */
	float	frictionNoise7(
					   int	Entry,		/* if =0, initialization */
					   float	inBuf[4][3],	/* fixed work array (input memories) */
					   float	outBuf[4][3],	/* fixed work array (output memories)*/
					   float	*mem);		/* fixed memory for lowcut filter */
	int	vtt_ini (void);
	void	vtt_term ( void );
	float	vtt_sim( void );


public:
	double	get_constriction_noise();
	int		get_constriction_location();
	double	Synthesize(float pAg,area_function *Af,int nAf,double VPort);
	void	Reset(float pAg,area_function *Af,int nAf);
};

#endif // !defined(AFX_MAEDA_H__9B1962DA_79DC_4065_857F_7FF8D248A09F__INCLUDED_)
