//
//  PYTimerHelper.h
//  PYTimer
//
//  Created by yang.pu on 2019/8/1.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYTimerHelper : NSObject

+ (PYTimerHelper *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id __nullable)userInfo repeats:(BOOL)yesOrNo;
+ (PYTimerHelper *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep;

- (void)fire;

- (NSDate *)fireDate;
- (void)setFireDate:(NSDate *)date;

- (NSTimeInterval)timeInterval;

- (void)invalidate;
- (void)finallyInvalidate;

- (BOOL)isValid;

- (id)userInfo;

- (void)addToRunloop:(NSRunLoop *)runloop forMode:(NSString *)mode;

@end

NS_ASSUME_NONNULL_END
