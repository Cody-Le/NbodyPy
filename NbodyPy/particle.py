import numpy as np



class particleSystem():
    def __init__(self,n, dt):
        self.n = n
        self.dt = dt
        self.currPosition = np.zeros((n,2)) #2 is the number of dimensions
        self.prevPosition = np.zeros((n, 2)) #previous position is neccesary for calculating the position using the efficient verlet algorithm
        self.mass = np.zeros((n,))
    def simpleRandom_Init(self, posRange, velRange, massRange):
        self.currPosition = np.random.uniform(posRange[0], posRange[1], size = (self.n,2)) #in AU
        velocity = np.random.uniform(velRange[0], velRange[1], size = (self.n,2))#in km
        self.prevPosition = self.currPosition - velocity  * self.dt
        self.mass = np.random.uniform(massRange[0], massRange[1], size = (self.n,))

    def addParticle(self, position, velocity, mass):
        self.n += 1
        np.append(self.currPosition, position)
        np.append(self.prevPosition, velocity * self.dt)
        np.append(self.mass, mass)
