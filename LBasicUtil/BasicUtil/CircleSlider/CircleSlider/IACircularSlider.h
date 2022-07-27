//
//  IACircularSlider.h
//  CustomCircularSlider
//
//  Created by user on 01.01.17.
//  Copyright © 2017 I&N. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface IACircularSlider : UIControl

@property (assign, nonatomic, readonly) IBInspectable CGFloat value;
@property (assign, nonatomic) IBInspectable CGFloat minimumValue;//对应秒，默认0
@property (assign, nonatomic) IBInspectable CGFloat maximumValue;//对应秒
@property (assign, nonatomic) IBInspectable NSUInteger spaceValue;//拖动间隔秒

@property (assign, nonatomic) CGFloat radian;

@property (assign, nonatomic) IBInspectable CGFloat startAngle;
@property (assign, nonatomic) IBInspectable CGFloat endAngle;
@property (assign, nonatomic) IBInspectable BOOL clockwise;
@property (assign ,nonatomic) IBInspectable BOOL isCapRound;

@property (strong, nonatomic) IBInspectable UIColor* thumbTintColor;
@property (strong, nonatomic) IBInspectable UIColor* thumbHighlightedTintColor;
@property (strong, nonatomic) IBInspectable UIColor* trackTintColor;
@property (strong, nonatomic) IBInspectable UIColor* trackHighlightedTintColor;

@property (assign, nonatomic) IBInspectable CGFloat trackWidth;
@property (assign, nonatomic) IBInspectable CGFloat thumbWidth;

@property (strong, nonatomic, readonly) UIColor* trackHighlightedGradientFirstColor;
@property (strong, nonatomic, readonly) UIColor* trackHighlightedGradientSecondColor;
@property (assign, nonatomic, readonly) CGPoint trackHighlightedGradientColorsLocations;
@property (assign, nonatomic, readonly) BOOL isTrackHighlightedGradient;
@property (assign, nonatomic, readonly) CGPoint gradientStartPoint;
@property (assign, nonatomic, readonly) CGPoint gradientEndPoint;

@property(nonatomic, assign) BOOL isShowTimeout;

-(void)setGradientColorForHighlightedTrackWithFirstColor:(UIColor*)firstColor
                               secondColor:(UIColor*)secondColor
                                         colorsLocations:(CGPoint)locations
                                              startPoint:(CGPoint)startPoint
                                             andEndPoint:(CGPoint)endPoint;
-(void)removeGradient;

-(void)setThumbImage:(UIImage*)thumbImage;

/**
 * 更新进度
 * @params
 * value [minimumValue,maximumValue] 进度
 */
- (void)updateProgressWithValue:(CGFloat)value;
@end
