from PIL import Image
import pygame

import os

import struct

import numpy as np
import time

import sys,array,fcntl
from threading import Thread


def MyThread (device):
    print "start capturing"
    command = "(stty raw; cat > buffer.txt) < " + device
    print command
    os.system(command)

width = 1000
height = 1246

line = 0
lastline = 0

size = [width, height]
screen = pygame.display.set_mode(size)

print sys.argv[1]
thread = Thread(target = MyThread, args = [str(sys.argv[1])])
thread.start()

time.sleep(1)

pygame.display.set_caption("Otter x-ray")

WHITE = (255, 255, 255)

done = False

screen.fill(WHITE)
pygame.display.flip()

clock = pygame.time.Clock()

while not done:
# This limits the while loop to a max of 10 times per second.
    # Leave this out and we will use all CPU we can.
    clock.tick(30)

    f = open("buffer.txt", "rb" )
    array = np.fromfile(f, dtype=np.uint8)

    line = array.size / height

    if lastline is not line:
        for x in xrange(lastline-1, line-1):
            for y in xrange(height/2):
                grey = array[(1246*x)+y*2]
                screen.set_at((x, y), (grey, grey, grey))

            for y in xrange(height/2, height):
                grey = array[(1246*x)+y*2+1]
                screen.set_at((x, y), (grey, grey, grey))

    lastline = line;

    for event in pygame.event.get(): # User did something
        if event.type == pygame.QUIT: # If user clicked close
            done=True # Flag that we are done so we exit this loop

    pygame.display.flip()

# Be IDLE friendly
pygame.quit()
