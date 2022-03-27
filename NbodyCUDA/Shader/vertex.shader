#version 450 core
layout(location = 0) in vec4 position;
uniform mat4 projection;
uniform mat4 view;
out float radiusScale;


void main(){
	gl_Position = position * projection * view;
	radiusScale = position.z;

}
