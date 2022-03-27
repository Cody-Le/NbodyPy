#include "Particle.h"
#include <random>

// Function to initialize the particle system

particleSystem::particleSystem(unsigned int _n,  glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 iMassRange, float dt) {
	n = _n;
	std::random_device rd;
	
	//Create "machine" that could generate random number within certain range
	std::mt19937 generator(rd());
	std::uniform_real_distribution<float> randomMass(iMassRange.x, iMassRange.y);
	std::uniform_real_distribution<float> randomPos(iPosRange.x, iPosRange.y);
	std::uniform_real_distribution<float> randomVel(iVelRange.x, iVelRange.y);

	for (unsigned int i = 0; i < n; i++) {
		glm::vec3 position;
		glm::vec3 prev_position;

		float pos = randomPos(generator);
		position.x = pos;
		prev_position.x = pos - randomVel(generator) * dt;//Using previous position instead of velocity to reduce error via the verlet algorithm

		float pos = randomPos(generator);
		position.y = pos;
		prev_position.y = pos - randomVel(generator) * dt;//Using previous position instead of velocity to reduce error via the verlet algorithm
		float pos = randomPos(generator);
		position.z = pos;
		prev_position.z = pos - randomVel(generator) * dt;//Using previous position instead of velocity to reduce error via the verlet algorithm

		currentPosition.push_back(position);
		previousPosition.push_back(prev_position);
		mass.push_back(randomMass(generator));

	}
}