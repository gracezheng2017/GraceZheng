import os
import re
import numpy as np

outputfile_path=os.path.join("output.txt")
#with open(outputfile_path, 'w', newline='') as outputfile

sourcefile_path = os.path.join("sample.txt")
#("paragraph_2.txt")

with open(sourcefile_path, 'r') as myfile:
    data=myfile.read().replace('\n', '').replace('\r', '')

#print(data)
#Approximate word count
words = data.split(" ")
wordscount=len(words)
print("Approximate word count: "+str(wordscount))

#Approximate sentence count
sentence = data.split(".")
sentence.pop(5) # have to remove that odd empty line
#print(sentence)
sentence_count=len(sentence)
print("Approximate sentence count: "+str(sentence_count))

#average letter count (per word)
###how to remove ,.
wordlen=[]
for x in range(0,len(words)):
    #re.split("(?&lt;=[.!?]) +", paragraph)
    wordlen.append(len(re.sub('[!@#$],."', '', words[x])))
#print(x)
print("average letter count (per word): "+str(np.mean(wordlen)))

#Average sentence length (in words)
sentencelen= wordscount/sentence_count
print("Average sentence length (in words): "+str(sentencelen))
