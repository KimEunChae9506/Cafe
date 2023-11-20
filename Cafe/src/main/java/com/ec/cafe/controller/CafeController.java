package com.ec.cafe.controller;

import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import javax.websocket.Session;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ec.cafe.service.CafeService;
import com.ec.cafe.vo.CafeVO;
import com.ec.cafe.vo.CartVO;
import com.ec.cafe.vo.UserVo;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/cafe")
public class CafeController {
	
	/**
	 * 보낼 파라미터(인풋 기본) = 
	 * @requestParam(인풋아이디), 
	 * @requestParam Map<String,String>(=키, 값객체니 map. vo나 dto 에 쓴 자료형으로 지정),
	 * @modelAttribute vo,dto 자체. 인풋name이랑 매핑되면 이걸로도 가능. 앞 생략가능
	 * vo,dto == service.메소드(셀렉트) 
	 */
	
	@Autowired
	CafeService cs;
	/*******
	 * payBt = 결제 버튼을 눌렀냐 체크하는 파라미터.
	 * backChk = 결제를 했냐 체크하는 파라미터.
	 * *******/
	
	//CafeVO cv2;
    //장바구니 담을 메뉴 리스트
    List<CartVO> cartList = new ArrayList<CartVO>();
    private int count = 0;
    
    @RequestMapping("/array")
    public ModelAndView array(ModelAndView mv) {
    	mv.setViewName("/array");
    	
    	StringBuffer sb = new StringBuffer();
    	sb.append("dddd");
    	mv.addObject("text", sb);
    	return mv;
    }
    
 // 컨트롤러 부분
    @RequestMapping(value = "/json", method = RequestMethod.GET, produces="application/text;charset=UTF-8")
    @ResponseBody
    public void json(Locale locale, Model model,HttpServletResponse response) throws IOException {    
    	List<HashMap<String, Map<String, String>>> list = new ArrayList<HashMap<String, Map<String, String>>>();
        HashMap<String, Map<String, String>> map = new HashMap<String, Map<String, String>>();
    	Map<String, String> array = new HashMap<>();
        
        array.put("나", "김은채");
        array.put("너", "김예찬");
        
        map.put("item", array);
        list.add(map);
        
        Gson gson = new Gson();
        
        response.setHeader("Content-Type", "application/xml");
        response.setContentType("text/xml;charset=UTF-8");
        response.setCharacterEncoding("utf-8");
        response.getWriter().print(gson.toJson(list));
        //return gson.toJson(list); // 배열 반환
       
        //response 는 반환 x
    }
    
    @SuppressWarnings("unchecked")//검증되지 않은 연산자 관련 경고 억제
	@RequestMapping(value = "/menu", method = RequestMethod.GET)
	public ModelAndView getmenuList (HttpServletRequest req) throws Exception {
		//class 인 ModelMap 이나 ModelAndView 는 파라미터 or 메소드 내 생성자로 쓸 수 있음
		ModelAndView mv = new ModelAndView("/menu"); //이렇게도 가능
		
		//HttpSession session = req.getSession();
		//session.invalidate();
		req.getSession().invalidate();
		req.getSession(true);
		
		List<CafeVO> menuList =  cs.menuList();

		//그냥 cafeVo는 지금 비어었고 cs.menuList를 해야 select해서 채워짐
		//System.out.println("*********************"+menuList.get(0).getNames());
		
		log.info("menuList>>>>>>>>>>" + menuList ); //그대로 출력되는건 lombok인  @data로 toString 자동 오버라이드 해줘서
		
		//model.addAttribute("menuList", menuList); --mv로 바꿔봄. 리턴도 바뀜
		mv.addObject("menuList", menuList);
		
		//HttpSession session2 = req.getSession();
		//session2.setAttribute("cartList", cartList);
		cartList.clear();
		
		req.getSession().setAttribute("cartList", cartList);
		mv.addObject("cartList", cartList);
		
		//로그인 저장 되어 있을 때만 화면에 로그아웃 체크박스 표시하게
		Cookie[] cooks = req.getCookies();
		if(cooks != null) {
			for(Cookie cook : cooks) {
				if(cook != null && cook.getName().contains("cookieId")) {
					req.getSession().setAttribute("payBt", 2);
				}
			}
		}
		//mv.setViewName("/menu");
		return mv;
	}
	
    @Scheduled(cron = "0 0 0 * * *") //매 자정에 재고파악 후 부족한 재고 자동 채워주는 스케줄
	public void stockBatch() throws Exception  {
		List<CafeVO> menuList = cs.menuList();
		for(int i = 0; i < menuList.size(); i++) {
			CafeVO cafevo = menuList.get(i);
			if(cafevo.getStock() <= 0) {
				cafevo.setStock(cafevo.getOriginStock()); //== menuList.getOriginStrock()해도됨
				cs.stock(cafevo);
			}
		}
	}
//	@RequestMapping(value = "/total", method = RequestMethod.GET)---필요없음. 어차피 처음에 데이터 없고, menu 에 포함되어있으니
//	public String gettotal (Model model) throws Exception {
//		
//		List<CafeVO> menulist =  cs.menulist();
//		
//		model.addAttribute("menulist", menulist);
//
//		return "total";
//	}
		
	@RequestMapping(value = "/total", method = RequestMethod.POST)
	public String gettotalListP (Model model, @RequestParam Map<String, String> map,HttpServletRequest req
			) 
			throws Exception {
		/** map param 으로 바꾸고 int 파라미터는 parsing 함
		@RequestParam("frmname") String menuname, @RequestParam("final") String price,@RequestParam("popup_num") int num,@RequestParam("popup_shot") int shots,
		@RequestParam("in_id") String id,
		**/
		//return menu 하기 때문에 필요함
		List<CafeVO> menuList =  cs.menuList();
		
		model.addAttribute("menuList", menuList);
		
		//메뉴 추가할 때마다 리스트에 담아야 돼서 한 번 담고 나서 초기화 = 메뉴 추가할 때마다 이 gettotalListP 메소드를 불러내는거임
		CartVO cartvo = new CartVO();
		cartvo.setNames(map.get("frmname"));
		cartvo.setPrice(map.get("final"));
		cartvo.setNum(Integer.parseInt(map.get("popup_num")));
		cartvo.setShot(Integer.parseInt(map.get("popup_shot")));
		cartvo.setId(map.get("in_id"));
		count++; //상품 개수 선택 제한 위해 전역변수 설정. 담을 때마다 메소드가 불러지지만 카운트는 모든 메뉴의 합으로 세야 되니.
		
		if(count < 11) {
			cartList.add(cartvo);
			//Collections.list 하고 반대는 Collections.reverse();
			log.info("cartList>>>>>>>>>>"+cartList);
		} else {
			model.addAttribute("couontError", 1); //개수 초과시 에러메시지 띄우기 위해
		}
		
		int total = 0; //총가격
		int totalNum = 0; //적립할 쿠폰개수(주문수량)
		for(int i = 0; i < cartList.size(); i++) {
			totalNum += cartList.get(i).getNum();
			total += Integer.parseInt(cartList.get(i).getPrice());
		}
		
		HttpSession session =  req.getSession();
		if (totalNum != 0) { //로그인 상태로 결제 실패시 쿠폰 적립이 안 돼서 null 포인트 에러 뜸
			session.setAttribute("totalPrice", total);
			session.setAttribute("totalNum", totalNum);
			session.setAttribute("cartList", cartList);
		}
			
		//로그인 상태 유지로 id 쿠키값으로 있을 시 여기서 user session을 형성한다.
		String cookPhone = "";
		Cookie[] cookies = req.getCookies();
		
		for(Cookie cooks : cookies) {
			if(cooks.getName().equals("cookieId")) {
				cookPhone = cooks.getValue();
				UserVo user = cs.userList(cookPhone);
				session.setAttribute("user", user);
				session.setAttribute("payBt", 2);//결제하기 누를 시 쿠키있으면 바로 쿠폰창으로 가게 변수 설정
			}	
		}
		
		log.debug(1 + map.get("frmname"));
		log.info(2 + map.get("frmname"));
		return "menu";
	}
	@ResponseBody
	@RequestMapping (value = "/sort", method = RequestMethod.POST)
	public List<CartVO> sort(@RequestParam("sort") String sort,Model model, HttpServletRequest req) throws Exception {
		if("n".equals(sort)) {
			Collections.sort(cartList, new Comparator<CartVO>() {//커스텀 Comparator 만들어줌
				@Override
				public int compare(CartVO o1, CartVO o2) {//이름 오름차순
					// TODO Auto-generated method stub
					return o1.getNames().compareTo(o2.getNames());
				}
				
			});
		} else if ("c".equals(sort)) {
			Collections.sort(cartList, new Comparator<CartVO>() {
				@Override
				public int compare(CartVO o1, CartVO o2) {//개수 내림차순
					// TODO Auto-generated method stub
					return o2.getNum() - o1.getNum();
				}
			});
		}
		return cartList;
	}
	@RequestMapping(value = "/cancel", method = RequestMethod.GET)
	public String cancel (Model model, HttpServletRequest req) throws Exception {
		//ModelMap model = new ModelMap(); -- Model 과 동일하나 model = interface, modelmap = class
		//moel 류는 파라미터로, mv는 생성자로. mv는 반환받을 수 있는 객체야. 그래서 리턴타입으로 씀

		HttpSession session =  req.getSession();
		session.invalidate();
		cartList.clear();
		
		List<CafeVO> menuList =  cs.menuList();
		model.addAttribute("menuList", menuList); 
		//-> 해줘야 하는 이유는 리턴으로 menu.jsp를 허잖아. 근데 url은 여전히 cancel 이니
		//menu.jsp단에서 쓰이는 ${menuList}로 불러오려면 여기서도 데이터를 모델로 보내줘야돼
		return "menu";
	}
	
	@RequestMapping(value = "/cartCancel", method = RequestMethod.POST)
	public String cartCancel (Model model,@RequestParam("cartc") int cartIdx,HttpServletRequest req) throws Exception {
		cartList.remove(cartIdx);
		
		int total = 0;
		for(int i = 0; i < cartList.size(); i++) {
			total += Integer.parseInt(cartList.get(i).getPrice());
		}
	
		HttpSession session =  req.getSession();
		session.setAttribute("totalPrice", total);
		
		List<CafeVO> menuList =  cs.menuList();
	
		model.addAttribute("menuList", menuList);
		return "menu";
	}
	
	@RequestMapping(value = "/userChk", method = RequestMethod.GET)
	public String getUserChk (HttpServletRequest req) throws Exception {
		HttpSession session =  req.getSession();
		session.setAttribute("payBt", 1);//회원확인 창 들렀는지 확인하는 변수
	
		return "userChk";
	}
	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String getjoin () throws Exception {

		return "join";
	}
	
	@ResponseBody //객체로 응답하겠다. 리턴 타입은 ajax에 datatype 지정된 거. 없으면 아무거나.
	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public int postjoin (@ModelAttribute @Valid UserVo uservo, HttpServletRequest req) throws Exception {//모델 객체는 ModelAttribute로 받으나 유효성 검사위해 붙임. 보통 @model은 생략가능		
		//보내진 파라미터가 모델 객체이기 때문에 모델객체 형식으로  바로  UserVo uservo 보냄
		System.out.println("=============="+uservo); // input값이 모델객체에 바로 넣어지나 테스트
		//폰번호는 유일키pk이기 때문에 insert가 중복으로 안 됨. 그래서 안 되면 중복가입이라는 에러가 뜰 수 있는 것
		int result = cs.join(uservo);
		
		HttpSession session = req.getSession();
		session.setAttribute("user", uservo);
		
		System.out.println(">>>>>>>>"+result);
		return result;
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public void login (@RequestParam ("phoneNum") String phoneNum,
			HttpServletRequest req, HttpServletResponse response) throws Exception {
		response.setContentType("text/html;charset=utf-8");
		HttpSession session =  req.getSession();
		
		UserVo user = cs.userList(phoneNum);
		
		/* 스크립트단에서 쿠키 설정
		 * if(loginChk.equals("") && loginChk == "2") { 
		 * Cookie cook = new Cookie("cafeId", phoneNum); 
		 * cook.setMaxAge(60 * 60 * 24 * 7);//7일
		 * response.addCookie(cook); 
		 * }
		 */
		//폰번호는 유일키pk이기 때문에 user가 생성되었다는 것은 회원정보 있다는 뜻. if 문 안 써도 됨
		session.setAttribute("user", user);
		
		/** 리턴값 json 하기 위해 쓴 옛날 교육 코드
		HashMap map = new HashMap<>();
		map. put("result",phonenum);
		StringBuffer bf = new StringBuffer();
		
	    ObjectMapper objectMapper = new ObjectMapper();

	    String results = objectMapper.writeValueAsString(map);
		
		bf.append(results);
		**/
		
		/* 쿠키삭제
		 * Cookie[] cooks = req.getCookies();
		 * 
		 * for (int i = 0; i < cooks.length; i++) { 
		 * cooks[i].setMaxAge(0);
		 * response.addCookie(cooks[i]); 
		 * }
		 */
		
		//쓰기로 응답하겠다. 리로드나 다른 페이지로 넘어가지 않을 시 f12에서 리스폰스 데이타 확인 가능.
		//위 join은 @ResponseBody 로 리턴값응답했으나, 여기선 그 어노테이션 안 쓰고 파라미터로 HttpServletResponse 해서
		//이거 없으면 ajax 통신 안 됨.
		response.getWriter().print(user.getName());
		//response.getWriter().print("안녕"); -- ajax 리턴타입이 정해져있지 않으므로 아무 형식이나 응답해도 됨
		//return user;
	}
	
	/**
	 * 
	 * @param model
	 * @note 로그인(회원확인) 후 쿠폰확인창 불러오는. 밑에 post /coupon 후임.
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/coupon", method = RequestMethod.GET)
	public String getCoupon (Model model,HttpServletRequest req) throws Exception {
		HttpSession session =  req.getSession();

		Object user = session.getAttribute("user");
		if(user != null) {
			model.addAttribute("user",session.getAttribute("user"));
		}
		
		Object cookiePayBt = session.getAttribute("payBt");
		if(cookiePayBt != null && (int)cookiePayBt == 2) {
			session.setAttribute("payBt", 1);//로그인 유지돼있는 상태로 쿠폰창에서 결제하기 누를시 /pay로 바로 넘어가게 하기 위해 다시 1 설정
		}

		return "coupon";
	}
	
	/**
	 * 
	 * @param phone
	 * @note 회원확인 후 뒤로가기 눌렀을시 회원정보 리턴
	 * @return jsp 페이지가 아닌 객체 리턴
	 * @throws Exception
	 */
	/*//get으로 쿠폰 페이지 갖고올 때 이미 user 정보가 있어 굳이 ajax 필요없음
	 * @ResponseBody
	 * @RequestMapping(value = "/coupon", method = RequestMethod.POST) public String
	 * coupon (@RequestParam (value = "phone") String phone,HttpServletRequest req)
	 * throws Exception{ UserVo user = cs.userList(phone);
	 * 
	 * HttpSession session = req.getSession(); session.setAttribute("user", user);
	 * 
	 * return phone; }
	 */
	
	@RequestMapping(value = "/pay")
	public String pay (Model model) throws Exception {
		return "pay";
	}
	
	@RequestMapping(value = "/finalPay")
	public String couponNoPay (HttpServletRequest req, Model model, @RequestParam("phone") String phone) throws Exception {
		HttpSession session =  req.getSession();	
		int totalNum = (int) session.getAttribute("totalNum");
		// 쿠폰사용을 안 한 사람(회원,비회원 포함)은 이 단계에서 쿠폰 적립
		Object coupChk = session.getAttribute("coupChk");

		// 회원이고 쿠폰을 안 쓴 사람만 쿠폰 적립
		if (StringUtils.isNotEmpty(phone) && coupChk == null) {
			UserVo uservo = new UserVo();
			uservo.setPhone(phone);
			uservo.setCoupon(totalNum);

			cs.couponUpdate(uservo);
		}
				
		for(int i = 0; i < cartList.size(); i++) {
			//모든 주문 끝난 후 주문 db 저장
			cs.orders(cartList.get(i));
			
			//모든 주문 끝난 후 '재고' 업데이트
			String id = cartList.get(i).getId();
			CafeVO cafevo = cs.selectone(id); //카트리스트에 있는 상품들만 업데이트 되어야 하니 각각 하는 selectOne으로
			cafevo.setStock(cafevo.getStock() - cartList.get(i).getNum()); //기존 재고에서 주문량만큼 차감
			
			cs.stock(cafevo);			
		}
		
		//session.invalidate();
		cartList.clear();
		
		//뒤로 버튼 눌렀을 때 이미 결제했는지 확인하는 변수
		session.setAttribute("backChk", 1);
		return "menu";
	}
	
	@ResponseBody
	@RequestMapping(value = "/couponPay", method = RequestMethod.POST)
	public int couponPay (HttpServletRequest req,@RequestParam("phoneNum") String phoneNum, @RequestParam("popup_num_coup") int moreCoupon) throws Exception {
		
		HttpSession session =  req.getSession();
		int totalPay = (int) session.getAttribute("totalPrice");
		
		if(moreCoupon == 1) {
			session.setAttribute("totalPrice", totalPay - 3000);
		}else {
			session.setAttribute("totalPrice", totalPay - (3000 * moreCoupon));
		}
		
		UserVo uservo = new UserVo();
		uservo.setPhone(phoneNum);
		uservo.setAftercoupon((int)session.getAttribute("totalNum")); //이번에 적립 될 쿠폰 개수
		
		if(moreCoupon == 1) {
			cs.update(uservo);
		}else {
			uservo.setMorecoupon(moreCoupon); //사용하려는 쿠폰의 개수
			cs.updateMore(uservo);
		}
		
		//쿠폰을 사용하여 결제하는 사람은 여기서 이미 쿠폰을 적립. 후에 /pay로 넘길시 또 적립되면 안되기 때문에 임의의 변수를 설정함.
		session.setAttribute("coupChk", 2);
		return totalPay;
	}
	
	@RequestMapping(value = "/userUpdate", method = RequestMethod.POST)
	public String userUpdate (Model model, HttpServletRequest req, @ModelAttribute UserVo uservo,  @RequestParam Map<String,String> map) throws Exception {
		
		log.debug("============"+map.get("phone"));
		log.debug("============"+map.get("phone2"));
		//UserVo uservo = new UserVo();
		uservo.setPhone(uservo.getPhone());
		uservo.setPhone2(uservo.getPhone2());
		
		cs.update_user(uservo);
		System.out.println("/////////"+cs.update_user(uservo));
		List<CafeVO> menuList =  cs.menuList();
		
		model.addAttribute("menuList", menuList);
		return "menu";
	}
	
	@ResponseBody
	@RequestMapping(value = "/userDelete", method = RequestMethod.POST)
	public int userDelete (Model model, @RequestParam("phone") String phone) throws Exception {
		
		cs.delete_user(phone);
		int retrunNum = cs.delete_user(phone); 
		
		List<CafeVO> menuList =  cs.menuList();
		
		model.addAttribute("menuList", menuList);
		
		System.out.println("<<<<<<<<<<<"+retrunNum);
		return retrunNum;
	}
	
	@ResponseBody
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public void logout(HttpServletRequest req, HttpServletResponse rep) {
		/*
		 * //쿠키삭제 Cookie cook = WebUtils.getCookie(req, "cookieId"); cook.setMaxAge(0);
		 * rep.addCookie(cook); System.out.println("name::" + cook.getName() + "value::"
		 * + cook.getValue());
		 */
		HttpSession session = req.getSession();
		session.setAttribute("payBt", null);
		session.setAttribute("logout", "Y");
	}
	
	@RequestMapping(value = "/test") //페이지내 jstl로 데이터 갖고 올 수 있나 테스트
	public String test (Model model) {
//		ModelAndView mv = new ModelAndView();
//		mv.addObject("tests", "은채짱");
//		mv.setViewName("/test");
		model.addAttribute("tests", "은채짱");
		return "test";
	}
	
	@RequestMapping(value = "/getJstlTest")
	public String jstlTest(Model model,@RequestParam String paramName) {
		/*test.jsp 에서 c:import 로 jstlTest.jsp 인클루드 시킴. 인클루여도 get은 필요하니
		컨트롤러에 매소드 만들어주고, param 은 굳이 request로 안 가져와도 자동으로 가져옴(ex.param.~)*/
		
		//String test = this.test(model);
		//System.out.printrln("test======"+this.test(model));
		//model.addAttribute("paramName", paramName);
		return "jstlTest";
	}
}
