#File for rendering point with Pygame
import pygame

#from matplotlib.animation import FuncAnimation
import numpy as np




class PyGame_Renderer():
    def __init__(self):
        pygame.init()
        pygame.display.set_caption('Pygame Renderer')
        window_surface = pygame.display.set_mode((800,800))
        background = pygame.Surface((800,800))
        background.fill(pygame.Color('#000000'))
        frameMatrix = np.zeros((800,800))
    def makeImage(self, pointList):
        pass #point list will be transfer into the frame matrix

    def display(self):
        pass



class PyGlet_Renderer():
    def __init__(self, height, width, scale):
        pass



"""

class MPL_Renderer():
    def __init__(self, width, height, scale):
        self.fig, self.ax = plt.subplots()
        self.particles = np.array([[]]);
        self.ln, = plt.plot([], [], 'ro')
        self.scale = scale

    def setScale(self, scale):
        self.scale = scale


    def updatePoint(self):
        print("Function 'updatePoint(self)' need to be redefine out of when define the renderer")

    def initFrame(self):
        return self.ln,

    def updateFrame(self):
        self.updatePoint();

        return self.ln,
    def run(self):
        #ani = FuncAnimation(self.fig, self.updateFrame, blit=True);
        plt.show();




"""