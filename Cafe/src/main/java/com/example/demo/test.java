package com.example.demo;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ec.cafe.service.CafeService;
import com.ec.cafe.vo.CafeVO;

@Controller
public class test {
	
	@Resource(name="com.ec.cafe.service")
	CafeService cs;
	
	@RequestMapping("/pay")
	private String jsptest() {
		return "pay";
	}
	@RequestMapping(value = "/menu", method = RequestMethod.GET)
	public String getmenuList (Model model, CafeVO cafevo) throws Exception {
		
		List<CafeVO> menuList =  cs.menuList();
		
		model.addAttribute("menuList", menuList);
		return "menu";
	}
	
	@RequestMapping(value = "/")
	public String array() {
		return "array";
	}
	
}
