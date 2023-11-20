package com.ec.cafe.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ec.cafe.mapper.CafeMapper;
import com.ec.cafe.vo.CafeVO;
import com.ec.cafe.vo.CartVO;
import com.ec.cafe.vo.UserVo;

@Service
public class CafeService {

	@Autowired
	CafeMapper cm;
	
	public List<CafeVO> menuList() throws Exception {
		return cm.menuList();
	}
	
	public UserVo userList(String phone) throws Exception {
		return cm.userList(phone);
	}
	
	public int join(UserVo uservo) throws Exception {
		return cm.join(uservo);
	}
	
	public int update(UserVo uservo) throws Exception {
		return cm.update(uservo);
	}
	
	public int updateMore(UserVo uservo) throws Exception{
		return cm.updateMore(uservo);
	};
	
	public int couponUpdate(UserVo uservo) throws Exception {
		return cm.couponUpdate(uservo);
	}
	
	public int orders(CartVO cartvo) throws Exception {
		return cm.orders(cartvo);
	}
	
	public int stock(CafeVO cafevo) throws Exception {
		return cm.stock(cafevo);
	}
	
	public CafeVO selectone(String id) throws Exception {
		return cm.selectone(id);
	}

	public int update_user(UserVo uservo) {
		return cm.update_user(uservo);
	}

	public int delete_user(String phone) {
		return cm.delete_user(phone);
	}

	
}

