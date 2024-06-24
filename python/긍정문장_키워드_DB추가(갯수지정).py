import c_s_note_func as func
import pandas as pd
import dbmanager as db
dbms = db.DBManager()

# 2100 돌림 
board = func.First_LoadFromDB(2100,200)

#print(board[0])
result = []
result_list = []
similar_list = []
word = ''
similar = ''
bkey = ''
bkfr = ''
bskey = ''
bsfr = ''
bkno = ''

sentance = ""
sent_list = []
positive = []
for i in range(len(board)):
    sentance = board[i]['bnote']
    #print(board[i]['bnote'])
    #print('-'*30)
    #게시물을 문장 단위로 끊어서 각 문장별로 긍정인 문장만 
    #result에 넣는다.
    result = func.Sentiment(board[i]['bnote'])
    for munjang in result :
        sentance += munjang[0]
        
        sent_list.append(munjang[0])
        positive.append(munjang[1])
    
    board[i]['sentance'] = sentance
    board[i]['sent_list'] = sent_list
    board[i]['positive'] = positive
    
    #print(board[i]['sent_list'])
    #print(board[i]['positive'])
    #print(board[i]['sentance'])
    #print("=" * 30)           
    # 긍정문장만 빈도수 검사실행
    nouns = func.Freq(sentance)
    board[i]['nouns'] = nouns
    #print(board[i]['nouns'])
    #print("=" * 30)
    bno = board[i]['bno']
    stopword = pd.read_csv('stopword.txt')
    for p in result :
        bpsent = p[0]
        bposi  = p[1]
        func.P_Insert(bpsent,bposi,bno)
    count = 0 
    #print(bno)
    for n in board[i]['nouns']:
        if len(n[0]) < 2 or n[0] in stopword:
            #2단어 미만은 제외
            continue
        bkey = n[0]
        bkfr = n[1]            
        if n[1] >= 3 :
            # 빈도수가 3이상인 단어에 대한 처리
            # bkeyword에 게시글에서 추출한 단어와 빈도수, bno 넣어 저장
            bkno = func.Insert(bkey, bkfr, bno)
            count = count + 1
    #빈도 3이상인 단어가 하나도 안 들어갔으면 빈도 2이상인 단어를 넣음.
    if count == 0 :
        for n in board[i]['nouns']:
            if len(n[0]) < 2 or n[0] in stopword:
                #2단어 미만은 제외
                continue
            bkey = n[0]
            bkfr = n[1]            
            if n[1] >= 2 :
                # 빈도수가 2이상인 단어에 대한 처리
                # bkeyword에 게시글에서 추출한 단어와 빈도수, bno 넣어 저장
                bkno = func.Insert(bkey, bkfr, bno)




