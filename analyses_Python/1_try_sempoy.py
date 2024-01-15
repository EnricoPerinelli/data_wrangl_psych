

# semopy https://pypi.org/project/semopy/

# pip install semopy  # just once



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


from semopy import Model
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

import graphviz
   

g = semplot(m, filename='C:/Users/Enrico Perinelli/Dropbox/GitHub_repos/data_wrangl_psych/analyses_Python/fig_semopy.pdf')
g
