//package com.spring.survey.config;
//import java.io.IOException;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//import org.springframework.context.annotation.ComponentScan;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
//import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
//import org.springframework.security.web.savedrequest.RequestCache;
//import org.springframework.security.web.savedrequest.SavedRequest;
//
//@Configuration
//@EnableWebSecurity
//@ComponentScan
//public class SecurityConfig extends WebSecurityConfigurerAdapter {
//
//    private final RequestCache requestCache = new HttpSessionRequestCache();
//
//    @Override
//    protected void configure(HttpSecurity http) throws Exception {
//        http
//            .authorizeRequests()
//                .antMatchers("/particiation/researchPopup").authenticated() // /particiation/researchPopup 요청에 대해 인증 필요
//                .anyRequest().permitAll() // 그 외 모든 요청은 허용
//                .and()
//            .formLogin()
//                .loginPage("/particiation/login") // 커스텀 로그인 페이지 URL
//                .permitAll()
//                .successHandler(new CustomAuthenticationSuccessHandler()) // 커스텀 로그인 성공 핸들러
//                .and()
//            .logout()
//                .permitAll();
//    }
//
//    @Override
//    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        auth
//            .inMemoryAuthentication()
//            .withUser("user").password("{noop}password").roles("USER"); // 인메모리 사용자 설정
//    }
//
//    private class CustomAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
//        @Override
//        public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
//            SavedRequest savedRequest = requestCache.getRequest(request, response);
//
//            if (savedRequest == null) {
//                super.onAuthenticationSuccess(request, response, authentication);
//                return;
//            }
//
//            // 로그인 후 원래 요청한 URL로 리디렉션
//            String targetUrl = savedRequest.getRedirectUrl();
//            clearAuthenticationAttributes(request);
//            getRedirectStrategy().sendRedirect(request, response, targetUrl);
//        }
//    }
//}




