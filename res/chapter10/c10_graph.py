# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    c10_graph.py                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: al19136 <al19136@shibaura-it.ac.jp>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 02:11:58 by al19136           #+#    #+#              #
#    Updated: 2021/06/05 02:47:08 by al19136          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def do_processing(label, labelList, varDict, distList):
	csv = "./c10_" + label + ".csv"
	print(label + ":")
	data = pd.read_csv(csv, encoding = 'utf-8')
	print("ave : " + str(np.mean(data['value'])))
	print("var : " + str(np.var(data['value'])))
	varDict['key_ave'].append(np.mean(data['value']))
	varDict['value'].append(np.var(data['value']))
	plt.plot(data['ms'], data['value'])
	labelList.append(label)
	distList['val_ave'].append(np.mean(data['value']))
 
distDict = {}
distDict['dist'] = pd.read_csv('./distance.csv', encoding = 'utf-8')['dist']
distDict['val_ave'] = []
labelList = []
varDict = {}
varDict['key_ave'] = []
varDict['value'] = []
plt.figure(1)
plt.grid(True)
plt.title('Relationship between average light intensity and time')
do_processing('data1', labelList, varDict, distDict)
do_processing('data2', labelList, varDict, distDict)
do_processing('data3', labelList, varDict, distDict)
do_processing('data4', labelList, varDict, distDict)
do_processing('data5', labelList, varDict, distDict)
plt.xlabel('Time[ms]')
plt.ylabel('value')
plt.legend(labelList)
plt.figure(2)
plt.grid(True)
plt.title('Relationship between average light intensity and variance')
plt.xlabel('Average')
plt.ylabel('Variance')
plt.scatter(varDict['key_ave'], varDict['value'])
plt.plot(varDict['key_ave'], np.poly1d(np.polyfit(varDict['key_ave'], varDict['value'], 2))(varDict['key_ave']))
plt.figure(3)
plt.grid(True)
plt.title('Relationship between average light intensity and distance')
plt.xlabel('Distance[cm]')
plt.ylabel('Average light intensity')
plt.scatter(distDict['dist'], distDict['val_ave'])
plt.plot(distDict['dist'], np.poly1d(np.polyfit(distDict['dist'], distDict['val_ave'], 2))(distDict['dist']))

plt.show()
