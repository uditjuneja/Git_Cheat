#include<stdio.h>
#define N 8
#define intswap(A,B) {int temp=A;A=B;B=temp;}
__global__ void sort(int *c)
{
 __shared__ int shared[N];
 int i = threadIdx.x;
 shared[i] = c[i];
 __syncthreads();
 for(int k=2;k<=8;k*=2){
 for(int j=k/2;j>0;j/=2){
 int xorres = i^j;

 if(xorres>i){
 if((i&k) == 0){
 if(shared[i]>shared[xorres])
 intswap(shared[i],shared[xorres]);
 }

 else{
 if(shared[i]<shared[xorres])
 intswap(shared[i],shared[xorres]);
 }
 }

 __syncthreads();
 }
 }
 c[i] = shared[i];
}
int main(){
 int a[N] = {6,1,2,5,3,4,7,9};
 int b[N];
 int n = N;
 printf("ORIGINAL ARRAY : \n");
 for(int i=0;i<n;i++)
 printf("%d ",a[i]);
 int *c;
 cudaMalloc((void**)&c,sizeof(int)*N);
 cudaMemcpy(c,&a,sizeof(int)*N,cudaMemcpyHostToDevice);
 sort<<< 1,N >>>(c);
10
 cudaMemcpy(b,c,sizeof(int)*N,cudaMemcpyDeviceToHost);
 printf("\nSORTED ARRAY : \n");
 for(int i=0;i<N;i++)
 printf("%d ",b[i]);
 printf("\n");
 cudaFree(c);
}
