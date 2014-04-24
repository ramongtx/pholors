import json
import re

with open('outFile.json') as file:
	data = json.load(file)

for color in data:
	if(len(color['label']) > 18 or not re.match('^[a-zA-Z0-9 \-]+$',color['label'])):
		print color['label'] + " -> " + str(len(color['label']))

		newlabel = str(raw_input("Novo nome: "))
		if newlabel != "":
			color['label'] = newlabel
		if newlabel == "exit123":
			print "EXIT"
			break

with open('outFile.json','w') as outfile:
	json.dump(data,outfile)