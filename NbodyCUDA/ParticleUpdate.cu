
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "Particle.h"

#include <math.h>



__device__ float vecMag(glm::vec3 a) {
    return sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]);
}

__device__ glm::vec3 unitVec(glm::vec3 a) {
    return a / vecMag(a);
}



__global__ void solve(glm::vec3* cPos, glm::vec3* pPos, glm::vec3* nPos, float* mass, float dt, unsigned int _n, float softening = 0.01) {
    float G = 1;
    int index = threadIdx.x * blockIdx.x;
    for (int i = 0; i<int(_n); i++) {
        glm::vec3 distance = cPos[i] - cPos[index];

    }


}










void particleSystem::updateSystem(float dt) {
    
    //Set up GPU
    glm::vec3* gpuPPos;
    glm::vec3* gpuNPos;
    glm::vec3* gpuCPos;
    float* mass;
   
    cudaSetDevice(0);
    
    //Allocate memory
    cudaMalloc((void**)gpuCPos, n * 3 * sizeof(float));
    cudaMalloc((void**)gpuPPos, n * 3 * sizeof(float));
    cudaMalloc((void**)gpuNPos, n * 3 * sizeof(float));
    
    //Set Values
    cudaMemcpy(gpuCPos, &currentPosition[0], n * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    cudaMemcpy(gpuPPos, &previousPosition[0], n * sizeof(glm::vec3), cudaMemcpyHostToDevice);
    
    solve <<<1, n>>>(gpuCPos, gpuPPos, gpuNPos, mass, dt, n);
    
    cudaDeviceSynchronize(); //Wait for processes to finish
    
    std::copy(&previousPosition.begin(), &previousPosition.end(), &currentPosition.begin()); //current position is now previousPosition
    cudaMemcpy(&currentPosition, gpuNPos, n * sizeof(glm::vec3), cudaMemcpyDeviceToHost);

    return;
}