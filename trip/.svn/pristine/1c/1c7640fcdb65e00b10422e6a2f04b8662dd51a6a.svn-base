package trip.dto;

import java.util.ArrayList;

import trip.vo.adkeywordVO;
import trip.dao.*;
import trip.vo.*;
import java.util.*;
import java.io.*;
import java.text.*;


public class adksimilarDTO extends DBManager
{
	// 해당 광고 키워드 유사어 및 유사도 얻기
	public ArrayList<adksimilarVO> GetSimilarKeyword(String adkeyno)
	{
		ArrayList<adksimilarVO> list = new ArrayList<>();
		
		if( this.DBOpen() == false )
		{
			return list;
		}
		
		String sql = "";
		//해당 광고물 번호에 대한 정보를 조회한다.
		sql += "select adksimilar.adksno, adksimilar.adkskey, adksimilar.adksfr, adkeyword.adkeyno, adkeyword.keyword "; 
		sql += "from adksimilar "; 
		sql += "join adkeyword on adksimilar.adkeyno = adkeyword.adkeyno ";
		sql += "where adkeyword.adkeyno =" + adkeyno;
		
		this.OpenQuery(sql);
		while(this.GetNext())
		{
			adksimilarVO vo = new adksimilarVO();
			vo.setAdksno(this.GetValue("adksno"));
			vo.setAdkskey(this.GetValue("adkskey"));
			vo.setAdksfr(this.GetValue("adksfr"));
			vo.setAdkeyno(this.GetValue("adkeyno"));
			vo.setKeyword(this.GetValue("keyword"));
			
			list.add(vo);
		}
		
		this.DBClose();
		return list;
	}
}
