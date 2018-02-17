import os
import csv
from datetime import datetime
from dateutil.parser import parse
#from libaryname import modulename
us_state = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
}


output_path = os.path.join('output', 'emp2.csv')

with open(output_path, 'w', newline='') as outputfile:
    csvwriter = csv.writer(outputfile, delimiter=',')
    csvwriter.writerow(["Emplid", "first_name", "last_name", "DOB", "SSN", "State"])
    
sourcefile_path = os.path.join('raw_data', 'employee_data2.csv')
with open(sourcefile_path, newline='') as csvfile1:
    csvreader = csv.reader(csvfile1, delimiter=',')
    #with open(output_path, 'w', newline='') as outputfile:
    #    csvwriter = csv.writer(outputfile, delimiter=',')
    #    csvwriter.writerow (item)
    next(csvreader) #skip the header row

    for row in csvreader:
        newrow = []
        #row.index : get the index of the row
        #print (row)
        #print (len(row))
        for x in range(0,len(row)):
            if (x==0): #emplid
               
                newrow.append(row[x])

            elif (x==1): #name               
                empname=row[x].split(' ')
                #print(mylist)   #mylist=row[x].partition(' ')                  
                newrow.append(empname[0])
                newrow.append(empname[1])
                                
            elif (x==2):#DOB                
                #datetime.datetime.strptime(row[x], '%y-%m-%d').strftime('%m/%d/%y')
                dt = parse(row[x])
                #print('DOB :'+str(dt)) #1985-12-04 00:00:00
                # datetime.datetime(2010, 2, 15, 0, 0)
                newdob = dt.strftime('%m/%d/%Y')
                #print(newdob) 
                newrow.append(newdob)
            
            elif (x==3):#SSN
                #print(row[x].split('-')) #['282', '01', '8166']
                newssn = '***-**-'+row[x].split('-')[2]                
                newrow.append(newssn)
            else:#state
                state = row[x]                
                if state in us_state:                    
                    newrow.append(us_state[state])
                    #newrow.append('\n')
            #print(newrow)
       
        with open(output_path, 'a', newline='') as outputfile:
                csvwriter = csv.writer(outputfile, delimiter=',')                                
                csvwriter.writerow (newrow)
                