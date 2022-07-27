//
//  LBasicSlider.m
//  LBasicUtil
//
//  Created by LN on 2021/9/7.
//

#import "LBasicSlider.h"

@implementation LBasicSlider
/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        //这里无论高度设为多少，都按其自己的默认高度显示
//           UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 100)];
           //这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1；
//        self.value =  0;
//           //设置滑块最小边界值（默认为0）
//        self.minimumValue =0;
//           // 设置滑块最大边界值（默认为1）
//        self.maximumValue = 1;
//        [self addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
           // 设置滑块最左端显示的图片
//        self.minimumValueImage = [UIImage imageNamed:@"3"];
//           // 设置滑块最右端显示的图片
//        self.maximumValueImage = [UIImage imageNamed:@"1"];
           // 设置滑块值是否连续变化(默认为YES) 这个属性设置为YES则在滑动时，其value就会随时变化，设置为NO，则当滑动结束时，value才会改变。
//        self.continuous = YES;
//           //设置滑块左边（小于部分）线条的颜色
//        self.minimumTrackTintColor = [UIColor whiteColor];
//           //设置滑块右边（大于部分）线条的颜色
//        self.maximumTrackTintColor = [UIColor cyanColor];
           //设置滑块颜色（影响已划过一端的颜色）  注意这个属性：如果你没有设置滑块的图片，那个这个属性将只会改变已划过一段线条的颜色，不会改变滑块的颜色，如果你设置了滑块的图片，又设置了这个属性，那么滑块的图片将不显示，滑块的颜色会改变（IOS7）
          // slider.thumbTintColor = [UIColor blackColor];
           //设置滑块的图片：
//        [self setThumbImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
//        [self setThumbImage:[UIImage imageNamed:@"4"] forState:UIControlStateSelected];

    }
    return self;
}

//改变背景颜色
- (void)slider:(UISlider *)slider
{
    if ([slider isKindOfClass:[UISlider class]]) {
        UISlider * slider1= slider;
        CGFloat value = slider1.value;
        NSLog(@"%f", value);
    }
}*/
@end
