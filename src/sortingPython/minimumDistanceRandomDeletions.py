import networkx as nx
import scipy.io
import h5py
import pdb
import numpy as np
import time
from time import gmtime, strftime
from os import listdir
from os.path import isfile, join
import os.path


randomDeletionPaths = []
randomDeletionPaths.append('/home/pedro/vboxshare/Pedro/AgingDots/results/distanceMatrix/randomDeletionImages/')


for mypath in randomDeletionPaths:
        monthFolders = []
        monthFolders = [f for f in listdir(mypath)]
        #print (mypath)
        for monthFolder in monthFolders:
                #monthPath = [];
                monthPath = str(mypath) + str(monthFolder) + '/'
                #print (monthPath)
                
                imagesPerMonth=[f for f in listdir(monthPath)]
                for imageFolder in imagesPerMonth:

                        imageFolderPath = str(mypath) + str(monthFolder) + '/' + imageFolder + '/'
                        #print (imageFolderPath)
                        onlyfiles=[f for f in listdir(imageFolderPath)]

                        for fileName in onlyfiles:
                                #print (fileName)
                            
                                if os.path.isfile('/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/ramdonDeletionImages/' + str(monthFolder) + '/' + imageFolder + '/' + fileName + '.mat') == 0:
                                        start = time.time()
                                        #print (strftime("%a, %d-%b-%Y %H:%M:%S GMT", time.gmtime()))
                                        #print start
                                        #print imageFolderPath + fileName
                                        mat = scipy.io.loadmat(imageFolderPath + fileName)
                                        if "Control" in fileName:
                                                distanceMatrix = np.matrix(mat['distanceMatrixControl'])
                                        else:
                                                distanceMatrix = np.matrix(mat['distanceMatrix'])

                                        distanceMatrixAux = distanceMatrix;
                                        adjacencyMatrix = np.zeros((len(distanceMatrix), len(distanceMatrix)))
                                        #print np.triu(distanceMatrix)
                                        
                                        #print (len(distanceMatrix))
                                        if len(distanceMatrix) > 5:
                                                #Creating network
                                                G = nx.Graph()
                                                #With an initial number of nodes
                                                G.add_nodes_from(np.arange(len(distanceMatrix)))

                                                iteration = 1
                                                while True:
                                                        
                                                        maxDistanceIteration = 0;
                                                        indicesMaxDistanceIteration = 0
                                                        numRow = 0;
                                                        #distanceMatrixAux will be the matrix in which we will add remove the minimum closest
                                                        #vertex of the row.
                                                        for row in distanceMatrixAux:
                                                                try:
                                                                        #minimum except zeros
                                                                        minValue = row[row != 0].min()
                                                                        #print minValue
                                                                        #indices of the min value
                                                                        indices = np.where(row == minValue)
                                                                        #first of indice's array is 0 always. Then it should be 'row', the real row.
                                                                        distanceMatrixAux[numRow, indices[1][0]] = 0
                                                                        #distanceMatrixAux[indices[1][0], row] = 0

                                                                        if minValue > maxDistanceIteration:
                                                                                maxDistanceIteration = minValue
                                                                except Exception:
                                                                        pass

                                                                numRow = numRow + 1
                                                        
                                                        #print distanceMatrix[1532][distanceMatrix[1532] != 0].min()
                                                        #print maxDistanceIteration
                                                        indices = np.where(distanceMatrix <= maxDistanceIteration)
                                                        #print len(indices[0])
                                                        #print len(distanceMatrix)
                                                        #print maxDistanceIteration
                                                        #Remove edges
                                                        #print indices
                                                        for index in range(len(indices[0])):
                                                                distanceMatrix[indices[0][index], indices[1][index]] = 0
                                                                distanceMatrix[indices[1][index], indices[0][index]] = 0
                                                                #Add the edge
                                                                edge = (indices[0][index], indices[1][index])
                                                                G.add_edge(*edge)

                                                                adjacencyMatrix[indices[0][index], indices[1][index]] = 1
                                                                adjacencyMatrix[indices[1][index], indices[0][index]] = 1


                                                        #Last edge
                                                        # distanceMatrixAux[indicesMaxDistanceIteration[0][0], indicesMaxDistanceIteration[1][0]] = 0.0
                                                        # edge = (indicesMaxDistanceIteration[0][0], indicesMaxDistanceIteration[1][0])
                                                        # G.add_edge(*edge)

                                                        # ----------- iteration is over! ------------#

                                                        #Output files of the network
                                                        #outputFileName = fileName.split('/')
                                                        #outputFileName = outputFileName[11].split('.')
                                                        #outputFileName = fileName.split('.')
                                                        adjacencyMatrixOut = nx.adjacency_matrix(G)
                                                        #print outputFileName[0] + 'It' + str(iteration) + '.mat'
                                                        outputFileName = fileName.split('.')
                                                        directory1='/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/ramdonDeletionImages/' + str(monthFolder) + '/' + imageFolder + '/allIterations/'
                                                        if not os.path.exists(directory1):
                                                                os.makedirs(directory1)
                                                        scipy.io.savemat(directory1 + outputFileName[0] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
                                                        
                                                        # print strftime("%a, %d %b %Y %H:%M:%S", gmtime())
                                                        #ccomp = sorted(nx.connected_components(G), key = len, reverse=True)
                                                        # #print len(ccomp)
                                                        # print ccomp
                                                        # print len(ccomp)
                                                        # print len(distanceMatrix)
                                                        #print min(sum(adjacencyMatrix))
                                                        #print np.where(sum(adjacencyMatrix) == min(sum(adjacencyMatrix)))
                                                        #print sum(adjacencyMatrixOut.todense()).min()
                                                        #print np.where(sum(adjacencyMatrixOut.todense()) == sum(adjacencyMatrixOut.todense()).min())

                                                        #If the iteration goes over 300, it has to be an error
                                                        if iteration > 300:
                                                                print ('Error!')
                                                                break

                                                        #if the graph is connected, we finish the algorithm
                                                        if nx.is_connected(G) or "Control" in fileName:
                                                                directory2='/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/ramdonDeletionImages/' + str(monthFolder) + '/' + imageFolder + '/lastIteration/'
                                                                if not os.path.exists(directory2):
                                                                    os.makedirs(directory2)
                                                                scipy.io.savemat(directory2 + outputFileName[0] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
                                                                #if len(ccomp) == 1:
                                                                break

                                                        iteration = iteration + 1
                                                            
                                        #print (strftime("%a, %d %b %Y %H:%M:%S", gmtime()))
                                        end = time.time()
                                        #print (end - start)
                                        #print ('------------------------------------------------')

