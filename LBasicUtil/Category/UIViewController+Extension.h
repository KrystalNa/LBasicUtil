//
//  UIViewController+Extension.h
//  LBasicUtil
//
//  Created by LN on 2021/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)
+ (void)popGestureOpen:(UIViewController *)VC;
+ (void)popGestureClose:(UIViewController *)VC;
+ (UIViewController *)getCurVc;
@end

NS_ASSUME_NONNULL_END
