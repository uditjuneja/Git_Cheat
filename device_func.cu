#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>

using namespace std;

__device__ void print(int a, int b, int sum){
	printf("Printing sum inside DEVICE\n");
	printf("\n%d\t%d + %d = %d", threadIdx.x, a, b, sum);
}

__global__ void add(int *a, int *b, int* sum){
	*sum = *a + *b;
	print(*a, *b, *sum);
}

int main(){
	int *a, *b, *sum;
	cudaMallocManaged(&a, sizeof(int));
	cudaMallocManaged(&b, sizeof(int));
	cudaMallocManaged(&sum , sizeof(int));
	cout<<"Enter A: ";	cin>>*a;
	cout<<"Enter B: ";	cin>>*b;
	add<<<1,10>>>(a,b,sum);
	cudaDeviceSynchronize();
	cout<<"\nPrinting sum in HOST: Sum is "<<*sum<<endl;
	return 0;
}
