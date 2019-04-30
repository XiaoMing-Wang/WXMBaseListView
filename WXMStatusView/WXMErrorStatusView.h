//
//  WXMStatusView.h
//  Demo2
//
//  Created by wq on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//
#define WXMMinH 60
#define WXMErrorSign 100200
#define WXMIMGSize CGSizeZero /* CGSizeMake(10, 10) CGSizeZero */
#define WXMSBackgroundColor [UIColor grayColor]
#define WXMSTextColor [UIColor blackColor]

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WXMErrorStatusType) {
    
    /** 正常 */
    WXMErrorStatusTypeNormal = 0,
    
    /** 无网络 */
    WXMErrorStatusTypeBadNetwork,
    
    /** 无记录 */
    WXMErrorStatusTypeNorecord,
    
    /** 请求失败 */
    WXMErrorStatusTypeRequestFail,
    
    /** 加载中 */
    WXMErrorStatusTypeRequestLoading,
    
};
@interface WXMErrorStatusView : UIControl
@property (nonatomic, assign) WXMErrorStatusType errorType;
@property (nonatomic, strong) UIImageView *erroeImgVC;
@property (nonatomic, strong) UILabel *errorMsg;
- (CGFloat)minHeight;
+ (WXMErrorStatusView *)errorsViewWithType:(WXMErrorStatusType)type;
@end
