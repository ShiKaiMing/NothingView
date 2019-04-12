//
//  SwipeHeader.h
//  framework
//
//  Created by suger on 2018/11/22.
//  Copyright © 2018 Maimaimai Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kSwipeDirectionTypeKey;
UIKIT_EXTERN NSString *const kWithOrHeightKey ;

typedef NS_ENUM(NSInteger,SwipeDirectionType) {

//    UISwipeGestureRecognizerDirectionRight = 1 << 0,
//    UISwipeGestureRecognizerDirectionLeft  = 1 << 1,
//    UISwipeGestureRecognizerDirectionUp    = 1 << 2,
//    UISwipeGestureRecognizerDirectionDown  = 1 << 3
    SwipeDirectionTypeLeft = 1 << 0, //从右边到左边
    SwipeDirectionTypeRight = 1 << 1, // 从左边到右边
    
    SwipeDirectionTypeBottom = 1 << 2,// 从上到下，
    SwipeDirectionTypeTop = 1 << 3,// 从下到上
};


@interface SwipeHeader : NSObject

@end

NS_ASSUME_NONNULL_END
