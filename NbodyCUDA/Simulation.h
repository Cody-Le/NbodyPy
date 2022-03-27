#pragma once
#
#include "Particle.h"
#include "Renderer.h"




//Ties the particle aspect with the renderer aspect
class simulation { 
public:
	unsigned int n;
	unsigned int width;
	unsigned int height;
	float dt;
	
	particleSystem world;
	renderer Engine;
	
	void runLoop(); //Function to run the main thing

	simulation(unsigned int n, glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 mRange);
private:
	
	
};
