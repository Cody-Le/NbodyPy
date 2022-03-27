#include "Simulation.h"





simulation::simulation(unsigned int n, glm::vec2 iPosRange, glm::vec2 iVelRange, glm::vec2 mRange) {
	width = 800;
	height = 800;
	n = n;

	world = particleSystem(n, iPosRange, iVelRange, mRange, 0.01);
	Engine = renderer(800, 800);
	Engine.initData(&world.currentPosition[0].x, int(n * sizeof(glm::vec3)));
	
	
}


void simulation::runLoop() {
	
	Engine.displayFrame(&world.currentPosition[0].x);
	world.updateSystem(dt);
}

