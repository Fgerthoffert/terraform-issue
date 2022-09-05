import os

chartsFolder = './charts'
hosts = []

print('Finding hosts in ', chartsFolder)
for root, dirs, files in os.walk(chartsFolder):
    for directories in dirs:
        hosts.append(directories)

chartWidth = 100/len(hosts)
print(hosts)

chartsTableFile = open('./summary.html', 'w')
chartsTableFile.write('<html><body>\n')
chartsTableFile.write('<table  width="100%" border="1">\n')
chartsTableFile.write('<tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center">' + host + '</td>\n')
chartsTableFile.write('</tr>\n')

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>CPU Utilization by Logical Core</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/All_CPUs.png"><img src=charts/' + host + '/All_CPUs.png width="100%"/></a></td>\n')

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>Total Disk Read and Write</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/Memory.png"><img src=charts/' + host + '/Memory.png width="100%"/></a></td>\n')    

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>Total Disk Read and Write</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/Disk.png"><img src=charts/' + host + '/Disk.png width="100%"/></a></td>\n')

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>Total Ethernet Read and Write</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/Network.png"><img src=charts/' + host + '/Network.png width="100%"/></a></td>\n')

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>Swap Usage</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/Swap.png"><img src=charts/' + host + '/Swap.png width="100%"/></a></td>\n')

chartsTableFile.write('<tr><td align="center" colspan="' + str(len(host)) + '"><b>Page Faults</b></td></tr>\n')
for host in hosts:
    chartsTableFile.write('<td align="center"><a target="_blank" href="charts/' + host + '/Page_Faults.png"><img src=charts/' + host + '/Page_Faults.png width="100%"/></a></td>\n')

chartsTableFile.write('</table>\n')
chartsTableFile.write('</body></html>\n')
chartsTableFile.close()
