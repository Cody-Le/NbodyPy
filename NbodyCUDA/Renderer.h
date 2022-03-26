#pragma once
#include <string>
#include <GLFW/glfw3.h>
#include "VertexBuffer.h"

class renderer {
public:
	void setWindowTitle(std::string title);
	void initData(float* data, int sizeBytes);
	void displayFrame(float* data);
private:
	GLFWwindow* window;
	std::string windowTitle = "Simulation";
	vertexBuffer VBO;
	bool initDataYet = false;
	renderer(int _width,
		int _height);
	int width, height;
	~renderer();
};