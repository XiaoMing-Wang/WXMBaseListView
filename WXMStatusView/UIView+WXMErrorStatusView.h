//
//  UIView+WXMErrorStatusView.h
//  Demo2
//
//  Created by wq on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMErrorStatusView.h"

@interface UIView (WXMErrorStatusView)
- (void)showErrorStatusViewWithType:(WXMErrorStatusType)errorType;
- (void)hidenErrorStatusView;
@end

@interface UIViewController (WXMErrorStatusView)
- (void)showErrorStatusViewWithType:(WXMErrorStatusType)errorType;
- (void)hidenErrorStatusView;
@end
