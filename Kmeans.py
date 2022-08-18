import matplotlib.pyplot as plt
import numpy as np
import math
import csv

with open('athdata.csv') as f:
    reader = csv.reader(f)
    my_data = list(reader)

def getdata() :
    new_data = []
    for i in range(100):
        if i != 0 :
            if my_data[i][5] != '' :
                if my_data[i][6] != '':
                    new_data.append( [float(my_data[i][5])*50, float(my_data[i][6])] )
    return new_data

def ed(a,b) :

    d0 = float(a[0]) - float(b[0])
    d1 = float(a[1]) - float(b[1])
    d  = d0*d0 + d1*d1
    return d

def edx(a,b) :

    d0 = float(a[0]) - float(b[0])
    d1 = float(a[1]) - float(b[1])
    d  = d0*d0 + d1*d1

    print(d0)
    print(d1)
    print(d)
    print('######################')

    return d

def belongingness(k,a) :
    colors = []
    for i in range(len(a)):
        if ed(k[0],a[i]) < ed(k[1],a[i]):
            if ed(k[0], a[i]) < ed(k[2], a[i]):
                colors.append('red')
            else:
                colors.append('blue')

        else:
            if ed(k[1], a[i]) < ed(k[2], a[i]):
                colors.append('green')
            else:
                colors.append('blue')

    print (a[25])
    print (edx(k[0],a[25]))
    print (edx(k[1],a[25]))
    print (edx(k[2],a[25]))

    return colors


def showscatter():
    ath = getdata()

    ########## first plot ################

    fig1, (a1,a2) = plt.subplots(2, 1)
    for i in range(len(ath)):
        a1.scatter(ath[i][0],ath[i][1], s=4 , c = 'blue')

    k_means = [ ath[10], ath[20], ath[30] ]  ##### r,g,b

    print(k_means)

    bel = belongingness(k_means,ath)


    for i in range(len(ath)):
        a2.scatter(ath[i][0],ath[i][1], s=4 , c = bel[i])

    a2.scatter(k_means[0][0],k_means[0][1], s=30 , c = 'red')
    a2.scatter(k_means[1][0],k_means[1][1], s=30 , c = 'green')
    a2.scatter(k_means[2][0],k_means[2][1], s=30 , c = 'blue')

    test = 25
    a2.scatter(ath[test][0],ath[test][1], s=50 , c = bel[test])

    plt.show()
