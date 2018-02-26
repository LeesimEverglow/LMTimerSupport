//
//  ViewController.m
//  NSTimerDemo
//
//  Created by Leesim on 2018/2/24.
//  Copyright © 2018年 LiMing. All rights reserved.
//

#import "ViewController.h"
#import "TimerViewController.h"

@interface ViewController ()

@property (nonatomic,strong)UIButton * pushButton;

@end

@implementation ViewController

-(UIButton *)pushButton{
    
    if (!_pushButton) {
     
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.backgroundColor = [UIColor redColor];
        _pushButton.frame = CGRectMake(0, 0, 100, 100);
        _pushButton.center = self.view.center;
        [_pushButton addTarget:self action:@selector(pushAciton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_pushButton];
    }
    return _pushButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pushButton class];
    
}

-(void)pushAciton{
    
    TimerViewController * vc = [[TimerViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
