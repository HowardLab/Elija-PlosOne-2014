/* sigproc - signal processing functions */

//#include "stdafx.h"
#include "sigproc.h"
#include "math.h"

/* autocorrelation function */
double autoc(double *sp,int len,double *acoeff,int l1,int l2)
{
	register int	i,j;
	int		num;
	double		sum,sumsq1,sumsq2,norm;
	double		*s1,*s2;
	double		mean=0;
	double epsilon = 1e-5;

	/* zero autocorrelation vector */
	for (i=0;i<l2;i++) acoeff[i]=(float)0.0;

	/* for zero delay */
	sum=(float)0.0;
	num=len;
	s1 = sp;
	for (j=0;j<num;j++,s1++) sum += *s1 * *s1;
	acoeff[0] = sum/len;

	/* for each delay in expected freq. range */
	for (i=l1;i<=l2;i++) {
		sumsq1=sumsq2=sum=(float)0.0;
		num = 3*i;	/* up to three possible cycles */
		if (num > (len-i)) num = len-i;
		s1 = sp;
		s2 = sp + i;
		for (j=0;j<num;j++) {
			sumsq1 += *s1 * *s1;
			sumsq2 += *s2 * *s2;
			sum += *s1++ * *s2++;
		}
		norm = (float)(sqrt(sumsq1)*sqrt(sumsq2)/num);
		if(norm < epsilon)
		{
			norm = epsilon;
		}

		acoeff[i] = (sum/num)/norm;
		mean += acoeff[i];
	}
	return(mean/(l2-l1+1));
}

/* zero crossing rate */
double zeroc(double *sp,int len,double srate)
{
	register int	i;
	double	last;
	double	curr;
	int		count=0;

	last=sp[0];
	for (i=1;i<len;i++) {
		curr = sp[i];
		if ((last<0)&&(curr>=0)) count++;
		last=curr;
	}

	return(count*srate/len);
}

/* normalise to zero mean and unit variance */
void normalise(double *buf,int len)
{
	int	i;
	double	sum=0;
	double	sumsq=0;
	double epsilon = 1e-5;

	/* zero mean */
	for (i=0;i<len;i++) sum += buf[i];
	sum /= len;
	for (i=0;i<len;i++) buf[i] -= sum;

	/* unit variance */
	for (i=0;i<len;i++) sumsq += buf[i]*buf[i];
	sumsq = sqrt(sumsq/len);
	if(sumsq < epsilon)
	{
		sumsq = epsilon;
	}

	for (i=0;i<len;i++) buf[i] /= sumsq;
}

