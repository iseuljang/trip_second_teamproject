📖 맞춤형 광고를 매칭하는 빅데이터/인공지능 분석
-
게시글을 분석하여 게시글 긍정문장에서 키워드를 추출하고 유사단어로 광고 매칭

## 목차
  - [개발기간](#개발기간)
  - [팀 구성](#팀-구성)
  - [개발환경](#개발환경)
  - [담당한 기능](#담당한-기능)
  - [트러블 슈팅](#트러블-슈팅)
  - [개선할 부분](#개선할-부분)

🗓️개발기간 
-
  + 2024.05.20 ~ 2024.06.21

👥팀 구성
-
  + 박 OO : 팀장, 게시글유사단어로 광고카테고리 지정 및 광고매칭 1, 네이버블로그 크롤링, 모달창에 게시글 분석 결과 출력
  + 장 OO : 부팀장, 게시글의 지역도출 및 지역맛집 매칭1, 지역맛집 크롤링, 게시글 오른쪽에 지역맛집 출력
  + 유 OO : 광고상품 분류 및 저장 1, 관리자 페이지에 광고관리 페이지 제작, 쿠키로 클릭한 광고가 게시글 하단 3번째 칸에 출력되도록 구현
  + 장이슬 : 게시글긍부정분석 및 유사단어 학습 및 도출 1, 쿠팡 크롤링, 게시글 하단에 출력되는 광고가 없을 시 1,2번째 칸에 vip 상품이 출력되도록 구현

🛠개발환경
-
  + HTML5, CSS3, JavaScript, Jquery-3.7.1, Apache Tomcat v9.0, MySQL v8.0.36
  + JDK 18.0.2.1, ERMaster, StarUML v6.1.0
  + Python(pandas, numpy,konlpy 등등)
  + 인공지능스킬(tensorflow 기반 긍부정 분석, gensim 기반 유사도 분석, 한글 형태소 분석, 웹크롤링)


🖥담당한 기능
-
  - **웹페이지 수정(Ajax, jQuery, JavaScript)**
    - 게시글 페이징부분에 첫페이지와 끝페이지로 가는 버튼 생성
    - 기존 검색창에서 “”(쌍따옴표) 검색 시 검색결과로 나온 게시글을 조회할 수 없었던 부분을 수정
    - 기존 게시글 조회 시 오른쪽에 있던 down top 버튼의 위치 변경과 맛집 정보 담을 칸 추가
    - 추천 및 비추천 시 전체 새로고침을 출력 부분만 변경되도록 수정
    - 댓글 등록 및 삭제 시 새로고침을 출력 부분만 변경되도록 수정
    - 댓글 수정 시 기존 프롬프트 창을 댓글 입력 창으로 변경하고, 취소 버튼 클릭 시 원래 댓글 내용이 보이도록 수정
    ![board_bottom.jpg](https://github.com/iseuljang/trip_second_teamproject/blob/master/board_bottom.jpg)


  - **데이터 분석(Python, 인공지능스킬)**
    - 데이터 수집
      - 쿠팡 쇼핑 리뷰 웹크롤링<br>
        [사용한 소스](https://github.com/JaehyoJJAng/Coupang-Review-Crawling)
      - 쿠팡 상품 웹크롤링<br>
        [참고한 소스](https://github.com/daje0601/coupang_crawling)
    - 데이터 처리
        - 네이버 리뷰 평점이 4, 5인 리뷰는 긍정, 평점 1, 2인 리뷰는 부정으로 분류
        - 중복 리뷰와 결측치 제거
        - 정규표현식을 사용해 한글 이외의 문자를 제거
        - 불용어를 지정하여 불필요한 토큰 제거
        - 리뷰의 최대 길이를 확인하여 전체 문장을 동일한 길이로 패딩 처리
    - 데이터 분석
        - 게시글을 문장 단위로 나누어 tensorflow와 keras를 사용하여 긍부정 분석        
         ![문장긍부정분석.jpg](https://github.com/iseuljang/trip_second_teamproject/blob/master/%EB%AC%B8%EC%9E%A5%EA%B8%8D%EB%B6%80%EC%A0%95%EB%B6%84%EC%84%9D.jpg)

        - 쿠팡 쇼핑 리뷰를 gensim Word2Vec으로 분석하여 단어 간 유사도 학습         
         ![유사단어.jpg](https://github.com/iseuljang/trip_second_teamproject/blob/master/%EC%9C%A0%EC%82%AC%EB%8B%A8%EC%96%B4.jpg)

    - 데이터 저장
        - 긍정문장과 긍정비율을 DB에 저장
        - 긍정 문장의 단어 중 빈도수가 3 이상인 단어를 빈도수와 함께 DB에 저장
        - 빈도수가 3 이상인 단어가 없을 경우 빈도수가 2인 단어를 빈도수와 함께 DB에 저장
        - 게시글에 저장된 단어를 유사도 학습 모델로 유사 단어와 유사도를 도출하여 DB에 저장
    - 데이터 시각화
        - 게시글 하단에 상품이 출력되는 부분에서 게시글 키워드로 도출된 광고가 있을 경우 해당 광고가 1번, 2번 칸에 보여지고, 없을 경우 VIP 브랜드의 광고를 우선순위에 따라 보여지도록 구현
        - 네이버 쇼핑 리뷰에서 긍정 및 부정 문장의 빈도수가 높은 키워드로 워드클라우드 생성<br>
          긍정문장단어
        ![wc_mecab_ns_positive.png](https://github.com/iseuljang/trip_second_teamproject/blob/master/wc_mecab_ns_positive.png)
          부정문장단어
        ![wc_mecab_ns_negative.png](https://github.com/iseuljang/trip_second_teamproject/blob/master/wc_mecab_ns_negative.png)
        - 긍정 및 부정 리뷰의 문장 길이를 히스토그램으로 시각화
        ![s_positive_negetive_reviews.png](https://github.com/iseuljang/trip_second_teamproject/blob/master/s_positive_negetive_reviews.png)



💡트러블 슈팅
-
  1️⃣ 데이터 전처리 시 정규표현식 미적용
  - 문제 배경
    - 데이터 전처리를 위해 정규표현식을 적용했으나, 한글 이외의 문자가 그대로 남아 있었습니다.
  - 해결 방법
    - 정규표현식을 사용할 때 추가로 필요한 인자를 추가하였습니다.
    - 추가로 replace 부분을 수정하면서 공백으로 변환된 데이터를 NaN으로 변환하여 drop시키는 코드를 빈칸 여부를 확인하여 바로 drop시키도록 수정하였습니다.
  - 코드 비교
    - 수정전      
        ```        
        # 정규표현식 사용 
        # 학습 데이터
        train_data['reviews'] = train_data['reviews'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","")

        # 한글 제외하고 모두 제거 후 결측치 확인
        train_data['reviews'].replace('', np.nan, inplace=True)
        print('한글 제외후 결측치 개수 확인')
        print(train_data.isna().sum())
        print('-'*50)
        ```       
    - 수정후
       ```
      # 정규표현식 사용 
      # 학습 데이터
      train_data['reviews'] = train_data['reviews'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","",regex=True)
      
      # 데이터 전처리 후 reviews가 비어있는 데이터 확인
      print(train_data[train_data['reviews']==''])
      train_data.drop(train_data[train_data['reviews']==''].index,inplace=True)
      train_data.isna().sum()
      ```     
    
- 해당 경험을 통해 알게 된 점
  - 파이썬에서 replace로 정규표현식을 사용하려면 regex=True를 입력해야 한다는 것을 알게 되었습니다.
  

 2️⃣ 코드 복잡성 문제
  - 문제 배경
    - 하나의 py 파일에 DB 연결, 게시글 불러오기, 긍부정 분석, 유사 단어 분석을 모두 포함하려다 보니 코드가 길어져서 동작 확인이 어려워졌습니다.
  - 해결 방법
    - 모든 코드를 하나의 파일에 넣지 않고, 각 기능을 수행하는 함수를 모아놓은 파일을 생성했습니다. 그런 다음, 이 함수 파일을 import하여 분할 작업을 수행했습니다.
  - 코드 비교
    - 수정전 코드
      ```
        <!-- c_s_note.py -->
        def sentiment_predict(new_sentence):
        new_sentence = re.sub(r'[^ㄱ-ㅎㅏ-ㅣ가-힣 ]','', new_sentence)
        new_sentence = okt.morphs(new_sentence, stem=True) # 토큰화
        new_sentence = [word for word in new_sentence if not word in stopwords] # 불용어 제거
        encoded = tokenizer.texts_to_sequences([new_sentence]) # 정수 인코딩
        pad_new = pad_sequences(encoded, maxlen = max_len) # 패딩
        score = float(loaded_model.predict(pad_new)) # 예측
        if(score > 0.7):
          print("{:.2f}% 확률로 긍정 리뷰입니다.\n".format(score * 100))
          print('-'*50)
          return score
      result_list = []
      
      for item in df['bnote'] :
          result = []
          # item-> 하나의 게시글
      #    print('-'*20,item,sep='\n')
          item = item.replace('\r','')
          item = re.sub('\n+','', item)  #정규표현식 re.sub을 이용한 문자열 치환하기
          print(item)
          sent_list = split_sentences(item)
      #    for line in sent_list:
      #        print(line,end='\n---------------------------\n')
          for sent in sent_list:
      #        print(sent)
              score = sentiment_predict(sent)
              if( score is not None ) :
                  result.append((sent,score))
          result_list.append(result)
      print(len(result_list[0]))
      print('-'*50)
      
      #=====================================================================
      from collections import Counter
      
      word_count_list = []
      stopword = pd.read_csv('stopword.txt')
      
      for result in result_list :
          # result -> 게시글
          # result의 원소 (문장,긍부정점수)
          
          sent_list = []
          print('result')
          print(result)
          for one,two in result :
              # result -> 게시글의 문장의 리스트
              print('one')
              print(one)
              sent_list.append(one)
          words_list = []
          for sent in sent_list :
              tmp = okt.nouns(sent)
              print(tmp)
              for i in tmp :
                  words_list.append(i)
          print(words_list)
          count = Counter(words_list)
          nouns = count.most_common(20)
          print(nouns)
          print('-'*50)
      
      #    df['tokenized'] = df['reviews'].apply(okt.nouns)
      #    df['tokenized'] = df['tokenized'].apply(lambda x: [item for item in x if item not in stopword])
      
      #    print(df['tokenized'])
      
      """
          c = df['tokenized']
      
      #with open('positive_words.pickle','rb') as f :
      #    positive_words = pickle.load(f)
      
          dano = []
          for i in c:
              count = Counter(i)
              nouns = count.most_common(20)
              print('빈도')
              print(nouns)
              print('-'*50)
          
              for o,t in nouns:
                  dano.append(o)
          print('단어만 남김')
          print(dano)
          print('-'*50)
      '''
      search = []
      for i in dano :
          for x in positive_words :
              if i not in x :
                  continue
              else:
                  search.append(i)
      search = set(search)
      #print(search)
      '''
      """
      #============================================================
      with open('c_loaded_model.pickle','rb') as f :
          c_loaded_model = pickle.load(f)
      
      
      #print(c_loaded_model.wv.most_similar('분유',topn=20))
      
          for one,two in nouns:
              if len(one) > 1 :
                  if one in c_loaded_model.wv :
                      print(one,'(',two,')', sep='')
                      print(c_loaded_model.wv.most_similar(one,topn=10))
                      print('-'*50)
                  else:
                      continue
              else:
                  continue
        ```        
    - 수정후 코드
       ```
      <!-- c_s_note_func.py -->
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
      ```
  - 해당 경험을 통해 알게 된 점
    - 기능별로 동작을 함수로 나누면 코드가 더 간단하게 운용될 수 있다는 점을 알게 되었습니다.

📝개선할 부분
-
  - 유사도 학습 시 한글을 제외한 문자를 제거하였지만 한글로 ‘ㅡ(으)’, ‘ㅠ’, ‘ㅜ’, ‘ㅋ’, ’ㅌ’, ’ㅇ’ 등으로 작성된 부분도 유사도 학습되어 유사단어로 도출되는 문제가 있습니다.
  - 긍정문장에서 빈도가 높은 단어를 추출할 때 사람 이름이 나오기도 하고 '애기', '아기' 등의 동의어 처리가 제대로 이루어지지 않았습니다.  데이터 전처리 부분이 미흡했습니다.


<div align="right">
  
[목차로](#목차)

</div>
