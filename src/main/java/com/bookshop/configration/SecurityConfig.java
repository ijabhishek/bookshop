package com.bookshop.configration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    @Autowired private UserDetailsService userDetailsService;

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(new BCryptPasswordEncoder(12));
        return provider;
    }

    @Bean
    public AuthenticationSuccessHandler roleAwareSuccessHandler() {
        return (request, response, authentication) -> {
            String role = authentication.getAuthorities().stream()
                    .map(a -> a.getAuthority())
                    .findFirst().orElse("ROLE_USER");
            if ("ROLE_ADMIN".equals(role)) response.sendRedirect(request.getContextPath() + "/bookstore/admin");
            else if ("ROLE_SELLER".equals(role)) response.sendRedirect(request.getContextPath() + "/bookstore/seller");
            else if ("ROLE_SALES".equals(role)) response.sendRedirect(request.getContextPath() + "/bookstore/sales/orders");
            else response.sendRedirect(request.getContextPath() + "/bookstore/home");
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity,
            AuthenticationSuccessHandler roleAwareSuccessHandler) throws Exception {
        httpSecurity
            .csrf(customizer -> customizer.disable())
            .authorizeHttpRequests(request -> request
                .requestMatchers("/bookstore/sales/**").hasAnyRole("SALES", "ADMIN")
                .requestMatchers("/bookstore/admin/**", "/bookstore/admin").hasRole("ADMIN")
                .requestMatchers("/bookstore/seller", "/bookstore/seller/**", "/bookstore/addbook", "/bookstore/save", "/bookstore/author/save")
                    .hasRole("SELLER")
                .requestMatchers("/bookstore/myorders", "/bookstore/checkout", "/bookstore/order/**", "/bookstore/cancelOrder/**")
                    .hasRole("USER")
                .requestMatchers("/bookstore/profile", "/bookstore/profile/**")
                    .authenticated()
                .requestMatchers("/bookstore/requestBook").hasAnyRole("USER", "SELLER")
                .requestMatchers("/bookstore/feedback", "/bookstore/feedback/**").permitAll()
                .requestMatchers("/bookstore/addToCart", "/bookstore/api/cart/**", "/bookstore/mycart", "/bookstore/removeCart/**")
                    .permitAll()
                .anyRequest().permitAll())
            .formLogin(form -> form
                .loginPage("/bookstore/login")
                .loginProcessingUrl("/bookstore/loginUser")
                .usernameParameter("userId")
                .passwordParameter("password")
                .successHandler(roleAwareSuccessHandler)
                .failureUrl("/bookstore/login?error=true")
                .permitAll())
            .logout(logout -> logout
                .logoutUrl("/bookstore/logout")
                .logoutSuccessUrl("/bookstore/home")
                .permitAll());
        return httpSecurity.build();
    }
}
