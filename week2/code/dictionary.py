taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 
# practice code - getting used to dictionaries!!


taxa_dic = {} # creates dictionary called taxa_dic

for order in taxa:
    if order[1] in taxa_dic: # this is looking if the order in the taxa list is already present in the taxa_dic
        taxa_dic[order[1]].append(order[0]) # if it is already a key in the dictionary then add the species to the list attatched to that key
    else:
        if order[1] not in taxa_dic: # if the order is not already part of the dictionary
            taxa_dic[order[1]] = [] # make a list associated with the order
        taxa_dic[order[1]].append(order[0]) # add species to the list

print(taxa_dic) # print (yay it works)

        
        


    





# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  
 
#### Your solution here #### 
