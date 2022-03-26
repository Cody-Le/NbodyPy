#pragma once
#include <GLFW/glfw3.h>
#include <assert.h>
class vertexBuffer {
public:
	GLuint vbo;
	int bufferID = 1;
	int sizeBytes = NULL;
	void loadData(float* data, int sizeBytes);
	void updateData(float* data);
	vertexBuffer();
private:
	
	
};