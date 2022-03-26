#pragma once
#include <string.h>
#include <sstream>
#include "GL/glew.h"
#include "GLFW/glfw3.h"
#include <iostream>
#include <fstream>

std::string readShader(const std::string& filePath) {
    std::ifstream adf(filePath);
    std::stringstream buffer;
    std::string line;
    while (std::getline(adf, line)) {

        buffer << line << "\n";
    }
    return buffer.str();

}
//Procedure needed to be done to compile, link and error handling the initialization of shaders
unsigned int compileShader(const std::string& source, unsigned int type) {
    unsigned int id = glCreateShader(type);
    const char* src = source.c_str();
    glShaderSource(id, 1, &src, nullptr);
    glCompileShader(id);
    //Error handling
    int result;
    glGetShaderiv(id, GL_COMPILE_STATUS, &result);//Get error status
    if (type == GL_VERTEX_SHADER) {
        std::cout << "Compiling a vertex shader at " << source << std::endl;
    }
    else {
        std::cout << "Compiling a fragment shader at " << source << std::endl;
    }
    if (result == GL_FALSE) {
        int length;
        glGetShaderiv(id, GL_INFO_LOG_LENGTH, &length); //Get error string length
        char* message = (char*)_malloca(length * sizeof(char));
        glGetShaderInfoLog(id, length, &length, message); //Set the size of char array then set the value of the array to the message gl wanted to send
        std::cout << "Failed to compiled shader!" << std::endl << message << std::endl;


    }

    return id;
}





int createShader(const std::string& vertexShader, const std::string& fragShader, const std::string& geometryShader) {
    unsigned int program = glCreateProgram();
    unsigned int vs = compileShader(vertexShader, GL_VERTEX_SHADER);
    unsigned int fs = compileShader(fragShader, GL_FRAGMENT_SHADER);
    unsigned int gs = compileShader(geometryShader, GL_GEOMETRY_SHADER);

    glAttachShader(program, vs);
    glAttachShader(program, gs);
    glAttachShader(program, fs);
    glLinkProgram(program);
    glValidateProgram(program);

    glDeleteShader(vs);
    glDeleteShader(gs);
    glDeleteShader(fs);
    return program;
}
