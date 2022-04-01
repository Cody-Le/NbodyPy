#pragma once
#include "Renderer.h"
class vertexBuffer {
public:
	unsigned int vbo;
	unsigned int bufferID = 1;
	int sizeBytes = NULL;
	void loadData(float* data, int sizeBytes);
	void updateData(float* data);
	vertexBuffer();
};