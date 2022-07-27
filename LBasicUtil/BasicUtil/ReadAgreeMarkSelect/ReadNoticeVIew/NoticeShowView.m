//
//  NoticeShowView.m
//  Mask-IOS
//
//  Created by LN on 2021/8/13.
//

#import "NoticeShowView.h"

@interface NoticeShowView()
@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) UIImageView *container;
//@property(nonatomic, strong) UILabel *headerLabel;
@property(nonatomic, strong) UITextView *contentTextView;

@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, strong) UIButton *ensureBtn;

@end

@implementation NoticeShowView
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         self.backgroundColor = [UIColor whiteColor];
         [self initView];
         [self show];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title{
     self = [self init];
     self.title = title;
     return self;
}

- (void)setTitle:(NSString *)title{
     _title = title;
     self.tipsLabel.text = [NSString stringWithFormat:@"请完整阅读%@",title];
}

- (UIImageView *)container{
    if (_container == nil) {
        _container = [[UIImageView alloc]    initWithFrame:CGRectMake(20, 100, self.width-40, self.height-200)];
        _container.userInteractionEnabled = YES;
        _container.backgroundColor = [UIColor whiteColor];
        _container.layer.cornerRadius = 20;
        _container.layer.borderWidth = 1;
        _container.layer.borderColor = [UIColor blueColor].CGColor;
        _container.layer.masksToBounds = YES;
    }
    return _container;
}

//- (UILabel *)headerLabel{
//    if (_headerLabel == nil) {
//        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.container.width, 35)];
//         _headerLabel.textAlignment = NSTextAlignmentCenter;
//         _headerLabel.font = [UIFont systemFontOfSize:20];
//         _headerLabel.textColor =  [UIColor blueColor];
//    }
//    return _headerLabel;
//}

- (UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.container.width-40, self.container.height-140)];
         [_contentTextView setEditable:NO];
         _contentTextView.backgroundColor = [UIColor clearColor];
         _contentTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
         _contentTextView.font = [UIFont systemFontOfSize:15];
         _contentTextView.textColor = [UIColor grayColor];
    }
    return _contentTextView;
}

- (UILabel *)tipsLabel{
    if (_tipsLabel == nil) {
         _tipsLabel = [[UILabel alloc] init];
         _tipsLabel.text = @"请完整阅读注意事项";
         _tipsLabel.textAlignment = NSTextAlignmentCenter;
         _tipsLabel.font = [UIFont systemFontOfSize:10];
         _tipsLabel.textColor =  [UIColor blueColor];
         [_tipsLabel sizeToFit];
    }
    return _tipsLabel;
}

- (UIButton *)ensureBtn{
    if (_ensureBtn == nil) {
         _ensureBtn = [[UIButton alloc] init];
         
         _ensureBtn.frame = CGRectMake(20, self.container.height-50-20, self.container.width-40 , 50);
        [_ensureBtn setBackgroundColor:[UIColor blueColor]];
         _ensureBtn.titleLabel.text = @"";
         [_ensureBtn setTitle:@"我已阅读并熟知" forState:UIControlStateNormal];
         [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         _ensureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
         [_ensureBtn addTarget:self action:@selector(ensureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}
- (void)initView{
     [self addSubview:self.container];
//     [self.container addSubview:self.headerLabel];
     [self.container addSubview:self.contentTextView];
     [self.container addSubview:self.ensureBtn];
     [self.container addSubview:self.tipsLabel];
     self.tipsLabel.centerX = self.ensureBtn.centerX;
     self.tipsLabel.bottom = self.ensureBtn.y-10;
    
}

- (void)ensureBtnClick{
     [self close];
     if (self.ensureBlock) {
          self.ensureBlock(YES);
     }
}

- (void)show{
     UIViewController *curVc = [UIViewController getCurVc];
     [curVc.view addSubview:self];
     [UIViewController popGestureClose:curVc];
}

- (void)close{
     [self removeFromSuperview];
     [UIViewController popGestureOpen:[UIViewController getCurVc]];
}



- (void)updateContentWithSourceHtmlPath:(NSString *)path{
     NSData *fileData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
     
     NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:fileData options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
     _contentTextView.attributedText = attributedString;
     
}
@end
