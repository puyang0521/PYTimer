//
//  ViewController.m
//  PYTimer
//
//  Created by yang.pu on 2019/8/1.
//  Copyright © 2019 yang.pu. All rights reserved.
//

#import "ViewController.h"
#import "PYTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PYTimer *timer = [PYTimer timer];
    [timer fireWithCountTime:^(NSTimeInterval timeInterval) {
        NSLog(@"%f",timeInterval);
    } completed:^{
        NSLog(@"倒计时结束");
    }];
    [timer fireWithTimeInterval:60];
    
}


@end
