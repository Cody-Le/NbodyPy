
from solver import *
from particle import particleSystemCP, particleSystem
from renderer import PyGame_Renderer
from copy import deepcopy
import time
import datetime
import numpy as np
import pandas as pd




def update(self):
    pass




#Any experiment is carried out here
if __name__ == "__main__":
    world = particleSystemCP(1000, 1)
    world.simpleRandom_Init([-10,10],[-0,0], [100,100])
    world2 = deepcopy(world)
    timeLim = 10
    data = np.zeros((timeLim, 2))


    for f in range(0, timeLim):
        start = datetime.datetime.now()
        S_cupyTotal(world)


        end = datetime.datetime.now()
        delta = end - start
        msTime = delta.total_seconds() * 1000
        data[f, 0] = f
        data[f, 1] = msTime

    table = pd.DataFrame(data)
    #table.to_csv("./S_CupyPartial1.csv")
    print(table)





    pass