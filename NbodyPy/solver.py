import numpy as np
import math
G = 0.01;

print(G)


def S_classPython(particleSystem):
    n = particleSystem.n;
    newPos = np.zeros(particleSystem.currPosition.shape)
    for i in range(0,n):
        a = [0, 0]
        for o in range(0, n):
            if o != i:
                r = [0,0]

                r[0] = particleSystem.currPosition[o][0] - particleSystem.currPosition[i][0] #Calculate distance on x axis
                r[1] = particleSystem.currPosition[o][1] - particleSystem.currPosition[i][1] #Calculate distance on y axis
                magnitude = math.sqrt(r[0] * r[0] + r[1] * r[1])

                a[0] += particleSystem.mass[o] * G * r[0]/(magnitude * magnitude * magnitude)
                a[1] += particleSystem.mass[o] * G * r[1] / (magnitude * magnitude * magnitude)
        newPos[i][0] = 2 * particleSystem.currPosition[i][0] - particleSystem.prevPosition[i][0] + a[0] * \
                       particleSystem.dt ** 2
        newPos[i][1] = 2 * particleSystem.currPosition[i][1] - particleSystem.prevPosition[i][1] + a[
            1] * particleSystem.dt ** 2

    particleSystem.prevPosition = particleSystem.currPosition
    particleSystem.currPosition = newPos



