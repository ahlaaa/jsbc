package com.jeespring.modules.test.web.one;

import com.jeespring.common.redis.RedisUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.lang.reflect.Method;
import java.sql.*;

@RestController
public class Test1Controller {
    @Autowired
    private RedisUtils redisUtils;
    @RequestMapping(value = "tt1",method = RequestMethod.GET)
    public String test(){
        ResultSet rs = null;
        String str = "";
        redisUtils.set("hl",123);
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jeespring","root","root");
            Statement sta = conn.createStatement();
            PreparedStatement ps = conn.prepareStatement("select * from sys_user where id = ?");
            ps.setString(1,"435438e2ad77427093973d4bb090d93f");
            rs = ps.executeQuery();
            while (rs.next()){
                str += rs.first();
            }
            rs = sta.executeQuery("select * from sys_user");

        } catch (Exception e) {
            e.printStackTrace();
        }
//        if (null != rs)
//            str = rs.toString();
        str+=redisUtils.get("hl");
        return str;
    }
}
