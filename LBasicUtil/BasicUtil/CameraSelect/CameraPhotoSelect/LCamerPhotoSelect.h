//
//  LCamerPhotoSelect.h
//  ArtPlatform
//
//  Created by LN on 2021/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    APCamerPhotoCamera,//仅拍照
    APCamerPhotoPhotoLibrary,//仅相册
    APCamerPhotoCancel,//拍照+相册+取消
} APCamerPhotoStyle;


typedef void(^GetImage)(UIImage *img);//传参类型及形参

@interface LCamerPhotoSelect : UIView
- (void)selectAnswerFromPhoto:(GetImage)getImage style:(APCamerPhotoStyle)style;
@end

NS_ASSUME_NONNULL_END
