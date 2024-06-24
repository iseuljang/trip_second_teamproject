package trip.dto;
import trip.dao.*;
import trip.vo.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class adkeywordDTO extends DBManager
{
	// 해당 광고 키워드 얻기
	public ArrayList<adkeywordVO> GetKeyword(String advertno)
	{
		ArrayList<adkeywordVO> list = new ArrayList<>();
		
		if( this.DBOpen() == false )
		{
			return list;
		}
		
		String sql = "";
		//해당 광고물 번호에 대한 정보를 조회한다.
		sql  = "select * ";
		sql += " from adkeyword";
		sql += " where advertno = " + advertno;
		this.OpenQuery(sql);
		while(this.GetNext())
		{
			adkeywordVO vo = new adkeywordVO();
			vo.setAdvertno(advertno);
			vo.setAdkeyno(this.GetValue("adkeyno"));
			vo.setKeyword(this.GetValue("keyword"));
			
			list.add(vo);
		}
		
		this.DBClose();
		return list;
	}
	
	// 해당 광고 키워드의 총 개수 얻기
	public int GetTotal(String advertno)
	{
		int total = 0;
		if( this.DBOpen() == false )
		{
			return total;
		}
		
		String sql = "";
		//해당 광고물 번호에 대한 정보를 조회한다.
		sql  = "select count(*) as count ";
		sql += "from adkeyword ";
		sql += "where advertno = " + advertno;
		this.OpenQuery(sql);
		
		if(this.GetNext() == false)
		{
			this.DBClose();
			return total;
		}
		
		total = this.GetInt("count");
		this.CloseQuery();
		System.out.println(total);
		
		this.DBClose();
		return total;
	}
	
}
