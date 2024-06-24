import pandas as pd        #판다스
from konlpy.tag import Okt #형태소
import pickle              #피클
import nltk                #나이브베이즈 가상머신
import dbmanager as db     #데이터베이스
#형태소 분석기
okt = Okt()

dbms = db.DBManager()
if dbms.DBOpen('192.168.0.146','trip','ezen','1234') == False :
    print("=================DB에 연결 실패========================")
else :
    print("=================DB에 연결 성공========================")
    sql = ' select * from board '
    dbms.OpenQuery(sql)
    text  = dbms.GetValue(1303, 'bnote') 
    words = okt.nouns(text)
    print(words)
    print("※블로그내용 형태소※")
    print("="*20)
    
    #블로그 내용 형태소 분석후 2글자 이상인 형태소만 모아서 새로운 리스트 만듬
    new_words = [] 
    for i in words :
        if len(i) >= 2 :
             new_words.append(i)
    print(new_words)
    print("※2글자 이상인 블로그내용 형태소※")
    print("="*20)
    
    #전국지명 데이터 
    df = pd.read_excel('전국지명.xlsx')
    df.drop('Unnamed: 0', axis=1 , inplace=True)
    df = list(df['데이터'])
            
    dic = {}
    for i in new_words :
        for j in df :
            word = j.find(i)
            if word >= 0 :
                print(i,"있음")
                if i in dic :
                    dic[i] += 1
                else :
                    dic[i] = 1
    print(dic)
    print("※블로그 내용중 언급된 지역 빈도수※")
    print("="*20)

    local  = []
    for key in dic :
        local.append(key)
    print(local)
    print("="*20)
    
    '''   
    score  = []

    for key in dic :
        print(key,dic[key])
        print("="*20)
        local.append(key)
        score.append(dic[key])
    '''
