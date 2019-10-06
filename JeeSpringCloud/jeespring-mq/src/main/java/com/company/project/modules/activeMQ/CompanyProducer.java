package com.company.project.modules.activeMQ;

import com.jeespring.common.redis.RedisUtils;
import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.activemq.command.ActiveMQQueue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.core.JmsMessagingTemplate;
import org.springframework.stereotype.Service;

import javax.jms.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 消息生产者.
 * @author 黄炳桂 516821420@qq.com
 * @version v.0.1
 * @date 2016年8月23日
 */

@Service("companyProducer")
public class CompanyProducer {

    private static Logger logger = LoggerFactory.getLogger(RedisUtils.class);
    public static final  String ActiveMQQueueKey="Company.ActiveMQ.queue";
    public static final  String ActiveMQQueueKeyA="Company.ActiveMQ.queueA";
    public static final  String ActiveMQQueueKeyB="Company.ActiveMQ.queueB";
    public static String RUN_MESSAGE="ActvieMQ连接异常，请开启ActvieMQ服务.";
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    // 也可以注入JmsTemplate，JmsMessagingTemplate对JmsTemplate进行了封装
    @Autowired
    private JmsMessagingTemplate jmsTemplate;
    // 发送消息，destination是发送到的队列，message是待发送的消息
    public void sendMessage( final String message){
        try{
            Destination destination = new ActiveMQQueue(CompanyProducer.ActiveMQQueueKey);
            jmsTemplate.convertAndSend(destination, message);
        }catch (Exception e){
            logger.error(dateFormat.format(new Date()) + " | " +"ActvieMQ:"+RUN_MESSAGE+e.getMessage(), RUN_MESSAGE+e.getMessage());
        }
    }

    public void sendMessageA( final String message){
        try{
            Destination destinationA = new ActiveMQQueue(CompanyProducer.ActiveMQQueueKeyA);
            jmsTemplate.convertAndSend(destinationA, message);
        }catch (Exception e){
            logger.error(dateFormat.format(new Date()) + " | " +"ActvieMQ:"+RUN_MESSAGE+e.getMessage(), RUN_MESSAGE+e.getMessage());
        }
    }
    public void sendMessageB(final String message){
        try{
            Destination destinationB = new ActiveMQQueue(CompanyProducer.ActiveMQQueueKeyA);
            jmsTemplate.convertAndSend(destinationB, message);
        }catch (Exception e){
            logger.error(dateFormat.format(new Date()) + " | " +"ActvieMQ:"+RUN_MESSAGE+e.getMessage(), RUN_MESSAGE+e.getMessage());
        }
    }
    @JmsListener(destination="company.out.queue")
    public void consumerMessage(String text){
        System.out.println(dateFormat.format(new Date()) + " | " +"ActvieMQ:从out.queue队列收到的回复报文为:"+text);
    }
    public static void main(String[] args){
        ThreadLocal<MessageProducer> threadLocal = new ThreadLocal<>();
        AtomicInteger count = new AtomicInteger(0);
        ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("admin","admin", ActiveMQConnection.DEFAULT_BROKER_URL);
        //从工厂中创建一个链接
        Connection connection  = null;
        try {
            connection = connectionFactory.createConnection();
            //开启链接
            connection.start();
            //创建一个事务（这里通过参数可以设置事务的级别）
            Session session = connection.createSession(true, Session.SESSION_TRANSACTED);
            Queue queue = session.createQueue("test");
            MessageConsumer consumer = null;
            //消息生产者
            MessageProducer messageProducer = null;
            if(threadLocal.get()!=null){
                messageProducer = threadLocal.get();
            }else{
//                messageProducer = session.createProducer(queue);
                consumer = session.createConsumer(queue);
//                threadLocal.set(messageProducer);
            }
            while(true){
                Thread.sleep(1000);
//                int num = count.getAndIncrement();
//                //创建一条消息
//                TextMessage msg = session.createTextMessage(Thread.currentThread().getName()+
//                        "productor:我是大帅哥，我现在正在生产东西！,count:"+num);
//                System.out.println(Thread.currentThread().getName()+
//                        "productor:我是大帅哥，我现在正在生产东西！,count:"+num);
//                //发送消息
//                messageProducer.send(msg);
//                //提交事务
//                session.commit();
                TextMessage msg = (TextMessage) consumer.receive();
                if(msg!=null) {
                    msg.acknowledge();
                    System.out.println(Thread.currentThread().getName()+": Consumer:我是消费者，我正在消费Msg"+msg.getText()+"--->"+count.getAndIncrement());
                }else {
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}