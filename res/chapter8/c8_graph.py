# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    c8_graph.py                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: al19136 <al19136@shibaura-it.ac.jp>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 02:11:58 by al19136           #+#    #+#              #
#    Updated: 2021/06/07 22:54:15 by al19136          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def do_processing(label, varDict, angle):
	csv = "./c8_" + label + ".csv"
	print(label + ":")
	data = pd.read_csv(csv, encoding = 'utf-8')
	print("var : " + str(np.var(data['value'])))
	varDict['angle'].append(angle)
	varDict['var'].append(np.var(data['value']))
 
varDict = {}
varDict['angle'] = []
varDict['var'] = []
varDictPullDown = {}
varDictPullDown['angle'] = []
varDictPullDown['var'] = []
plt.figure(1)
plt.grid(True)
do_processing('data1', varDict, 90)
do_processing('data2', varDict, 60)
do_processing('data3', varDict, 30)
do_processing('data4', varDict, 0)
plt.scatter(varDict['angle'], varDict['var'])
plt.plot(varDict['angle'], np.poly1d(np.polyfit(varDict['angle'], varDict['var'], 2))(varDict['angle']));
plt.xlabel('Angle[$deg$]')
plt.ylabel('Variance[$deg^2$]')
plt.title('NormalCircuit')
plt.figure(2)
plt.grid(True)
do_processing('data5', varDictPullDown, 90)
do_processing('data6', varDictPullDown, 60)
do_processing('data7', varDictPullDown, 30)
do_processing('data8', varDictPullDown, 0)
plt.scatter(varDictPullDown['angle'], varDictPullDown['var'])
plt.plot(varDictPullDown['angle'], np.poly1d(np.polyfit(varDictPullDown['angle'], varDictPullDown['var'], 2))(varDictPullDown['angle']));
plt.xlabel('Angle[$deg$]')
plt.ylabel('Variance[$deg^2$]')
plt.title('NormalCircuit + PullDownCircuit')

plt.show()
