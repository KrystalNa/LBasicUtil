//
//  LReadAgreeMarkViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/9/7.
//

#import "LReadAgreeMarkViewController.h"
#import "NoticeSelectView.h"
#import "NoticeShowView.h"

@interface LReadAgreeMarkViewController ()
@property(nonatomic, strong) NoticeSelectView *noticeSelectView;
@end

@implementation LReadAgreeMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NoticeSelectView *noticeSelectView = [[NoticeSelectView alloc] initWithShowInView:self.view];
    noticeSelectView.y = 200;
    noticeSelectView.centerX = self.view.centerX;
    [self.view addSubview:noticeSelectView];
    _noticeSelectView = noticeSelectView;
}

@end
