# %% [markdown]
# Capstone Project: Tea Recommender System, by Amjad Alqahtani (uploaded: 16/11/2021)
# 
# Recommender Systems are everywhere around us, from ads, to music apps, to search engines, they influence our decisions in 
# implicit yet impactful ways. Building recommender systems can vary in difficulty based on complexity, but below is a 
# simple example of a straight forward recommendation system using unique data gathered from online sources. The goal of 
# the Tea Recommender is to generate tea recommendations for users based on their preferred tea. Unlike online examples 
# of recommender systems that measure similarity based on description, here we will use the ingredients to find similarity 
# between the teas.

# %%
# Import the necessary libraries for basic functions, NLP, RegEx,
# calculating similarity, requests, and data visualization
import pandas as pd
import numpy as np
pd.set_option('display.max_colwidth', 100)
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer, WordNetLemmatizer
from nltk.tag import DefaultTagger
from nltk.corpus import treebank
from nltk.tokenize import RegexpTokenizer
from textblob import TextBlob
import re
import string
import random
from sklearn.metrics.pairwise import linear_kernel
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
import requests
import matplotlib.pyplot as plt
%matplotlib inline

# %%
# Nice, but not necessary, watch time when executing text processing tasks. *This is more useful for larger datasets with long computing times.
from tqdm import tqdm
tqdm.pandas()

# %%
# Import dataset and set 'encoding = 'unicode_escape' to avoid UnicodeDecodeError
df = pd.read_csv("C:/Users/Glow9/Documents/Misk-DSI-2021/Capstone/data-tidying/clean_megalist.csv", encoding = 'unicode_escape')

# %%
# Rename column make it one word to remove the dot
df = df.rename(columns = {"Health.Problem": "HealthP"}, inplace = False)

# %%
# View head and make sure the type is a Pandas DataFrame
df.head()

# %%
# Type is pd Df
type(df)

# %%
# for # rows and columns
df.shape

# %%
# view random row to ensure data quality and reproducibility 
df.sample(5, random_state=33)

# %%
# to see the categories we can use, we print the names of columns
for col in df.columns:
    print(col)

# %%
# To see the structure of the strings we're working with
# Select random numbers of each column to print the string
f_text = df["Flavor"][833]
f_text
d_text = df["Description"][677]
d_text
n_text = df["Ingredients"][677]
n_text
o_text = df["Origin"][500]
o_text
c_text = df["Color"][297]
c_text
n_text = df["Ingredients"][347]
n_text
h_text = df["Ingredients"][677]
h_text
t_text = df["Type"][20]
t_text

# %%
# More string editing to improve visualization (some strings are
# capitalized and would be plotted as a seperate category from
# the lowercase strings in one column)
df['Time'] = df['Time'].str.lower()
df['Flavor'] = df['Flavor'].str.lower()
df['Ingredients'] = df['Ingredients'].str.lower()
df['Color'] = df['Color'].str.lower()
df['Description'] = df['Description'].str.lower()
df['Type'] = df['Type'].str.lower()
df['Ingredients'] = df['HealthP'].str.lower()

# %%
# Data Visualization
# Tea types and times best to drink distribution:
# Types, we can see that herbal and black tea are tied at the top
df['Type'].value_counts().plot(x = 'Type', y ='count', kind = 'bar', figsize = (10,5), title = 'Teas Distribution by Type (n= 850)')

# %%
# Time, more teas are best to drink in the AM, which follows that the dataset 
# has a larger propotion of black, green and other caffeinated teas. Herbal 
# teas can be consumed anytime and are recommended in the evening
df['Time'].value_counts().plot(x = 'Time', y ='count', kind = 'bar', figsize = (10,5), title = 'Teas Distribution by Drinking Time (n= 850)')

# %%
# We can look at the Word Count to gain more insight into the number
# of ingredients used to make commercial tea, 
# First, we'll look at the Ingredients word count.
df['word_count'] = df['Ingredients'].apply(lambda x: len(str(x).split()))
df['word_count'].plot(
    kind='hist',
    bins = 50,
    figsize = (12,8),title='Tea Ingredients Word Count Distribution')
# The right skew indicates that more teas have more than 1 or 2 ingredients.

# %%
# For the Description we see that most have 50 to 100 words
df['word_count'] = df['Description'].apply(lambda x: len(str(x).split()))# Plotting the word count
df['word_count'].plot(
    kind='hist',
    bins = 50,
    figsize = (12,8),title='Word Count Distribution for tea descriptions')

# %%
# We can find the lexicon makeup of the longest strings, 
# Description and Ingredients
# Ingredients
from textblob import TextBlob
blob = TextBlob(str(df['Ingredients']))
pos_df = pd.DataFrame(blob.tags, columns = ['word' , 'pos'])
pos_df = pos_df.pos.value_counts()[:10]
pos_df.plot(kind = 'pie', figsize=(8, 6), title = "Top 10 Part-of-speech tags in Ingredients")
# for both, most are nouns, HealthPs, which is not surprising

# %%
from textblob import TextBlob
blob = TextBlob(str(df['Description']))
pos_df = pd.DataFrame(blob.tags, columns = ['word' , 'pos'])
pos_df = pos_df.pos.value_counts()[:10]
pos_df.plot(kind = 'pie', figsize=(8, 6), title = "Top 10 Part-of-speech tags in Descriptions")
# for both, most are nouns, names, which is not surprising

# %%
# Preparing text:
# Function for removing NonAscii characters
def _removeNonAscii(s):
    return "".join(i for i in s if  ord(i)<128)

# Function for converting into lower case
def make_lower_case(text):
    return text.lower()

# Function for removing stop words
def remove_stop_words(text):
    text = text.split()
    stops = set(stopwords.words("english"))
    text = [w for w in text if not w in stops]
    text = " ".join(text)
    return text

# Function for removing punctuation
def remove_punctuation(text):
    tokenizer = RegexpTokenizer(r'\w+')
    text = tokenizer.tokenize(text)
    text = " ".join(text)
    return text

# Applying all the functions in health problems and storing as a "Ingredients"
df["Ingredients"] = df["Ingredients"].apply(_removeNonAscii)
df["Ingredients"] = df.Ingredients.apply(func = make_lower_case)
df["Ingredients"] = df.Ingredients.apply(func = remove_stop_words)
df["Ingredients"] = df.Ingredients.apply(func=remove_punctuation)

# %%
#Print ingredients of the first 5 teas.
df['Ingredients'].head()

# %%
#Define a TF-IDF Vectorizer Object. Remove all english stop words such as 'the', 'a'
tfidf = TfidfVectorizer(stop_words='english')

#Replace NAs with an empty string
df['Ingredients'] = df['Ingredients'].fillna('')

#Construct the required TF-IDF matrix by fitting and transforming the data
tfidf_matrix = tfidf.fit_transform(df['Ingredients'])

#Output the shape of tfidf_matrix
tfidf_matrix.shape

# %%
# From the above shape, we see that there are 698 words in the dataset
# Array mapping from feature integer indices to feature name.
tfidf.get_feature_names_out()[94:104]

# %%
# Compute the cosine similarity matrix
cosine_sim = linear_kernel(tfidf_matrix, tfidf_matrix)

# %%
cosine_sim.shape

# %%
cosine_sim[1]

# %%
# Now that we have the matrix of similarity, we should 
# generate a reverse map of indices and tea names
indices = pd.Series(df.index, index=df['Name']).drop_duplicates()

# %%
indices[:5]

# %%
# At this point, we can begin building the recommendation function, 
# It will take in Name as input and returns similar teas as output
def get_recommendations(Name, cosine_sim=cosine_sim):
    # Get the index of teas that match the name
    idx = indices[Name]

    # Get the pairwsie similarity scores of all similar teas
    sim_scores = list(enumerate(cosine_sim[idx]))

    #  Based on the similarity scores, sort the tea names
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

    # Find the scores of the 5 most similar teas
    sim_scores = sim_scores[1:6]

    # Get the tea indices
    tea_indices = [i[0] for i in sim_scores]

    # Bring it all together and return the top 5 most similar teas
    return df['Name'].iloc[tea_indices]

# %%
df['Name'][363:373]

# %%
get_recommendations('Lavender')


