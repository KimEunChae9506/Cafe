package com.ec.cafe.vo;

import java.util.List;

public class CartVO{

	private String id;
	private String names;
	private String price;
	private int num;
	private int shot;
	private List<CartVO> cartList; 
	
	public String getNames() {
		return names;
	}
	public void setNames(String name) {
		this.names = name;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getShot() {
		return shot;
	}
	public void setShot(int shot) {
		this.shot = shot;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public List<CartVO> getcartList() {
		return cartList;
	}
	public void setCartList(List<CartVO> cartList) {
		this.cartList = cartList;
	}
	@Override
	public String toString() {
		return "CartVO [id=" + id + ", names=" + names + ", price=" + price + ", num=" + num + ", shot=" + shot
				+ ", cartList=" + cartList + "]";
	}
	

	
	
}
