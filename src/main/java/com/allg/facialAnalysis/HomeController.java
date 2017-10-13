package com.allg.facialAnalysis;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, HttpServletRequest request) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		//접속 기기 체크
		Device device = DeviceUtils.getCurrentDevice(request);
				
		if(device.isMobile() || device.isTablet()) {
			return "m_index";
		}
		
		return "index";
	}
	
	@RequestMapping(value="/m_index", method=RequestMethod.GET)
	public String mHome() {
		return "m_index";
	}
	
}
