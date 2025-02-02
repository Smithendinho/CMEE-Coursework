"""Creating bird lists using for loops and list comprehensions""" # these triple quotation marks indicate a docstring which are part of the running code but are just used to describe the programme

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.

    # Creating List of Latin Names
ListOfLatinNamesLC = [LatinNames[0] for LatinNames in birds]
print(ListOfLatinNamesLC)

    # Creating List of Common Names
ListOfCommonNamesLC = [CommonNames[1] for CommonNames in birds]
print(ListOfCommonNamesLC)

    # Creating List of Mean Masses
ListOfMeanMassLC = [MeanMass[2] for MeanMass in birds]
print(ListOfMeanMassLC)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

    # Creating List of Latin Names
ListOfLatinNames = []
for LatinNames in birds:
    ListOfLatinNames.append(LatinNames[0]) 

print(ListOfLatinNames)
    # Creating List of Common Names
ListOfCommonNames = []
for CommonNames in birds:
    ListOfCommonNames.append(CommonNames[1])

print(ListOfCommonNames)

    # Creating List of Mean Masses
ListOfMeanMass = []
for MeanMass in birds:
    ListOfMeanMass.append(MeanMass[2])

print(ListOfMeanMass)

