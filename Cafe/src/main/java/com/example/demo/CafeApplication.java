package com.example.demo;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@MapperScan("com.ec.cafe.mapper")
@ComponentScan(basePackages = {"com.ec.cafe.*"})
/** 
 * MapperScan 어노테이션을 통해 탐색할 Mapper 인터페이스의 경로를 설정해 주고, sqlSessionFactory를 이용해서 Mapper xml과 맵핑해준다.
 * 일반 스프링에서는 root-context.xml에서 설정했던 걸 부트에선 여기서 설정.
 * mapper 경로 설정 후, mapper.xml 에서 namespace로 매핑할 xml 경로를 써줌, java에서 @mapper 어노테이션 주입 후 매핑 되어 사용가능. xml과 java 이름이 같아야 매핑
 * napespace란 소속단체명. 즉 a namespace의 자원 1,2,3. 여기선 mapper namespace의 자원 1,2,3(각 sql문 id)
**/
/** 
 * @ComponentScan 또한 root-context.xml에서 설정했던 걸 부트에선 여기서 설정.
 * controller, serveice, repository 등 어노테이션이 부여된 클래스들을 자동 scan 하여 bean으로 등록
**/
@EnableScheduling
public class CafeApplication {

	public static void main(String[] args) {
		SpringApplication.run(CafeApplication.class, args);
	}

	/*
     * SqlSessionFactory 설정 
     * 스프링에선 root-context.xml 에서 3단계로 p,c 하던걸 여기서 줄임. db접속정보는 application.properties에서 정의
     */
    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception{
        
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        
        sessionFactory.setDataSource(dataSource);
        return sessionFactory.getObject();
        
    }


}
