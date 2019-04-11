//
//  SKYViewController.m
//  SwipeViewModule
//
//  Created by ShiKaiMing on 04/11/2019.
//  Copyright (c) 2019 ShiKaiMing. All rights reserved.
//

#import "SKYViewController.h"
#import "SKYSwipeViewController.h"
@interface SKYViewController ()

@end

@implementation SKYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)action
{
    SKYSwipeViewController *vc = [[SKYSwipeViewController alloc]init];
    [vc isShowOn:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
