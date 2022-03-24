#version 450 core
#define PI 3.1415926538

layout(points) in;
layout(triangle_strip, max_vertices = 30) out;


float radius = 0.01; //Radius of circles
layout(location = 2) uniform float u_division; //Number of circle division per particle
out vec4 positionOut;

void main(void) {
    float difference = 2 * PI / 24;
    //radius = radius / gl_in[0].gl_Position.z;
    for (float i = 0; i < 24; i++) {
        gl_Position = gl_in[0].gl_Position + vec4(radius * cos(difference * i), radius * sin(difference * i), 0, 0);
        EmitVertex();

     
        gl_Position = gl_in[0].gl_Position + vec4(radius * cos(difference * i), radius * sin(difference * i) * -1, 0, 0);
        EmitVertex();
    }
    EndPrimitive();
}