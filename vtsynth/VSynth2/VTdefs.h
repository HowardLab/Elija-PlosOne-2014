// Acoustic analysis
#define VTS_THIRDOCTAVE		1		/* third octave filters */
#define VTS_FX				2		/* perform autocorrelation fx estimation */
#define VTS_VDEGREE			4		/* perform voicing dgree analysis */
#define VTS_MEANENERGY		8		/* treat overall energy as separate parameter */
#define VTS_VOCODER			16		/* auditory filterbank */

#define VTS_PRINT			1024	/* print the analysis */
#define VTS_RESPONSE		2048	/* dump the filter response */
#define VTS_NORMALISE		4096	/* normalise input signal */

/* vocal tract size flags */
#define VTS_SIZE_MALE	0
#define VTS_SIZE_FEMALE	1
#define VTS_SIZE_CHILD	2

