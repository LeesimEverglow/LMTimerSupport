//
//  NSTimer+LMBlockSupport.h
//  NSTimerDemo
//
//  Created by Leesim on 2018/2/24.
//  Copyright © 2018年 LiMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LMBlockSupport)

+ (NSTimer *)lm_scheduledTimerWithTimeInterval:(NSTimeInterval)time
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats;

@end
