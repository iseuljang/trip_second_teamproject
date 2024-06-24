package trip.vo;

public class bestlocalfoodVO 
{
	// bestlocalfood 테이블
	private String BFno;        // 맛집번호
	private String BFlocal;     // 맛집지역
	private String BFtitle;     // 맛집이름
	private String BFcategory;  // 맛집카테고리
	private String BFimageurl;  // 맛집이미지
	private String BFurl;       // 맛집정보 보여주는 사이트주소
	// 외래키
	private String BFbno;       // 게시물번호
	
	public String getBFno() { return BFno; }
	public String getBFlocal() { return BFlocal; }
	public String getBFtitle() { return BFtitle; }
	public String getBFcategory() { return BFcategory; }
	public String getBFimageurl() { return BFimageurl; }
	public String getBFbno() { return BFbno; }
	public String getBFurl() { return BFurl; }
	
	public void setBFno(String bFno) { BFno = bFno; }
	public void setBFlocal(String bFlocal) { BFlocal = bFlocal; }
	public void setBFtitle(String bFtitle) { BFtitle = bFtitle;	}
	public void setBFcategory(String bFcategory) { BFcategory = bFcategory; }
	public void setBFimageurl(String bFimageurl) { BFimageurl = bFimageurl;	}
	public void setBFbno(String bFbno) { BFbno = bFbno;	}
	public void setBFurl(String bFurl) { BFurl = bFurl;	}
	
}
