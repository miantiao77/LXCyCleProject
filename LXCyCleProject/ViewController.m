//
//  ViewController.m
//  LXCyCleProject
//
//  Created by lx on 2018/4/3.
//  Copyright © 2018年 yintu. All rights reserved.
//

#import "ViewController.h"
#import "LXCycleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LXCycleView *view = [LXCycleView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) datas:@[@"1",@"2",@"3"]];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
