package com.bookshop.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // This maps any request (**) to look inside the 'static' folder 
        // located on the classpath (i.e., src/main/resources/static).
        // The default handler is often '/**'.
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
        
        // This ensures all other static resources (like CSS, JS) still load
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }
    
}
