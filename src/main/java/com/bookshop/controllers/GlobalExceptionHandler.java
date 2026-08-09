package com.bookshop.controllers;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.bind.annotation.ExceptionHandler;

// NOTE: this was previously missing @ControllerAdvice, so Spring never
// actually registered it - 404s were falling through to the default
// Whitelabel/BasicErrorController instead of this handler.
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404() {
        return "error";
    }

}
