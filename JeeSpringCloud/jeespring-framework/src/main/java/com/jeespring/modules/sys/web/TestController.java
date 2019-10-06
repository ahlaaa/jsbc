package com.jeespring.modules.sys.web;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @RequestMapping(value = "/tt", method = RequestMethod.GET)
    public static Integer getTest(){
        Integer a = 1;
        return 111;
    }
}
