package trip.vo;

public class adkeywordVO 
{
	// field
	private String adkeyno;   // 광고물 키워드 번호
	private String keyword;   // 광고 키워드
	// foreign key
	private String advertno;  // 광고 번호
	
	
	
	// getter
	public String getAdkeyno()     {	return adkeyno;    }
	public String getKeyword()     {	return keyword;    }
	// foreign key
	public String getAdvertno()    {	return advertno;   }
	
	
	
	// setter
	public void setAdkeyno(String adkeyno)   { this.adkeyno = adkeyno;   }
	public void setKeyword(String keyword)   { this.keyword = keyword;   }
	// foreign key
	public void setAdvertno(String advertno) { this.advertno = advertno; }
}
