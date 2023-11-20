package com.ec.cafe.mapper;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ec.cafe.vo.CafeVO;
import com.ec.cafe.vo.CartVO;
import com.ec.cafe.vo.UserVo;

@Mapper
public interface CafeMapper {

		public List<CafeVO> menuList() throws Exception;
		
		public UserVo userList(String phone) throws Exception;
	
		public int join(UserVo uservo) throws Exception;
		
		public int update(UserVo uservo) throws Exception;
		
		public int updateMore(UserVo uservo) throws Exception;
		
		public int couponUpdate(UserVo uservo) throws Exception;
		
		public int orders(CartVO cartvo) throws Exception;
		
		public int stock(CafeVO cafetvo) throws Exception;
		
		public CafeVO selectone(String id) throws Exception;

		public int update_user(UserVo uservo);

		public int delete_user(String phone);

		
}
