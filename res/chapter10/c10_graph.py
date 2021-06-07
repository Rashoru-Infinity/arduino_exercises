# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    c10_graph.py                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: al19136 <al19136@shibaura-it.ac.jp>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 02:11:58 by al19136           #+#    #+#              #
#    Updated: 2021/06/08 01:24:48 by al19136          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def do_processing(label, varDict):
	csv = "./c10_" + label + ".csv"
	print(label + ":")
	data = pd.read_csv(csv, encoding = 'utf-8')
	print("ave : " + str(np.mean(data['value'])))
	print("var : " + str(np.var(data['value'])))
	varDict['var'].append(np.var(data['value']))
	plt.plot(data['ms'], data['value'])
 
labelList = []
varDict = {}
varDict['dist'] = pd.read_csv('./distance.csv', encoding = 'utf-8')['dist']
for i in range(len(varDict['dist'])) :
	labelList.append("distance=" + str(varDict['dist'][i]) + "cm")
varDict['var'] = []
plt.figure(figsize = (8, 8))
plt.figure(1)
plt.grid(True)
plt.title('Light intensity')
do_processing('data1', varDict)
do_processing('data2', varDict)
do_processing('data3', varDict)
do_processing('data4', varDict)
do_processing('data5', varDict)
plt.xlabel('Time[$ms$]')
plt.ylabel('Value')
plt.legend(labelList)
plt.figure(figsize = (8, 8))
plt.figure(2)
plt.grid(True)
plt.title('Variance of light intensity')
plt.xlabel('Distance[$cm$]')
plt.ylabel('Variance')
plt.scatter(varDict['dist'], varDict['var'])
plt.plot(varDict['dist'], np.poly1d(np.polyfit(varDict['dist'], varDict['var'], 3))(varDict['dist']))

plt.show()
