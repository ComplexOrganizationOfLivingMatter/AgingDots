import networkx as nx
import scipy.io
import h5py
import numpy as np
import time
from time import gmtime, strftime
from os import listdir
from os.path import isfile, join
import os.path


mypaths = []
mypaths.append('/home/pedro/vboxshare/Pedro/AgingDots/results/distanceMatrix/rawImages/')

for mypath in mypaths:
	onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]

	for fileName in onlyfiles:
		outputFileName = fileName.split('.')
		#print outputFileName[0][:-14]
		if os.path.isfile('/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/rawImages/' + outputFileName[0] + 'It' + '1' + '.mat') == 0:
			start = time.time()
			print (strftime("%a, %d-%b-%Y %H:%M:%S GMT", time.gmtime()))
			#print start
			#print mypath + fileName
			mat = scipy.io.loadmat(mypath + fileName)
			if "Control" in fileName:
				distanceMatrix = np.matrix(mat['distanceMatrixControl'])
			else:
				distanceMatrix = np.matrix(mat['distanceMatrix'])

			distanceMatrixAux = distanceMatrix;
			adjacencyMatrix = np.zeros((len(distanceMatrix), len(distanceMatrix)))
			#print np.triu(distanceMatrix)
			
			print (len(distanceMatrix))
			if len(distanceMatrix) > 15:
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
					scipy.io.savemat('/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/rawImages/allIterations/sorting_' + outputFileName[0] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
					
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
						scipy.io.savemat('/home/pedro/vboxshare/Pedro/AgingDots/results/sortingAlgorithm/rawImages/lastIteration/sorting_' + outputFileName[0] + 'It' + str(iteration) + '.mat', mdict={'adjacencyMatrix': adjacencyMatrixOut})
						#if len(ccomp) == 1:
						break

					iteration = iteration + 1
					    
			print (strftime("%a, %d %b %Y %H:%M:%S", gmtime()))
			end = time.time()
			print (end - start)
			print ('------------------------------------------------')
