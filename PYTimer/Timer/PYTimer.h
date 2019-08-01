//
//  PYTimer.h
//  PYTimer
//
//  Created by yang.pu on 2019/8/1.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^timeIntervalAction)(NSTimeInterval timeInterval);
typedef void (^completedAction)(void);

NS_ASSUME_NONNULL_BEGIN

@interface PYTimer : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval countDownSecond;

/**
 初始化方法
 
 @return timer
 */
+ (instancetype)timer;


/**
 是否在正在倒计时
 */
@property (nonatomic, assign) BOOL isRunning;

/**
 开始倒计时
 
 @param timeInterval 时间
 */
- (void)fireWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 结束倒计时
 */
- (void)invalidate;

/**
 记录时间block
 
 @param timeIntervalBlock 时间
 @param completedBlock 倒计时停止调用
 */
- (void)fireWithCountTime:(timeIntervalAction)timeIntervalBlock completed:(completedAction)completedBlock;

/**
 时间格式化工具
 
 @param timeInterval 默认 时分秒  格式  00:00:00
 @return 时间格式字符串
 */
+ (NSString *)getDateStringForTimeInterval:(NSTimeInterval)timeInterval;

/**
 自定义时间格式化
 
 @param timeInterval 时间
 @param dateFormatter 格式
 @return 格式字符串
 */
+ (NSString *)getDateStringForTimeInterval:(NSTimeInterval)timeInterval withDateFormatter:(NSNumberFormatter * __nullable)dateFormatter;

/**
 格式化为 00:00:00 样式的字符串
 
 @param timeInterval 时间
 @param formatter 格式
 @return 格式字符串
 */
+ (NSString *)getAllDateStringForTimeInterval:(NSTimeInterval)timeInterval withDateFormatter:(NSNumberFormatter *)formatter;

@end

NS_ASSUME_NONNULL_END
