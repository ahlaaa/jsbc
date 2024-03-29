/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/HuangBingGui/jeespring">jeespring</a> All rights reserved.
 */
package com.jeespring.common.utils;

import org.activiti.engine.impl.cfg.IdGenerator;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.SessionIdGenerator;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.security.SecureRandom;
import java.util.*;

/**
 * 封装各种生成唯一性ID算法的工具类.
 *
 * @author 黄炳桂 516821420@qq.com
 * @version 2013-01-15
 */
@Service
@Lazy(false)
public class IdGen implements IdGenerator, SessionIdGenerator {

    private static SecureRandom random = new SecureRandom();

    /**
     * 封装JDK自带的UUID, 通过Random数字生成, 中间无-分割.
     */
    public static String uuid() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    /**
     * 使用SecureRandom随机生成Long.
     */
    public static long randomLong() {
        return Math.abs(random.nextLong());
    }

    /**
     * 基于Base62编码的SecureRandom随机生成bytes.
     */
    public static String randomBase62(int length) {
        byte[] randomBytes = new byte[length];
        random.nextBytes(randomBytes);
        return Encodes.encodeBase62(randomBytes);
    }

    /**
     * Activiti ID 生成
     */
    //@Override
    @Override
    public String getNextId() {
        return IdGen.uuid();
    }

    @Override
    public Serializable generateId(Session session) {
        return IdGen.uuid();
    }

    public static void main(String[] args){
        int index = 0;
        Set<String> set = new TreeSet<String>();
        while (true) {
            String str = IdGen.randomBase62(5);
            if (!set.add(str) || index > 99999999){
                System.out.println(index);
                break;
            }
            index++;
        }
        Iterator<String> ite = set.iterator();
        while (ite.hasNext()){
            System.out.println(ite.next());
        }
    }
}
