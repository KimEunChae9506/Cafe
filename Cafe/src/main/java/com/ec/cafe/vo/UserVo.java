package com.ec.cafe.vo;

import lombok.Data;

@Data
public class UserVo {

	private String phone;
	private String phone2; // 수정한 폰 번호
	private String name;
	private int coupon;
	private int aftercoupon;
	private int morecoupon;
	
	//model attribute 자동 매핑 말고 이렇게 수동으로 값 바꿔줄 수 있음
//	public void setName(String name) {
//		if("".equals(name) | name !=null) {
//			this.name = "김대포";
//		}
//	}
	/*  lombok 으로 대체
	 * public int getAftercoupon() { return aftercoupon; } public void
	 * setAftercoupon(int aftercoupon) { this.aftercoupon = aftercoupon; } public
	 * String getPhone() { return phone; } public void setPhone(String phone) {
	 * this.phone = phone; } public String getName() { return name; } public void
	 * setName(String name) { this.name = name; } public int getCoupon() { return
	 * coupon; } public void setCoupon(int coupon) { this.coupon = coupon; } public
	 * String getPhone2() { return phone2; } public void setPhone2(String phone2) {
	 * this.phone2 = phone2; } public int getMorecoupon() { return morecoupon; }
	 * public void setMorecoupon(int morecoupon) { this.morecoupon = morecoupon; }
	 */
	
}
