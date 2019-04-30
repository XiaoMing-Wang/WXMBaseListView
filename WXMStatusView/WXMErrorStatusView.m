//
//  WXMStatusView.m
//  Demo2
//
//  Created by wq on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height

#import "WXMErrorStatusView.h"

@implementation WXMErrorStatusView

+ (WXMErrorStatusView *)errorsViewWithType:(WXMErrorStatusType)type {
    WXMErrorStatusView *statusView = [WXMErrorStatusView new];
    statusView.errorType = type;
    statusView.tag = WXMErrorSign;
    [statusView setupInterface];
    return statusView;
}
- (void)setupInterface {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backgroundColor = WXMSBackgroundColor;
    
    UIImage *image = self.currentImage;
    CGFloat oldWidth = image.size.width;
    if (oldWidth > (KWidth - 120)) oldWidth = KWidth - 120;
    CGFloat imgHeight = (image.size.height / image.size.width) * oldWidth;
    
    /** 自定义图片大小 */
    if (CGSizeEqualToSize(WXMIMGSize, CGSizeZero) == NO) {
        oldWidth = WXMIMGSize.width;
        imgHeight = WXMIMGSize.height;
    }
    _erroeImgVC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,oldWidth, imgHeight)];
    _erroeImgVC.image = image;
    
    _errorMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _errorMsg.textAlignment = NSTextAlignmentCenter;
    _errorMsg.text = self.currentMessage;
    _errorMsg.font = [UIFont systemFontOfSize:14];
    _errorMsg.textColor = WXMSTextColor;
    _errorMsg.numberOfLines = 1;
    
    [self modifyCoordinate];
    [self addSubview:_erroeImgVC];
    [self addSubview:_errorMsg];
}

/** 更新frame */
- (void)modifyCoordinate {
    [_errorMsg sizeToFit];
    if (!self.superview) return;
    CGFloat selfWidth = self.superview.frame.size.width;
    CGFloat centX = selfWidth / 2;
    
    _erroeImgVC.center = CGPointMake(centX, _erroeImgVC.center.y);
    _errorMsg.center = CGPointMake(centX, _errorMsg.center.y);
    CGFloat superH = self.superview.frame.size.height;
    CGFloat minH = WXMMinH + _erroeImgVC.frame.size.height + _errorMsg.frame.size.height;
    CGFloat realH = MAX(minH, superH);
    CGFloat blank = realH - _erroeImgVC.frame.size.height - _errorMsg.frame.size.height;
    CGFloat top = (blank - 10) / 2.0 - (realH == superH ? (superH >= (KHeight - 64 ) ? 44 : 15) : 5);
    CGRect imgFrame = _erroeImgVC.frame;
    CGRect msgFrame = _errorMsg.frame;
    imgFrame.origin.y = top;
    msgFrame.origin.y = top + imgFrame.size.height;
    _erroeImgVC.frame = imgFrame;
    _errorMsg.frame = msgFrame;
    self.frame = CGRectMake(0, 0, selfWidth, realH);
}
/** 图片 */
- (UIImage *)currentImage {
    NSString * imageName = @"";
    switch (self.errorType) {
        case WXMErrorStatusTypeNormal:imageName = @""; break;
        case WXMErrorStatusTypeBadNetwork:imageName = @"ic_default4"; break;
        case WXMErrorStatusTypeNorecord: imageName = @"ic_default1";  break;
        case WXMErrorStatusTypeRequestFail: imageName = @"ic_default2";  break;
        default: break;
    }
    return [UIImage imageNamed:imageName] ?: nil;
}
/** 提示内容 */
- (NSString *)currentMessage {
    NSString * messsage = @"";
    switch (self.errorType) {
        case WXMErrorStatusTypeNormal:messsage = @""; break;
        case WXMErrorStatusTypeBadNetwork:messsage = @"网络异常"; break;
        case WXMErrorStatusTypeNorecord: messsage = @"暂无更多记录";  break;
        case WXMErrorStatusTypeRequestFail: messsage = @"数据加载失败"; break;
        default: break;
    }
    return messsage;
}
/** 设置类型 */
- (void)setErrorType:(WXMErrorStatusType)errorType {
    _errorType = errorType;
    _erroeImgVC.image = self.currentImage;
    _errorMsg.text = self.currentMessage;
    if (errorType == WXMErrorStatusTypeNormal) [self removeFromSuperview];
    [self modifyCoordinate];
}
- (CGFloat)minHeight {
    return WXMMinH + _erroeImgVC.frame.size.height + _errorMsg.frame.size.height;
}
- (void)didMoveToSuperview {
    if (self.superview) [self modifyCoordinate];
}
@end
