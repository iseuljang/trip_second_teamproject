import c_s_note_func as func
import dbmanager as db
dbms = db.DBManager()


board_bno = func.Last_board_Select()
board_last = int(board_bno[0]['bno'])
print(board_last)

bkey_bno = func.Last_key_Select()
bkey_last = int(bkey_bno[0]['bno'])
print(bkey_last)


# bkeyword의 bno와 board의 bno를 비교하여
# board의 bno가 더 크면(새로 추가된 게시글이 있으면)
# 그 차이만큼 추가
if board_last > bkey_last :
    count = board_last - bkey_last
    print(count)
    board = func.LoadFromDB(str(bkey_last),str(count))
    print(board)
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
    for i in range(len(board)):
        
        #게시물을 문장 단위로 끊어서 각 문장별로 긍정인 문장만 
        #result에 넣는다.
        result = func.Sentiment(board[i]['bnote'])
        sentance = ""
        sent_list = []
        positive = []
        for munjang in result :
            sentance += munjang[0]
            
            sent_list.append(munjang[0])
            positive.append(munjang[1])
        
        board[i]['sentance'] = sentance
        board[i]['sent_list'] = sent_list
        board[i]['positive'] = positive
        
        # 긍정문장만 빈도수 검사실행
        nouns = func.Freq(sentance)
        board[i]['nouns'] = nouns
        bno = board[i]['bno']
        
        for p in result :
            bpsent = p[0]
            bposi  = p[1]
            func.P_Insert(bpsent,bposi,bno)

        count = 0            
        for n in board[i]['nouns']:
            if len(n[0]) < 2 :
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
                if len(n[0]) < 2 :
                    #2단어 미만은 제외
                    continue
                bkey = n[0]
                bkfr = n[1]            
                if n[1] >= 2 :
                    # 빈도수가 2이상인 단어에 대한 처리
                    # bkeyword에 게시글에서 추출한 단어와 빈도수, bno 넣어 저장
                    bkno = func.Insert(bkey, bkfr, bno)
else :
    print('이전 게시글에서 추가작성된 게시글이 없습니다.')







