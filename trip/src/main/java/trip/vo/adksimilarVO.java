package trip.vo;

public class adksimilarVO 
{
	// field
	private String adksno;     // 광고키워드 유사어 번호
	private String adkskey;    // 광고 키워드 유사어
	private String adksfr;     // 광고 키워드 유사도
	// foreign key
	private String adkeyno;    // 광고물 키워드 번호
	private String keyword;  // 광고물 키워드
	
	
	
	// getter
	public String getAdksno()     { return adksno;    }
	public String getAdkskey()    { return adkskey;   }
	public String getAdksfr()     { return adksfr;    }
	// foreign key
	public String getAdkeyno()    {	return adkeyno;   }
	public String getKeyword()    {	return keyword;   }
	
	
	
	// setter
	public void setAdksno(String adksno)	      {	this.adksno = adksno;       }
	public void setAdkskey(String adkskey)        {	this.adkskey = adkskey;     }
	public void setAdksfr(String adksfr)          {	this.adksfr = adksfr;       }
	// foreign key
	public void setAdkeyno(String adkeyno)	      {	this.adkeyno = adkeyno;     }
	public void setKeyword(String keyword)	      {	this.keyword = keyword;     }
}
