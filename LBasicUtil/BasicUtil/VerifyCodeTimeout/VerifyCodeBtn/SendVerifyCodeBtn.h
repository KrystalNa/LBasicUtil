//
//  SendVerifyCodeBtn.h
//  Mask-IOS
//
//  Created by LN on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SendVerifyCode)(void);
@interface SendVerifyCodeBtn : UIView
@property(nonatomic, assign) BOOL isEnabled;
@property(nonatomic, copy) SendVerifyCode sendCodeBlock;
@end

NS_ASSUME_NONNULL_END
