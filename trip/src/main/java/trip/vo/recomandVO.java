package trip.vo;

public class recomandVO 
{
	private String rcno;   // 추천번호
	private String rcstate;// 추천상태
	private String bno;    // 게시물번호
	private String uno;    // 회원번호
	
	public String getRcno() { return rcno; }
	public String getRcstate() { return rcstate; }
	public String getBno()  { return bno;  }
	public String getUno()  { return uno;  }
	
	public void setRcno(String rcno)       { this.rcno = rcno; }
	public void setRcstate(String rcstate) { this.rcstate = rcstate; }
	public void setBno(String bno)         { this.bno = bno;   }
	public void setUno(String uno)         { this.uno = uno;   }
}
