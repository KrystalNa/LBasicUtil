//
//  LProgressHUD.m
//  SSExam
//
//  Created by LN on 2020/6/4.
//  Copyright © 2020 SS. All rights reserved.
//

#import "LProgressHUD.h"
#import "SVProgressHUD.h"

@implementation LProgressHUD

+ (void)initHUD{

    [SVProgressHUD setBackgroundColor:[UIColor.blackColor colorWithAlphaComponent:0.7]];
    [SVProgressHUD setForegroundColor:UIColor.whiteColor];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}

+ (void)showWithText:(NSString *)text duration:(NSTimeInterval)duration{
    [SVProgressHUD dismiss];
    
    [self initHUD];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
//    [SVProgressHUD showInfoWithStatus:text];///根据text长度自动计算隐藏时间
    
    [SVProgressHUD showWithStatus:text];///需要手动dismiss
    
    if (duration>=0) {
        [SVProgressHUD dismissWithDelay:duration];
    }
}

+ (void)showWithText:(NSString *)text{
    [self showWithText:text duration:-1];
}

+ (void)show{
    [SVProgressHUD dismiss];
    
    [self initHUD];
    [SVProgressHUD show];
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

+ (void)showNoTouch{
    [SVProgressHUD dismiss];
    
    [self initHUD];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
}


@end
