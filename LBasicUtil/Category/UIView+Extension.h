//
//  UIView+Extension.h
//  Mask-IOS
//
//  Created by LN on 2021/8/13.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

/** 从xib中创建一个控件 */
+ (instancetype)viewFromXib;
@end
