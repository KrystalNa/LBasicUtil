//
//  ViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/8/30.
//

#import "ViewController.h"
#import "CameraPickViewController.h"
#import "LLoginViewController.h"
#import "LTimeTextClockViewController.h"
#import "LSLiderViewController.h"
#import "LReadAgreeMarkViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *table;
@end

@implementation ViewController

- (UITableView *)table{
    if (_table == nil) {
        UITableView *tab = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BasicUtilCell"];
        tab.tableFooterView = [UIView new];
        tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tab.delegate = self;
        tab.dataSource = self;
        _table = tab;
    }
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table];
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicUtilCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"相册选择功能";
            break;
        case 1:
            cell.textLabel.text = @"登录发送验证码倒计时";
            break;
        case 2:
            cell.textLabel.text = @"倒计时时钟00:00:00";
            break;
        case 3:
            cell.textLabel.text = @"半圆进度调节";
            break;
        case 4:
            cell.textLabel.text = @"注册登录阅读协议(仿腾讯课堂)";
            break;
        case 5:
            cell.textLabel.text = @"简单吐司弹框(白字半透明黑底)";
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            CameraPickViewController *vc = [[CameraPickViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            
            break;
        case 1:{
            LLoginViewController *vc = [[LLoginViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 2:{
            LTimeTextClockViewController *vc = [[LTimeTextClockViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 3:{
            LSLiderViewController *vc = [[LSLiderViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 4:{
            LReadAgreeMarkViewController *vc = [[LReadAgreeMarkViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 5:
            break;
        default:
            break;
    }
}
@end
