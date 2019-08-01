//
//  PYTimer.m
//  PYTimer
//
//  Created by yang.pu on 2019/8/1.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import "PYTimer.h"
#import "PYTimerHelper.h"
#import <UIKit/UIApplication.h>

@interface PYTimer()

@property (nonatomic, strong) PYTimerHelper *timer;

@property (nonatomic, assign) NSTimeInterval countDownSecond;

@property (nonatomic, strong) NSDate *currentStopDate;

@property(nonatomic, copy) timeIntervalAction timeIntervalBlock;

@property(nonatomic, copy) completedAction completedBlock;

@property (nonatomic, assign) BOOL isCompletedBlock;

@end

@implementation PYTimer

+ (instancetype)timer;
{
    PYTimer *backgroundTimer = [[self alloc]init];
    return backgroundTimer;
}

- (PYTimerHelper *)timer
{
    if (!_timer) {
        _timer = [PYTimerHelper timerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
        [_timer addToRunloop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)fireWithCountTime:(timeIntervalAction)timeIntervalBlock completed:(completedAction)completedBlock
{
    if (self.timeIntervalBlock) {
        self.timeIntervalBlock = NULL;
    }
    self.timeIntervalBlock = timeIntervalBlock;
    
    if (self.completedBlock) {
        self.completedBlock = NULL;
    }
    self.completedBlock = completedBlock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        [notifCenter addObserver:self
                        selector:@selector(resignActive:)
                            name:UIApplicationDidEnterBackgroundNotification
                          object:nil];
        [notifCenter addObserver:self
                        selector:@selector(becomeActive:)
                            name:UIApplicationWillEnterForegroundNotification
                          object:nil];
    }
    return self;
}

- (void)fireWithTimeInterval:(NSTimeInterval)timeInterval
{
    if (self.isRunning) {
        [_timer invalidate];
        _timer = nil;
    }
    if (timeInterval <= 0) {
        return;
    }
    self.countDownSecond = timeInterval;
    [self.timer fire];
}

- (void)timerCountDown
{
    if (self.timeIntervalBlock) {
        self.timeIntervalBlock(self.countDownSecond);
    }
    self.countDownSecond --;
    self.isCompletedBlock = YES;
    if (self.countDownSecond < 0) {
        [self stopCoundDown];
    }
}

//结束重置并回调
- (void)stopCoundDown
{
    if (self.isCompletedBlock) {
        if (self.completedBlock) {
            self.completedBlock();
        }
        self.isCompletedBlock= NO;
    }
    
    [self invalidate];
    self.countDownSecond = 0;
}

//停止计时器
- (void)invalidate
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

//是否在计时
- (BOOL)isRunning
{
    return _timer ? _timer.isValid : NO;
}

#pragma mark - notificationCenter

- (void)resignActive:(NSNotification *)notification
{
    self.currentStopDate = [NSDate date];
    [self invalidate];
}

- (void)becomeActive:(NSNotification *)notification
{
    NSTimeInterval stopInterval = -[self.currentStopDate timeIntervalSinceNow];
    if ((self.countDownSecond + 0.0000001 - stopInterval) > 1) {
        self.countDownSecond = (self.countDownSecond + 0.0000001 - stopInterval);
        [self.timer fire];
    } else {
        [self stopCoundDown];
    }
}


+ (NSString *)getDateStringForTimeInterval:(NSTimeInterval)timeInterval
{
    return [self getDateStringForTimeInterval:timeInterval withDateFormatter:nil];
}

+ (NSString *)getDateStringForTimeInterval:(NSTimeInterval)timeInterval withDateFormatter:(NSNumberFormatter *)formatter
{
    double hours;
    double minutes;
    double seconds = round(timeInterval);
    hours = floor(seconds / 3600.);
    seconds -= 3600. * hours;
    minutes = floor(seconds / 60.);
    seconds -= 60. * minutes;
    
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        [formatter setPositiveFormat:@"#00"];  // Use @"#00.0" to display milliseconds as decimal value.
    }
    
    NSString *secondsInString = [formatter stringFromNumber:[NSNumber numberWithDouble:seconds]];
    
    if (hours == 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"%02.0f:%@", @"Short format for elapsed time (minute:second). Example: 05:3.4"), minutes, secondsInString];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%.0f:%02.0f:%@", @"Short format for elapsed time (hour:minute:second). Example: 1:05:3.4"), hours, minutes, secondsInString];
    }
}

//格式化为 00:00:00 样式的字符串
+ (NSString *)getAllDateStringForTimeInterval:(NSTimeInterval)timeInterval withDateFormatter:(NSNumberFormatter *)formatter
{
    double hours;
    double minutes;
    double seconds = round(timeInterval);
    hours = floor(seconds / 3600.);
    seconds -= 3600. * hours;
    minutes = floor(seconds / 60.);
    seconds -= 60. * minutes;
    
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        [formatter setPositiveFormat:@"#00"];  // Use @"#00.0" to display milliseconds as decimal value.
    }
    
    NSString *secondsInString = [formatter stringFromNumber:[NSNumber numberWithDouble:seconds]];
    
    return [NSString stringWithFormat:NSLocalizedString(@"%02.0f:%02.0f:%@", @"Short format for elapsed time (hour:minute:second). Example: 00:05:00"), hours, minutes, secondsInString];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
