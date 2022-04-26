
from solver import S_classPython
from particle import particleSystem
import time
import pandas


#Any experiment is carried out here
if __name__ == "__main__":
    world = particleSystem(1000, 1)
    world.simpleRandom_Init([-10,10],[-0,0], [100,100])
    for f in range(0, 10):
        print(world.currPosition)
        S_classPython(world)

        pass


    pass