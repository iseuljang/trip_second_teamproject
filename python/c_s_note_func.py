import warnings
warnings.filterwarnings("ignore")

import re
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import load_model
from kss import split_sentences 
import numpy as np

import pandas as pd
import urllib.request
import pickle
from collections import Counter
from konlpy.tag import Mecab
from tqdm import tqdm
mecab = Mecab('C:\mecab\mecab-ko-dic')

import dbmanager as db

# [[ DB연결 & bno,btitle,bnote 넣은 딕셔너리, 딕셔너리 넣은 리스트 생성
def First_LoadFromDB(start,count) :
    # DBManger객체 생성
    dbms = db.DBManager()
    # DB연결
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('SELECT * FROM board limit '+ str(start) +', ' + str(count))
        total = dbms.GetTotal()
        
        board = []
        for i in range(total):
            item = { 
                "bno"      : dbms.GetValue(i, 'bno'),
                "btitle"   : dbms.GetValue(i, 'btitle'),
                "bnote"    : dbms.GetValue(i, 'bnote'),
                "sentance" : "",
                "sent_list" : "",
                "positive" : "",
                "nouns"    : []
                }
            board.append(item)
        #print(board)
            
        df = pd.DataFrame(board)
        #print(df)
        
        dbms.CloseQuery()   
        dbms.DBClose()
        return board
# ]] ============================================


# [[ DB연결 & bno,btitle,bnote 넣은 딕셔너리, 딕셔너리 넣은 리스트 생성
# 추가 작성된 게시글 조회하는 메소드 -> 자동으로 돌릴때 사용
def LoadFromDB(bno,count) :
    # DBManger객체 생성
    dbms = db.DBManager()
    # DB연결
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('SELECT * FROM board where bno > '+ bno + ' limit ' + count)
        total = dbms.GetTotal()
        
        board = []
        for i in range(total):
            item = { 
                "bno"      : dbms.GetValue(i, 'bno'),
                "btitle"   : dbms.GetValue(i, 'btitle'),
                "bnote"    : dbms.GetValue(i, 'bnote'),
                "sentance" : "",
                "sent_list" : "",
                "positive" : "",
                "nouns"    : []
                }
            board.append(item)
        #print(board)
            
        df = pd.DataFrame(board)
        #print(df)
        
        dbms.CloseQuery()   
        dbms.DBClose()
        return board
# ]] ============================================
    

# [[ 문장 긍부정 확인하여 긍정문장만 리스트에 저장
def Sentiment(sentance):
    loaded_model = load_model('s_best_model_total.h5')
    
    with open('s_tokenizer.pickle', 'rb') as handle:
        tokenizer = pickle.load(handle)
    
    
    result_list = []
    result = []
    
    #불용어
    stopword = pd.read_csv('stopword.txt')
    max_len = 80
    result = []
    # item-> 하나의 게시글
    sentance = sentance.replace('\r',' ')
    sentance = re.sub('\n+',' ', sentance)  #정규표현식 re.sub을 이용한 문자열 치환하기
    #print('sentance')
    #print(sentance)
    
    sent_list = split_sentences(sentance)
    #print('sent_list')
    #print(sent_list)
    for sent in sent_list:
        predict = re.sub(r'[^ㄱ-ㅎㅏ-ㅣ가-힣 ]','', sent)
        predict = re.sub('[-=+,#/\?:^.@*\"※~ㆍ!』‘|\(\)\[\]`\'…》\”\“\’·]', ' ', predict)
        predict = ' '.join(predict.split())
        print(predict)
        predict = mecab.morphs(sent) # 토큰화
        predict = [word for word in predict if not word in stopword] # 불용어 제거
        encoded = tokenizer.texts_to_sequences([predict]) # 정수 인코딩
        pad_new = pad_sequences(encoded, maxlen = max_len) # 패딩
        score = float(loaded_model.predict(pad_new)) # 예측
        if(score > 0.7) :
            result.append((sent,score))
    return result

# ]] ============================================


# [[ 긍정문장에서 빈도수 높은 단어만 추출
def Freq(sentance):
    word_count_list = []
    
    with open('c_loaded_model.pickle','rb') as f :
        c_loaded_model = pickle.load(f)
    # result -> 게시글
    # result의 원소 (문장,긍부정점수)
    #print('result')
    #print(result)
    words_list = []
    tmp = mecab.nouns(sentance)
    for i in tmp :
        words_list.append(i)
    count = Counter(words_list)
    nouns = count.most_common(20)
    return nouns

# ]] ============================================



# [[ 빈도수 높은 단어 중 검색데이터에 있는 단어로 유사단어 추출
def Similar(nouns) :
    with open('c_loaded_model.pickle','rb') as f :
        c_loaded_model = pickle.load(f)
    word = ''
    similar = ''
    if nouns in c_loaded_model.wv :
        word = nouns
        #word.append(nouns)
        #freq.append(freq)
        similar = c_loaded_model.wv.most_similar(nouns,topn=10)
        #similar_list.append(word)
        #similar_list.append(freq)
        #similar_list.append(similar)
    return word,similar
# ]] ============================================


# [[ bkeyword 테이블에 데이터 추가
def Insert(bkey,bkfr,bno):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return False
    else :
        # 북마크 게시물 중복 검사 
        # 리턴값 : true - 중복 게시물, false - 중복이 안된 게시물
        sql  = "select bno,bkey ";
        sql += "from bkeyword ";
        sql += "where bno=" + str(bno) + " and bkey='" + str(bkey) + "' "
        dbms.OpenQuery(sql)
        
        if dbms.GetTotal() == 0 :
            sql  = "insert into bkeyword "
            sql += "(bkey,bkfr,bno) "
            sql += "values "
            sql += "( "
            sql += " '" + bkey + "',"
            sql += " '" + str(bkfr) + "',"
            sql += " '" + str(bno) + "' "
            sql += " ) "
            dbms.RunSQL(sql)
            dbms.DBClose()
            return True
# ]] ============================================

# [[ bkeyword 테이블 조회
def bkeyword_Select(bkey,bkfr,bno):
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery("select * from bkeyword where bno=" + str(bno) + " and bkey='" + str(bkey) + "' ")
        total = dbms.GetTotal()
            
        bkeyword = []
        for i in range(total):
            item = { 
                "bkno"      : dbms.GetValue(i, 'bkno'),
                "bkey"   : dbms.GetValue(i, 'bkey'),
                "bkfr"    : dbms.GetValue(i, 'bkfr'),
                "bno"    : dbms.GetValue(i, 'bno')
                }
            bkeyword.append(item)
        print(bkeyword)
            
        df = pd.DataFrame(bkeyword)
        print(df)
        dbms.DBClose()
        return bkeyword
# ]] ============================================

# [[ bkeyword 테이블 조회
def First_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from bkeyword')
        total = dbms.GetTotal()
            
        bkeyword = []
        for i in range(total):
            item = { 
                "bkno"      : dbms.GetValue(i, 'bkno'),
                "bkey"   : dbms.GetValue(i, 'bkey'),
                "bkfr"    : dbms.GetValue(i, 'bkfr'),
                "bno"    : dbms.GetValue(i, 'bno')
                }
            bkeyword.append(item)
        print(bkeyword)
            
        df = pd.DataFrame(bkeyword)
        print(df)
        dbms.DBClose()
        return bkeyword
# ]] ============================================

# [[ bkeyword 테이블 추가된 키워드 확인하기 위해 조회 -> 자동으로 돌릴때 사용
def Select(bkno,count):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from bkeyword where bkno > '+ bkno + ' limit ' + count)
        total = dbms.GetTotal()
            
        bkeyword = []
        for i in range(total):
            item = { 
                "bkno"      : dbms.GetValue(i, 'bkno'),
                "bkey"   : dbms.GetValue(i, 'bkey'),
                "bkfr"    : dbms.GetValue(i, 'bkfr'),
                "bno"    : dbms.GetValue(i, 'bno')
                }
            bkeyword.append(item)
        print(bkeyword)
            
        df = pd.DataFrame(bkeyword)
        print(df)
        dbms.DBClose()
        return bkeyword
# ]] ============================================

# [[ bsimilar 테이블에 데이터 추가
def S_Insert(bskey,bsfr,bkno):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return False
    else :
        # 북마크 게시물 중복 검사 
        # 리턴값 : true - 중복 게시물, false - 중복이 안된 게시물
        
        sql  = "select bkno,bskey "
        sql += "from bsimilar "
        sql += "where bkno=" + str(bkno) + " and bskey='" + bskey + "' "
        dbms.OpenQuery(sql)
        if dbms.GetTotal() == 0 :
            sql  = "insert into bsimilar "
            sql += "(bskey,bsfr,bkno) "
            sql += "values "
            sql += "( "
            sql += " '" + bskey + "',"
            sql += " '" + str(bsfr) + "',"
            sql += " '" + str(bkno) + "' "
            sql += " ) "
            dbms.RunSQL(sql)
            dbms.DBClose()
            return True
# ]] ============================================


# [[ bsimilar 테이블 조회
def Similar_Select(bkno):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from bsimilar where bkno=' + bkno)
        total = dbms.GetTotal()
            
        bsimilar = []
        for i in range(total):
            item = { 
                "bsno"  : dbms.GetValue(i, 'bsno'),
                "bskey" : dbms.GetValue(i, 'bskey'),
                "bsfr"  : dbms.GetValue(i, 'bsfr'),
                "bkno"  : dbms.GetValue(i, 'bkno')
                }
            bsimilar.append(item)
        print(bsimilar)
            
        df = pd.DataFrame(bsimilar)
        print(df)
        dbms.DBClose()
        return bsimilar
# ]] ============================================


# [[ bsimilar 테이블 조회
def Last_similar_Select():
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from bsimilar order by bkno desc limit 1')
        total = dbms.GetTotal()
            
        bsimilar = []
        for i in range(total):
            item = { 
                "bsno"  : dbms.GetValue(i, 'bsno'),
                "bskey" : dbms.GetValue(i, 'bskey'),
                "bsfr"  : dbms.GetValue(i, 'bsfr'),
                "bkno"  : dbms.GetValue(i, 'bkno')
                }
            bsimilar.append(item)
        print(bsimilar)
            
        df = pd.DataFrame(bsimilar)
        print(df)
        dbms.DBClose()
        return bsimilar
# ]] ============================================




# [[ positive 테이블에 데이터 추가
def P_Insert(bpsent,bposi,bno):
    dbms = db.DBManager()
    
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return False
    else :
        # 북마크 게시물 중복 검사 
        # 리턴값 : true - 중복 게시물, false - 중복이 안된 게시물
        sql  = "select bno,bpsent ";
        sql += "from positive ";
        sql += "where bno=" + str(bno) + " and bpsent='" + bpsent.replace("'","''") + "' "
        dbms.OpenQuery(sql)
        
        if dbms.GetTotal() == 0 :
            sql  = "insert into positive "
            sql += "(bpsent,bposi,bno) "
            sql += "values "
            sql += "( "
            sql += " '" + bpsent.replace("'","''") + "',"
            sql += " '" + str(bposi) + "',"
            sql += " '" + str(bno) + "' "
            sql += " ) "
            dbms.RunSQL(sql)
            dbms.DBClose()
            return True
# ]] ============================================




# [[ ad 테이블 조회
def AD_Select():
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from ad')
        total = dbms.GetTotal()
            
        items = []
        for i in range(total):
            item = { 
                "advertno"    : dbms.GetValue(i, 'advertno'),
                "category"    : dbms.GetValue(i, 'category'),
                "subclass"    : dbms.GetValue(i, 'subclass'),
                "productName" : dbms.GetValue(i, 'productName'),
                "price"       : dbms.GetValue(i, 'price'),
                "imageURL"    : dbms.GetValue(i, 'imageURL'),
                "detailURL"   : dbms.GetValue(i, 'detailURL'),
                "nouns"   : []
                }
            items.append(item)
        print(items)
            
        df = pd.DataFrame(items)
        print(df)
        dbms.DBClose()
        return items
# ]] ============================================


# [[ adkeyword 테이블 조회
def ADkey_First_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from adkeyword')
        total = dbms.GetTotal()
            
        adkeyword = []
        for i in range(total):
            item = { 
                "adkeyno"    : dbms.GetValue(i, 'adkeyno'),
                "keyword"    : dbms.GetValue(i, 'keyword'),
                "advertno"   : dbms.GetValue(i, 'advertno')
                }
            adkeyword.append(item)
        print(adkeyword)
            
        df = pd.DataFrame(adkeyword)
        print(df)
        dbms.DBClose()
        return adkeyword
# ]] ============================================


# [[ adkeyword 테이블 조회
def ADkey_Select(advertno):
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from adkeyword where advertno=' + advertno)
        total = dbms.GetTotal()
            
        adkeyword = []
        for i in range(total):
            item = { 
                "adkeyno"    : dbms.GetValue(i, 'adkeyno'),
                "keyword"    : dbms.GetValue(i, 'keyword'),
                "advertno"   : dbms.GetValue(i, 'advertno')
                }
            adkeyword.append(item)
        print(adkeyword)
            
        df = pd.DataFrame(adkeyword)
        print(df)
        dbms.DBClose()
        return adkeyword
# ]] ============================================


# [[ adkeyword 테이블 조회  
def ADkey_Select_last(adkeyno,count):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from adkeyword where adkeyno > '+ adkeyno + ' limit ' + count)
        total = dbms.GetTotal()
            
        items = []
        for i in range(total):
            item = { 
                "adkeyno"    : dbms.GetValue(i, 'adkeyno'),
                "keyword"    : dbms.GetValue(i, 'keyword'),
                "advertno"   : dbms.GetValue(i, 'advertno')
                }
            items.append(item)
        print(items)
            
        df = pd.DataFrame(items)
        print(df)
        dbms.DBClose()
        return items
# ]] ============================================



# [[ adkeyword 테이블에 데이터 추가
def ADKey_Insert(adkey,adsfr,advertno):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return False
    else :
        sql  = "select advertno,adkey ";
        sql += "from adkeyword ";
        sql += "where advertno=" + str(advertno) + " and adkey='" + adkey + "' "
        dbms.OpenQuery(sql)
        
        if dbms.GetTotal() == 0 :
            sql  = "insert into adkeyword "
            sql += "(adkey,adsfr,advertno) "
            sql += "values "
            sql += "( "
            sql += " '" + adkey + "',"
            sql += " '" + str(adsfr) + "',"
            sql += " '" + str(advertno) + "' "
            sql += " ) "
            dbms.RunSQL(sql)
            dbms.DBClose()
            return True
# ]] ============================================



# [[ 상품명에서 단어 추출
def Nouns(sentance):
    word_count_list = []
    
    words_list = []
    tmp = mecab.nouns(sentance)
    for i in tmp :
        words_list.append(i)
    count = Counter(words_list)
    nouns = count.most_common(20)
    return nouns

# ]] ============================================


# [[ bkeyword의 마지막 게시물 번호 조회
def Last_key_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select bkno,bno from bkeyword order by bno desc limit 1')
        total = dbms.GetTotal()
            
        bkeyword = []
        for i in range(total):
            item = { 
                "bkno"      : dbms.GetValue(i, 'bkno'),
                "bkey"   : dbms.GetValue(i, 'bkey'),
                "bkfr"    : dbms.GetValue(i, 'bkfr'),
                "bno"    : dbms.GetValue(i, 'bno')
                }
            bkeyword.append(item)
        print(bkeyword)
            
        df = pd.DataFrame(bkeyword)
        print(df)
        dbms.DBClose()
        return bkeyword
# ]] ============================================


# [[ board의 마지막 게시물 번호 조회
def Last_board_Select() :
    # DBManger객체 생성
    dbms = db.DBManager()
    # DB연결
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select bno,btitle from board order by bno desc limit 1')
        total = dbms.GetTotal()
        
        board = []
        for i in range(total):
            item = { 
                "bno"      : dbms.GetValue(i, 'bno'),
                "btitle"   : dbms.GetValue(i, 'btitle')
                }
            board.append(item)
        #print(board)
            
        df = pd.DataFrame(board)
        #print(df)
        
        dbms.CloseQuery()   
        dbms.DBClose()
        return board
# ]] ============================================




# [[ bkeyword의 마지막 키워드 번호 조회
def Last_keynum_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select bkno,bno from bkeyword order by bkno desc limit 1')
        total = dbms.GetTotal()
            
        bkeyword = []
        for i in range(total):
            item = { 
                "bkno"      : dbms.GetValue(i, 'bkno'),
                "bkey"   : dbms.GetValue(i, 'bkey'),
                "bkfr"    : dbms.GetValue(i, 'bkfr'),
                "bno"    : dbms.GetValue(i, 'bno')
                }
            bkeyword.append(item)
        print(bkeyword)
            
        df = pd.DataFrame(bkeyword)
        print(df)
        dbms.DBClose()
        return bkeyword
# ]] ============================================


# [[ adkeyword의 마지막 키워드 번호 조회
def Last_adkey_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from adkeyword order by adkeyno desc limit 1')
        total = dbms.GetTotal()
            
        adkeyword = []
        for i in range(total):
            item = { 
                "advertno"  : dbms.GetValue(i, 'advertno'),
                "advertno"  : dbms.GetValue(i, 'advertno'),
                "adkeyno"   : dbms.GetValue(i, 'adkeyno')
                }
            adkeyword.append(item)
        print(adkeyword)
            
        df = pd.DataFrame(adkeyword)
        print(df)
        dbms.DBClose()
        return adkeyword
# ]] ============================================


# [[ adksimilar의 마지막 키워드 번호 조회
def Last_adksi_Select():
    dbms = db.DBManager()
    bkno = ''
    bkey = ''
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return None
    else :
        dbms.OpenQuery('select * from adksimilar order by adkeyno desc limit 1')
        total = dbms.GetTotal()
            
        adksimilar = []
        for i in range(total):
            item = { 
                "adksno"    : dbms.GetValue(i, 'adksno'),
                "adkskey"   : dbms.GetValue(i, 'adkskey'),
                "adksfr"    : dbms.GetValue(i, 'adksfr'),
                "adkeyno"   : dbms.GetValue(i, 'adkeyno')
                }
            adksimilar.append(item)
        print(adksimilar)
            
        df = pd.DataFrame(adksimilar)
        print(df)
        dbms.DBClose()
        return adksimilar
# ]] ============================================


# [[ adksimilar 테이블에 데이터 추가
def ADKeysimilar_Insert(adkskey,adksfr,adkeyno):
    dbms = db.DBManager()
    if dbms.DBOpen('192.168.0.146', 'trip', 'ezen', '1234') == False :
        return False
    else :
        sql  = "select * ";
        sql += "from adksimilar ";
        sql += "where adkeyno=" + str(adkeyno) + " and adkskey='" + adkskey + "' "
        dbms.OpenQuery(sql)
        
        if dbms.GetTotal() == 0 :
            sql  = "insert into adksimilar "
            sql += "(adkskey,adksfr,adkeyno) "
            sql += "values "
            sql += "( "
            sql += " '" + adkskey + "',"
            sql += " '" + str(adksfr) + "',"
            sql += " '" + str(adkeyno) + "' "
            sql += " ) "
            dbms.RunSQL(sql)
            dbms.DBClose()
            return True
# ]] ============================================













