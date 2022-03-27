#include "Renderer.h"



renderer::renderer(int width, int height) {
    /* Initialize the library */
    if (!glfwInit())
        glfwTerminate();
    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(width, height, const_cast<char* >(windowTitle.c_str()), NULL, NULL);
    if (!window)
    {
        glfwTerminate();
    }
    initShader(); //Initalize and load the shaders
    perspectiveMatrix = glm::perspective(float(45), float((width/height)), float(1), float(150));
    viewMatrix = glm::lookAt(glm::vec3(0, 0, 10), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));
    /* Make the window's context current */
    glfwMakeContextCurrent(window);
}


void renderer::initShader() {
    std::string vs = readShader("D:/Projects/NbodyCUDA/NbodyCUDA/Shader/vertex.shader");
    std::string fs = readShader("D:/Projects/NbodyCUDA/NbodyCUDA/Shader/fragment.shader");
    std::string gs = readShader("D:/Projects/NbodyCUDA/NbodyCUDA/Shader/mesh.shader");

    shader = createShader(vs, fs, gs);
}
void renderer::initData(float* data, int sizeBytes) {
    VBO.loadData(data, sizeBytes);
    initDataYet = true;
}

void renderer::setCamera(glm::vec3 position, glm::vec3 target) {
    viewMatrix = glm::lookAt(position, target, glm::vec3(0, 1, 0));
}

void renderer::setUniformMat4(char* name, glm::mat4 data) {
    int location = glGetUniformLocation(shader, name);
    assert(location != -1);
    glUniformMatrix4fv(location, 1, GL_FALSE, &data[0][0]);


}
void renderer::setUniformFloat(char* name, float data) {
    int location = glGetUniformLocation(shader, name);
    assert(location != -1);
    glUniform1f(location, data);


}




void renderer::displayFrame(float* data) {
    assert(!glfwWindowShouldClose(window));
    assert(initDataYet);

    setUniformMat4("projection", perspectiveMatrix);
    setUniformMat4("view", viewMatrix);


    glUseProgram(shader);
    glClear(GL_COLOR_BUFFER_BIT);
    glDrawArrays(GL_POINTS, 0, VBO.sizeBytes);
    /* Swap front and back buffers */
    glfwSwapBuffers(window);
    /* Poll for and process events */
    glfwPollEvents();
}


renderer::~renderer() {
    glfwTerminate();
}