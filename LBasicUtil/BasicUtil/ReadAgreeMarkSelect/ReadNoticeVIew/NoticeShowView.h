//
//  NoticeShowView.h
//  Mask-IOS
//
//  Created by LN on 2021/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EnsureBlock)(BOOL isEnsure);
@interface NoticeShowView : UIView
- (instancetype)initWithTitle:(NSString *)title;
@property(nonatomic, copy) EnsureBlock ensureBlock;
- (void)updateContentWithSourceHtmlPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
