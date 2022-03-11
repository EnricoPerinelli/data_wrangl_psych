####################### Default syntax from rodeo

ciao = "Hello world"

xxx = [1,2,3,4]
xxx

# Press CTRL + ENTER to run a single line in the console
print('Welcome to Rodeo!')

# Press CTRL + ENTER with text selected to run multiple lines
# For example, select the following lines
x = 7
x**2
# and remember to press CTRL + ENTER

# Here is an example of using Rodeo:

# Install packages

! pip install pandas
! pip install numpy

# Import packages

import numpy as np
import pandas as pd

N = 100
df = pd.DataFrame({
    'A': pd.date_range(start='2016-01-01',periods=N,freq='D'),
    'x': np.linspace(0,stop=N-1,num=N),
    'y': np.random.rand(N),
    'C': np.random.choice(['Low','Medium','High'],N).tolist(),
    'D': np.random.normal(100, 10, size=(N)).tolist()
    })
df.head()

# Another example of making a plot:

from matplotlib import pyplot as plt
x=df.x
with plt.style.context('fivethirtyeight'):
    plt.plot(x, np.sin(x*5) + x + np.random.randn(N)*15)
    plt.plot(x, np.sin(x*5) + 0.5 * x + np.random.randn(N)*5)
    plt.plot(x, np.sin(x) + 2 * x + np.random.randn(N)*20)

plt.title('Random lines')
plt.show()

####################### Comments

# this is a comment

'''
This is a longer 
comment
'''

####################### semopy https://pypi.org/project/semopy/

# pip install semopy  # just once

# The first step

import semopy
from semopy import Model
mod = """ x1 ~ x2 + x3
          x3 ~ x2 + eta1
          eta1 =~ y1 + y2 + y3
          eta1 ~ x1
      """
      
model = Model(mod)
model

# The second step

from pandas import read_csv
data = read_csv("my_data_file.csv", index_col=0)  # i do not have a file


# The third step

model.fit(data)

# Finally, user can inspect parameters' estimates:

model.inspect()

############ https://semopy.com/tutorial.html

import semopy
import pandas as pd
desc = semopy.examples.political_democracy.get_model()
print(desc)

data = semopy.examples.political_democracy.get_data()
print(data.head())

mod = semopy.Model(desc)
res = mod.fit(data)
print(res)

ins = mod.inspect()
print(ins)

#### https://gitlab.com/georgy.m/semopy/-/blob/master/notebooks/semopy%20-%20Walkthrough.ipynb

from semopy.examples import political_democracy
desc = political_democracy.get_model()
data = political_democracy.get_data()
print(desc)
data.head()

m = Model(desc)
m.fit(data)
ins = m.inspect()
ins


from semopy import estimate_means
means = estimate_means(m)
means

from semopy import ModelMeans
m = ModelMeans(desc)
m.fit(data)
m.inspect()

desc = political_democracy.get_model()
data = political_democracy.get_data()
m = Model(desc)
m.fit(data)
factors = m.predict_factors(data)
factors.head()

import numpy as np
np.random.seed(1)
desc = political_democracy.get_model()
data = political_democracy.get_data()
m = Model(desc)

# Let's generate random misses in data:
N_misses = 5
mask_x = np.random.randint(0, len(data), N_misses)
mask_y = np.random.randint(0, len(data.columns), N_misses)
data_true = data.values[mask_x, mask_y].copy()
data.values[mask_x, mask_y] = np.nan
# Model can work with misses by default, but ModelMeans and ModelEffects can not. However, there is
# a FIML estimator available (just FYI).
m.fit(data)
pred = m.predict(data)
print('Mean relative error: {:.3f}%'.format(
       abs((pred.values[mask_x, mask_y] - data_true) / data_true).mean() * 100))
pred.head()

from semopy import semplot
# I have to install this:
#    pip install graphviz
    import graphviz
   

g = semplot(m, filename='t.pdf')
g
