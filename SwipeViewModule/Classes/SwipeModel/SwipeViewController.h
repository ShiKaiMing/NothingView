//
//  SwipeViewController.h
//  framework
//
//  Created by suger on 2018/11/14.
//  Copyright © 2018 Maimaimai Co.,Ltd. All rights reserved.
//

#import "QMUICommonViewController.h"
#import "AppLord.h"
#import "SwipeHeader.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SwipeProtocol<ALService>
// 显示delegate事件回调
- (void)willSpreadInWithProtocol:(id<SwipeProtocol>)protocol;
- (void)didSpreadInWithProtocol:(id<SwipeProtocol>)protocol;
// 隐藏
- (void)willSpreadOutWithProtocol:(id<SwipeProtocol>)protocol;
- (void)didSpreadOutWithProtocol:(id<SwipeProtocol>)protocol;


@optional

/**
 点击空白页面反馈
 */
- (void)responseTapBlankEvent:(id<SwipeProtocol>)protocol;
@end

@interface SwipeViewController : QMUICommonViewController<SwipeProtocol>

/**
 显示侧滑偏移量
 */
@property(nonatomic,assign,readonly) CGFloat withOrHeight;

/**
 存放 当前内容View
 */
@property(nonatomic, strong, readonly) UIView *contentView;


/**
 是否关闭“取消”功能 手势 和 点击 blankButton
 默认NO
 */
@property(nonatomic, assign) BOOL disabledCancelFunc;


/**
 默认存在手势YES
 */
@property(nonatomic, assign) BOOL gestureEnabled;
/**
关闭功能
 */
- (void)colse;
/**
 初始化方法

 @param SwipeDirectionType 测滑方向
 @param wh 显示部分宽度或者高度
 @return 返回 SwipeViewController 对象
 */
- (instancetype)initSwipeDirection:(SwipeDirectionType)SwipeDirectionType widthOrHeight:(CGFloat)wh;


/**
 滑动事件回调协议
 */
@property(nonatomic, weak) id<SwipeProtocol> swipeProtocol;
/*
 * 添加父级Viewcontroller
 * 默认是隐藏 并且如果没有添加到指定的View Controller 则默认添加到当前的NavigtaionController上
 * */
- (void)attachToViewController:(UIViewController *)viewController;
/**
 是否显示
 */
- (void)isShowOn:(BOOL)showOn;

@end

NS_ASSUME_NONNULL_END
