//
//  MJDIYHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJRefresh.h"

/** 控件处于什么状态 */
typedef NS_ENUM(NSUInteger, WXMMJRefreshType) {
    WXMRefreshFree = 0,
    WXMRefreshHeader,
    WXMRefreshFoot,
};

@interface WXMMJDIYHeader : MJRefreshHeader

@end
