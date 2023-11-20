package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

public class ServletInitializer extends SpringBootServletInitializer {

	public static void main(String[] args) { 
		
		SpringApplication.run(CafeApplication.class, args); 
		
	}

	@Override protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) { 
		return builder.sources(CafeApplication.class); 
		}

	
//	@Override
//	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
//		return application.sources(CafeApplication.class);
//	}
	
	
}
