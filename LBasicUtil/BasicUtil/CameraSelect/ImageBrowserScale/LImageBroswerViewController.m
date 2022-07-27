//
//  LImageBroswerViewController.m
//  ArtPlatform
//
//  Created by LN on 2021/8/4.
//

#import "LImageBroswerViewController.h"

@interface LImageBroswerViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *mScroll;
@property (nonatomic, strong) UIImageView *imgInfo;

@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;//双击
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;//单击
@property (nonatomic,strong) UIImageView *moveImage;//拖拽时的展示image
@property (nonatomic,assign) BOOL doingPan;//正在拖拽
@property (nonatomic,assign) BOOL doingZoom;//正在缩放，此时不执行拖拽方法
@property (nonatomic,assign) CGFloat comProprotion;//拖拽进度
@property (nonatomic,assign) BOOL directionIsDown;//拖拽是不是正在向下，如果是，退回页面，否则，弹回

@end

#pragma mark - 向下拖拽相关的一些变量
//最多移动多少时，页面完全透明，图片达到最小状态
#define MAX_MOVE_OF_Y 250.0
//当移动达到MAX_MOVE_OF_Y时，图片缩小的比例
#define IMAGE_MIN_ZOOM 0.3
static CGFloat dragCoefficient = 0.0;//拖拽系数，手指移动距离和图片移动距离的系数，图片越高时它越大
static CGFloat panBeginX = 0.0;//向下拖拽手势开始时的X，在拖拽开始时赋值，拖拽结束且没有退回页面时置0
static CGFloat panBeginY = 0.0;//向下拖拽手势开始时的Y，在拖拽开始时赋值，拖拽结束且没有退回页面时置0
static CGFloat imageWidthBeforeDrag = 0.0;//向下拖拽开始时，图片的宽
static CGFloat imageHeightBeforeDrag = 0.0;//向下拖拽开始时，图片的高
static CGFloat imageCenterXBeforeDrag = 0.0;//向下拖拽开始时，图片的中心X
static CGFloat imageYBeforeDrag = 0.0;//向下拖拽开始时，图片的Y
static CGFloat scrollOffsetX = 0.0;//向下拖拽开始时，滚动控件的offsetX

@implementation LImageBroswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addGestureRecognizer:self.doubleTap];
    [self.view addGestureRecognizer:self.singleTap];
    
    
    [self.view addSubview:self.mScroll];
}

- (UIScrollView *)mScroll{
    if (_mScroll == nil) {
        _mScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mScroll.backgroundColor = [UIColor blackColor];
        _mScroll.delegate = self;
        _mScroll.showsVerticalScrollIndicator = NO;
        _mScroll.showsHorizontalScrollIndicator = NO;
        _mScroll.alwaysBounceVertical = YES;
        _mScroll.alwaysBounceHorizontal = YES;//这是为了左右滑时能够及时回调scrollViewDidScroll代理
        if (@available(iOS 11.0, *))//表示只在ios11以上的版本执行
        {
            _mScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        [_mScroll addSubview:self.imgInfo];
    
        _mScroll.contentSize = self.imgInfo.frame.size;
        
        _mScroll.minimumZoomScale = 1.0;//最小缩放比例
        _mScroll.maximumZoomScale = 3.0;//最大缩放比例
        _mScroll.zoomScale = 1.0f;//当前缩放比例
        _mScroll.contentOffset = CGPointZero;//当前偏移
        
        self.imgInfo.center = [self centerOfScrollViewContent:_mScroll];
    }
    return _mScroll;
}

- (UIImageView *)imgInfo{
    if (_imgInfo == nil) {
        _imgInfo = [[UIImageView alloc] init];
        _imgInfo.contentMode = UIViewContentModeScaleAspectFill;
        _imgInfo.backgroundColor = [UIColor whiteColor];
        _imgInfo.layer.masksToBounds = YES;
        //根据image宽高算imageview的宽高
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imgUrl]];
        CGSize imageSize = image.size;
        CGFloat imageViewWidth = self.view.frame.size.width;
        CGFloat imageViewHeight = imageSize.height / imageSize.width * imageViewWidth;//等于是按比例算出满宽时的高
        _imgInfo.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
        _imgInfo.image = image;
    }
    return _imgInfo;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap)
    {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap)
    {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];//系统会先判定是不是双击，如果不是，才会调单击的事件
        
    }
    return _singleTap;
}

#pragma mark - 事件响应

/** 双击 */
- (void)doDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (self.mScroll.zoomScale <= 1.0)
    {
        CGFloat scaleX = touchPoint.x + self.mScroll.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.mScroll.contentOffset.y;//需要放大的图片的Y点
        [self.mScroll zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    }
    else
    {
        [self.mScroll setZoomScale:1.0 animated:YES]; //还原
    }
}

/** 单击 */
- (void)doSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 通知代理开始或结束拖拽,不返回 */
- (void)noticeDelegateBeginOrEndDrag:(BOOL)isBegin
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(YYPhotoBrowserSubScrollViewDoDownDrag:view:needBack:imageFrame:)])
//    {
//        [self.delegate YYPhotoBrowserSubScrollViewDoDownDrag:isBegin view:self needBack:NO imageFrame:CGRectZero];
//    }
}


/** 计算imageview的center，核心方法之一 */
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;//x偏移
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;//y偏移
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
    
    return actualCenter;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgInfo;//返回需要缩放的控件
}

/** 缩放完成的回调 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imgInfo.center = [self centerOfScrollViewContent:scrollView];
    self.doingZoom = NO;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.doingZoom = YES;
}

@end
