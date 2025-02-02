

"""UK Rainfall loops task""" # these triple quotation marks indicate a docstring which are part of the running code but are just used to describe the programme




# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets

rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

# Step 1 - make a working for loop before converting to list comprehension

    # MonthsMoreThan100mm = []

    # for months in rainfall:
        # if months[1] > 100:
        # MonthsMoreThan100mm.append(months[0])

    # print(MonthsMoreThan100mm)

MonthsMoreThan100mmLC = [months[0] for months in rainfall if months[1] > 100]

print(MonthsMoreThan100mmLC)

    # Answers: January, Febuary, August, November, December
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# Basically just copied the answer to question 1 but changed the numbers and signs 
MonthsLessThan50mmLC = [months[0] for months in rainfall if months[1] < 50]
print(MonthsLessThan50mmLC)

    # Answers: Mars and September

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# Conventional loop for Q1:
MonthsMoreThan100mm = []

for months in rainfall:
    """a for loop to add all the months with more than 100mm of rainfall to a list"""
    if months[1] > 100:
        MonthsMoreThan100mm.append(months[0])

print(MonthsMoreThan100mm)

# Conventional loop for Q2:
MonthsLessThan50mm = []

for months in rainfall:
    if months[1] < 50:
        MonthsLessThan50mm.append(months[0])

print(MonthsLessThan50mm)


