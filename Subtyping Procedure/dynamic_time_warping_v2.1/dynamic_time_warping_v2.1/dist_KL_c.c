

#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double vectorDistance(double *s, double *t, int ns, int nt, int k, int i, int j)
{
    double result=0;
    double ss,tt;
    int x;
    for(x=0;x<k;x++)
    {
        ss=s[i+ns*x];
        tt=t[j+nt*x];
        result+= tt * log(tt/ss) - tt + ss;
    }
     
    return result;
}

double dist_KL_c(double *s, double *t, int w, int ns, int nt, int k)
{
    double d=0;
    int i;
    
    for(i=1;i<=ns;i++)
    {         
        d+=vectorDistance(s,t,ns,nt,k,i-1,0);
    }
    
    return d;
}


void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double *s,*t;
    int w;
    int ns,nt,k;
    double *dp;
    
  
    if(nrhs!=2&&nrhs!=3)
    {
         
    }
    if(nlhs>1)
    {
         
    }
    
    /* check to make sure w is a scalar */
    if(nrhs==2)
    {
        w=-1;
    }
    else if(nrhs==3)
    {
        
        
 
        w = (int) mxGetScalar(prhs[2]);
    }
    
    
  
    s = mxGetPr(prhs[0]);
    
   
    t = mxGetPr(prhs[1]);
    
   
    ns = mxGetM(prhs[0]);
    k = mxGetN(prhs[0]);
    
  
    nt = mxGetM(prhs[1]);
     
    
    
    plhs[0] = mxCreateDoubleMatrix( 1, 1, mxREAL);
    
   
    dp = mxGetPr(plhs[0]);
  
    dp[0]=dist_KL_c(s,t,w,ns,nt,k);
    
    return;
    
}
