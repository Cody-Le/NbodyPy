#pragma once

#include "glm.hpp"

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


private:

	particleSystem(unsigned int n, glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 iMassRange, float dt);



};