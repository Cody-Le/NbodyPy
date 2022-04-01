#pragma once

#include "Libraries.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <vector>

class particleSystem {
public:
	unsigned int n;
	unsigned int dt;
	std::vector<glm::vec3> currentPosition;
	std::vector<glm::vec3> previousPosition;
	std::vector<float> mass;
	void updateSystem(float dt);
	particleSystem(unsigned int n, glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 iMassRange, float dt);
	particleSystem();
private:
	glm::vec2 iMassRange;
	glm::vec2 iPosRange;
	glm::vec2 iVelRange;
};