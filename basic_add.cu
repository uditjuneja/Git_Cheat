#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
using namespace std;

__global__ void add(int x, int y, int* sum){
	*sum = x + y;
	printf("BlockID: %d\tThread ID: %d\tSum is %d\n",blockIdx.x,threadIdx.x,*sum);
}

int main(){
	int a, b, sum=0;
	int *sumd;
	cout<<"\nEnter A: "; cin>>a;
	cout<<"\nEnter B: "; cin>>b;
	
	cudaMalloc(&sumd, sizeof(int));
	cudaMemcpy(sumd, &sum, sizeof(int), cudaMemcpyHostToDevice);
	add<<<5,2>>>(a, b, sumd);
	cudaMemcpy(&sum, sumd, sizeof(int), cudaMemcpyDeviceToHost);
	cout<<"\nSum is "<<sum<<endl;
	return 0;
}
