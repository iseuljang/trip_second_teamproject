package trip.dto;
import trip.dao.*;
import trip.vo.*;
import trip.mail.*; 
import java.io.*;
import java.util.*;
import java.text.*;

// 회원정보 관리 클래스
public class userDTO<SendMail> extends DBManager
{
	// 아이디 중복 검사 
	// 리턴값 : true - 중복된 아이디, false - 중복이 안된 아이디
	public boolean CheckID(String uid)
	{	// 부모상속을 받은 경우라 super. / this. / 혹은 없이  DBOpen() 이렇게도 사용 가능
		this.DBOpen();
		String sql = "";
		sql  = "select uid ";
		sql += "from user ";
		sql += "where uid = '" + uid + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	//아이디가 있음
			this.DBClose();
			return true;
		}
		this.DBClose();
		return false;
	}
	//아이디 중복 검사 오버로딩
	public boolean CheckID(userVO vo)
	{
		return CheckID(vo.getUid());
	}
	
	// 회원가입 처리 --return 값 :: true 등록성공   false 등록실패
	public boolean Join(userVO vo)
	{	//중복된 아이디 체크하기
		if( CheckID(vo.getUid()) == true)
		{	//아이디가 중복됨
			return false;
		}
		
		if( CheckUnick(vo.getUnick()) == true)
		{	//닉네임 중복됨
			return false;
		}
		
		this.DBOpen();
		String sql = "";
		
		sql = "insert into user ";
		sql += "(uid,upw,uname,unick,email,uicon,season,local,human,move,schedule,uinout) ";
		sql += "values ";
		sql += " ( ";
		sql += "'" + vo.getUid()     + "',";
		sql += "md5('" + vo.getUpw() + "'),";
		sql += "'" + vo.getUname()   + "',";
		sql += "'" + vo.getUnick().replace("<","&lt;").replace(">","&gt;").replace("\n","\n<br>").replace("'", "''") + "',";
		sql += "'" + vo.getEmail()  + "',";
		sql += "'" + vo.getUicon()  + "',";
		sql += "'" + vo.getSeason()  + "',";
		sql += "'" + vo.getLocal()  + "',";
		sql += "'" + vo.getHuman()  + "',";
		sql += "'" + vo.getMove()  + "',";
		sql += "'" + vo.getSchedule()  + "',";
		sql += "'" + vo.getUinout()  + "'";
		sql += " ) ";
		this.RunSQL(sql);
		
		//등록된 회원 번호를 얻는다
		sql = "select last_insert_id() as uno";
		this.OpenQuery(sql);
		this.GetNext();
		vo.setUno(this.GetValue("uno"));
		this.CloseQuery();
		
		this.DBClose();
		return true;
	}
	
	
	// 회원 로그인 처리
	public userVO Login(String uid, String upw)
	{
		this.DBOpen();
		String sql = "";
		sql  = "select ";
		sql += "* ";
		sql += "from user ";
		sql += "where uid = '" + uid + "' and upw = md5('" + upw + "') and uretire = 'N' and ustop = 'N' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{
			//회원정보가 없음
			this.DBClose();
			return null;
		}
		userVO vo = new userVO();
		vo.setUno(this.GetValue("uno"));
		vo.setUid(this.GetValue("uid"));
		vo.setUname(this.GetValue("uname"));
		vo.setUnick(this.GetValue("unick"));
		vo.setAdmin(this.GetValue("admin"));
		vo.setUicon(this.GetValue("uicon"));
		vo.setEmail(this.GetValue("email"));
		vo.setSeason(this.GetValue("season"));
		vo.setLocal(this.GetValue("local"));
		vo.setHuman(this.GetValue("human"));
		vo.setMove(this.GetValue("move"));
		vo.setSchedule(this.GetValue("schedule"));
		vo.setUinout(this.GetValue("uinout"));
		vo.setUstop(this.GetValue("ustop"));
		vo.setUstopdate(this.GetValue("ustopdate"));
		vo.setUstopend(this.GetValue("ustopend"));
		this.DBClose();
		return vo;
	}
	
	//회원 탈퇴 처리(userVO)
	public boolean Retire(userVO vo)
	{
		return Retire(vo.getUid(),vo.getUreason(),vo.getUpw());
	}
	
	//회원 탈퇴 처리
	public boolean Retire(String uid, String ureason, String upw)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		// 회원탈퇴여부 변경
		sql  = "update user set ";
		sql += "uretire = 'Y', ";
		sql += "ureason = '" + ureason + "' ";
		sql += "where uid = '" + uid + "' and upw = md5('" + upw +"')";
		this.RunSQL(sql);
		
		this.DBClose();
		return true;
	}
	
	//계정이 탈퇴 혹은 정지된 상태임을 확인
	public userVO CheckState(String uid, String upw)
	{
		userVO vo = new userVO();
		if( this.DBOpen() == false )
		{
			return vo;
		}
		String sql = "";
		sql  = "select uretire, ustop from user";
		sql += " where uid = '" + uid + "' and upw = md5('" + upw +"')";
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			//회원정보가 없음
			this.DBClose();
			return vo;
		}
		vo.setUstop(this.GetValue("ustop"));
		vo.setUretire(this.GetValue("uretire"));
		
		this.DBClose();
		return vo;
	}
	
	//쿠키 취소를 위한 체크 오버로딩
	public userVO CheckState(String uid)
	{
		userVO vo = new userVO();
		if( this.DBOpen() == false )
		{
			return vo;
		}
		String sql = "";
		sql  = "select uretire, ustop from user";
		sql += " where uid = '" + uid + "'";;
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			//회원정보가 없음
			this.DBClose();
			return vo;
		}
		vo.setUstop(this.GetValue("ustop"));
		vo.setUretire(this.GetValue("uretire"));
		
		this.DBClose();
		return vo;
	}
	
	//회원정지
	public boolean Stop(String ustopdate,String uno)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		
		//회원정지
		if(!ustopdate.equals("0"))
		{	// 1주일, 2주일, 한달 정지인 경우
			sql  = "update user set ";
			sql += "ustop = 'Y', ";
			sql += "ustopdate = '" + ustopdate + "', ";
			sql += "ustopend = DATE_ADD(NOW(), INTERVAL " + ustopdate + " DAY) ";
			sql += "where uno = " + uno;
			this.RunSQL(sql);
		}else
		{	// 영구정지인 경우
			sql  = "update user set ";
			sql += "ustop = 'Y', ";
			sql += "ustopend = '2099-12-31' ";
			sql += "where uno = " + uno;
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
	}
	
	//회원정지(시간을 더하는 것이 아닌, 정지날짜를 자체를 설정)
	public boolean Stop2(String ustopdate,String uno)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		
		//회원정지
		if(!ustopdate.equals("0"))
		{	// 1주일, 2주일, 한달 정지인 경우
			sql  = "update user set ";
			sql += "ustop = 'Y', ";
			sql += "ustopend = '" + ustopdate + "' ";
			sql += "where uno = " + uno;
			this.RunSQL(sql);
		}else
		{	// 영구정지인 경우
			sql  = "update user set ";
			sql += "ustop = 'Y', ";
			sql += "ustopend = '2099-12-31' ";
			sql += "where uno = " + uno;
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
	}
	
	//회원정지 해제
	public boolean Stopend(String uid)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		String sql = "";
		sql  = "update user set ";
		sql += "ustop = 'N', ";
		sql += "ustopdate = -1 ";
		sql += "where uid = '" + uid + "' ";
		sql += " and ustopend <= now()";
		this.RunSQL(sql);
		
		this.DBClose();
		return true;
	}
	// 관리자페이지에서 회원정지해제
	public boolean lift_sanctions(String uno)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		String sql = "";
		sql  = "update user set ";
		sql += "ustop = 'N', ";
		sql += "ustopdate = -1, ";
		sql += "ustopend = null ";
		sql += "where uno = '" + uno + "' ";
		this.RunSQL(sql);
		
		this.DBClose();
		return true;
	}
	
	//회원정지일 얻기
	public userVO Stopenddate(String uid)
	{
		if( this.DBOpen() == false )
		{
			return null;
		}
		
		String sql = "";
		sql  = "select uid,ustopenddate ";
		sql += "from user ";
		sql += "where uid = '" + uid + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{	
			this.DBClose();
			return null;
		}
		
		userVO vo = new userVO();
		vo.setUno(this.GetValue("uno"));
		vo.setUid(uid);
		vo.setUstop(this.GetValue("ustop"));
		vo.setUstopdate(this.GetValue("ustopdate"));
		vo.setUstopend(this.GetValue("ustopend"));
		
		this.DBClose();
		return vo;
	}
	
	//아이디 찾기 
	public userVO Search(String uname,String email)
	{
		userVO vo = null;
		
		if( this.DBOpen() == false )
		{
			return vo;
		}
		String sql = "";
		sql  = "select * ";
		sql += "from user ";
		sql += "where uname = '" + uname + "' and email = '" + email + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	
			vo = new userVO();
			vo.setUid(this.GetValue("uid"));
			vo.setUname(this.GetValue("uname"));
			this.DBClose();
			return vo;
		}else 
		{
			this.DBClose();
			return vo;
		}
	}
	
	//아이디 찾기( 비밀번호찾기용 오버로딩 )
	public userVO Search(String uid, String uname,String email)
	{
		userVO vo = null;
		if( this.DBOpen() == false )
		{
			return vo;
		}
		String sql = "";
		sql  = "select * ";
		sql += "from user ";
		sql += "where uid = '"+ uid +"' and uname = '" + uname + "' and email = '" + email + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	
			vo = new userVO();
			vo.setUid(this.GetValue("uid"));
			vo.setUname(this.GetValue("uname"));
			vo.setUpw(this.GetValue("upw"));
			return vo;
		}else 
		{
			this.DBClose();
			return vo;
		}
	}

	//비밀번호 변경
	public boolean Change(userVO vo)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		//비밀번호 변경
		if(!vo.getUpw().equals(""))
		{
			sql  = "update user set ";
			sql += "upw = md5('" + vo.getUpw() + "') ";
			sql += "where uid = '" + vo.getUid() + "' ";
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
	}
	
	// 기존 비밀번호와 같은지 비교 
	public boolean DuplicateCheck(userVO uvo)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		//비밀번호 변경
		sql  = "select * from user ";
		sql += "where uid = '"+ uvo.getUid() +"' and "; 
		sql += "uname = '"+ uvo.getUname() +"' and ";
		sql += "upw = md5('" + uvo.getUpw() + "') ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{	
			this.DBClose();
			return false;
		}
		
		this.DBClose();
		return true;
	}
	
	// 내정보보기에서 수정
	public boolean MyChange(userVO vo)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		String sql = "";
		//비밀번호 확인
		sql  = "select * ";
		sql += "from user ";
		sql += "where upw = md5('" + vo.getUpw() + "') and uid = '" + vo.getUid() + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{	//비밀번호 틀림
			this.DBClose();
			return false;
		}
		
		//닉네임 변경
		if(vo.getUnick() != null && !vo.getUnick().equals("") )
		{
			sql  = "update user set ";
			sql += "unick = '" + vo.getUnick().replace("<","&lt;").replace(">","&gt;").replace("\n","\n<br>").replace("'", "''") + "' ";
			sql += "where uid = '" + vo.getUid() + "' ";
			this.RunSQL(sql);
		}
		//선호조건 변경
		if(( ( vo.getSeason() != null && vo.getLocal() != null ) || !vo.getSeason().equals("") && !vo.getLocal().equals("") ))
		{
			sql  = "update user set ";
			sql += "season = '" + vo.getSeason() + "', ";
			sql += "local = '" + vo.getLocal() + "', ";
			sql += "human = '" + vo.getHuman() + "', ";
			sql += "move = '" + vo.getMove() + "', ";
			sql += "schedule = '" + vo.getSchedule() + "', ";
			sql += "uinout = '" + vo.getUinout() + "' ";
			sql += "where uid = '" + vo.getUid() + "'";
			this.RunSQL(sql);
		}
		
		//아이콘 변경
		if(vo.getUicon() != null || !vo.getUicon().equals(""))
		{
			sql  = "update user set ";
			sql += "uicon = '" + vo.getUicon() + "' ";
			sql += "where uid = '" + vo.getUid() + "' ";
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
	}
	
	// 관리자페이지에서 회원정보 수정
	public boolean ModifyUser(userVO vo)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		String sql = "";
		//비밀번호 확인
		sql  = "select * ";
		sql += "from user ";
		sql += "where uno = '" + vo.getUno() +"' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{	//유효한 번호 아님
			this.DBClose();
			return false;
		}
		
		//닉네임 변경
		if(vo.getUnick() != null && !vo.getUnick().equals("") )
		{
			sql  = "update user set ";
			sql += "unick = '" + vo.getUnick().replace("<","&lt;").replace(">","&gt;").replace("\n","\n<br>").replace("'", "''") + "' ";
			sql += "where uid = '" + vo.getUid() + "' ";
			this.RunSQL(sql);
		}
		//선호조건 변경
		if(( ( vo.getSeason() != null && vo.getLocal() != null ) || !vo.getSeason().equals("") && !vo.getLocal().equals("") ))
		{
			sql  = "update user set ";
			sql += "season = '" + vo.getSeason() + "', ";
			sql += "local = '" + vo.getLocal() + "', ";
			sql += "human = '" + vo.getHuman() + "', ";
			sql += "move = '" + vo.getMove() + "', ";
			sql += "schedule = '" + vo.getSchedule() + "', ";
			sql += "uinout = '" + vo.getUinout() + "' ";
			sql += "where uid = '" + vo.getUid() + "'";
			this.RunSQL(sql);
		}
		
		//아이콘 변경
		if(vo.getUicon() != null || !vo.getUicon().equals(""))
		{
			sql  = "update user set ";
			sql += "uicon = '" + vo.getUicon() + "' ";
			sql += "where uid = '" + vo.getUid() + "' ";
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
	}
	
	//이메일 인증
	public boolean Email(String email)
	{
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		Sendmail mail = new Sendmail();
		//System.out.println(mail.AuthCode(7));
		mail.setFrom("gyr0204@naver.com");
		mail.setTo(email);
		mail.setAccount("gyr0204", "zxcv1234!!");
		mail.setMail("메일인증 코드입니다.", "인증코드 : " + mail.AuthCode(6));
		mail.sendMail();
		
		this.DBClose();
		return true;
	}
	
	//닉네임 중복 확인
	public boolean CheckUnick(String unick)
	{	
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		sql  = "select unick ";
		sql += "from user ";
		sql += "where unick = '" + unick + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	//닉네임 있음
			this.DBClose();
			return true;
		}
		this.DBClose();
		return false;
	}
	
	//이름 중복 확인
	public boolean CheckUname(String uname)
	{	
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		sql  = "select uname ";
		sql += "from user ";
		sql += "where uname = '" + uname + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	//닉네임 있음
			this.DBClose();
			return true;
		}
		this.DBClose();
		return false;
	}
	
	//이메일 중복 확인
	public boolean CheckEmail(String email)
	{	
		if( this.DBOpen() == false )
		{
			return false;
		}
		String sql = "";
		sql  = "select email ";
		sql += "from user ";
		sql += "where email = '" + email + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == true)
		{	
			this.DBClose();
			return true;
		}
		this.DBClose();
		return false;
	}
	
	//닉네임으로 회원정보 조회
	public userVO ShowUser(String unick)
	{	
		if( this.DBOpen() == false )
		{
			return null;
		}
		
		String sql = "";
		sql  = "select * ";
		sql += "from user ";
		sql += "where unick = '" + unick + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{
			//회원정보가 없음
			this.DBClose();
			return null;
		}
		userVO vo = new userVO();
		vo.setUno(this.GetValue("uno"));
		vo.setUid(this.GetValue("uid"));
		vo.setUname(this.GetValue("uname"));
		vo.setUnick(this.GetValue("unick"));
		vo.setAdmin(this.GetValue("admin"));
		vo.setUicon(this.GetValue("uicon"));
		vo.setEmail(this.GetValue("email"));
		vo.setSeason(this.GetValue("season"));
		vo.setLocal(this.GetValue("local"));
		vo.setHuman(this.GetValue("human"));
		vo.setMove(this.GetValue("move"));
		vo.setSchedule(this.GetValue("schedule"));
		vo.setUinout(this.GetValue("uinout"));
		vo.setUstop(this.GetValue("ustop"));
		vo.setUretire(this.GetValue("uretire"));
		vo.setUstopdate(this.GetValue("ustopdate"));
		vo.setUstopend(this.GetValue("ustopend"));
		
		this.DBClose();
		return vo;
	}
	
	//닉네임으로 회원정보 조회(오버로딩)
	public ArrayList<userVO> ShowUser(String user_search_type,  String keyword)
	{	
		ArrayList<userVO> list = new ArrayList<>();
		
		if( this.DBOpen() == false )
		{
			return list;
		}
		
		String sql = "";
		sql  = "select * ";
		sql += "from user ";
		
		String where = "";
		
		if(!user_search_type.equals(""))
		{
			if(user_search_type.equals("user_id"))
			{
				where +="where uid = '" +  keyword + "' ";
				
			}else if(user_search_type.equals("user_name"))
			{
				where +="where uname = '" +  keyword + "' ";
				
			}else if(user_search_type.equals("user_nick"))
			{
				where +="where unick = '" +  keyword + "' ";
				
			}else if(user_search_type.equals("user_email"))
			{
				where +="where email = '" +  keyword + "' ";
			}
		}else
		{
			this.DBClose();
			return list;
		}
		
		sql += where;
		
		this.OpenQuery(sql);
		while(this.GetNext() == true)
		{
			userVO vo = new userVO();
			vo.setUno(this.GetValue("uno"));
			vo.setUid(this.GetValue("uid"));
			vo.setUname(this.GetValue("uname"));
			vo.setUnick(this.GetValue("unick"));
			vo.setAdmin(this.GetValue("admin"));
			vo.setUicon(this.GetValue("uicon"));
			vo.setEmail(this.GetValue("email"));
			vo.setSeason(this.GetValue("season"));
			vo.setLocal(this.GetValue("local"));
			vo.setHuman(this.GetValue("human"));
			vo.setMove(this.GetValue("move"));
			vo.setSchedule(this.GetValue("schedule"));
			vo.setUinout(this.GetValue("uinout"));
			vo.setUstop(this.GetValue("ustop"));
			vo.setUretire(this.GetValue("uretire"));
			vo.setUstopdate(this.GetValue("ustopdate"));
			vo.setUstopend(this.GetValue("ustopend"));
			
			list.add(vo);
			
		}
		
			this.DBClose();
			return list;
	}
	
	// 회원번호로 회원정보 조회
	public userVO CheckUser(String uno)
	{	
		if( this.DBOpen() == false )
		{
			return null;
		}
		
		String sql = "";
		sql  = "select * ";
		sql += "from user ";
		sql += "where uno = '" + uno + "' ";
		this.OpenQuery(sql);
		if(this.GetNext() == false)
		{
			//회원정보가 없음
			this.DBClose();
			return null;
		}
		userVO vo = new userVO();
		vo.setUno(this.GetValue("uno"));
		vo.setUid(this.GetValue("uid"));
		vo.setUname(this.GetValue("uname"));
		vo.setUnick(this.GetValue("unick"));
		vo.setAdmin(this.GetValue("admin"));
		vo.setUicon(this.GetValue("uicon"));
		vo.setEmail(this.GetValue("email"));
		vo.setSeason(this.GetValue("season"));
		vo.setLocal(this.GetValue("local"));
		vo.setHuman(this.GetValue("human"));
		vo.setMove(this.GetValue("move"));
		vo.setSchedule(this.GetValue("schedule"));
		vo.setUinout(this.GetValue("uinout"));
		vo.setUstop(this.GetValue("ustop"));
		vo.setUretire(this.GetValue("uretire"));
		vo.setUstopdate(this.GetValue("ustopdate"));
		vo.setUstopend(this.GetValue("ustopend"));
		
		this.DBClose();
		return vo;
	}
	
	// 전체 회원수 얻기
	public int GetTotal(int pageno, String search_type, String retire, String ustop, String admin, String all, String keyword, String sort_type)
	{
		int total = 0;
		if( this.DBOpen() == false )
		{
			return total;
		}
		
		//게시물의 갯수를 얻는다.
		String sql = "";
		sql  = "select count(*) as count "; 
		sql += "from user ";
		//sql += "where ";
		
		
		String where = "";
		if(!keyword.equals(""))
		{
			if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_id") )
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_id"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N")  && all.equals("N") && search_type.equals("user_id"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y")  && all.equals("N") && search_type.equals("user_id"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N")  && all.equals("N") && search_type.equals("user_id"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y")  && all.equals("N") && search_type.equals("user_id"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, 모두 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_id"))
			{
				// 9. 모두 O , search_type = '아이디'
				where += "where uid like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, 모두 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_name"))
			{
				// 9. 모두 O , search_type = '이름'
				where += "where uname like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X 모두 X,, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, 모두 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_nick"))
			{
				// 9. 모두 O , search_type = '닉네임'
				where += "where unick like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, 모두 X,search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, 모두 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_email"))
			{
				// 9. 모두 O , search_type = '이메일'
				where += "where email like '%" + keyword + "%' ";
			}
		}else
		{
			if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, 모두 X 
				where += "where uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, 모두 X 
				where += "where uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, 모두 X
				where += "where uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, 모두 X
				where += "where uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, 모두 X 
				where += "where uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, 모두 X 
				where += "where uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, 모두 X 
				where += "where uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, 모두 X
				where += "where uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y"))
			{
				// 9.탈퇴 X, 정지 X, 관리자 X 모두 O
				where += "";
				
			}
		}
		sql += where;
		
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			this.DBClose();
			return total;
		}
		
		total = this.GetInt("count");
		this.CloseQuery();
		
		this.DBClose();
		return total;
	}
	
	//전체 회원목록 얻기
	public ArrayList<userVO> GetUserList(int pageno, String search_type, String retire, String ustop, String admin, String all,  String keyword, String sort_type)
	{
		ArrayList<userVO> list = new ArrayList<userVO>();
		
		if( this.DBOpen() == false )
		{
			return list;
		}		
		
		//게시물 목록을 얻는다.
		String sql = "";
		sql  = "select * from user ";
		//sql += "where ";
		
		String where = "";
		if(!keyword.equals(""))
		{
			if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_id"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_id"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_id"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_id"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_id"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, search_type = '아이디' 
				where += "where uid like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_id"))
			{
				// 9. 모두, search_type = '아이디'
				where += "where uid like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_name"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N")&& search_type.equals("user_name"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N")&& search_type.equals("user_name"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_name"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, search_type = '이름' 
				where += "where uname like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_name"))
			{
				// 9. 모두, search_type = '이름'
				where += "where uname like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_nick"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, search_type = '닉네임' 
				where += "where unick like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_nick"))
			{
				// 9. 모두, search_type = '닉네임'
				where += "where unick like '%" + keyword + "%' ";
				
			}else if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N") && search_type.equals("user_email"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N")&& search_type.equals("user_email"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N") && search_type.equals("user_email"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O, search_type = '이메일' 
				where += "where email like '%" + keyword + "%' ";
				where += "and uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y") && search_type.equals("user_email"))
			{
				// 9. 모두, search_type = '이메일'
				where += "where email like '%" + keyword + "%' ";
				
			}
			
		}else
		{
			if( retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("N"))
			{
				// 1.탈퇴 X, 정지 X, 관리자 X 
				where += "where uretire = 'N' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("N") && all.equals("N"))
			{
				// 2.탈퇴 O, 정지 X, 관리자 X 
				where += "where uretire = 'Y' and ustop = 'N' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("N") && all.equals("N"))
			{
				// 3.탈퇴 X, 정지 O, 관리자 X 
				where += "where uretire = 'N' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("Y") && all.equals("N"))
			{
				// 4.탈퇴 X, 정지 X, 관리자 O 
				where += "where uretire = 'N' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("N") && all.equals("N"))
			{
				// 5.탈퇴 O, 정지 O, 관리자 X 
				where += "where uretire = 'Y' and ustop = 'Y' and admin = 'N'";
				
			}else if(retire.equals("N") && ustop.equals("Y") && admin.equals("Y") && all.equals("N"))
			{
				// 6.탈퇴 X, 정지 O, 관리자 O 
				where += "where uretire = 'N' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("N") && admin.equals("Y") && all.equals("N"))
			{
				// 7.탈퇴 O, 정지 X, 관리자 O 
				where += "where uretire = 'Y' and ustop = 'N' and admin = 'Y'";
				
			}else if(retire.equals("Y") && ustop.equals("Y") && admin.equals("Y") && all.equals("N"))
			{
				// 8.탈퇴 O, 정지 O, 관리자 O
				where += "where uretire = 'Y' and ustop = 'Y' and admin = 'Y'";
				
			}else if(retire.equals("N") && ustop.equals("N") && admin.equals("N") && all.equals("Y"))
			{
				// 9.탈퇴 X, 정지 X, 관리자 X 모두 O
				where += "";
				
			}
		}
		
		sql += where;
		
		String orderBy = "";
		if(sort_type.equals("in_order"))
		{
			//sort_type = '가나다'일시
			orderBy += " order by uid, uname, unick desc";
			
		}else if(sort_type.equals("by_number"))
		{
			//sort_type = '최근등록순'일시
			orderBy += " order by uno desc ";
			
		}
			
		sql += orderBy;
		
		//페이지당 20개씩 가져오도록 limit 를 처리한다.
		int startno = 20 * (pageno - 1);
		sql += " limit " + startno + ",20 ";
		
		
		this.OpenQuery(sql);
		
		while(this.GetNext() == true)
		{
			userVO vo = new userVO();
			
			vo.setUno(this.GetValue("uno"));
			vo.setUid(this.GetValue("uid"));
			vo.setUname(this.GetValue("uname"));
			vo.setUnick(this.GetValue("unick"));
			vo.setEmail(this.GetValue("email"));
			vo.setUjoindate(this.GetValue("ujoindate"));
			vo.setUretire(this.GetValue("uretire"));
			vo.setUicon(this.GetValue("uicon"));
			vo.setSeason(this.GetValue("season"));
			vo.setLocal(this.GetValue("local"));
			vo.setHuman(this.GetValue("human"));
			vo.setMove(this.GetValue("move"));
			vo.setSchedule(this.GetValue("schedule"));
			vo.setUinout(this.GetValue("uinout"));
			vo.setAdmin(this.GetValue("admin"));
			vo.setUstop(this.GetValue("ustop"));
			vo.setUreason(this.GetValue("ureason"));
			vo.setUstopdate(this.GetValue("ustopdate"));
			vo.setUstopend(this.GetValue("ustopend"));

			list.add(vo);
		}
		
		this.DBClose();
		return list;
	}
	
}
