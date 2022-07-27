//
//  YYBasicTickView.m
//  YYDemo
//
//  Created by yy on 2017/7/27.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "YYBasicTickView.h"

@interface YYBasicTickView()

@property(nonatomic,strong)UIColor *backColor;

@property(nonatomic,strong)UIColor *tickColor;

@property(nonatomic, assign) BOOL isShowBorder;
@end

@implementation YYBasicTickView

- (instancetype)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)backColor tickColor:(UIColor *)tickColor isShowBorder:(BOOL)isShowBorder
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.backColor = backColor;
        self.tickColor = tickColor;
        self.isShowBorder = isShowBorder;
        self.isTick = NO;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)setIsTick:(BOOL)isTick
{
    _isTick = isTick;
    
    if (self.basicTickDelegate != nil && [self.basicTickDelegate respondsToSelector:@selector(basicTickViewValueChanged:)])
    {
        [self.basicTickDelegate basicTickViewValueChanged:self];
    }
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)setInsets:(CGFloat)insets{
    _insets = insets;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.isTick)
    {
        /** 填充背景 */
        CGPoint center = CGPointMake(rect.size.width*0.5,rect.size.height*0.5);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(rect.size.width*0.5 - rect.size.width*0.03-_insets) startAngle:0 endAngle:M_PI*2 clockwise:YES];
        //设置颜色
        [self.backColor set];
        // 填充：必须是一个完整的封闭路径,默认就会自动关闭路径
        [path fill];
        
        /** 绘制勾 */
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        path1.lineWidth = (rect.size.width-_insets*2)*0.09;
        // 设置起点
        [path1 moveToPoint:CGPointMake(_insets+(rect.size.width-2*_insets)*0.28, _insets+(rect.size.height-2*_insets)*0.47)];
        // 添加一根线到某个点
        [path1 addLineToPoint:CGPointMake(_insets+(rect.size.width-2*_insets)*0.43, _insets + (rect.size.height-2*_insets)*0.62)];
        [path1 addLineToPoint:CGPointMake(_insets+(rect.size.width-2*_insets)*0.72, _insets+(rect.size.height-2*_insets)*0.36)];
        //设置颜色
        [self.tickColor set];
        // 绘制路径
        [path1 stroke];
    }
    else
    {
        CGPoint center = CGPointMake(_insets+(rect.size.width-2*_insets)*0.5,_insets+(rect.size.height-2*_insets)*0.5);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(rect.size.width*0.5 - rect.size.width*0.03-_insets) startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [self.backColor set];
        [path stroke];
    }
    
    if (self.isShowBorder) {
        /** 填充边框 */
        CGPoint center = CGPointMake(rect.size.width*0.5,rect.size.height*0.5);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:(rect.size.width*0.5 - rect.size.width*0.03-_insets) startAngle:0 endAngle:M_PI*2 clockwise:YES];
        //设置颜色
        [self.tickColor setStroke];
        [path stroke];
    }
}

- (void)tapAction
{
    self.isTick = !self.isTick;
}


@end
