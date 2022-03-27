#pragma once

#include "Libraries.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


class particleSystem {
public:
	unsigned int n;
	unsigned int dt;
	float* currentPosition;
	float* previousPosition;
	std::vector<float> mass;
	cudaError_t updateSystem(float dt);
	particleSystem(unsigned int n, glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 iMassRange, float dt);

private:

};