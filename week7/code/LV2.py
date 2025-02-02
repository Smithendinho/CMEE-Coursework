#!/usr/bin/env python3

import numpy as np
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys

r = float(sys.argv[1])
a = float(sys.argv[2])
z = float(sys.argv[3])
e = float(sys.argv[4])
K = float(sys.argv[5])


def dCR_dt(pops, t = 0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1-(R/K)) - a * R * C
    dCdt = -z * C + e * a * R * C

    return np.array([dRdt, dCdt])

#r = 1. # growth rate
#a = 0.1 # search rate for the resource multiplied by attack success probability
#z = 1.5 # mortality rate
#e = 0.75 # 
#K = 100 # carrying capacity

t = np.linspace(0,15,1000)

R0 = 10
C0 = 5
RC0 = np.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics\n' + 'r = ' + str(r) + ', a = ' + str(a) + ', z = ' + str(z) + ', e = ' + str(e) + ', K = ' + str(K))
p.show()# To display the figure
f1.savefig('../results/LV2_plot1.pdf') #Save figure

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], 'r-')
p.grid()
p.xlabel('Resource density')
p.ylabel('Consumer density')
p.title('Consumer-Resource population dynamics')
p.show()
f2.savefig('../results/LV2_plot2.pdf')