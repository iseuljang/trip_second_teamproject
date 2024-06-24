package trip.dto;
import trip.dao.*;
import trip.vo.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class bestlocalfoodDTO extends DBManager
{
	// 맛집 정보 가져오기
	public ArrayList<bestlocalfoodVO> Get_BFlist(String bno)
	{
		ArrayList<bestlocalfoodVO> list = new ArrayList<>();
		
		if( this.DBOpen() == false )
		{
			return list;
		}
		
		String sql = " select * from bestlocalfood where BFbno = "+ bno ;
		this.OpenQuery(sql);
		while(this.GetNext())
		{
			bestlocalfoodVO vo = new bestlocalfoodVO();
			vo.setBFbno(bno);                              //게시물 번호
			vo.setBFno(this.GetValue("BFno"));             //맛집 번호
			vo.setBFtitle(this.GetValue("BFtitle"));       //맛집 이름
			vo.setBFcategory(this.GetValue("BFcategory")); //맛집 카테고리
			vo.setBFlocal(this.GetValue("BFlocal"));       //맛집 지역
			vo.setBFimageurl(this.GetValue("BFimageurl")); //맛집 이미지
			vo.setBFimageurl(this.GetValue("BFimageurl")); //맛집 이미지
			vo.setBFurl(this.GetValue("BFurl"));           //맛집정보 사이트주소
			
			list.add(vo);
		}
		
		this.DBClose();
		return list;
	}
	
	// 맛집 지역 가져오기
	public bestlocalfoodVO Get_BFlocal(String bno)
	{
		bestlocalfoodVO BFvo = new bestlocalfoodVO();
		if( this.DBOpen() == false )
		{
			return BFvo;
		}
		
		String sql = " select * from bestlocalfood where BFbno = "+ bno ;
		this.OpenQuery(sql);
		this.GetNext();
		BFvo.setBFlocal(this.GetValue("BFlocal")); //맛집 지역
		
		this.DBClose();
		return BFvo;
	}
	
}