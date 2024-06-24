import c_s_note_func as func
import dbmanager as db
dbms = db.DBManager()


bkeyword = func.First_Select()
#print(bkeyword)

#print(bkeyword[0]['bkey'])

bskey = ''
bsfr = ''
bkno = ''
for i in range(500) :
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






























