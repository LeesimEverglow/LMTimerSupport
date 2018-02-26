//
//  TimerViewController.m
//  NSTimerDemo
//
//  Created by Leesim on 2018/2/24.
//  Copyright © 2018年 LiMing. All rights reserved.
//

#import "TimerViewController.h"
#import "NSTimer+LMBlockSupport.h"

@interface TimerViewController ()

@property (nonatomic,strong)NSTimer * timer;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.造成循环引用的写法
    //正常的 strong声明的timer 因为target指定了self  强引用了self 然后 self 又强引用timer
    //所以造成了循环引用 控制器不会被释放  timer也就无法释放
    //
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
    //2.用分类方法定义的新类方法 解决循环引用问题
    //定义一个NSTimer的类别，在类别中定义一个类方法。类方法有一个类型为块的参数（定义的块位于栈上，为了防止块被释放，需要调用copy方法，将块移到堆上）。使用这个类别的方式如下：
    __weak TimerViewController *weakSelf = self;
    self.timer = [NSTimer lm_scheduledTimerWithTimeInterval:1.0 block:^{
        __strong TimerViewController *strongSelf = weakSelf;
        [strongSelf timerAction];
    } repeats:YES];
    
    
    [self.timer fire];
    
    // Do any additional setup after loading the view.
}

#warning  这是以往老的解决方案 非常不可取
//以往的解决思路是在控制器消失的时候 关闭计时器
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self.timer invalidate];
//    self.timer = nil;
}
//在控制器出现时候 启动计时器 但是这样过于繁琐
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerAction{
    
    NSLog(@"timerFire");
    
}

-(void)dealloc{
    
    //在dealloc方法内记得关闭计时器
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"dealloc---timer");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
