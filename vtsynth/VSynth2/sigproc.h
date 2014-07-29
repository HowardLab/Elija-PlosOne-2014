/* autocorrelation function */
double autoc(double *sp,int len,double *acoeff,int l1,int l2);

/* zero crossing rate */
double zeroc(double *sp,int len,double srate);

/* normalise to zero mean and unit variance */
void normalise(double *buf,int len);
