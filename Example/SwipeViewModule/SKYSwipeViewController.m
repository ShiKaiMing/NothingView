//
//  SKYSwipeViewController.m
//  SwipeViewModule_Example
//
//  Created by sky on 2019/4/11.
//  Copyright © 2019 ShiKaiMing. All rights reserved.
//

#import "SKYSwipeViewController.h"

@interface SKYSwipeViewController ()

@end

@implementation SKYSwipeViewController
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (instancetype)init
{
    self = [super initSwipeDirection:(SwipeDirectionTypeTop) widthOrHeight:500/*UI标注*/];
    if (self) {
        [self createTopView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTopView];
    // Do any additional setup after loading the view.
}
/**
 头部创建
 */
-(void)createTopView
{
    UIView *topView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor cyanColor];
        view;
    });
    topView.frame = CGRectMake(0, 0, 100, 200);
    [self.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, 100, 200);
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
