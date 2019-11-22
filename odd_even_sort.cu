#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>

using namespace std;
#define N 10

#define intswap(A,B) {int temp=A;A=B;B=temp;}

__global__ void sort(int *c,int *count)
{
    int l;
    if(*count%2==0)
          l=*count/2;
    else
         l=(*count/2)+1;
    for(int i=0;i<l;i++)
    {
            if((!(threadIdx.x&1)) && (threadIdx.x<(*count-1)))  //even phase
            {
                if(c[threadIdx.x]>c[threadIdx.x+1])
                  intswap(c[threadIdx.x], c[threadIdx.x+1]);
            }

            __syncthreads();
            if((threadIdx.x&1) && (threadIdx.x<(*count-1)))     //odd phase
            {
                if(c[threadIdx.x]>c[threadIdx.x+1])
                  intswap(c[threadIdx.x], c[threadIdx.x+1]);
            }
            __syncthreads();
    }//for

}



int main()
{int a[N],b[N],n;
    printf("enter size of array");
    scanf("%d",&n);
    if (n > N) {printf("too large!\n"); return 1;}
    printf("enter the elements of array");
  for(int i=0;i<n;i++)
  {
    scanf("%d",&a[i]);
  }
  printf("ORIGINAL ARRAY : \n");
  for(int i=0;i<n;i++)
          {

          printf("%d ",a[i]);
          }
  int *c,*count;
  cudaMalloc((void**)&c,sizeof(int)*N);
  cudaMalloc((void**)&count,sizeof(int));
  cudaMemcpy(c,&a,sizeof(int)*N,cudaMemcpyHostToDevice);
  cudaMemcpy(count,&n,sizeof(int),cudaMemcpyHostToDevice);
  sort<<< 1,n >>>(c,count);
  cudaMemcpy(&b,c,sizeof(int)*N,cudaMemcpyDeviceToHost);
  printf("\nSORTED ARRAY : \n");
  for(int i=0;i<n;i++)
      {
         printf("%d ",b[i]);
      }

  printf("\n");
}
