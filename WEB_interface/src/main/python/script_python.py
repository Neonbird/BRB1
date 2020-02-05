import sys
# print 'Number of Arguments:', len(sys.argv), 'arguments.'
# print 'Argument List:', str(sys.argv)
# print('This is Python Code')
# print('Executing Python')
# print('From Java')
# import sys


print("open")
with open("src/main/python/index.js.vcf", "w") as new_file:
    new_file.write('9	13	rs12216896	C	T	.	.	.\n'+
    '9	1	rs3124766	G	A	.	.	.\n'+
    '9	136323754	rs4962153	A	G	.	.	.\n'+
    '9	136326248	rs739468	T	G	.	.	.\n'+
    '9	136328657	rs3124765	T	C	.	.	.\n'+
    '9	136329954	rs3124764	T	C	.	.	.\n'+
    '9	136334910	rs3094379	T	C	.	.	.\n'+
    '9	136339755	rs3124761	T	C	.	.	.\n'+
    '9	136270992	rs41296107	C	T	.	.	.\n'+
    '9	136305738	rs28645493	C	G	.	.	.\n'+
    '9	136308796	rs28446901	C	G	.	.	.\n'+
    '9	136315974	rs36222279	G	C	.	.	.')
    new_file.close()
    print('Downloaded')
