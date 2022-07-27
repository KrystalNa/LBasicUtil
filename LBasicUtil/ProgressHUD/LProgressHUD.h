//
//  LProgressHUD.h
//  SSExam
//
//  Created by LN on 2020/6/4.
//  Copyright © 2020 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LProgressHUD : NSObject

+ (void)showNoTouch;

+ (void)dismiss;

+ (void)show;

+ (void)showWithText:(NSString *)text;

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration;

+ (void)initHUD;

@end

NS_ASSUME_NONNULL_END
