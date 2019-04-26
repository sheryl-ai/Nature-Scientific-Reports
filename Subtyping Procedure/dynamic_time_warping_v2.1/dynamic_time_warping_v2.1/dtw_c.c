

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
        result+=((ss-tt)*(ss-tt));
    }
    result=sqrt(result);
    return result;
}

double dtw_c(double *s, double *t, int w, int ns, int nt, int k)
{
    double d=0;
    int sizediff=ns-nt>0 ? ns-nt : nt-ns;
    double ** D;
    int i,j;
    int j1,j2;
    double cost,temp;
    
    
    if(w!=-1 && w<sizediff) w=sizediff; 
    D=(double **)malloc((ns+1)*sizeof(double *));
    for(i=0;i<ns+1;i++)
    {
        D[i]=(double *)malloc((nt+1)*sizeof(double));
    }
    
 
    for(i=0;i<ns+1;i++)
    {
        for(j=0;j<nt+1;j++)
        {
            D[i][j]=-1;
        }
    }
    D[0][0]=0;
    
 
    for(i=1;i<=ns;i++)
    {
        if(w==-1)
        {
            j1=1;
            j2=nt;
        }
        else
        {
            j1= i-w>1 ? i-w : 1;
            j2= i+w<nt ? i+w : nt;
        }
        for(j=j1;j<=j2;j++)
        {
            cost=vectorDistance(s,t,ns,nt,k,i-1,j-1);
            
            temp=D[i-1][j];
            if(D[i][j-1]!=-1) 
            {
                if(temp==-1 || D[i][j-1]<temp) temp=D[i][j-1];
            }
            if(D[i-1][j-1]!=-1) 
            {
                if(temp==-1 || D[i-1][j-1]<temp) temp=D[i-1][j-1];
            }
            
            D[i][j]=cost+temp;
        }
    }
    
    
    d=D[ns][nt];
   
    for(i=0;i<ns+1;i++)
    {
        free(D[i]);
    }
    free(D);
    
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
  
    dp[0]=dtw_c(s,t,w,ns,nt,k);
    
    return;
    
}
