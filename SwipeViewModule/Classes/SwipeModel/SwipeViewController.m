//
//  SwipeViewController.m
//  framework
//
//  Created by suger on 2018/11/14.
//  Copyright © 2018 Maimaimai Co.,Ltd. All rights reserved.
//

#import "SwipeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "QMUIKit.h"
#import "YYKit.h"
//Baby log
#ifdef DEBUG
#define SwipeViewLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SwipeViewLog(fmt, ...)  {};
#endif
@interface SwipeViewController ()<UIGestureRecognizerDelegate>
/**
 滑动方向
 */
@property(nonatomic) SwipeDirectionType swipeDirectionType;

/**
 父ViewController
 */
@property(nonatomic, weak) UIViewController *superViewController;

/**
 显示侧滑偏移量
 */
@property(nonatomic,assign) CGFloat withOrHeight;
/**
 标示当前是否显示
 */
@property(nonatomic) BOOL showOn;

/**
 存放 当前内容View
 */
@property(nonatomic, strong) UIView *contentView;


/**
 空白点击Button
 */
@property(nonatomic,strong)QMUIButton *blankButton;
/**
 侧滑手势
 */
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;


/**
 按住事件反馈
 */
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;



@property(nonatomic, assign) CGFloat limitLeftCentX;
@end

@AppLordService(SwipeProtocol,SwipeViewController)
@implementation SwipeViewController
- (void)dealloc {
    [self.view removeGestureRecognizer:_swipeGesture];
    [self.view removeGestureRecognizer:_panGesture];
    SwipeViewLog(@"");
}
- (instancetype)initSwipeDirection:(SwipeDirectionType)SwipeDirectionType widthOrHeight:(CGFloat)wh{
    if (self = [super init]) {
        
        self.withOrHeight = wh;
        self.swipeDirectionType = SwipeDirectionType;
        self.gestureEnabled = YES;
    }
    return self;
}

- (void)attachToViewController:(UIViewController *)viewController {
    self.superViewController  = viewController;
    
}

- (void)isShowOn:(BOOL)showOn {
    
    showOn ? [self _spreadInPositionWithType:self.swipeDirectionType showOn:showOn] : [self _spreadOutPositionWithType:self.swipeDirectionType showOn:showOn];
}

- (void)colse {
    [self _spreadOutPositionWithType:self.swipeDirectionType showOn:NO];
}


#pragma mark - Tools

- (void)_spreadInPositionWithType:(SwipeDirectionType)swipeDirectionType showOn:(BOOL)showOn {
    if  (!(!self.showOn && showOn)) {
        return;
    }
    
    // TODO: 聚合事件回调
    if ([self.swipeProtocol respondsToSelector:@selector(willSpreadInWithProtocol:)]) {
        [self.swipeProtocol willSpreadInWithProtocol:self];
    }
    
    self.view.alpha = 1.f;
    [UIView animateWithDuration:.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        switch (swipeDirectionType) {
            case SwipeDirectionTypeLeft:
                self.contentView.left = self.superViewController.view.width - self.withOrHeight;
                break;
            case SwipeDirectionTypeRight:
                self.contentView.left = 0.f;
                break;
            case SwipeDirectionTypeBottom:
                self.contentView.top = 0.f;
                break;
            case SwipeDirectionTypeTop:
                self.contentView.top = self.superViewController.view.height - self.withOrHeight;
                break;
                
        }
    } completion:^(BOOL finished) {
        self.showOn = showOn;
        
        if (self.gestureEnabled){
            
            self.limitLeftCentX  = self.contentView.centerX;
            // 添加手势
            [self _addSwipeGestureWithDirection:swipeDirectionType];
            [self _addPanGestureWithDirection:swipeDirectionType];

        }
        
        // TODO: 聚合事件回调
        if ([self.swipeProtocol respondsToSelector:@selector(didSpreadInWithProtocol:)]) {
            [self.swipeProtocol didSpreadInWithProtocol:self];
        }
    }];
    
}

/*
 * ，根据当前初始位置 初始化当前view的位置
 * */
- (void)_spreadOutPositionWithType:(SwipeDirectionType)swipeDirectionType showOn:(BOOL)showOn {
    if  (!(self.showOn && !showOn)) {
        return;
    }
    
    [self _resetPositionWithType:swipeDirectionType showOn:showOn animation:YES];
    
}

- (void)_resetPositionWithType:(SwipeDirectionType)swipeDirectionType showOn:(BOOL)showOn animation:(BOOL)animation {
    
    void (^positionBlock)(SwipeDirectionType direction) = ^void(SwipeDirectionType direction) {
        switch (direction) {
            case SwipeDirectionTypeLeft:
            {
                self.contentView.left = self.superViewController.view.width + self.withOrHeight;
                self.contentView.width = self.withOrHeight;
                self.contentView.height = self.superViewController.view.height;
                
                self.blankButton.width = self.superViewController.view.width - self.contentView.width;
                self.blankButton.height = self.superViewController.view.height;
                
            }
                break;
            case SwipeDirectionTypeRight:
            {
                self.contentView.left = - self.withOrHeight;
                self.contentView.width = self.withOrHeight;
                self.contentView.height = self.superViewController.view.height;
                
                self.blankButton.width = self.superViewController.view.width - self.contentView.width;
                self.blankButton.height = self.superViewController.view.height;
                self.blankButton.right = self.superViewController.view.width;
                
            }
                break;
            case SwipeDirectionTypeBottom:
            {
                self.contentView.top = - self.withOrHeight;
                self.contentView.height = self.withOrHeight;
                self.contentView.width = self.superViewController.view.width;
                
                
                self.blankButton.width = self.superViewController.view.width;
                self.blankButton.height = self.superViewController.view.height - self.withOrHeight;
                self.blankButton.bottom = self.superViewController.view.height;
            }
                break;
            case SwipeDirectionTypeTop:
            {
                self.contentView.top = self.superViewController.view.height;
                self.contentView.height = self.withOrHeight;
                self.contentView.width = self.superViewController.view.width;
                
                
                self.blankButton.width = self.superViewController.view.width;
                self.blankButton.height = self.superViewController.view.height - self.withOrHeight;
            }
                break;
        }
        
        
    };
    
    self.blankButton.alpha = 0.f;
    if (animation){
        // TODO: 散开事件回调
        if ([self.swipeProtocol respondsToSelector:@selector(willSpreadOutWithProtocol:)]) {
            [self.swipeProtocol willSpreadOutWithProtocol:self];
        }
        
        [UIView animateWithDuration:.2f delay:0.f options:(QMUIViewAnimationOptionsCurveIn) animations:^{
            positionBlock(swipeDirectionType);
            self.view.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            self.showOn = showOn;
            
            // TODO: 散开事件回调
            if ([self.swipeProtocol respondsToSelector:@selector(didSpreadOutWithProtocol:)]) {
                [self.swipeProtocol didSpreadOutWithProtocol:self];
            }
            
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
        
    }else {
        positionBlock(swipeDirectionType);
        self.showOn = showOn;
    }
    
    [UIView animateWithDuration:.1f delay:.2f options:(UIViewAnimationOptionCurveLinear) animations:^{
        self.blankButton.alpha = 1.f;
    } completion:nil];
}

#pragma  mark - SwipeGesture
- (void)_addSwipeGestureWithDirection:(SwipeDirectionType)dictionType{
    
    if (!_swipeGesture) {
        self.swipeGesture =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_reponseSwipeGesture)];
        self.swipeGesture.direction = (UISwipeGestureRecognizerDirection)dictionType;
        self.swipeGesture.delegate = self;
        [self.view addGestureRecognizer:self.swipeGesture];
        
    }
}

- (void)_addPanGestureWithDirection:(SwipeDirectionType)dictionType {
    if (!_panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(_reponsePanGesture:)];
        self.panGesture.delegate = self;
        [self.swipeGesture requireGestureRecognizerToFail:self.panGesture];
        [self.view addGestureRecognizer:self.panGesture];
        
    }
}


#pragma mark - UIGestureRecognizerDelegate
/**
 多个手势同时存在的代理,不能忘记
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)_reponsePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    
    CGPoint endPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view]; //移动手势最后到的点
    
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            SwipeViewLog(@"swipeDirectionType is %ld %.2f",(long)self.swipeDirectionType, endPoint.x);
            
            switch (self.swipeDirectionType) {
                case SwipeDirectionTypeLeft:
                    [self handlerSwipeDirectionTypeLeftPan:endPoint];
                    break;
                    
                default:
                    break;
            }
            [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            switch (self.swipeDirectionType) {
                case SwipeDirectionTypeLeft:
                    [self endSwipeDirectionTypeLeftPan:endPoint];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStatePossible:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
    }
}

- (void)handlerSwipeDirectionTypeLeftPan:(CGPoint)offset {
    
    CGFloat cutX  = self.contentView.centerX + offset.x;
    if ( cutX <= self.limitLeftCentX) {
        return;
    }
    self.contentView.centerX = cutX;
}

- (void)endSwipeDirectionTypeLeftPan:(CGPoint)offset {
    if (self.contentView.centerX > (self.limitLeftCentX * 1.35f)) {
        
        [self _reponseSwipeGesture];
        
    }else {
        
        [UIView animateWithDuration:.1f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.left = self.superViewController.view.width - self.withOrHeight;
        } completion:^(BOOL finished) {
        }];
    }
}



- (void)_reponseSwipeGesture {
    
    if (self.disabledCancelFunc) {
        SwipeViewLog(@" disabledCancelFunc is YES");
        return ;
    }
    
    // TODO: 事件回调
    if ([self.swipeProtocol respondsToSelector:@selector(responseTapBlankEvent:)]) {
        [self.swipeProtocol responseTapBlankEvent:self];
    }
    
    [self isShowOn:NO];
    
}

#pragma mark - Action
- (void)_doTapBlankAction:(id)sender {
    [self _reponseSwipeGesture];
}

- (void)initSubviews {
    [super initSubviews];
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 测试背景颜色
    self.contentView.backgroundColor = UIColorWhite;
    self.blankButton.backgroundColor = UIColor.clearColor;
    
    self.view.backgroundColor = [UIColor.darkTextColor colorWithAlphaComponent:.3f];
    
    self.superViewController =  self.superViewController ? self.superViewController : QMUIHelper.visibleViewController.navigationController;
    
    // 建立 父子ViewController
    [self.superViewController addChildViewController:self];
    [self.superViewController.view addSubview:self.view];
    
    // 初始化 ContentView 相关参数
    [self _resetPositionWithType:self.swipeDirectionType showOn:NO animation:NO];
    
    
    
    // Do any additional setup after loading the view.
}


#pragma make --- lazy laod
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (QMUIButton *)blankButton {
    if (!_blankButton) {
        _blankButton = [QMUIButton buttonWithType:(UIButtonTypeCustom)];
        [self.view addSubview:_blankButton];
        [_blankButton addTarget:self action:@selector(_doTapBlankAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_blankButton target:self action:@selector(_doTapBlankAction:)];
    }
    return _blankButton;
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
