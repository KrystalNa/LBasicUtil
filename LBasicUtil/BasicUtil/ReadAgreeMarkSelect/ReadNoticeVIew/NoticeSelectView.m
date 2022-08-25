//
//  NoticeSelectView.m
//  Mask-IOS
//
//  Created by LN on 2021/8/16.
//

#import "NoticeSelectView.h"
#import "NoticeShowView.h"
#import "YYBasicTickView.h"

@interface NoticeSelectView()<YYBasicTickViewDelegate>
@property(nonatomic, weak) UIView *showInView;
@property(nonatomic, strong) YYBasicTickView *tickView;
@property(nonatomic, strong) UIButton *tickBtn;

@end

@implementation NoticeSelectView

//- (UIButton *)tickBtn{
//    if (_tickBtn==nil) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
//        btn.centerY = self.height/2;
//        [btn setImage:[UIImage imageNamed:@"L_default"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"L_agree"] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(tickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setSelected:[self isAllTipsChoice]];
//        _tickBtn = btn;
//    }
//    return _tickBtn;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake((SCREEN_WIDTH-360)/2.0f, 0, 360, 50);
        [self initView];
    }
    return self;
}

- (instancetype)initWithShowInView:(UIView *)showInView{
    self = [self init];
    self.showInView = showInView;
    return self;
}

- (void)initView{
    
    CGFloat space = 5;
//    [self addSubview:self.tickBtn];
    YYBasicTickView *basicTick = [[YYBasicTickView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) backGroundColor:[UIColor blueColor] tickColor:[UIColor whiteColor] isShowBorder:YES borderColor:[UIColor blueColor]];
    basicTick.centerY = self.height/2;
    basicTick.isTick = [self isAllTipsChoice];
    basicTick.insets = 14;
    [self addSubview:basicTick];
    basicTick.basicTickDelegate = self;
    self.tickView = basicTick;

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(basicTick.right-9, 0, 0, self.height)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor grayColor];
    label.text = @"我已阅读并同意";
    label.width = [self getWidthWithText:label.text height:label.height font:label.font];
    [self addSubview:label];
    
    UIButton *noticeBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.right+space, 0, 50, self.height)];
    [noticeBtn setTitle:@"使用条款" forState:UIControlStateNormal];
    [noticeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    noticeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [noticeBtn addTarget:self action:@selector(useNoteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noticeBtn];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(noticeBtn.right+space, 0, 0, self.height)];
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label1.textColor = [UIColor grayColor];
    label1.text = @"和";
    label1.width = [self getWidthWithText:label1.text height:label1.height font:label1.font];
    [self addSubview:label1];
    
    UIButton *secretBtn = [[UIButton alloc] initWithFrame: CGRectMake(label1.right+space, 0, 50, self.height)];
    [secretBtn setTitle:@"隐私政策" forState:UIControlStateNormal];
    [secretBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    secretBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [secretBtn addTarget:self action:@selector(secretNoteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:secretBtn];
    
    self.width = secretBtn.right;
}

- (void)useNoteClick:(UIButton *)sender{
    NoticeShowView *view = [[NoticeShowView alloc] initWithTitle:sender.titleLabel.text];
//    [view updateContentWithSourceHtmlPath:[[NSBundle mainBundle] pathForResource:@"TermsAndCondition.html" ofType:nil]];
    __weak __typeof(self)weakSelf = self;
    view.ensureBlock = ^(BOOL isEnsure) {
        //设置选中
        [weakSelf updateIsReadNoteWithIsSecret:nil isUse:@1];
        [weakSelf updateTick];
    };
    [self.showInView addSubview:view];
}

- (void)secretNoteClick:(UIButton *)sender{
    NoticeShowView *view = [[NoticeShowView alloc] initWithTitle:sender.titleLabel.text];
//    [view updateContentWithSourceHtmlPath:[[NSBundle mainBundle] pathForResource:@"PrivacyAgreement.html" ofType:nil]];
    __weak __typeof(self)weakSelf = self;
    view.ensureBlock = ^(BOOL isEnsure) {
        //设置选中
        [weakSelf updateIsReadNoteWithIsSecret:@1 isUse:nil];
        [weakSelf updateTick];
        
    };
    [self.showInView addSubview:view];
}

- (void)updateTick{
    BOOL isAllTipsChoice = [self isAllTipsChoice];
    if (isAllTipsChoice) {
        self.tickView.isTick = YES;
        [self.tickBtn setSelected:YES];
    }
}

- (void)updateIsReadNoteWithIsSecret:(NSNumber *)isSecret isUse:(NSNumber *)isUse{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (isSecret!=nil) {
        [user setObject:isSecret forKey:@"secretNoteClick"];
        [user synchronize];
    }
    if (isUse!=nil) {
        [user setObject:isUse forKey:@"useNoteClick"];
        [user synchronize];
    }
}

- (BOOL)isAllTipsChoice{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isclickUseNote = [[user objectForKey:@"useNoteClick"] boolValue];
    BOOL isclickSecretNote = [[user objectForKey:@"secretNoteClick"] boolValue];
    
    if (isclickUseNote&&isclickSecretNote) {
        return YES;
    }else{
        return NO;
    }
}
- (void)basicTickViewValueChanged:(YYBasicTickView *)tickView{
    NSLog(@"Basic:%d",tickView.isTick);
    if (tickView.isTick) {
        [self updateIsReadNoteWithIsSecret:@1 isUse:@1];
    }else{
        [self updateIsReadNoteWithIsSecret:@0 isUse:@0];
    }
}

- (void)tickBtnClick:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        [self updateIsReadNoteWithIsSecret:@1 isUse:@1];
    }else{
        [self updateIsReadNoteWithIsSecret:@0 isUse:@0];
    }
}

/**
 *根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
 */
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return rect.size.width;
}


@end
