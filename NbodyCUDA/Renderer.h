#pragma once
#include <string>
#include "VertexBuffer.h"
#include "Shader_load.h"
#include "glm.hpp"
#include "Libraries.h"
class renderer {
public:
	void setWindowTitle(std::string title);
	void initData(float* data, int sizeBytes);
	void displayFrame(float* data);
	void setCamera(glm::vec3 position, glm::vec3 target);
	renderer(int _width,
		int _height);
	~renderer();
private:
	GLFWwindow* window;
	std::string windowTitle = "Simulation";
	vertexBuffer VBO;
	GLuint shader; //variable to shader
	bool initDataYet = false; //Check if the data is pushed to the vertex buffer before rendering

	void initShader();
	void setUniformMat4(char* name, glm::mat4 data);
	void setUniformFloat(char* name, float data);

	glm::mat4 perspectiveMatrix;
	glm::mat4 viewMatrix;




	
	int width, height;
	
};