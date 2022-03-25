
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "Particle.h"
#include <stdio.h>
#include <math.h>
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main1()
{
    const int arraySize = 5;
    const int a[arraySize] = { 1, 2, 3, 4, 5 };
    const int b[arraySize] = { 10, 20, 30, 40, 50 };
    int c[arraySize] = { 0 };

    // Add vectors in parallel.
    cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addWithCuda failed!");
        return 1;
    }

    printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
        c[0], c[1], c[2], c[3], c[4]);

    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }

    return 0;
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}



__device__ float vecMag(glm::vec3 a) {
    return sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]);
}

__device__ glm::vec3 unitVec(glm::vec3 a) {
    return a / vecMag(a);
}



__global__ void solve(glm::vec3* cPos, glm::vec3* pPos, glm::vec3* nPos, float* mass, float dt, unsigned int _n, float softening = 0.01) {
    float G = 1;
    int id = threadIdx.x * blockIdx.x;
    int n = int(_n);
    glm::vec3  tAccel = glm::vec3(0.0, 0.0, 0.0);
    for (int i = 0; i < n; i++) {
        if (i != id) {
            glm::vec3 distance = cPos[i] - cPos[id];
            float mag = vecMag(distance);
            glm::vec3 accel = (G * mass[i]/(mag * mag)) * unitVec(distance);
            tAccel += accel;
        }
    }

    nPos[id] = cPos[id] + cPos[id] - pPos[id] + (tAccel * dt * dt);


}











void particleSystem::updateSystem(float dt) {
    //Set up GPU
    glm::vec3* gpuCPos;
    glm::vec3* gpuPPos;
    glm::vec3* gpuNPos;
    float* mass;
   
    cudaSetDevice(0);

    //Allocate memory
    cudaMalloc((void**)gpuCPos, n * sizeof(glm::vec3));
    cudaMalloc((void**)gpuPPos, n * sizeof(glm::vec3));
    cudaMalloc((void**)gpuNPos, n * sizeof(glm::vec3));

    //Set Values
    cudaMemcpy(gpuCPos, &currentPosition[0].x, n * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuPPos, &previousPosition[0].x, n * sizeof(glm::vec3), cudaMemcpyHostToDevice);

    solve <<<1, n>>>(gpuCPos, gpuPPos, gpuNPos, mass, dt, n);
    cudaDeviceSynchronize(); //Wait for processes to finish
    std::copy(currentPosition[0], currentPosition[n], previousPosition); //current position is now previousPosition
    cudaMemcpy(&currentPosition, gpuNPos, n * sizeof(glm::vec3), cudaMemcpyDeviceToHost);

    //
}