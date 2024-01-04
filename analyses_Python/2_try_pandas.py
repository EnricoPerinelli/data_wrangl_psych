
import os
os.getcwd()
print("Current working directory: {0}".format(os.getcwd()))
os.chdir(r'C:\Users\Enrico Perinelli\Downloads\data_wrangl_psych\analyses_Python')
os.getcwd()

import pandas as pd

my_bfi = pd.read_csv("my_bfi.csv")       # load data

my_bfi.shape                             # dimension

my_bfi.columns                           # names

my_bfi.head()                            # head

my_bfi.query('A1 == 1 & A2 == 1')        # filter

my_bfi.query('A1 == 1 & A2 == 1').shape  # filter + dimension

my_bfi[['A1', 'E2']]                     # select 1

my_bfi.loc[:, 'A1':'E1']                 # select 2

my_bfi[['age', 'E1']].mean()             # compute means of different variables

# Data viz

my_bfi[['age']].hist()

my_bfi[['age', 'education']].plot.box()


# Mutate (recoding reverse items)

my_bfi_new = my_bfi.assign(A1_rev = 7 - my_bfi['A1'],
                           C4_rev = 7 - my_bfi['C4'],
                           C5_rev = 7 - my_bfi['C5'],
                           E1_rev = 7 - my_bfi['E1'],
                           E2_rev = 7 - my_bfi['E2'],
                           O2_rev = 7 - my_bfi['O2'],
                           O5_rev = 7 - my_bfi['O5']                           
                           )

# Mutate (create composite scores)

my_bfi_new = my_bfi_new.assign(
    Agreeableness     = my_bfi_new[['A1_rev', 'A2', 'A3', 'A4', 'A5']].mean(axis = 1),
    Conscientiousness = my_bfi_new[['C1', 'C2', 'C3', 'C4_rev', 'C5_rev']].mean(axis = 1),
    Extraversion      = my_bfi_new[['E1_rev', 'E2_rev', 'E3', 'E4', 'E5']].mean(axis = 1),
    Neuroticism       = my_bfi_new[['N1', 'N2', 'N3', 'N4', 'N5']].mean(axis = 1),
    Openness          = my_bfi_new[['O1', 'O2_rev', 'O3', 'O4', 'O5_rev']].mean(axis = 1)
    )


# Calculate Cronbach's Alpha and corresponding 99% confidence interval (ci = .95, by default)

# pip install pingouin      # Just once

import pingouin as pg

pg.cronbach_alpha(data=my_bfi_new[['A1_rev', 'A2', 'A3', 'A4', 'A5']], ci = .99)
pg.cronbach_alpha(data=my_bfi_new[['C1', 'C2', 'C3', 'C4_rev', 'C5_rev']], ci = .99)
pg.cronbach_alpha(data=my_bfi_new[['E1_rev', 'E2_rev', 'E3', 'E4', 'E5']], ci = .99)
pg.cronbach_alpha(data=my_bfi_new[['N1', 'N2', 'N3', 'N4', 'N5']], ci = .99)
pg.cronbach_alpha(data=my_bfi_new[['O1', 'O2_rev', 'O3', 'O4', 'O5_rev']], ci = .99)