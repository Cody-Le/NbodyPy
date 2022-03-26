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
    /* Make the window's context current */
    glfwMakeContextCurrent(window);
}


void renderer::initData(float* data, int sizeBytes) {
    VBO.loadData(data, sizeBytes);
    initDataYet = true;
}


void renderer::displayFrame(float* data) {
    assert(!glfwWindowShouldClose(window));
    assert(initDataYet);
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