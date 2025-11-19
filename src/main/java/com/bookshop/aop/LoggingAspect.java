package com.bookshop.aop;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AdviceName;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;


@Component
@Aspect
public class LoggingAspect {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingAspect.class);

    // return tye, class name, method-name(args)
    @Before("execution(* com.bookshop.service.BookService.getBooksByKeyword*(..))")  //---> this is point cut(means when we want advice to be called)
    public void logMethodCall(JoinPoint joinPoint) {
        LOGGER.info("Method called " + joinPoint.getSignature().getName());
        
    }
    @Before("execution(* com.bookshop.service.CartService.*(..))")
    public void logMethod() {
        LOGGER.info("Cart service method called");
        
    }
    
}
