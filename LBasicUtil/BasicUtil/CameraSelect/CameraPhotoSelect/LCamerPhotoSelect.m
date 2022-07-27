//
//  LCamerPhotoSelect.m
//  ArtPlatform
//
//  Created by LN on 2021/1/13.
//

#import "LCamerPhotoSelect.h"
#import <AVFoundation/AVFoundation.h>
#import "LProgressHUD.h"
#import "AESelectController.h"
#import "UIImage+Extension.h"
#import "LCameraPhotoTake.h"

@interface LCamerPhotoSelect()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) GetImage getImage;/**< */
@end

@implementation LCamerPhotoSelect

/**
 * 从相册选择答题照片并上传
 */

- (void)selectAnswerFromPhoto:(GetImage)getImage style:(APCamerPhotoStyle)style{
    
    self.getImage = getImage;
    
    //当前控制器
    UIViewController *currentVc = [AESelectController getCurrentVC];
    
    if(style == APCamerPhotoCamera){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            [LProgressHUD showWithText:@"请您设置允许APP访问您的相机->设置->隐私->相机"];

        }else{

//            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//
//            imagePickerController.delegate=self;
//
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//            [currentVc presentViewController:imagePickerController animated:YES completion:nil];
            
            LCameraPhotoTake *vc = [[LCameraPhotoTake alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVc presentViewController:vc animated:YES completion:nil];

        }
    }else if(style == APCamerPhotoPhotoLibrary){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

        imagePickerController.delegate = self;

        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [currentVc presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];

        [alertVc addAction:[UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

            imagePickerController.delegate = self;

            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            [currentVc presentViewController:imagePickerController animated:YES completion:nil];
            
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
                [LProgressHUD showWithText:@"请您设置允许APP访问您的相机->设置->隐私->相机"];

            }else{
                LCameraPhotoTake *vc = [[LCameraPhotoTake alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [currentVc presentViewController:vc animated:YES completion:nil];
//                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//
//                imagePickerController.delegate=self;
//
//                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//                [currentVc presentViewController:imagePickerController animated:YES completion:nil];

            }

        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];


        [currentVc presentViewController:alertVc animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *newImage = [self fixOrientation:image];
    
    UIImage *newImage1 = [UIImage compressQualityWithImage:newImage maxLimit:800000];
    
    if (self.getImage) {
        self.getImage(newImage1);
    }
}

/**处理拍照图片保存后旋转问题*/
- (UIImage *)fixOrientation:(UIImage *)aImage {
  // No-op if the orientation is already correct
  if (aImage.imageOrientation ==UIImageOrientationUp)
    return aImage;
  // We need to calculate the proper transformation to make the image upright.
  // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
  CGAffineTransform transform =CGAffineTransformIdentity;
  switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    default:
      break;
  }
  switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    default:
      break;
  }
  // Now we draw the underlying CGImage into a new context, applying the transform
  // calculated above.
  CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                       CGImageGetBitsPerComponent(aImage.CGImage),0,
                       CGImageGetColorSpace(aImage.CGImage),
                       CGImageGetBitmapInfo(aImage.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      // Grr...
      CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
      break;
    default:
      CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
      break;
  }
  // And now we just create a new UIImage from the drawing context
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}
@end
