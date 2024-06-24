import re
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import urllib.request
from collections import Counter

from sklearn.model_selection import train_test_split
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

# nltk :: 전세계 언어 분석
import nltk

urllib.request.urlretrieve(
    "https://raw.githubusercontent.com/bab2min/corpus/master/sentiment/naver_shopping.txt", 
    filename="ratings_total.txt")

# 데이터에는 열 제목이 없음.
# 컬럼명 설정
total_data = pd.read_table('ratings_total.txt', names=['ratings', 'reviews'])

# 전체 리뷰 개수 출력
print('전체 리뷰 개수 :', len(total_data)) 
print('-'*50)
# 샘플 확인
print('총리뷰 중 3개만 확인')
print(total_data[:3])
print('-'*50)
print('각 평점 갯수')
print(total_data[['ratings']].value_counts())
print('-'*50)
# 데이터에 label(y값) 이 없음
# 평점 4, 5인 리뷰를 1
# 평점 1, 2인 리뷰를 0 으로 label 컬럼 생성
total_data['label'] = np.select([total_data.ratings > 3], [1], default=0)

# 결과 확인
print(total_data[:3])
print('-'*50)


# 총 20만개의 샘플데이터
# 중복 데이터가 존재함.
# 컬럼별 중복을 제외한 샘플 수
print('평점 고유값 수:',total_data['ratings'].nunique())
print('리뷰 고유값 수:',total_data['reviews'].nunique())
print('긍부정 고유값 수:',total_data['label'].nunique())
print('-'*50)

# reviews 내용에 중복데이터 제거
total_data.drop_duplicates(subset=['reviews'], inplace=True)
print('총 샘플 수 :', len(total_data))
print('-'*50)

# 결측치 확인
print('결측치 확인')
print(total_data.isna().sum())
print('-'*50)

# 학습데이터 : 테스트 데이터 
# 비율 3 : 1 분리
train_data, test_data = train_test_split(total_data,test_size  = 0.25,random_state= 42)
print('훈련용   리뷰의 개수 :', len(train_data))
print('테스트용 리뷰의 개수 :', len(test_data))
print('-'*50)

# 정규표현식 사용 
# 학습 데이터
train_data['reviews'] = train_data['reviews'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","",regex=True)

# 데이터 전처리 후 reviews가 비어있는 데이터 확인
print(train_data[train_data['reviews']==''])
train_data.drop(train_data[train_data['reviews']==''].index,inplace=True)
train_data.isna().sum()

# 전처리 후 샘플의 개수
print('전처리 후 학습   데이터 샘플 :', len(train_data))
print('전처리 후 테스트 데이터 샘플 :', len(test_data))
print('-'*50)

# konlpy :: 한국어 형태소 분석기
from konlpy.tag import Mecab
from tqdm import tqdm
mecab = Mecab('C:\mecab\mecab-ko-dic')

# 불용어를 지정하여 필요없는 토큰을 제거
stopwords = pd.read_csv('stopword.txt')

# 학습 데이터
train_data['tokenized'] = train_data['reviews'].apply(mecab.morphs)
train_data['tokenized'] = train_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])

# 테스트 데이터
test_data['tokenized'] = test_data['reviews'].apply(mecab.morphs)
test_data['tokenized'] = test_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])

# 단어들을 리스트로 저장.
# 1 : 긍정 / 0 : 부정
negative_words = np.hstack(train_data[train_data.label == 0]['tokenized'].values)
positive_words = np.hstack(train_data[train_data.label == 1]['tokenized'].values)
print('부정적인 단어')
print(negative_words)
print('긍정적인 단어')
print(positive_words)
print('-'*50)

# counter() 를 사용하여 각 단어에 대한 빈도수 계산.
# 요소들의 개수를 세어, 딕셔너리 형태로 반환  {문자 : 개수} 형태
negative_word_count = Counter(negative_words)
positive_word_count = Counter(positive_words)
print('부정적인 단어 상위 3개 :', negative_word_count.most_common(3))
print('긍정적인 단어 상위 3개 :', positive_word_count.most_common(3))
print('-'*50)
print('train_data[\'tokenized\'].values')
print(train_data['tokenized'].values)
print('-'*50)


X_train = train_data['tokenized'].values
y_train = train_data['label'].values
X_test = test_data['tokenized'].values
y_test = test_data['label'].values

tokenizer = Tokenizer()
# 글자와 숫자 정보를 맵핑
# 단어 집합이 생성되면서 단어에 고유한 정수가 부여됨.
tokenizer.fit_on_texts(X_train)
# 어떤 숫자와 맵핑되었는지 확인
tokenizer.word_index 

# 횟수가 1회인 단어들은 자연어 처리에서 배제.
# 단어들이 데이터에서 차지하는 비중 확인
threshold = 2

# 단어의 수
total_cnt = len(tokenizer.word_index)

# 등장 빈도수가 threshold = 2 보다 작은 단어의 수 확인.
rare_cnt = 0

# 학습 데이터의 전체 단어 빈도수 총 합
total_freq = 0

# 등장 빈도수가 threshold보다 작은 단어의 등장 빈도수의 총 합
rare_freq = 0

# 단어와 빈도수의 쌍(pair)을 key 와 value로 
for key, value in tokenizer.word_counts.items() :
    # 학습 데이터의 전체 단어 빈도수 총합
    total_freq = total_freq + value

    # 단어의 등장 빈도수가 2보다 작으면
    if(value < threshold) :
        rare_cnt = rare_cnt + 1
        rare_freq = rare_freq + value

print('단어 집합(vocabulary)의 크기                :',total_cnt)
print('등장 빈도가 %s번 이하인 희귀 단어의 수       : %s'%(threshold - 1, rare_cnt))
print("단어 집합에서 희귀 단어의 비율              :", (rare_cnt / total_cnt)*100)
print("전체 등장 빈도에서 희귀 단어 등장 빈도 비율 :", (rare_freq / total_freq)*100)


# 전체 단어 개수 중 빈도수 2 이하인 단어 개수 제거
# 단어의 수 - 등장 빈도수 2 이하
# 0번 패딩 토큰과 1번 OOV 토큰을 고려하여 +2

total_cnt - rare_cnt +2 
vocab_size = total_cnt - rare_cnt +2 
print('단어 집합의 크기 :', vocab_size)

tokenizer = Tokenizer(vocab_size, oov_token = 'OOV') 
tokenizer.fit_on_texts(str(X_train))
X_train = tokenizer.texts_to_sequences(X_train)
X_test = tokenizer.texts_to_sequences(X_test)
# 상위 3개만 
print(X_train[:3])
print(X_test[:3])


# 전체 데이터에서 긴 리뷰와 짧은 리뷰 확인.
max(len(review) for review in X_train)
round(sum(map(len, X_train)) / len(X_train), 2)

print('리뷰 최대 길이 :', max(len(review) for review in X_train))
print('리뷰 평균 길이 :', round(sum(map(len, X_train)) / len(X_train), 2))

plt.hist([len(review) for review in X_train], bins=50)
plt.xlabel('length of samples')
plt.ylabel('number of samples')
plt.show()

def below_threshold_len(max_len, nested_list):
    count = 0
    for sentence in nested_list:
        if(len(sentence) <= max_len):
            count = count + 1
    print('전체 샘플 중 길이가 %s 이하인 샘플의 비율: %s'%(max_len, (count / len(nested_list))*100))


# 길이가 80으로 패딩할 경우 몇개의 샘플을 보전할 수 있는지?
max_len = 80
below_threshold_len(max_len, X_train)

# 리뷰의 99% 80이하의 길이를 가짐.
X_train = pad_sequences(X_train, maxlen=max_len)
X_test = pad_sequences(X_test, maxlen=max_len)


from tensorflow.keras.layers import Embedding, Dense, GRU
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import load_model
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

embedding_dim = 100
hidden_units = 128

model = Sequential()
model.add(Embedding(vocab_size, embedding_dim))
model.add(GRU(hidden_units))
model.add(Dense(1, activation='sigmoid'))


es = EarlyStopping(monitor='val_loss', mode='min', verbose=1, patience=4)
mc = ModelCheckpoint('best_model.h5', monitor='val_acc', mode='max', verbose=1, save_best_only=True)

model.compile(optimizer='rmsprop', loss='binary_crossentropy', metrics=['acc'])
model.summary()

model.compile(optimizer='rmsprop', loss='binary_crossentropy', metrics=['acc'])
history = model.fit(X_train, y_train, 
                    epochs=15, callbacks=[es, mc], 
                    batch_size=60, validation_split=0.2)
loaded_model = load_model('best_model.h5')
print("\n 테스트 정확도: %.4f" % (loaded_model.evaluate(X_test, y_test)[1]))


# 임의 문장에 대한 예측
# 학습 하기 전 전처리 동일하게 처리.
# 전처리의 순서 : 정규 표현식을 통한 한국어 외 문자 제거→토큰화→불용어 제거→정수 인코딩→패딩 순

def sentiment_predict(new_sentence):
    new_sentence = re.sub(r'[^ㄱ-ㅎㅏ-ㅣ가-힣 ]','', new_sentence)
    new_sentence = mecab.morphs(new_sentence)
    new_sentence = [word for word in new_sentence if not word in stopwords]
    encoded = tokenizer.texts_to_sequences([new_sentence])
    pad_new = pad_sequences(encoded, maxlen = 150)
    
    score = float(loaded_model.predict(pad_new))
    if(score > 0.5):
        print("{:.2f}% 확률로 긍정 리뷰입니다.".format(score * 100))
    else:
        print("{:.2f}% 확률로 부정 리뷰입니다.".format((1 - score) * 100))

sentiment_predict('본래 간고등어구이가 나오는 식사였는데 대표님께서 직접 우리가 방문하기 전 날 또 방문해서 재차 확인을 하셨는데 예전과 구성이 살짝 달라져서 우리들이 아쉬울까봐 찜닭까지 추가해주셨다.  ')
sentiment_predict('반찬으로 열무김치와무장아찌 같은 무김치가 나오는데무김치가 아주 아삭아삭하니 맛있어.')















