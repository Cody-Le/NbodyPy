


//Modifed version of simple CUDA nbody simulation from github



#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include "timer.h"

#define BLOCK_SIZE 256
#define SOFTENING 1e-9f

typedef struct { float x, y, vx, vy; } Body;


void randomizeBodies(float* data, int n) {
    for (int i = 0; i < n; i++) {
        data[i] = 2.0f * (rand() / (float)RAND_MAX) - 1.0f;
    }
}

__global__
void bodyForce(Body* p, float dt, int n) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < n) {
        float Fx = 0.0f; float Fy = 0.0f;

        for (int j = 0; j < n; j++) {
            float dx = p[j].x - p[i].x;
            float dy = p[j].y - p[i].y;
          
            float distSqr = dx * dx + dy * dy + SOFTENING;
            float invDist = sqrt(distSqr);
            float invDist3 = invDist * invDist * invDist;

            Fx += dx * invDist3; Fy += dy * invDist3; 
        }

        p[i].vx += dt * Fx; p[i].vy += dt * Fy;
    }
}

int main(const int argc, const char** argv) {

    int nBodies = 1000;
    if (argc > 1) nBodies = atoi(argv[1]);

    const float dt = 0.01f; // time step
    const int nIters = 2000;  // simulation iterations

    int bytes = nBodies * sizeof(Body);
    float* buf = (float*)malloc(bytes);
    Body* p = (Body*)buf;

    randomizeBodies(buf, 4 * nBodies); // Init pos / vel data

    float* d_buf;
    cudaMalloc(&d_buf, bytes);
    Body* d_p = (Body*)d_buf;

    int nBlocks = (nBodies + BLOCK_SIZE - 1) / BLOCK_SIZE;
    double totalTime = 0.0;

    for (int iter = 1; iter <= nIters; iter++) {
        StartTimer();

        cudaMemcpy(d_buf, buf, bytes, cudaMemcpyHostToDevice);
        bodyForce << <nBlocks, BLOCK_SIZE >> > (d_p, dt, nBodies); // compute interbody forces
        cudaMemcpy(buf, d_buf, bytes, cudaMemcpyDeviceToHost);

        for (int i = 0; i < nBodies; i++) { // integrate position
            p[i].x += p[i].vx * dt;
            p[i].y += p[i].vy * dt;
      
        }

        const double tElapsed = GetTimer() / 1000.0;
        if (iter > 1) { // First iter is warm up
            totalTime += tElapsed;
        }
#ifndef SHMOO
        printf("Iteration %d: %.3f seconds\n", iter, tElapsed);
#endif
    }
    double avgTime = totalTime / (double)(nIters - 1);

#ifdef SHMOO
    printf("%d, %0.3f\n", nBodies, 1e-9 * nBodies * nBodies / avgTime);
#else
    //printf("Average rate for iterations 2 through %d: %.3f +- %.3f steps per second.\n",nIters, rate);
    printf("%d Bodies: average %0.3f Billion Interactions / second\n", nBodies, 1e-9 * nBodies * nBodies / avgTime);
#endif
    free(buf);
    cudaFree(d_buf);
}

