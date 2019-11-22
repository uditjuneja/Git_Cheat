#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>
#define N 10

using namespace std;

__global__ void mul(int* a_d, int n){
	// printf("%d %d %d\n", blockIdx.x,blockDim.x,threadIdx.x);
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if(index < n){
		a_d[index] *= 5; 
	}
}

int main(){
	cudaEvent_t start, stop;

  	cudaEventCreate(&start);
  	cudaEventCreate(&stop);

	int *a, *a_d;
	
	int size = N * sizeof(int);
	
	a = (int*) malloc(size);
	
	cout << "Enter " << N << " numbers: "; 
	for(int i=0; i<N; i++){
		cin>>a[i];
	}
	
	cudaMalloc(&a_d, size);
	cudaMemcpy(a_d, a, size, cudaMemcpyHostToDevice);
	
	cudaEventRecord(start);
	mul<<<1,10>>>(a_d,N);
	cudaDeviceSynchronize();
	cudaEventRecord(stop);

	cudaMemcpy(a, a_d, size, cudaMemcpyDeviceToHost);

	cout<<"Matrix After Multiplying:\n";
	for(int i=0; i<N; i++){
		cout<<a[i]<<" ";
	}

	float millis = 0;
  	cudaEventElapsedTime(&millis, start, stop);
  	cout << "\nElasped Time: " << millis << endl;

	return 0;
}
