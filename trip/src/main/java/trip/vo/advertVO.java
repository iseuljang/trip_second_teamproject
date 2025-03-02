package trip.vo;

public class advertVO 
{
	// field
	private String advertno;       // 광고 번호
	private String category;       // 광고 대분류
	private String subclass;       // 광고 중분류
	private String price;          // 가격
	private	String productName;    // 상품 이름
	private	String imageURL;       // 광고 이미지 주소
	private	String detailURL;      // 상세 주소
	private	String vipWhether;     // vip여부
	private	String vipStartDate;   // vip광고 시작일
	private	String vipEndDate;     // vip광고 종료일
	private	String vipTimes;       // vip 신청한 횟수
	private	String vipPri;         // vip 우선순위
	private	String exposure_count; // 노출된 횟수
	
	// getter
	public String getAdvertno()       { return advertno;       }
	public String getCategory()       { return category;       }
	public String getSubclass()       { return subclass;       }
	public String getPrice()          { return price;          }
	public String getProductName()    { return productName;    }
	public String getImageURL()       { return imageURL;       }
	public String getDetailURL()      { return detailURL;      }
	public String getVipWhether()     { return vipWhether;     }
	public String getVipStartDate()   { return vipStartDate;   }
	public String getVipEndDate()     { return vipEndDate;     }
	public String getVipTimes()       { return vipTimes;       }
	public String getVipPri()         { return vipPri;         }
	public String getExposure_count() { return exposure_count; }
	
	// setter
	public void setAdvertno(String advertno)             { this.advertno = advertno;             }
	public void setCategory(String category)             { this.category = category;             }
	public void setSubclass(String subclass)             { this.subclass = subclass;             }
	public void setPrice(String price)                   { this.price = price;                   }
	public void setProductName(String productName)       { this.productName = productName;       }
	public void setImageURL(String imageURL)             { this.imageURL = imageURL;             }
	public void setDetailURL(String detailURL)           { this.detailURL = detailURL;           }
	public void setVipWhether(String vipWhether)         { this.vipWhether = vipWhether;         }
	public void setVipStartDate(String vipStartDate)     { this.vipStartDate = vipStartDate;     }
	public void setVipEndDate(String vipEndDate)         { this.vipEndDate = vipEndDate;         }
	public void setVipTimes(String vipTimes)             { this.vipTimes = vipTimes;             }
	public void setVipPri(String vipPri)                 { this.vipPri = vipPri;                 }
	public void setExposure_count(String exposure_count) { this.exposure_count = exposure_count; }
} 
