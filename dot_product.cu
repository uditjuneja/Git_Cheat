#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;

__global__ void func(int *dev_arr1, int *dev_arr2, int *dev_dot){
  __shared__ int temp[3];
  int index = threadIdx.x;
  if (index < 3){
    temp[index] = dev_arr1[index] * dev_arr2[index];
  }
  __syncthreads();
  if (index == 0){
    *dev_dot = temp[0] + temp[1] + temp[2];
  }
}

int main(){
  cudaEvent_t start, stop;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  int *arr1, *arr2, *dot;
  int *dev_arr1, *dev_arr2, *dev_dot;

  int size = 3 * sizeof(int); // i j k
  
  arr1 = (int*) malloc(size);
  arr2 = (int*) malloc(size);
  dot = (int*) malloc(sizeof(int));

  cudaMalloc(&dev_arr1, size);
  cudaMalloc(&dev_arr2, size);
  cudaMalloc(&dev_dot, sizeof(int));


  cout << "Enter values of x, y, z. Vector1: xi + yj + zk: ";
  cin>>arr1[0]>>arr1[1]>>arr1[2];
  cout << "Enter values of x, y, z. Vector2: xi + yj + zk: ";
  cin>>arr2[0]>>arr2[1]>>arr2[2];


  cudaMemcpy(dev_arr1, arr1, size, cudaMemcpyHostToDevice);
  cudaMemcpy(dev_arr2, arr2, size, cudaMemcpyHostToDevice);
  cudaMemcpy(dev_dot, dot, sizeof(int), cudaMemcpyHostToDevice);


  cudaEventRecord(start);
  func<<<1,3>>>(dev_arr1, dev_arr2, dev_dot);
  cudaEventRecord(stop);

  cudaMemcpy(dot, dev_dot, sizeof(int), cudaMemcpyDeviceToHost);

  cudaDeviceSynchronize();

  cout << "Dot product is: " << *dot << endl;

  float millis = 0;
  cudaEventElapsedTime(&millis, start, stop);
  cout << "Elasped Time: " << millis << endl; 
  return 0;
}