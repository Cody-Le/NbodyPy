#pragma once

#include "Particle.h"
#include "Renderer.h"




//Ties the particle aspect with the renderer aspect
class simulation { 
public:
	unsigned int n;
	unsigned int width;
	unsigned int height;


private:
	simulation(unsigned int n);

};
