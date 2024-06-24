import pandas as pd
import urllib.request
import pickle
import re


df_train = pd.read_table('c_s_review.txt', encoding='cp949')

#print(df_train.head())
df_train.dropna(inplace=True)
#df_train.info()


from konlpy.tag import Mecab
from tqdm import tqdm
mecab = Mecab('C:\mecab\mecab-ko-dic')


def remove_emoji(inputString):
    emoji_pattern = re.compile("["
            u"\U0001F600-\U0001F64F"  # emoticons
            u"\U0001F300-\U0001F5FF"  # symbols & pictographs
            u"\U0001F680-\U0001F6FF"  # transport & map symbols
            u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
                               "]+", flags=re.UNICODE)
    return emoji_pattern.sub(r'', inputString) # no emoji



sentence_list = []
for sentence in tqdm(df_train['reviews']):
    sentence = re.sub(r'[^ㄱ-ㅎㅏ-ㅣ가-힣 ]','', sentence)
    sentence = re.sub('[-=+,#/\?:^.@*\"※~ㆍ!』‘|\(\)\[\]`\'…》\”\“\’·]', '', sentence)
    sentence = remove_emoji(sentence)
    sentence_list.append(mecab.morphs(sentence)) 
    #리스트 안에 토큰화된 리스트를 추가하는 형식.
len(sentence_list)

for s in range(0,5):
    print(sentence_list[s])

import gensim
from gensim.models.word2vec import Word2Vec

w2v_model = Word2Vec(sentences= sentence_list, vector_size=100, window=5, sg=1, max_vocab_size= None, min_count=5)

w2v_model.save('c_word2vec.model')

loaded_model = Word2Vec.load('c_word2vec.model')
#===== 모델 저장========
with open('c_loaded_model.pickle','wb') as file :
    pickle.dump(loaded_model,file)



#=======================여기부터 돌리면 됨===================================
with open('c_loaded_model.pickle','rb') as f :
    loaded_model = pickle.load(f)

#print(loaded_model.wv.vectors.shape)
#print(loaded_model.wv.get_vector('음악'))

print(loaded_model.wv.most_similar('바다',topn=10))






