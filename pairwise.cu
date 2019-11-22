#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;

// #define N 10

__global__ void addPair(int *dev_vec, int *N)
{
	int index = 2 * threadIdx.x;

	if (index + 1  < *N)
	{
		int sum = dev_vec[index] + dev_vec[index + 1];
		// cout << "A[" << index << "] + A[" << index + 1 << "] = " << sum << endl;
		printf("A[%d] + A[%d] = %d\n", index, index + 1, sum );
	}
}

int main()
{
	int *vec, *dev_vec, *n_c, N = 10;
	
	int size = N * sizeof(int);
	
	vec = (int*)malloc(size);

	cout << "Enter 10 elements";
	
	for(int i = 0; i < N; i++)
	{
		cin >> vec[i];
	}

	cudaMalloc(&dev_vec, size);

	cudaMalloc(&n_c, sizeof(int));
	
	cudaMemcpy(dev_vec, vec, size, cudaMemcpyHostToDevice);

	cudaMemcpy(n_c, &N, sizeof(int), cudaMemcpyHostToDevice);	

	addPair<<<5,2>>>(dev_vec, n_c);

	cudaMemcpy(vec, dev_vec, size, cudaMemcpyDeviceToHost);

	cudaDeviceSynchronize();

	return 0;
}