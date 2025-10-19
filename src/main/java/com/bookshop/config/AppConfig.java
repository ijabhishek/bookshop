package com.bookshop.config;

import org.springframework.context.annotation.Bean;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Configuration;
// Configuration class the config the model mapper that helps in mapping Entity class to DTO class(ex. Book to BookDTO)
@Configuration
public class AppConfig {
    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
}
