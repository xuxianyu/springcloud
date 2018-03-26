package com.ming.base.scheduler;

import com.alibaba.fastjson.JSON;
import com.ming.base.quartz.ProxyJob;
import lombok.extern.slf4j.Slf4j;
import org.junit.Assert;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Optional;

/**
 * 定时器实例
 * todo  ming  异常处理
 *
 * @author ming
 * @date 2017-11-08 15:16
 */
@Component
@Slf4j
public class SchedulerInstance {

    private static final String JOB_GROUP = "mingJobGroup";
    private static final String TRIGGER_GROUP = "mingTriggerGroup";
    @Autowired
    private Optional<SchedulerFactoryBean> schedulerFactoryBeanOptional;

    private Scheduler scheduler;

    /**
     * 调整初始化方案
     *
     * @author ming
     * @date 2017-11-08 18:02
     */
    @PostConstruct
    public void init() {
        scheduler = schedulerFactoryBeanOptional.orElseThrow(RuntimeException::new).getScheduler();
        //scheduler = SpringBeanManager.getBean(SchedulerFactoryBean.class).getScheduler();
    }


    /**
     * 操作之前校验 定时容器
     *
     * @author ming
     * @date 2017-11-09 11:51
     */
    private void checkScheduler() {
        //定时容器 必须存在
        Assert.assertNotNull(scheduler);
    }

    /**
     * 添加定时器
     *
     * @param jobName           任务名称
     * @param jobDesc           任务描述
     * @param jobGroup          任务组
     * @param triggerName       触发器名称
     * @param triggerGroup      触发器 组
     * @param triggerType       定时器触发类型
     * @param triggerExpression 定时器触发规则表达式
     */
    public void create(String jobName, String jobDesc, String jobGroup, String triggerName, String triggerGroup, TriggerType triggerType, String triggerExpression) {
        checkScheduler();
        JobDetail jobDetail = JobBuilder.newJob(ProxyJob.class)
                .withIdentity(jobName, jobGroup)
                .withDescription(jobDesc)
                .build();
        try {
            scheduler.scheduleJob(jobDetail, buildTrigger(triggerType, triggerName, triggerGroup, triggerExpression, jobDesc));
        } catch (SchedulerException e) {
            log.error("[新增定时器失败!!参数:s%]::异常信息:s%", JSON.toJSONString(jobDetail), e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 删除定时器
     *
     * @param jobName  定时器名称
     * @param jobGroup 任务组
     * @author ming
     * @date 2017-11-09 11:28
     */
    public void delete(String jobName, String jobGroup) {
        checkScheduler();
        try {
            scheduler.deleteJob(new JobKey(jobName, jobGroup));
        } catch (SchedulerException e) {
            log.error("[删除s%定时器失败]::异常信息:s%", jobName, e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 修改定时器 执行触发器
     * 创建新的触发器  将已有的任务改变触发器
     *
     * @param jobName           任务名称
     * @param jobDesc           任务描述
     * @param triggerName       触发器名称
     * @param triggerGroup      触发器组
     * @param triggerExpression 定时器触发规则表达式
     * @param triggerType       定时器触发规则类型
     * @author ming
     * @date 2017-11-09 11:37
     */
    public void update(String jobName, String jobDesc, String triggerName, String triggerGroup, TriggerType triggerType, String triggerExpression) {
        checkScheduler();
        Trigger trigger = buildTrigger(triggerType, triggerName, triggerGroup, triggerExpression, jobDesc);
        try {
            scheduler.rescheduleJob(new TriggerKey(triggerName, triggerGroup), trigger);
        } catch (SchedulerException e) {
            log.error("[修改s%定时器失败]::异常信息:s%", jobName, e.getMessage());
            e.printStackTrace();
        }
    }


    /**
     * 暂停定时器
     *
     * @param jobName      任务名称
     * @param jobGroup     任务组
     * @param triggerName  触发器名称
     * @param triggerGroup 触发器组
     * @author ming
     * @date 2017-11-09 11:38
     */
    public void pause(String jobName, String jobGroup, String triggerName, String triggerGroup) {
        checkScheduler();
        try {
            scheduler.pauseJob(new JobKey(jobName, jobGroup));
            scheduler.pauseTrigger(new TriggerKey(triggerName, triggerGroup));
        } catch (SchedulerException e) {
            log.error("[停止s%定时器失败]::异常信息:s%", jobName, e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 重启暂停的定时器
     *
     * @param jobName      任务名称
     * @param jobGroup     任务组
     * @param triggerName  触发器名称
     * @param triggerGroup 触发器组
     * @author ming
     * @date 2017-11-09 11:38
     */
    public void resume(String jobName, String jobGroup, String triggerName, String triggerGroup) {
        checkScheduler();
        try {
            scheduler.resumeJob(new JobKey(jobName, jobGroup));
            scheduler.resumeTrigger(new TriggerKey(triggerName, triggerGroup));
        } catch (SchedulerException e) {
            log.error("[重启s%定时器失败]::异常信息:s%", jobName, e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 立即执行定时器
     *
     * @param jobName  任务名称
     * @param jobGroup 任务组
     * @author ming
     * @date 2017-11-09 11:40
     */
    public void run(String jobName, String jobGroup) {
        checkScheduler();
        try {
            scheduler.triggerJob(new JobKey(jobName, jobGroup));
        } catch (SchedulerException e) {
            log.error("[立即执行s%定时器失败]::异常信息s%", jobName, e.getMessage());
            e.printStackTrace();
        }
    }


    /**
     * 构建触发规则
     *
     * @param triggerType       定时器触发规则类型
     * @param triggerName       定时器触发规则名称
     * @param triggerGroup      定时器触发规则组名称
     * @param triggerExpression 定时器触发规则表达式
     * @param jobDesc           任务描述
     * @author ming
     * @date 2017-11-08 18:00
     */
    private Trigger buildTrigger(TriggerType triggerType, String triggerName, String triggerGroup, String triggerExpression, String jobDesc) {
        Trigger trigger;
        switch (triggerType) {
            case SIMPLE: {
                trigger = TriggerBuilder.newTrigger()
                        .withIdentity(triggerName, triggerGroup)
                        .withDescription(jobDesc)
                        .withSchedule(SimpleScheduleBuilder.simpleSchedule()
                                .withIntervalInSeconds(Integer.valueOf(triggerExpression))
                                .repeatForever())
                        .build();
                break;
            }
            case CRON: {
                trigger = TriggerBuilder.newTrigger()
                        .withIdentity(triggerName, triggerGroup)
                        .withDescription(jobDesc)
                        .withSchedule(CronScheduleBuilder.cronSchedule(triggerExpression))
                        .build();
                break;
            }
            default:
                throw new RuntimeException("没有这种格式定时");
        }
        return trigger;
    }

    /**
     * 触发规则类型 枚举
     *
     * @author ming
     * @date 2017-11-08 17:59
     */
    public enum TriggerType {
        /**
         * 简单模式定时  指定秒数
         */
        SIMPLE,
        /**
         * cron模式  使用cron表达式
         */
        CRON
    }


}
