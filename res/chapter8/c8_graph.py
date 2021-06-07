# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    c8_graph.py                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: al19136 <al19136@shibaura-it.ac.jp>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/04 02:11:58 by al19136           #+#    #+#              #
#    Updated: 2021/06/08 00:51:54 by al19136          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def plot_csv_data(prefix, labelList, label) :
	csv = "./c8_" + prefix + ".csv"
	data = pd.read_csv(csv, encoding = 'utf-8')
	plt.plot(data['ms'], data['value'], alpha = 0.4)
	labelList.append(label)

def append_variance(label, varDict, angle):
	csv = "./c8_" + label + ".csv"
	print(label + ":")
	data = pd.read_csv(csv, encoding = 'utf-8')
	print("ave : " + str(np.mean(data['value'])))
	print("var : " + str(np.var(data['value'])))
	varDict['angle'].append(angle)
	varDict['var'].append(np.var(data['value']))
 
varDict = {}
varDict['angle'] = []
varDict['var'] = []
varDictPullDown = {}
varDictPullDown['angle'] = []
varDictPullDown['var'] = []
labelList = []
plt.figure(figsize = (8, 8))
plt.figure(1)
plt.grid(True)
plot_csv_data('data1', labelList, 'angle=90 nomal')
plot_csv_data('data2', labelList, 'angle=60 nomal')
plot_csv_data('data3', labelList, 'angle=30 nomal')
plot_csv_data('data4', labelList, 'angle=0 nomal')
plot_csv_data('data5', labelList, 'angle=90 pull_down')
plot_csv_data('data6', labelList, 'angle=60 pull_down')
plot_csv_data('data7', labelList, 'angle=30 pull_down')
plot_csv_data('data8', labelList, 'angle=0 pull_down')
plt.xlabel('Time[ms]')
plt.ylabel('Value')
plt.legend(labelList)
plt.figure(figsize = (8, 8))
plt.figure(2)
plt.grid(True)
append_variance('data1', varDict, 90)
append_variance('data2', varDict, 60)
append_variance('data3', varDict, 30)
append_variance('data4', varDict, 0)
plt.scatter(varDict['angle'], varDict['var'])
plt.plot(varDict['angle'], np.poly1d(np.polyfit(varDict['angle'], varDict['var'], 2))(varDict['angle']));
plt.xlabel('Angle[$deg$]')
plt.ylabel('Variance')
plt.title('NormalCircuit')
plt.figure(figsize = (8, 8))
plt.figure(3)
plt.grid(True)
append_variance('data5', varDictPullDown, 90)
append_variance('data6', varDictPullDown, 60)
append_variance('data7', varDictPullDown, 30)
append_variance('data8', varDictPullDown, 0)
plt.scatter(varDictPullDown['angle'], varDictPullDown['var'])
plt.plot(varDictPullDown['angle'], np.poly1d(np.polyfit(varDictPullDown['angle'], varDictPullDown['var'], 2))(varDictPullDown['angle']));
plt.xlabel('Angle[$deg$]')
plt.ylabel('Variance')
plt.title('NormalCircuit + PullDownCircuit')

plt.show()
