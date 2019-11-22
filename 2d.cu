#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>

using namespace std;

__global__ void colonel(int *a_d){
	//std::cout<<"\nHello Cuda"; //cannot be used in global device
	// *a_d = 2;
	printf("\nblockIdx.x: %d\tblockIdx.y: %d\ttheradIdx.x: %d\tthreadIdx.y: %d",blockIdx.x,blockIdx.y,threadIdx.x,threadIdx.y);

	// cout << "Block ID - " << blockIdx.x << " " << blockIdx.y << " " << blockIdx.z << "\	n";
	// cout << "Thread ID - " << threadIdx.x << " " << threadIdx.y << " " << threadIdx.z << "\n";

}

int main(){
	int a = 0, *a_d;
	cudaMalloc((void**) &a_d, sizeof(int));
	cudaMemcpy(a_d, &a, sizeof(int), cudaMemcpyHostToDevice);

	dim3 grid(2, 1, 0);
	dim3 block(1, 2, 0);

	colonel<<<grid, block>>>(a_d);

	cudaMemcpy(&a, a_d, sizeof(int), cudaMemcpyDeviceToHost);

	cout<<"\na = "<<a<<endl;
	cudaFree(a_d);
}
