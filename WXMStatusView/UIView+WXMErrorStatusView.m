//
//  UIView+WXMErrorStatusView.m
//  Demo2
//
//  Created by wq on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "UIView+WXMErrorStatusView.h"

@implementation UIView (WXMErrorStatusView)
- (void)showErrorStatusViewWithType:(WXMErrorStatusType)errorType {
    [self hidenErrorStatusView];
    if (errorType == WXMErrorStatusTypeNormal) return;
    WXMErrorStatusView *error = [WXMErrorStatusView errorsViewWithType:errorType];
    [self addSubview:error];
}
- (void)hidenErrorStatusView {
     [[self viewWithTag:WXMErrorSign] removeFromSuperview];
}
@end
@implementation UIViewController (WXMErrorStatusView)
- (void)showErrorStatusViewWithType:(WXMErrorStatusType)errorType {
    [self.view showErrorStatusViewWithType:errorType];
}
- (void)hidenErrorStatusView {
    [self.view hidenErrorStatusView];
}
@end
