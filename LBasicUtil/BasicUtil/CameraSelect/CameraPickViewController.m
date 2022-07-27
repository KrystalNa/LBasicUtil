//
//  CameraPickViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/8/30.
//

#import "CameraPickViewController.h"
#import "LCamerPhotoSelect.h"
#import "NSDate+time.h"
#import "LImageBroswerViewController.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Extension.h"


@interface CameraPickViewController()<UICollectionViewDelegate, UICollectionViewDataSource>
/**< 选择拍照上传相关*/
@property (nonatomic, strong) UIImageView *tipCameraImgView;
@property (nonatomic,strong) UIButton *cameraPickerBtn;/**< 拍照上传*/

@property (nonatomic,strong) UIButton *cameraAddBtn;/**< 继续添加*/
@property (nonatomic,strong) UICollectionView *photoCollectionView;/**<上传图片view*/
@property (nonatomic,strong) NSArray *picArray;/**<图片集合*/
@property (nonatomic,strong) UIView *largeImageContent;
@property (nonatomic,strong) NSURL *curSelectImgUrl;/**<当前选中的图片的URL*/
@property(nonatomic, strong) LCamerPhotoSelect *picker;/**<上传相册/拍照*/
@property(nonatomic, assign) BOOL isShowError;
@property(nonatomic, strong) NSString *tipImagePath;
@property(nonatomic, strong) NSString *imgAnswerFileDir;
@end

@implementation CameraPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgAnswerFileDir = [self createImgListAnswerSrcPath:[NSString stringWithFormat:@"%@/Library/drawImg", NSHomeDirectory()]];
    [self setupUI];
//    [self loadDataAsyn];
}

- (void)setupUI{
    
    [self.view addSubview:self.tipCameraImgView];
    [self.view addSubview:self.cameraPickerBtn];
    [self.view addSubview:self.photoCollectionView];
    [self layoutContentView];
}
- (void)layoutContentView {

    [self.tipCameraImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.offset(20);
        make.height.mas_equalTo(200);
    }];

    [self.cameraPickerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(48);
            make.top.equalTo(self.tipCameraImgView.mas_bottom).offset(20);
    }];


    [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(CGRectGetWidth(self.photoCollectionView.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.photoCollectionView.frame));
        make.top.equalTo(self.tipCameraImgView.mas_bottom).offset(11);
    }];
    
}

- (void)loadDataAsyn{
    self.tipImagePath = [[NSBundle mainBundle] pathForResource:@"yuanshen.jpg" ofType:nil];
    __block NSString *cellStatus = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tipCameraImgView sd_setImageWithURL:[NSURL fileURLWithPath:self.tipImagePath] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            
            CGFloat realWidth = self.tipCameraImgView.width;
            
            CGFloat calHeight = height*realWidth/width;
            
            if (calHeight>self.view.height/2) {
                calHeight = self.view.height/2;
            }
            [self.tipCameraImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(calHeight);
            }];
            
        }];
        
        //获取绘画作答的本地图片路径
        NSArray *drawImgList = [self getDrawImgFilePathList];
        
        if (drawImgList.count>0) {
            [self cameraUIWithIsShow:YES isShowError:NO];
            
            self.picArray = drawImgList;
            
            //获取路径viewModel.drawImgPath下图片
            //刷新collectionView
            [self.photoCollectionView reloadData];
            
            cellStatus = @"1";
        }else{
            [self cameraUIWithIsShow:NO isShowError:NO];
            
            cellStatus = @"0";
        }
    });
    
    if (cellStatus) {
        //保存到本地，存储到数据库并更新状态，新加方法
//        [self.viewModel saveDrawImgWithStatus:cellStatus];
    }
}


#pragma mark - 选择拍照上传

- (UIImageView *)tipCameraImgView{
    if (!_tipCameraImgView) {
        _tipCameraImgView = [[UIImageView alloc] init];
        CGFloat realWidth = self.view.frame.size.width-100;
        _tipCameraImgView.width = realWidth;
        _tipCameraImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        _tipCameraImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDrawQuestionPic:)];
        [_tipCameraImgView addGestureRecognizer:tap];
    }

    return _tipCameraImgView;
}

- (void)tapDrawQuestionPic:(UITapGestureRecognizer *)gesture{
    
    //点击图片放大
    LImageBroswerViewController *vc = [[LImageBroswerViewController alloc] init];
    vc.modalPresentationStyle = 0;
    vc.imgUrl = [NSURL fileURLWithPath:self.tipImagePath];
    [self presentViewController:vc animated:NO completion:nil];
//    [self showLargeImage:[NSURL fileURLWithPath:self.viewModel.drawImgPath] isShowDel:NO];
}

- (UIButton *)cameraPickerBtn{
    if (!_cameraPickerBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"p_drawPhoto"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cameraPickerSelect) forControlEvents:UIControlEventTouchUpInside];
        _cameraPickerBtn = btn;
    }
    return _cameraPickerBtn;
}

- (UIButton *)cameraAddBtn{
    if (!_cameraAddBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"p_rePhoto"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cameraPickerSelect) forControlEvents:UIControlEventTouchUpInside];
        _cameraAddBtn = btn;

        _cameraAddBtn.hidden = YES;
    }
    return _cameraAddBtn;
}

- (LCamerPhotoSelect *)picker{
    if (!_picker) {
        LCamerPhotoSelect *picker = [[LCamerPhotoSelect alloc] init];
        _picker = picker;
    }
    return _picker;
}


- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        //144 108
        
        CGFloat realWidth = self.tipCameraImgView.width;
        CGFloat spaceX = 11;
        CGFloat cellWidth = (realWidth-spaceX*2)/3;
        CGFloat cellHeight = 108./144*cellWidth;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = spaceX;
        flowLayout.minimumLineSpacing = spaceX;
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        
        UICollectionView *col = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, realWidth, cellHeight) collectionViewLayout:flowLayout];
        col.delegate = self;
        col.dataSource = self;
        col.backgroundColor = [UIColor clearColor];
        [col registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
        _photoCollectionView = col;
        _photoCollectionView.hidden = YES;
    }
    return _photoCollectionView;
}

- (void)cameraPickerSelect{
  
    __weak __typeof(self)weakSelf = self;
    [self.picker selectAnswerFromPhoto:^(UIImage * _Nonnull img) {
        
        //存储到沙盒
        [UIImage saveImage:img withPath:[weakSelf.imgAnswerFileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSDate currentTimestamp]]]];
        //保存到本地，存储到数据库并更新状态，新加方法
//        [weakSelf.viewModel saveDrawImgWithStatus:@"1"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //添加img
            //更新UI
            [weakSelf cameraUIWithIsShow:YES isShowError:NO];

            weakSelf.picArray = [weakSelf getDrawImgFilePathList];
            [weakSelf.photoCollectionView reloadData];
        });
    } style:APCamerPhotoCancel];

}
 
- (void)cameraUIWithIsShow:(BOOL)isShow isShowError:(BOOL)isShowError{

    if (self.isShowError) {
        self.cameraPickerBtn.hidden = YES;

        self.photoCollectionView.hidden = NO;
    }else{
        self.cameraPickerBtn.hidden = isShow;

        self.photoCollectionView.hidden = !isShow;
    }
}
#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    for (UIView*view in cell.contentView.subviews) {
        if (view) {
            [view removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    
    if (self.picArray.count>0 && self.picArray.count<3 && indexPath.item == self.picArray.count) {//显示继续添加按钮
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 39)];
        image.contentMode = UIViewContentModeCenter;
        image.image = [UIImage imageNamed:@"p_addPhotoBtn"];
        
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.width.mas_equalTo(image.width);
            make.height.mas_equalTo(image.height);
        }];
    }else{
        
        NSString *url = self.picArray[indexPath.item];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.isShowError) {
                [image sd_setImageWithURL:[NSURL fileURLWithPath:url] placeholderImage:nil options:SDWebImageRetryFailed];
            }else{
                [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed];
            }
        });
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.picArray.count>0 && self.picArray.count<3 && indexPath.item == self.picArray.count){
        [self cameraPickerSelect];
    }else{
        NSString *url = self.picArray[indexPath.item];
        NSURL *fileUrl;
        if (!self.isShowError) {
            fileUrl = [NSURL fileURLWithPath:url];
        }else{
            fileUrl = [NSURL URLWithString:url];
        }
        [self showLargeImage:fileUrl isShowDel:!self.isShowError];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.isShowError) {
        if (self.picArray.count >= 3) {
            return self.picArray.count;
        }else if (self.picArray.count>0) {
            return self.picArray.count + 1;
        }else{
            return self.picArray.count;
        }
    }else{
        return self.picArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)showLargeImage:(NSURL *)imgURL isShowDel:(BOOL)isShowDel{
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    [self.view addSubview:contentView];
    self.largeImageContent = contentView;
    
    CGFloat imagW = contentView.width-38*2;
    CGFloat imagH = 108./144*imagW;
    
    UIImageView *drawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(38,contentView.height/4,imagW,imagH)];
    drawImageView.contentMode = UIViewContentModeScaleAspectFit;
    [drawImageView sd_setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageProgressiveLoad];
    [contentView addSubview:drawImageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(drawImageView.right-38,drawImageView.y-51,53,51);
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [closeButton setImage:[UIImage imageNamed:@"p_drawPhotoClose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    
    if (isShowDel) {
        self.curSelectImgUrl = imgURL;
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(drawImageView.x,drawImageView.bottom+21,drawImageView.width,50);
        
        [delBtn setBackgroundColor:UIColor.redColor];
        [delBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [delBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:delBtn];
    }
    
}

- (void)closeAction {
    [self.largeImageContent removeFromSuperview];
}
- (void)delAction{
    //删除沙盒中的文件名
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtURL:self.curSelectImgUrl error:nil];
    self.picArray = [self getDrawImgFilePathList];
    [self.photoCollectionView reloadData];
    [self closeAction];
    if (self.picArray.count==0) {
        [self cameraUIWithIsShow:NO isShowError:NO];
    }
}

#pragma mark - 单一题目多图片上传

- (NSArray *)getDrawImgFilePathList{
    
    return [self getSubFilePathsWithDir:self.imgAnswerFileDir];
}

- (NSArray *)getSubFilePathsWithDir:(NSString *)dirPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * dirArray = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    NSString * subPath = nil;
    
    NSMutableArray *subPathList = [[NSMutableArray alloc] init];
    for (NSString * str in dirArray) {
        subPath  = [dirPath stringByAppendingPathComponent:str];
        [subPathList addObject:subPath];
    }
    subPathList = [self sortArrayWithArray:subPathList];
    
    return subPathList;
}

- (NSString *)getFileNameWithFilePath:(NSString *)filePath{
    return [NSString stringWithFormat:@"%@_%@", [NSDate currentTimestamp],[filePath lastPathComponent]];
}

- (NSString *)createImgListAnswerSrcPath:(NSString *)filePath {
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return filePath;
}

- (NSMutableArray *)sortArrayWithArray:(NSMutableArray *)sortArr{
    int len = (int)sortArr.count;
    //按时间顺序排序，图片已按上传时间命名
    for (int i = 0; i<len-1; i++) {
        for (int j = 0; j<len-1-i; j++) {
            double time1 = [[[[sortArr[j] lastPathComponent] componentsSeparatedByString:@"_"] firstObject] doubleValue];
            double time2 = [[[[sortArr[j+1] lastPathComponent] componentsSeparatedByString:@"_"] firstObject] doubleValue];
            NSString *temp;
            if (time1>time2) {
                temp = sortArr[j];
                sortArr[j] = sortArr[j+1];
                sortArr[j+1] = temp;
            }
        }
    }
    return sortArr;
}
@end

