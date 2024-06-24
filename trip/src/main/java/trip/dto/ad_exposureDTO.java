package trip.dto;
import trip.dao.*;
import trip.vo.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class ad_exposureDTO extends DBManager 
{
	// 게시물에 노출된 상품의 정보를 테이블에 삽입
	public boolean Insert(ad_exposureVO vo, boolean whether)
	{
		
		Date today = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String Stoday = dateFormat.format(today);
		
		if( this.DBOpen() == false )
		{
			return false;
		}
		
		String sql = "";
		sql += "insert into ad_exposure (advertno, bno, uno, exposure_date) ";
		sql += "values ( ";
		sql += "'" + vo.getAdvertno() + "', ";
		sql += "'" + vo.getBno() + "', ";
		if(vo.getUno() != null)
		{
			sql += "'" + vo.getUno() + "', ";
		}else
		{
			sql += "null, ";
		}
		sql += "'" + Stoday + "' )";
		this.RunSQL(sql);
		
		if(whether == true)
		{
			//상품의 노출 카운트를 증가시킨다.
			sql  = "update ad set exposure_count = exposure_count + 1 ";
			sql += "where advertno = " + vo.getAdvertno();
			this.RunSQL(sql);
		}
		
		this.DBClose();
		return true;
		
	}
	// 해당 광고물의 노출 정보를 받는 메소드
	public ArrayList<ad_exposureVO> GetExposure_info(String advertno)
	{
		 ArrayList<ad_exposureVO> list = new ArrayList<>();
		 
		if( this.DBOpen() == false )
		{
			return list;
		}
		
		String sql = "";
		sql += "select * from ad_exposure ";
		sql += "where advertno = " + advertno;
		this.OpenQuery(sql);
		
		
		
		while(this.GetNext() == true)
		{
			ad_exposureVO vo = new ad_exposureVO();
			
			vo.setExno(this.GetValue("exno"));
			vo.setAdvertno(advertno);
			vo.setBno(this.GetValue("bno"));
			vo.setUno(this.GetValue("uno"));
			vo.setExposure_date(this.GetValue("exposure_date"));
			
			list.add(vo);
		}
		
		this.DBClose();
		return list;
		
	}
}
