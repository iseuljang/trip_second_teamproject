import c_s_note_func as func
import dbmanager as db
dbms = db.DBManager()


bkey_bkno = func.Last_keynum_Select()
bkno_last = int(bkey_bkno[0]['bkno'])
print(bkno_last)

bsi_bsno = func.Last_similar_Select()
bsno_last = int(bsi_bsno[0]['bkno'])
print(bsno_last)


# bkeyword의 bkno와 bsimilar의 bsno를 비교하여
# bkeyword의 bkno가 더 크면(새로 추가된 키워드가 있으면)
# 그 차이만큼 추가
if bkno_last > bsno_last :
    count = bkno_last - bsno_last
    print(count)

    bkeyword = func.Select(str(bsno_last), str(count))
    #print(bkeyword)
    
    #print(bkeyword[0]['bkey'])
    
    bskey = ''
    bsfr = ''
    bkno = ''
    for i in range(len(bkeyword)) :
        key = bkeyword[i]['bkey']
        print(key)
        word,similar = func.Similar(key)
        bkno = bkeyword[i]['bkno']
        print(bkno)
        print(word)
        print(similar)
        for s_word in similar :
            #print(s_word[0])
            #print(s_word[1])
            bskey = s_word[0]
            bsfr  = s_word[1]
            if bskey is not None and bsfr is not None:
                func.S_Insert(bskey,bsfr,bkno)
else :
    print('이전 작업 이후 추가된 키워드가 없습니다.')


































