//
//  LCameraPhotoTake.m
//  LBasicUtil
//
//  Created by LN on 2022/2/14.
//

#import "LCameraPhotoTake.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LPhotoTileViewController.h"

@interface LCameraPhotoTake()<AVCapturePhotoCaptureDelegate>//AVCaptureFileOutputRecordingDelegate

@property(nonatomic, strong) UIButton *photoButton;

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property(nonatomic, strong) AVCaptureSession *session;

//预览图层
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//后置摄像头
@property(nonatomic, strong) AVCaptureDevice *backDevice;
//前置摄像头
@property(nonatomic, strong) AVCaptureDevice *frontDevice;

//当前设备,(前置/后置摄像头)
@property(nonatomic, strong) AVCaptureDevice *imageDevice;

//输入设备
@property(nonatomic, strong) AVCaptureDeviceInput *imageInput;

//照片输出流
@property(nonatomic, strong) AVCapturePhotoOutput *photoOutput;

@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic, strong) UIImageView *focusView;
@end

@implementation LCameraPhotoTake

- (void)viewDidLoad{
    [super viewDidLoad];
    [self customCamera];
    [self.view addSubview:self.photoButton];
}

- (UIButton *)photoButton{
    if (_photoButton == nil) {
        _photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height-100, 66, 66)];
        _photoButton.centerX = self.view.centerX;
        [_photoButton setImage:[UIImage imageNamed:@"Photo"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]){
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        } else if ([_session canSetSessionPreset:AVCaptureSessionPresetiFrame1280x720]) {
            _session.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//AVLayerVideoGravityResize;
        _previewLayer.frame = self.view.bounds;
        
    }
    return _previewLayer;
}


#pragma mark -
- (AVCaptureDevice *)backDevice {
    if (!_backDevice) {
        _backDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    }
    return _backDevice;
}

- (AVCaptureDevice *)frontDevice {
    if (!_frontDevice) {
        _frontDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    }
    return _frontDevice;
}
- (void)setImageDevice:(AVCaptureDevice *)imageDevice {
    _imageDevice = imageDevice;
    
    [self.session beginConfiguration];
    for (AVCaptureDeviceInput *input in self.session.inputs) {
        if (input.device.deviceType == AVCaptureDeviceTypeBuiltInWideAngleCamera) {
            [self.session removeInput:input];
        }
    }
    NSError *error;
    AVCaptureDeviceInput *imageInput = [AVCaptureDeviceInput deviceInputWithDevice:_imageDevice error:&error];
    self.imageInput = imageInput;
    
    if (error) {
        NSLog(@"photoInput init error: %@", error);
    } else {//设置输入
        if ([self.session canAddInput:imageInput]) {
            [self.session addInput:imageInput];
        }
    }
    [self.session commitConfiguration];
}


#pragma mark -
- (void)customCamera {
    [self addFocusGesture];
    
    self.imageDevice = self.backDevice;

    AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.session canAddOutput:photoOutput]) {
        [self.session addOutput:photoOutput];
    }
    self.photoOutput = photoOutput;
    
//    [self.photoOutput.connections.lastObject setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
//    //注意添加区域改变捕获通知必须首先设置设备允许捕获
//    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
//        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
//    }];
    
    //自动对象,苹果提供了对应的通知api接口,可以直接添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.imageDevice];
    
    [self.session startRunning];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.layer addSublayer:self.previewLayer];
    });

}

////通过给屏幕上的view添加手势,获取手势的坐标.将坐标用setFocusPointOfInterest方法赋值给device
//- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
//    AVCaptureDevice *captureDevice= [self.input device];
//    NSError *error;
//    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
//    if ([captureDevice lockForConfiguration:&error]) {
//        propertyChange(captureDevice);
//        [captureDevice unlockForConfiguration];
//    }else{
//        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
//    }
//}

#pragma mark - 手动对焦
- (void)addFocusGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [self.view addGestureRecognizer:tap];
    
    self.focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.focusView.image = [UIImage imageNamed:@"P_focus"];
    [self.previewLayer addSublayer:self.focusView.layer];
    [self setFocusCursorWithPoint:self.view.center];
}

- (void)tapToFocus:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
        [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.imageDevice lockForConfiguration:&error]) {
        if ([self.imageDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.imageDevice setFocusPointOfInterest:focusPoint];
            [self.imageDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.imageDevice unlockForConfiguration];
    }
    [self setFocusCursorWithPoint:point];
}

#pragma mark - 自动对焦
- (void)subjectAreaDidChange:(NSNotification *)notification
{
    //先进行判断是否支持控制对焦
    if (self.imageDevice.isFocusPointOfInterestSupported &&[self.imageDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error =nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
        [self.imageDevice lockForConfiguration:&error];
        [self.imageDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        [self focusAtPoint:self.view.center];
        //操作完成后，记得进行unlock。
        [self.imageDevice unlockForConfiguration];
    }
}
-(void)setFocusCursorWithPoint:(CGPoint)point{
     //下面是手触碰屏幕后对焦的效果
    self.focusView.center = point;
    self.focusView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];
    
}

#pragma mark - 闪光灯控制
- (void)changeFlashLight:(AVCaptureTorchMode)mode{
    [self.imageDevice lockForConfiguration:nil];
    self.imageDevice.torchMode = mode;//AVCaptureTorchModeOn;
    [self.imageDevice unlockForConfiguration];
}

#pragma mark - 点击拍照
- (void)takePhoto {

    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{
        AVVideoCodecKey: AVVideoCodecJPEG,
    }];
    settings.flashMode = self.photoButton.isSelected ? AVCaptureFlashModeOn : AVCaptureFlashModeOff;
    for (AVCaptureOutput *output in self.session.outputs) {
        if ([output isKindOfClass:[AVCapturePhotoOutput class]]) {
            AVCapturePhotoOutput *photoOutput = (AVCapturePhotoOutput *)output;
            [photoOutput capturePhotoWithSettings:settings delegate:self];
            break;
        }
    }
}

#pragma mark -
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {

    if (photoSampleBuffer) {
        [self.session stopRunning];
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        UIImage *image = [UIImage imageWithData:data];
        UIEdgeInsets insets = UIEdgeInsetsZero;
//        self.image = [UIImage clipCameraPicture:image toInsets:insets];
        //退出预览页面控制器/View
        
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    if (!error) {
        // 使用该方式获取图片，可能图片会存在旋转问题，在使用的时候调整图片即可
        NSData *data = [photo fileDataRepresentation];
        UIImage *image = [UIImage imageWithData:data];

        // 对，就是上面的image
        
        LPhotoTileViewController *vc = [[LPhotoTileViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.image = image;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark -

@end
