package com.ec.cafe.vo;

import lombok.Data;

@Data
public class CafeVO {

	private String id;
	
	private String names;
	private String price;
	private int stock;
	private String cafe;
	private int originStock;
	
	/*
	 * public String getCafe() { return cafe; } public void setCafe(String cafe) {
	 * this.cafe = cafe; } public String getId() { return id; } public void
	 * setId(String id) { this.id = id; } public String getName() { return name; }
	 * public void setName(String name) { this.name = name; } public String
	 * getPrice() { return price; } public void setPrice(String price) { this.price
	 * = price; } public int getStock() { return stock; } public void setStock(int
	 * stock) { this.stock = stock; }
	 */
}
