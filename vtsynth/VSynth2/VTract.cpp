// VTract.cpp: implementation of the CVTract class.
//
//////////////////////////////////////////////////////////////////////
// last changed information
#define	VERSIONNUMBER		403
#define VERSIONDATE			300109
// last changed by Ian Howard

#include "stdafx.h"
#include "LFModel.h"
#include "maeda.h"
#include "VTract.h"
#include "math.h"
#include "stdio.h"
#include "stdlib.h"



#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
const	float	pi = 3.14159265f;

// the single VTract object
class CVTract VTract;

CVTract::CVTract()
{
	int	nfs, nafs;

	/* semi-polar coordinate specs. */
	// skiplines( in, 9 );
	//fscanf(in, "%d %d %d %f %f %f %d %d\n",
	//	    &m1, &m2, &m3, &dl, &omega, &theta, &ix0, &iy0 );
	m1 = 14;
	m2 = 11;
    m3 = 6;
    dl = 0.50000;
	omega = -11.25000;
	theta = 11.25000;
	ix0 = 3000;
	iy0 = 1850;

	//skiplines( in, 1 );
	//fscanf(in, "%f %f\n", &TEKvt, &TEKlip);
	TEKvt = 188.679245;
	TEKlip = 0.000000;

	//skiplines( in, 1 );
	//for(i=0; i<m1+m2+m3; i++)
	//   fscanf(in, "%d %f %f\n", &dummy, &alph[i], &beta[i]);
	alph[0] = 1.800000;		beta[0] = 1.200000;
	alph[1] = 1.800000;		beta[1] = 1.200000;
	alph[2] = 1.800000;		beta[2] = 1.200000;
	alph[3] = 1.800000;		beta[3] = 1.200000;
	alph[4] = 1.800000;		beta[4] = 1.200000;
	alph[5] = 1.800000;		beta[5] = 1.200000;
	alph[6] = 1.800000;		beta[6] = 1.200000;
	alph[7] = 1.800000;		beta[7] = 1.200000;
	alph[8] = 1.800000;		beta[8] = 1.200000;
	alph[9] = 1.800000;		beta[9] = 1.200000;
	alph[10] = 1.800000;		beta[10] = 1.200000;
	alph[11] = 1.800000;		beta[11] = 1.200000;
	alph[12] = 1.800000;		beta[12] = 1.200000;
	alph[13] = 1.800000;		beta[13] = 1.200000;
	alph[14] = 1.800000;		beta[14] = 1.200000;
	alph[15] = 1.800000;		beta[15] = 1.200000;
	alph[16] = 1.800000;		beta[16] = 1.300000;
	alph[17] = 1.700000;		beta[17] = 1.400000;
	alph[18] = 1.700000;		beta[18] = 1.400000;
	alph[19] = 1.700000;		beta[19] = 1.500000;
	alph[20] = 1.700000;		beta[20] = 1.500000;
	alph[21] = 1.700000;		beta[21] = 1.500000;
	alph[22] = 1.700000;		beta[22] = 1.500000;
	alph[23] = 1.700000;		beta[23] = 1.500000;
	alph[24] = 1.700000;		beta[24] = 1.500000;
	alph[25] = 1.700000;		beta[25] = 1.500000;
	alph[26] = 1.800000;		beta[26] = 1.500000;
	alph[27] = 1.800000;		beta[27] = 1.500000;
	alph[28] = 1.900000;		beta[28] = 1.500000;
	alph[29] = 2.000000;		beta[29] = 1.500000;
	alph[30] = 2.600000;		beta[30] = 1.500000;

/* Lip specifications */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_lip, &jaw_lip, &dummy, &dummy, &nfs, &nafs);
	nvrs_lip = 4;
	jaw_lip = 1;
	nfs = 4;
	nafs = 2;

	//if( jaw_lip != JAW || nfs < JAW+LIP )
	//{  printf("Not enough factors in the lip spec..");
	//   exit(1);
	//}

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+LIP; i++)  fscanf(in, "%s\n", flab_lip[i]);
	strcpy_s(flab_lip[0],"JW");
	strcpy_s(flab_lip[1],"HT");
	strcpy_s(flab_lip[2],"P1");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%f\n", &u_lip[i]);
	u_lip[0] = 104.271675;
	u_lip[1] = 122.812141;
	u_lip[2] = 135.938339;
	u_lip[3] = 460.440857;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%f\n", &s_lip[i]);
    s_lip[0] = 27.674635;
    s_lip[1] = 33.068081;
    s_lip[2] = 99.392258;
    s_lip[3] = 213.996170;

	//skiplines( in, 1 );
	//fscanf(in, "%f %f\n", &inci_x, &inci_y);
    inci_x = 2212.354492;
    inci_y = 1999.574219;

	//skiplines( in, 3 );
	//for(i=0; i<nvrs_lip; i++)
	//{  for(j=0; j<JAW+LIP; j++) fscanf(in, "%f\n", &A_lip[i][j]);
	//   skiplines( in, 1 );
	//}
	A_lip[0][0] = 1.000000; A_lip[0][1] = 0.000000; A_lip[0][2] = 0.000000;
	A_lip[1][0] = 0.178244; A_lip[1][1] =-0.395733; A_lip[1][2] = 0.888897;
	A_lip[2][0] =-0.154638; A_lip[2][1] = 0.987971; A_lip[2][2] = 0.000000;
	A_lip[3][0] =-0.217332; A_lip[3][1] = 0.825187; A_lip[3][2] =-0.303429;

	//skiplines( in, 1 + nvrs_lip );

	/* Tongue */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_tng, &jaw_tng, &iniva_tng, &lstva_tng, &nfs, &nafs);
    nvrs_tng = 26;
    jaw_tng = 1;
    iniva_tng = 7;
    lstva_tng = 31;
    nfs = 7;
    nafs = 1;

	//if( jaw_tng != JAW || nfs < JAW+TNG )
	//{  printf("Not enough factors in the tongue spec..");
	//   exit(1);
	//}
	iniva_tng--;	/* coordinate address for C, now same as lable */
	lstva_tng--;

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+TNG; i++)  fscanf(in, "%s\n", flab_tng[i]);
  	strcpy_s(flab_tng[0],"JW");
  	strcpy_s(flab_tng[1],"P1");
  	strcpy_s(flab_tng[2],"P2");
  	strcpy_s(flab_tng[3],"P3");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%f\n", &u_tng[i]);
    u_tng[0] = 104.271675;
    u_tng[1] = 443.988434;
    u_tng[2] = 450.481689;
    u_tng[3] = 399.942200;
    u_tng[4] = 348.603088;
    u_tng[5] = 351.181122;
    u_tng[6] = 365.404633;
    u_tng[7] = 370.290955;
    u_tng[8] = 356.202301;
    u_tng[9] = 341.890167;
    u_tng[10] = 332.117523;
    u_tng[11] = 326.826599;
    u_tng[12] = 326.512512;
    u_tng[13] = 331.631989;
    u_tng[14] = 343.175323;
    u_tng[15] = 361.265900;
    u_tng[16] = 385.231201;
    u_tng[17] = 411.826599;
    u_tng[18] = 435.691711;
    u_tng[19] = 455.040466;
    u_tng[20] = 462.736023;
    u_tng[21] = 453.025055;
    u_tng[22] = 432.250488;
    u_tng[23] = 407.358368;
    u_tng[24] = 384.551056;
	u_tng[25] = 363.836212;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%f\n", &s_tng[i]);
	s_tng[0] = 27.674635;
	s_tng[1] = 29.947931;
	s_tng[2] = 44.694466;
	s_tng[3] = 99.310226;
	s_tng[4] = 96.871323;
    s_tng[5] = 84.140404;
    s_tng[6] = 78.357513;
    s_tng[7] = 73.387718;
    s_tng[8] = 72.926758;
    s_tng[9] = 71.453232;
    s_tng[10] = 69.288765;
    s_tng[11] = 66.615509;
    s_tng[12] = 63.603722;
    s_tng[13] = 59.964859;
    s_tng[14] = 56.695446;
    s_tng[15] = 56.415058;
    s_tng[16] = 62.016468;
    s_tng[17] = 73.235176;
    s_tng[18] = 84.008438;
    s_tng[19] = 91.488312;
    s_tng[20] = 94.124176;
    s_tng[21] = 95.246323;
    s_tng[22] = 93.516365;
    s_tng[23] = 93.000343;
    s_tng[24] = 100.934669;
    s_tng[25] = 106.512482;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_tng; i++)
	//{  for(j=0; j<JAW+TNG; j++) fscanf(in, "%f\n", &A_tng[i][j]);
	//   skiplines( in, 1 );
	//}
	A_tng[0][0] = 1.000000; A_tng[0][1] = 0.000000; A_tng[0][2] = 0.000000; A_tng[0][3] = 0.000000;
	A_tng[1][0] =-0.464047; A_tng[1][1] = 0.098776; A_tng[1][2] =-0.251690; A_tng[1][3] = 0.228351;
	A_tng[2][0] =-0.328015; A_tng[2][1] = 0.337579; A_tng[2][2] =-0.283667; A_tng[2][3] = 0.568234;
	A_tng[3][0] =-0.213039; A_tng[3][1] = 0.485565; A_tng[3][2] =-0.283533; A_tng[3][3] = 0.653696;
	A_tng[4][0] =-0.302565; A_tng[4][1] = 0.705432; A_tng[4][2] =-0.379044; A_tng[4][3] = 0.392917;
	A_tng[5][0] =-0.327806; A_tng[5][1] = 0.786897; A_tng[5][2] =-0.388116; A_tng[5][3] = 0.245703;
	A_tng[6][0] =-0.325065; A_tng[6][1] = 0.852409; A_tng[6][2] =-0.285125; A_tng[6][3] = 0.176843;
	A_tng[7][0] =-0.325739; A_tng[7][1] = 0.904725; A_tng[7][2] =-0.142602; A_tng[7][3] = 0.138558;
	A_tng[8][0] =-0.313741; A_tng[8][1] = 0.926339; A_tng[8][2] = 0.021042; A_tng[8][3] = 0.122976;
	A_tng[9][0] =-0.288138; A_tng[9][1] = 0.924019; A_tng[9][2] = 0.131949; A_tng[9][3] = 0.116762;
	A_tng[10][0] =-0.249008; A_tng[10][1] = 0.909585; A_tng[10][2] = 0.250320; A_tng[10][3] = 0.112433;
	A_tng[11][0] =-0.196936; A_tng[11][1] = 0.882236; A_tng[11][2] = 0.369083; A_tng[11][3] = 0.112396;
	A_tng[12][0] =-0.128884; A_tng[12][1] = 0.830243; A_tng[12][2] = 0.499894; A_tng[12][3] = 0.115700;
	A_tng[13][0] =-0.040825; A_tng[13][1] = 0.730520; A_tng[13][2] = 0.651662; A_tng[13][3] = 0.112048;
	A_tng[14][0] = 0.073420; A_tng[14][1] = 0.543080; A_tng[14][2] = 0.807947; A_tng[14][3] = 0.126204;
	A_tng[15][0] = 0.202726; A_tng[15][1] = 0.230555; A_tng[15][2] = 0.919065; A_tng[15][3] = 0.163735;
	A_tng[16][0] = 0.298853; A_tng[16][1] =-0.162541; A_tng[16][2] = 0.899074; A_tng[16][3] = 0.213884;
	A_tng[17][0] = 0.332785; A_tng[17][1] =-0.491647; A_tng[17][2] = 0.748869; A_tng[17][3] = 0.243163;
	A_tng[18][0] = 0.349955; A_tng[18][1] =-0.681313; A_tng[18][2] = 0.567615; A_tng[18][3] = 0.245295;
	A_tng[19][0] = 0.377277; A_tng[19][1] =-0.771200; A_tng[19][2] = 0.410502; A_tng[19][3] = 0.249425;
	A_tng[20][0] = 0.422713; A_tng[20][1] =-0.804874; A_tng[20][2] = 0.270513; A_tng[20][3] = 0.274015;
	A_tng[21][0] = 0.474635; A_tng[21][1] =-0.797704; A_tng[21][2] = 0.129324; A_tng[21][3] = 0.314454;
	A_tng[22][0] = 0.526087; A_tng[22][1] =-0.746938; A_tng[22][2] =-0.026201; A_tng[22][3] = 0.366149;
	A_tng[23][0] = 0.549466; A_tng[23][1] =-0.643572; A_tng[23][2] =-0.190005; A_tng[23][3] = 0.422848;
	A_tng[24][0] = 0.494200; A_tng[24][1] =-0.504012; A_tng[24][2] =-0.350434; A_tng[24][3] = 0.488056;
	A_tng[25][0] = 0.448797; A_tng[25][1] =-0.417352; A_tng[25][2] =-0.445410; A_tng[25][3] = 0.500909;

	//skiplines( in, 1 + nvrs_tng );

	/* Larynx */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_lrx, &jaw_lrx, &iniva_lrx, &lstva_lrx, &nfs, &nafs);
	nvrs_lrx = 5;
	jaw_lrx = 1;
	iniva_lrx = 7;
	lstva_lrx = 6;
	nfs = 5;
	nafs = 2;
	//if( jaw_lrx != JAW || nfs < JAW+LRX )
	//{  printf("No enough factors in the larynx spec..");
	//   exit(1);
	//}

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+LRX; i++)  fscanf(in, "%s\n", flab_lrx[i]);
	strcpy_s(flab_lrx[0],"JW");
	strcpy_s(flab_lrx[1],"Y1");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%f\n", &u_lrx[i]);
	u_lrx[0] = 104.271675;
	u_lrx[1] = 143.138733;
	u_lrx[2] = -948.229309;
	u_lrx[3] = 404.678223;
	u_lrx[4] = -962.936401;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%f\n", &s_lrx[i]);
	s_lrx[0] = 27.674635;
	s_lrx[1] = 41.593315;
	s_lrx[2] = 65.562340;
	s_lrx[3] = 44.372742;
	s_lrx[4] = 66.147499;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lrx; i++)
	//{  for(j=0; j<JAW+LRX; j++) fscanf(in, "%f\n", &A_lrx[i][j]);
	//   skiplines( in, 1 );
	//}
	A_lrx[0][0] = 1.000000; A_lrx[0][1] = 0.000000;
	A_lrx[1][0] =-0.208338; A_lrx[1][1] = 0.262446;
	A_lrx[2][0] = 0.127814; A_lrx[2][1] = 0.991798;
	A_lrx[3][0] =-0.131840; A_lrx[3][1] = 0.300784;
	A_lrx[4][0] = 0.097688; A_lrx[4][1] = 0.934267;

	//skiplines( in, 1 + nvrs_lrx );

	/* Wall */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//&nvrs_wal, &jaw_wal, &iniva_wal, &lstva_wal, &nfs, &nafs);
	nvrs_wal = 25;
	jaw_wal = 0;
	iniva_wal = 7;
	lstva_wal = 31;
	nfs = 7;
	nafs = 0;

	iniva_wal--;	/* coordinate address for C, now same as lable */
	lstva_wal--;

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_wal; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 3 );
	//for(i=0; i<nvrs_wal; i++) fscanf(in, "%f\n", &u_wal[i]);
    u_wal[0] = 550.196533;
    u_wal[1] = 604.878601;
    u_wal[2] = 674.127197;
    u_wal[3] = 678.776489;
    u_wal[4] = 665.905579;
    u_wal[5] = 653.312134;
    u_wal[6] = 643.223511;
    u_wal[7] = 633.836243;
    u_wal[8] = 636.994202;
    u_wal[9] = 668.834290;
    u_wal[10] = 703.098267;
    u_wal[11] = 657.815002;
    u_wal[12] = 649.919067;
    u_wal[13] = 565.194580;
    u_wal[14] = 529.824646;
    u_wal[15] = 573.250488;
    u_wal[16] = 603.023132;
    u_wal[17] = 621.433533;
    u_wal[18] = 643.055847;
    u_wal[19] = 650.136780;
	u_wal[20] = 630.809265;
	u_wal[21] = 589.867065;
	u_wal[22] = 556.134888;
	u_wal[23] = 541.551086;
	u_wal[24] = 525.210022;

	// other initialisation
	vp_map = 1.0f;
	size_correction = 1.10f;
	vp_width_cm = 10.0f;
	inci_lip = 0.8f;
	inci_lip_vp = 0;

	convert_scale();
	semi_polar();
}

CVTract::~CVTract()
{

}


/*****
*	Function : semi_polar
*		The semi-ploar is specified by x-y values of the two ends
*		of each grid line.
*
*****/

void	CVTract::semi_polar ( void )
{

	float	r  = 5.0;		/* grid length (cm) */

	float	r_vp, dl_vp, ome, the, gam;
	float	dx_i, dy_i, dx_e, dy_e;
	float	p, q, s;
	int	i;

	r_vp  = r/vp_map;
	dl_vp = dl/vp_map;
	ome    = pi*omega/180.0f;
	the    = pi*theta/180.0f;

/* linear coordinate in the pharynx region */
	dx_i  = dl_vp*(float)cos(ome - pi/2.);
	dy_i  = dl_vp*(float)sin(ome - pi/2.);
	dx_e  = r_vp*(float)cos(ome);
	dy_e  = r_vp*(float)sin(ome);

	for(i=0; i<m1; i++)
	{  igd[i].x = dx_i*(m1 - (i + 1)) + ix0;
	   igd[i].y = dy_i*(m1 - (i + 1)) + iy0;
	   egd[i].x = dx_e + igd[i].x;
	   egd[i].y = dy_e + igd[i].y;
	}
/* polar coordinate in the velar region */
	for(i=m1; i<m1+m2; i++)
	{  gam = the*(i + 1 - m1) + ome;
	   igd[i].x = (float)ix0;
	   igd[i].y = (float)iy0;
	   egd[i].x = r_vp*(float)cos(gam) + ix0;
	   egd[i].y = r_vp*(float)sin(gam) + iy0;
	}
/* linear coordinate in the palato-dental region */
	dx_i  = dl_vp*(float)cos(gam + pi/2.0f);
	dy_i  = dl_vp*(float)sin(gam + pi/2.0f);
	dx_e  = r_vp*(float)cos(gam);
	dy_e  = r_vp*(float)sin(gam);

	for(i=m1+m2; i<m1+m2+m3; i++)
	{  igd[i].x = dx_i*(i + 1 - m1 - m2) + ix0;
	   igd[i].y = dy_i*(i + 1 - m1 - m2) + iy0;
	   egd[i].x = dx_e + igd[i].x;
	   egd[i].y = dy_e + igd[i].y;
	}
/* Mapping coefficients from vector to semi-polar */
	for(i=0; i<m1+m2+m3; i++)
	{  p = egd[i].x - igd[i].x;
	   q = egd[i].y - igd[i].y;
	   s = (float)sqrt( p*p + q*q );
	   vtos[i].x = p/s;
	   vtos[i].y = q/s;
	}
}

/*************************( plotting functions )**************************/
/*****
*	Function : convert_scale
*	Note :	Convert the cm-TEK unit mapping coefs., TEKvt and TEKlip,
*		and change the center coordinate (ix0, iy0), in order to
*		plot the genetated VT contours inside the specified
*		viewport.  Mean and standard deviation in TEK unit are
*		converted into the viewport unit. A viewport mapping coef.,
*		vp_map, is defined as its width corresponds to vp_width_cm
*		cm.
*****/
#define DWIDTH	10*20		/* display width in pixels */
#define DHEIGHT	10*20		/* display height in pixels */

void	CVTract::convert_scale ( void )
{
	int	i;
	int done_flag=0;

/* viewport-to-cm scale factors (mapping coefficient) */
	vp_map = vp_width_cm/(DWIDTH/10);

/* Modify TEK-to-cm to TEK-to-viewport scale factor */
	TEKvt  = TEKvt*vp_map;
	if( TEKlip == 0. ) TEKlip = TEKvt;
	else               TEKlip = TEKlip*vp_map;

/* convert absolute mean maxillary incisor position to that relative
   to the semi-polar coordinate center, and to in viewport unit */
	inci_x = (inci_x - ix0)/TEKvt;
	inci_y = (inci_y - iy0)/TEKvt;

/* convert din in cm to in vp-unit */
	inci_lip_vp = inci_lip/vp_map;

/* convert TEK-unit to the viewport unit */
	for(i=0; i<2; i++)              /* jaw and lip protrusion */
	{  u_lip[i] = u_lip[i]/TEKvt;
	   s_lip[i] = s_lip[i]/TEKvt;
	}
	for(i=2; i<nvrs_lip; i++)	/* front lip height and width */
	{  u_lip[i] = u_lip[i]/TEKlip;
	   s_lip[i] = s_lip[i]/TEKlip;
	}
	for(i=0; i<nvrs_tng; i++)	/* tongue profile */
	{  u_tng[i] = u_tng[i]/TEKvt;
	   s_tng[i] = s_tng[i]/TEKvt;
	}
	for(i=0; i<nvrs_lrx; i++)	/* larynx profile */
	{  u_lrx[i] = u_lrx[i]/TEKvt;
	   s_lrx[i] = s_lrx[i]/TEKvt;
	}

	if (done_flag == 0) {
	for(i=0; i<nvrs_wal; i++)	/* vt rear wall profile */
	   u_wal[i] = u_wal[i]/TEKvt;
	done_flag=1;
	}

/* new coordinate center in the viewport */
	ix0 = 0.6*(DWIDTH/10);
	iy0 = 0.6*(DHEIGHT/10);
}

/*****
*	Function : lam
*	Note :	Compute vector representetion of the articulator positions
*		for given parameter values and project them on the semi-
*		polar coordinate to generate a VT profile.
*
*		Articulatory parameters are defined as follows :
*			para[0] : jaw
*			para[1] : tongue-body position
*			para[2] : tongue-body shape
*			para[3] : tongue-tip position
*			para[4] : lip height (aperture)
*			para[5] : lip protrusion
*			para[6] : larynx height
*
*		Note :	In order to avoid the crossover of contours, the lip
*			tube dimensions are blocked at zero and the tract
*			inside contour (tongue) is also blocked at the
*			exterior walls (10/08/92).
*
****/
void	CVTract::lam ( float *pa )		/* a set of JAW+TNG+LIP+LRX */
{                                       /* articulatory parameter   */
	float	p[JAW+TNG];
	float	v_lip[NVRS_LIP], v_tng[NVRS_TNG], v_lrx[NVRS_LRX];
	float	v, x1, y1, x2, y2;
	int	i, j;

/*** copy parameter values and compute vectors ****/

	p[0] = pa[0];		    /* p[0] is always jaw parameter value */

/* tongue */
	for(i=1; i<=TNG; i++) p[i] = pa[i];
	for(i=0; i<nvrs_tng; i++)
	{  v = 0;
	   for(j=0; j<JAW+TNG; j++) v = v + A_tng[i][j]*p[j];
	   v_tng[i] = s_tng[i]*v + u_tng[i];
	}
/* lip */
	for(i=1; i<=LIP; i++) p[i] = pa[i+TNG];/* copy intrinsic lip pars.*/
	for(i=0; i<nvrs_lip; i++)
	{  v = 0;
	   for(j=0; j<JAW+LIP; j++) v = v + A_lip[i][j]*p[j];
	   v_lip[i] = s_lip[i]*v + u_lip[i];
	   if( v_lip[i] < 0. ) v_lip[i] = 0.;		/** block at zero **/
	}
/* larnx */
	for(i=1; i<=LRX; i++) p[i] = pa[i+TNG+LIP];
	for(i=0; i<nvrs_lrx; i++)
	{  v = 0;
	   for(j=0; j<JAW+LRX; j++) v = v + A_lrx[i][j]*p[j];
	   v_lrx[i] = s_lrx[i]*v + u_lrx[i];
	}

/*** Projection of vectors on the semi-polar coordinate ***/

/* larynx back edge */
	np=0;
	ivt[np].x = v_lrx[JAW]   + ix0;		/* front edge */
	ivt[np].y = v_lrx[JAW+1] + iy0;
	evt[np].x = v_lrx[JAW+2] + ix0;		/* rear edge */
	evt[np].y = v_lrx[JAW+3] + iy0;

/* larynx, pharynx and buccal */
	for(i=iniva_tng; i<=lstva_tng; i++)
	{  j = i - iniva_tng;
	   /** block tongue contour at walls **/
	   v = (float)min( v_tng[j+JAW], u_wal[j] );
	   x1 = vtos[i].x * v + igd[i].x;		/* inside */
	   y1 = vtos[i].y * v + igd[i].y;
	   x2 = vtos[i].x * u_wal[j] + igd[i].x;	/* outside */
	   y2 = vtos[i].y * u_wal[j] + igd[i].y;

	   if(i == iniva_tng)			/* add an extra point */
	   {  ivt[++np].x = (ivt[0].x + x1)/2;
	      ivt[  np].y = (ivt[0].y + y1)/2;
	      evt[  np].x = (evt[0].x + x2)/2;
	      evt[  np].y = (evt[0].y + y2)/2;
	   }
	   ivt[++np].x = x1;
	   ivt[  np].y = y1;
	   evt[  np].x = x2;
	   evt[  np].y = y2;
	}
/* lips */
	evt[++np].x = inci_x + ix0;     /* pos. of inner edge of upper lip */
	evt[  np].y = inci_y + inci_lip_vp + iy0;
	ivt[  np].x = evt[np].x;
	ivt[  np].y = evt[np].y - v_lip[2];	/* lower lip */

	evt[++np].x = evt[np-1].x - v_lip[1];
	evt[  np].y = evt[np-1].y;
	ivt[  np].x = evt[np].x;
	ivt[  np].y = ivt[np-1].y;

/* number of points */
	++np;

/*** Lip frontal shape (ellips) ***/
	lip_h = (float)(v_lip[2]/2.);
	lip_w = (float)(v_lip[3]/2.);

//	for (i=0;i<np;i++) {
//		TRACE("In: x=%8.1f y=%8.1f\tEx: x=%8.1f y=%8.1f\n",ivt[i].x,ivt[i].y,evt[i].x,evt[i].y);
//	}
}

/*****
*	Function : amo
*	Note : returns the distance between two points.
*****/
float	CVTract::amo (float2D p, float2D q)
{
	return( (float)sqrt((p.x-q.x)*(p.x-q.x) + (p.y-q.y)*(p.y-q.y)) );
}

/******
*	Function : sagittal_to_area
*	Note :	To calculate an area function of the vocal tract (VT)
*		from a quadrilateral representation of the profile.
*		The conversion employes an "alpha-beta" sagittal-to-
*		area relationships.  The alpha and beta values are
*		specified in relation with the semi-polar coordinate
*		grids.
*****/

void	CVTract::sagittal_to_area (
	int	*ns,		/* number of sections */
	area_function	*af)	/* af.A = cross-sectional area (cm**2) */
				/* af.x = section length (cm) */
{
	float	p, q, r, s, t, a1, a2, s1, s2, x1, y1, d, w;
	float	c, cc;
	int	i, j;

/* vt_unit to cm conversion coef. with size_correction */
	c = size_correction*vp_map;
	cc = c*c;

/* from larynx to buccal */
	for(i=1; i<np-1; i++)
	{  p  = amo(ivt[i],   ivt[i-1]);
	   q  = amo(evt[i],   evt[i-1]);
	   r  = amo(ivt[i-1], evt[i-1]);
	   s  = amo(evt[i],   ivt[i]  );
	   t  = amo(evt[i],   ivt[i-1]);
	   a1 = (float)(0.5*(p + s + t));
	   a2 = (float)(0.5*(q + r + t));
	   s1 = (float)sqrt(a1*(a1 - p)*(a1 - s)*(a1 - t));
	   s2 = (float)sqrt(a2*(a2 - q)*(a2 - r)*(a2 - t));
	   x1 = ivt[i-1].x + evt[i-1].x - ivt[i].x - evt[i].x;
	   y1 = ivt[i-1].y + evt[i-1].y - ivt[i].y - evt[i].y;
	   d  = 0.5f*(float)sqrt(x1*x1 + y1*y1);
	   w  = c*(s1 + s2)/d;
	   af[i-1].x = c*d;
	   j  = i + iniva_tng - 3;
	   af[i-1].A = (float)(1.4*alph[j]*pow(w, beta[j])); /* 40% ad hoc increase */
	}
/* lips (2 sections with the equel length) */
	af[np-2].A = af[np-1].A = pi * lip_h * lip_w * cc;
	af[np-2].x = af[np-1].x = (float)(0.5 * (ivt[np-2].x - ivt[np-1].x) * c);

/* number of sections */
	*ns = np;

/* Check areas */
	for(i=0; i<*ns; i++)
	{  if(af[i].A <= 0.0) af[i].A = 0.0001f;
	   if(af[i].x <= 0.0) af[i].x = 0.01f;
	}
}

/*****
*	Function : appro_area_function
*	Note :	Approximate the area function from LAM, in which the section
*		length varies, by an area function with M tubes with a fixed
*		section length.  In the approximation, the fixed section
*		lenght is determined as dx = total length/M, so that the
*		total length remains invariant.
*****/

void	CVTract::appro_area_function (
	int		ns1,	/* number of sections */
	area_function	*af1,	/* input area function with ns1 sections */
	int		ns2,	/* number of fixed sections */
	area_function	*af2 )	/* output areas function */
{
	float	dx;
	float	x, z1, z2, s1, s2;
	int	i, j;

/* compute dx */
	for(x=0., i=0; i<ns1; i++) x = x + af1[i].x;
	for(dx=x/ns2,i=0; i<ns2; i++) af2[i].x = dx;

/* approximation of areas */
	x = z2 = s2 = 0.;
	i = j = 0;
	while( i < ns2 )
	{  x += dx;
	   while( z2 <= x )
	   {  z1 = z2; z2 += af1[j].x;
	      s1 = s2; s2 += af1[j].x*af1[j].A;
	      if( ++j == ns1 ) break;
	   }
	   af2[i++].A = (s1 + (x - z1)*af1[j-1].A)/dx;
	   while( x+dx <= z2 )
	   {  af2[i++].A = af1[j-1].A;
	      x += dx;
	   }
	   s2 = (z2 - x)*af1[j-1].A;
	}

/*	Let the approximated lip area, af2[ns2-1].A, equal to the lip area*/
/*	of the original area function, af1[ns1-1].A.  This operation is   */
/*	necessary, since the averaged area, af2.A, tends to be too large  */
/*	in the case of the vowel such as [u], resulting in too high F2    */
/*	value.                                                            */

	af2[ns2-1].A = af1[ns1-1].A;
}



void CVTract::SetSize(double size)
{
	int	nfs, nafs;

	/* semi-polar coordinate specs. */
	// skiplines( in, 9 );
	//fscanf(in, "%d %d %d %f %f %f %d %d\n",
	//	    &m1, &m2, &m3, &dl, &omega, &theta, &ix0, &iy0 );
	m1 = 14;
	m2 = 11;
    m3 = 6;
    dl = 0.50000;
	omega = -11.25000;
	theta = 11.25000;
	ix0 = 3000;
	iy0 = 1850;

	//skiplines( in, 1 );
	//fscanf(in, "%f %f\n", &TEKvt, &TEKlip);
	TEKvt = 188.679245;
	TEKlip = 0.000000;

	//skiplines( in, 1 );
	//for(i=0; i<m1+m2+m3; i++)
	//   fscanf(in, "%d %f %f\n", &dummy, &alph[i], &beta[i]);
	alph[0] = 1.800000;		beta[0] = 1.200000;
	alph[1] = 1.800000;		beta[1] = 1.200000;
	alph[2] = 1.800000;		beta[2] = 1.200000;
	alph[3] = 1.800000;		beta[3] = 1.200000;
	alph[4] = 1.800000;		beta[4] = 1.200000;
	alph[5] = 1.800000;		beta[5] = 1.200000;
	alph[6] = 1.800000;		beta[6] = 1.200000;
	alph[7] = 1.800000;		beta[7] = 1.200000;
	alph[8] = 1.800000;		beta[8] = 1.200000;
	alph[9] = 1.800000;		beta[9] = 1.200000;
	alph[10] = 1.800000;		beta[10] = 1.200000;
	alph[11] = 1.800000;		beta[11] = 1.200000;
	alph[12] = 1.800000;		beta[12] = 1.200000;
	alph[13] = 1.800000;		beta[13] = 1.200000;
	alph[14] = 1.800000;		beta[14] = 1.200000;
	alph[15] = 1.800000;		beta[15] = 1.200000;
	alph[16] = 1.800000;		beta[16] = 1.300000;
	alph[17] = 1.700000;		beta[17] = 1.400000;
	alph[18] = 1.700000;		beta[18] = 1.400000;
	alph[19] = 1.700000;		beta[19] = 1.500000;
	alph[20] = 1.700000;		beta[20] = 1.500000;
	alph[21] = 1.700000;		beta[21] = 1.500000;
	alph[22] = 1.700000;		beta[22] = 1.500000;
	alph[23] = 1.700000;		beta[23] = 1.500000;
	alph[24] = 1.700000;		beta[24] = 1.500000;
	alph[25] = 1.700000;		beta[25] = 1.500000;
	alph[26] = 1.800000;		beta[26] = 1.500000;
	alph[27] = 1.800000;		beta[27] = 1.500000;
	alph[28] = 1.900000;		beta[28] = 1.500000;
	alph[29] = 2.000000;		beta[29] = 1.500000;
	alph[30] = 2.600000;		beta[30] = 1.500000;

/* Lip specifications */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_lip, &jaw_lip, &dummy, &dummy, &nfs, &nafs);
	nvrs_lip = 4;
	jaw_lip = 1;
	nfs = 4;
	nafs = 2;

	//if( jaw_lip != JAW || nfs < JAW+LIP )
	//{  printf("Not enough factors in the lip spec..");
	//   exit(1);
	//}

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+LIP; i++)  fscanf(in, "%s\n", flab_lip[i]);
	strcpy_s(flab_lip[0],"JW");
	strcpy_s(flab_lip[1],"HT");
	strcpy_s(flab_lip[2],"P1");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%f\n", &u_lip[i]);
	u_lip[0] = 104.271675;
	u_lip[1] = 122.812141;
	u_lip[2] = 135.938339;
	u_lip[3] = 460.440857;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lip; i++) fscanf(in, "%f\n", &s_lip[i]);
    s_lip[0] = 27.674635;
    s_lip[1] = 33.068081;
    s_lip[2] = 99.392258;
    s_lip[3] = 213.996170;

	//skiplines( in, 1 );
	//fscanf(in, "%f %f\n", &inci_x, &inci_y);
    inci_x = 2212.354492;
    inci_y = 1999.574219;

	//skiplines( in, 3 );
	//for(i=0; i<nvrs_lip; i++)
	//{  for(j=0; j<JAW+LIP; j++) fscanf(in, "%f\n", &A_lip[i][j]);
	//   skiplines( in, 1 );
	//}
	A_lip[0][0] = 1.000000; A_lip[0][1] = 0.000000; A_lip[0][2] = 0.000000;
	A_lip[1][0] = 0.178244; A_lip[1][1] =-0.395733; A_lip[1][2] = 0.888897;
	A_lip[2][0] =-0.154638; A_lip[2][1] = 0.987971; A_lip[2][2] = 0.000000;
	A_lip[3][0] =-0.217332; A_lip[3][1] = 0.825187; A_lip[3][2] =-0.303429;

	//skiplines( in, 1 + nvrs_lip );

	/* Tongue */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_tng, &jaw_tng, &iniva_tng, &lstva_tng, &nfs, &nafs);
    nvrs_tng = 26;
    jaw_tng = 1;
    iniva_tng = 7;
    lstva_tng = 31;
    nfs = 7;
    nafs = 1;

	//if( jaw_tng != JAW || nfs < JAW+TNG )
	//{  printf("Not enough factors in the tongue spec..");
	//   exit(1);
	//}
	iniva_tng--;	/* coordinate address for C, now same as lable */
	lstva_tng--;

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+TNG; i++)  fscanf(in, "%s\n", flab_tng[i]);
  	strcpy_s(flab_tng[0],"JW");
  	strcpy_s(flab_tng[1],"P1");
  	strcpy_s(flab_tng[2],"P2");
  	strcpy_s(flab_tng[3],"P3");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%f\n", &u_tng[i]);
    u_tng[0] = 104.271675;
    u_tng[1] = 443.988434;
    u_tng[2] = 450.481689;
    u_tng[3] = 399.942200;
    u_tng[4] = 348.603088;
    u_tng[5] = 351.181122;
    u_tng[6] = 365.404633;
    u_tng[7] = 370.290955;
    u_tng[8] = 356.202301;
    u_tng[9] = 341.890167;
    u_tng[10] = 332.117523;
    u_tng[11] = 326.826599;
    u_tng[12] = 326.512512;
    u_tng[13] = 331.631989;
    u_tng[14] = 343.175323;
    u_tng[15] = 361.265900;
    u_tng[16] = 385.231201;
    u_tng[17] = 411.826599;
    u_tng[18] = 435.691711;
    u_tng[19] = 455.040466;
    u_tng[20] = 462.736023;
    u_tng[21] = 453.025055;
    u_tng[22] = 432.250488;
    u_tng[23] = 407.358368;
    u_tng[24] = 384.551056;
	u_tng[25] = 363.836212;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_tng; i++) fscanf(in, "%f\n", &s_tng[i]);
	s_tng[0] = 27.674635;
	s_tng[1] = 29.947931;
	s_tng[2] = 44.694466;
	s_tng[3] = 99.310226;
	s_tng[4] = 96.871323;
    s_tng[5] = 84.140404;
    s_tng[6] = 78.357513;
    s_tng[7] = 73.387718;
    s_tng[8] = 72.926758;
    s_tng[9] = 71.453232;
    s_tng[10] = 69.288765;
    s_tng[11] = 66.615509;
    s_tng[12] = 63.603722;
    s_tng[13] = 59.964859;
    s_tng[14] = 56.695446;
    s_tng[15] = 56.415058;
    s_tng[16] = 62.016468;
    s_tng[17] = 73.235176;
    s_tng[18] = 84.008438;
    s_tng[19] = 91.488312;
    s_tng[20] = 94.124176;
    s_tng[21] = 95.246323;
    s_tng[22] = 93.516365;
    s_tng[23] = 93.000343;
    s_tng[24] = 100.934669;
    s_tng[25] = 106.512482;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_tng; i++)
	//{  for(j=0; j<JAW+TNG; j++) fscanf(in, "%f\n", &A_tng[i][j]);
	//   skiplines( in, 1 );
	//}
	A_tng[0][0] = 1.000000; A_tng[0][1] = 0.000000; A_tng[0][2] = 0.000000; A_tng[0][3] = 0.000000;
	A_tng[1][0] =-0.464047; A_tng[1][1] = 0.098776; A_tng[1][2] =-0.251690; A_tng[1][3] = 0.228351;
	A_tng[2][0] =-0.328015; A_tng[2][1] = 0.337579; A_tng[2][2] =-0.283667; A_tng[2][3] = 0.568234;
	A_tng[3][0] =-0.213039; A_tng[3][1] = 0.485565; A_tng[3][2] =-0.283533; A_tng[3][3] = 0.653696;
	A_tng[4][0] =-0.302565; A_tng[4][1] = 0.705432; A_tng[4][2] =-0.379044; A_tng[4][3] = 0.392917;
	A_tng[5][0] =-0.327806; A_tng[5][1] = 0.786897; A_tng[5][2] =-0.388116; A_tng[5][3] = 0.245703;
	A_tng[6][0] =-0.325065; A_tng[6][1] = 0.852409; A_tng[6][2] =-0.285125; A_tng[6][3] = 0.176843;
	A_tng[7][0] =-0.325739; A_tng[7][1] = 0.904725; A_tng[7][2] =-0.142602; A_tng[7][3] = 0.138558;
	A_tng[8][0] =-0.313741; A_tng[8][1] = 0.926339; A_tng[8][2] = 0.021042; A_tng[8][3] = 0.122976;
	A_tng[9][0] =-0.288138; A_tng[9][1] = 0.924019; A_tng[9][2] = 0.131949; A_tng[9][3] = 0.116762;
	A_tng[10][0] =-0.249008; A_tng[10][1] = 0.909585; A_tng[10][2] = 0.250320; A_tng[10][3] = 0.112433;
	A_tng[11][0] =-0.196936; A_tng[11][1] = 0.882236; A_tng[11][2] = 0.369083; A_tng[11][3] = 0.112396;
	A_tng[12][0] =-0.128884; A_tng[12][1] = 0.830243; A_tng[12][2] = 0.499894; A_tng[12][3] = 0.115700;
	A_tng[13][0] =-0.040825; A_tng[13][1] = 0.730520; A_tng[13][2] = 0.651662; A_tng[13][3] = 0.112048;
	A_tng[14][0] = 0.073420; A_tng[14][1] = 0.543080; A_tng[14][2] = 0.807947; A_tng[14][3] = 0.126204;
	A_tng[15][0] = 0.202726; A_tng[15][1] = 0.230555; A_tng[15][2] = 0.919065; A_tng[15][3] = 0.163735;
	A_tng[16][0] = 0.298853; A_tng[16][1] =-0.162541; A_tng[16][2] = 0.899074; A_tng[16][3] = 0.213884;
	A_tng[17][0] = 0.332785; A_tng[17][1] =-0.491647; A_tng[17][2] = 0.748869; A_tng[17][3] = 0.243163;
	A_tng[18][0] = 0.349955; A_tng[18][1] =-0.681313; A_tng[18][2] = 0.567615; A_tng[18][3] = 0.245295;
	A_tng[19][0] = 0.377277; A_tng[19][1] =-0.771200; A_tng[19][2] = 0.410502; A_tng[19][3] = 0.249425;
	A_tng[20][0] = 0.422713; A_tng[20][1] =-0.804874; A_tng[20][2] = 0.270513; A_tng[20][3] = 0.274015;
	A_tng[21][0] = 0.474635; A_tng[21][1] =-0.797704; A_tng[21][2] = 0.129324; A_tng[21][3] = 0.314454;
	A_tng[22][0] = 0.526087; A_tng[22][1] =-0.746938; A_tng[22][2] =-0.026201; A_tng[22][3] = 0.366149;
	A_tng[23][0] = 0.549466; A_tng[23][1] =-0.643572; A_tng[23][2] =-0.190005; A_tng[23][3] = 0.422848;
	A_tng[24][0] = 0.494200; A_tng[24][1] =-0.504012; A_tng[24][2] =-0.350434; A_tng[24][3] = 0.488056;
	A_tng[25][0] = 0.448797; A_tng[25][1] =-0.417352; A_tng[25][2] =-0.445410; A_tng[25][3] = 0.500909;

	//skiplines( in, 1 + nvrs_tng );

	/* Larynx */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//	&nvrs_lrx, &jaw_lrx, &iniva_lrx, &lstva_lrx, &nfs, &nafs);
	nvrs_lrx = 5;
	jaw_lrx = 1;
	iniva_lrx = 7;
	lstva_lrx = 6;
	nfs = 5;
	nafs = 2;
	//if( jaw_lrx != JAW || nfs < JAW+LRX )
	//{  printf("No enough factors in the larynx spec..");
	//   exit(1);
	//}

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 1 );
	//for(i=0; i<JAW+LRX; i++)  fscanf(in, "%s\n", flab_lrx[i]);
	strcpy_s(flab_lrx[0],"JW");
	strcpy_s(flab_lrx[1],"Y1");

	//skiplines( in, 2 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%f\n", &u_lrx[i]);
	u_lrx[0] = 104.271675;
	u_lrx[1] = 143.138733;
	u_lrx[2] = -948.229309;
	u_lrx[3] = 404.678223;
	u_lrx[4] = -962.936401;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lrx; i++) fscanf(in, "%f\n", &s_lrx[i]);
	s_lrx[0] = 27.674635;
	s_lrx[1] = 41.593315;
	s_lrx[2] = 65.562340;
	s_lrx[3] = 44.372742;
	s_lrx[4] = 66.147499;

	//skiplines( in, 1 );
	//for(i=0; i<nvrs_lrx; i++)
	//{  for(j=0; j<JAW+LRX; j++) fscanf(in, "%f\n", &A_lrx[i][j]);
	//   skiplines( in, 1 );
	//}
	A_lrx[0][0] = 1.000000; A_lrx[0][1] = 0.000000;
	A_lrx[1][0] =-0.208338; A_lrx[1][1] = 0.262446;
	A_lrx[2][0] = 0.127814; A_lrx[2][1] = 0.991798;
	A_lrx[3][0] =-0.131840; A_lrx[3][1] = 0.300784;
	A_lrx[4][0] = 0.097688; A_lrx[4][1] = 0.934267;

	//skiplines( in, 1 + nvrs_lrx );

	/* Wall */
	//skiplines( in, 2 );
	//fscanf(in, "%d %d %d %d %d %d\n",
	//&nvrs_wal, &jaw_wal, &iniva_wal, &lstva_wal, &nfs, &nafs);
	nvrs_wal = 25;
	jaw_wal = 0;
	iniva_wal = 7;
	lstva_wal = 31;
	nfs = 7;
	nafs = 0;

	iniva_wal--;	/* coordinate address for C, now same as lable */
	lstva_wal--;

	//skiplines( in, nafs + 2 );
	//for(i=0; i<nvrs_wal; i++) fscanf(in, "%s\n", vlab_dummy);

	//skiplines( in, 3 );
	//for(i=0; i<nvrs_wal; i++) fscanf(in, "%f\n", &u_wal[i]);
    u_wal[0] = 550.196533;
    u_wal[1] = 604.878601;
    u_wal[2] = 674.127197;
    u_wal[3] = 678.776489;
    u_wal[4] = 665.905579;
    u_wal[5] = 653.312134;
    u_wal[6] = 643.223511;
    u_wal[7] = 633.836243;
    u_wal[8] = 636.994202;
    u_wal[9] = 668.834290;
    u_wal[10] = 703.098267;
    u_wal[11] = 657.815002;
    u_wal[12] = 649.919067;
    u_wal[13] = 565.194580;
    u_wal[14] = 529.824646;
    u_wal[15] = 573.250488;
    u_wal[16] = 603.023132;
    u_wal[17] = 621.433533;
    u_wal[18] = 643.055847;
    u_wal[19] = 650.136780;
	u_wal[20] = 630.809265;
	u_wal[21] = 589.867065;
	u_wal[22] = 556.134888;
	u_wal[23] = 541.551086;
	u_wal[24] = 525.210022;

	// other initialisation
	vp_map = 1.0f;
	size_correction = 1.10f;
	vp_width_cm = 10.0f;
	inci_lip = 0.8f;
	inci_lip_vp = 0;

	size_correction = size;
	vp_width_cm = 1.1 * 10.0 / size;

	convert_scale();
	semi_polar();
}
