import numpy as np
import cupy as cp
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
                print(r)

                a[0] += particleSystem.mass[o] * G * r[0]/(magnitude * magnitude * magnitude)
                a[1] += particleSystem.mass[o] * G * r[1] / (magnitude * magnitude * magnitude)
        newPos[i][0] = 2 * particleSystem.currPosition[i][0] - particleSystem.prevPosition[i][0] + a[0] * \
                       particleSystem.dt ** 2
        newPos[i][1] = 2 * particleSystem.currPosition[i][1] - particleSystem.prevPosition[i][1] + a[
            1] * particleSystem.dt ** 2

    particleSystem.prevPosition = particleSystem.currPosition
    particleSystem.currPosition = newPos


def S_classPythonCP(particleSystemCP):
    n = particleSystemCP.n;
    newPos = cp.zeros(particleSystemCP.currPosition.shape)
    for i in range(0,n):
        a = [0, 0]
        for o in range(0, n):
            if o != i:
                r = cp.array([0,0])

                r[0] = particleSystemCP.currPosition[o][0] - particleSystemCP.currPosition[i][0] #Calculate distance on x axis
                r[1] = particleSystemCP.currPosition[o][1] - particleSystemCP.currPosition[i][1] #Calculate distance on y axis
                magnitude = math.sqrt(r[0] * r[0] + r[1] * r[1])
                print(r)

                a[0] += particleSystemCP.mass[o] * G * r[0]/(magnitude * magnitude * magnitude)
                a[1] += particleSystemCP.mass[o] * G * r[1] / (magnitude * magnitude * magnitude)
        newPos[i][0] = 2 * particleSystemCP.currPosition[i][0] - particleSystemCP.prevPosition[i][0] + a[0] * \
                       particleSystemCP.dt ** 2
        newPos[i][1] = 2 * particleSystemCP.currPosition[i][1] - particleSystemCP.prevPosition[i][1] + a[
            1] * particleSystemCP.dt ** 2

    particleSystemCP.prevPosition = particleSystemCP.currPosition
    particleSystemCP.currPosition = newPos



def S_numpyPartial(particleSystem):
    n = particleSystem.n
    newPos = np.zeros(particleSystem.currPosition.shape)
    for i in range(0, n):
        r = np.zeros(newPos.shape)
        r[:,0] = particleSystem.currPosition[:,0] - particleSystem.currPosition[i][0]
        r[:, 1] = particleSystem.currPosition[:, 1] - particleSystem.currPosition[i][1]
        rMag = np.sqrt(r[:,0] * r[:,0] + r[:,1] * r[:,1])

        rUnit = np.zeros(r.shape)
        rUnit[:,0] = r[:,0]/rMag
        rUnit[:,1] = r[:,1]/rMag


        r = 0


        a = G * np.transpose(np.vstack((particleSystem.mass, particleSystem.mass))) * rUnit/np.transpose(np.vstack((rMag* rMag, rMag * rMag)))

        a = np.delete(a, i, 0)

        aSum = np.sum(a, axis = 0)
        newPos[i] = 2 * particleSystem.currPosition[i] - particleSystem.prevPosition[i] + aSum *  np.square(particleSystem.dt)


    particleSystem.prevPosition = particleSystem.currPosition
    particleSystem.currPosition = newPos

def S_cupyPartial(particleSystemCP):
    n = particleSystemCP.n
    newPos = cp.zeros(particleSystemCP.currPosition.shape)
    for i in range(0, n):
        r = cp.zeros(newPos.shape)
        r[:,0] = particleSystemCP.currPosition[:,0] - particleSystemCP.currPosition[i][0]
        r[:, 1] = particleSystemCP.currPosition[:, 1] - particleSystemCP.currPosition[i][1]
        rMag = cp.sqrt(r[:,0] * r[:,0] + r[:,1] * r[:,1])

        rUnit = cp.zeros(r.shape)
        rUnit[:,0] = r[:,0]/rMag
        rUnit[:,1] = r[:,1]/rMag


        r = 0


        a = G * np.transpose(cp.vstack((particleSystemCP.mass, particleSystemCP.mass))) * rUnit/np.transpose(cp.vstack((rMag* rMag, rMag * rMag)))

        a[i,0] = 0
        a[i,1] = 0

        aSum = cp.sum(a, axis = 0)
        newPos[i] = 2 * particleSystemCP.currPosition[i] - particleSystemCP.prevPosition[i] + aSum *  cp.square(particleSystemCP.dt)


    particleSystemCP.prevPosition = particleSystemCP.currPosition
    particleSystemCP.currPosition = newPos


def S_numpyTotal(particleSystem):

    #acceleration calculation
    n = particleSystem.n
    repPos = np.repeat(particleSystem.currPosition, n, 0)
    tilePos = np.tile(particleSystem.currPosition, [n, 1])

    r = tilePos - repPos
    rMag = np.sqrt(np.sum(r * r, axis = 1))[:, np.newaxis]
    rUnit = r/rMag
    r = 0
    tileMass = np.tile(particleSystem.mass, n)[:,np.newaxis]
    tileAccel = G* tileMass * rUnit/(rMag * rMag)
    nanLessA = np.delete(tileAccel, np.arange(0,n) * n + np.arange(0,n), axis = 0).reshape(n, n-1 , 2)
    a = np.sum(nanLessA, axis = 1)
    #next position
    newPos = 2 * particleSystem.currPosition - particleSystem.prevPosition + a*np.square(particleSystem.dt)
    particleSystem.prevPosition = particleSystem.currPosition
    particleSystem.currPosition = newPos
    pass

def S_cupyTotal(particleSystemCP):

    #acceleration calculation
    n = particleSystemCP.n
    repPos = cp.repeat(particleSystemCP.currPosition, n, 0)
    tilePos = cp.tile(particleSystemCP.currPosition, [n, 1])

    r = tilePos - repPos
    rMag = cp.sqrt(cp.sum(r * r, axis = 1))[:, cp.newaxis]
    rUnit = r/rMag
    r = 0
    tileMass = cp.tile(particleSystemCP.mass, n)[:,cp.newaxis]
    tileAccel = G* tileMass * rUnit/(rMag * rMag)
    zeroIndex = np.arange(0,n) * n + np.arange(0,n)
    tileAccel[zeroIndex, :] = 0
    A = tileAccel.reshape(n, n, 2)
    a = cp.sum(A, axis = 1)
    #next position
    newPos = 2 * particleSystemCP.currPosition - particleSystemCP.prevPosition + a*cp.square(particleSystemCP.dt)
    particleSystemCP.prevPosition = particleSystemCP.currPosition
    particleSystemCP.currPosition = newPos
    pass