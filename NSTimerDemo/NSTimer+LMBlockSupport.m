//
//  NSTimer+LMBlockSupport.m
//  NSTimerDemo
//
//  Created by Leesim on 2018/2/24.
//  Copyright © 2018年 LiMing. All rights reserved.
//

#import "NSTimer+LMBlockSupport.h"

@implementation NSTimer (LMBlockSupport)

+ (NSTimer *)lm_scheduledTimerWithTimeInterval:(NSTimeInterval)time
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats{
    
    return [self scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(lm_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)lm_blockInvoke:(NSTimer *)timer{
    
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
