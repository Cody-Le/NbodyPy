#include "VertexBuffer.h"



vertexBuffer::vertexBuffer() {
	glGenBuffers(1, &vbo);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	glVertexAttribPointer(bufferID, 3, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(bufferID);

};


void vertexBuffer::loadData(float* data, int sizeBytes) {
	glBufferData(GL_ARRAY_BUFFER, sizeBytes, data, GL_DYNAMIC_DRAW);
}

void vertexBuffer::updateData(float* data) {
	assert(sizeBytes != NULL);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeBytes, data);
}
