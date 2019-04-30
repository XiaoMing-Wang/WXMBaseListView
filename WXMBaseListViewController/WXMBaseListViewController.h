//
//  WXMBaseListViewController.h
//
//  Created by edz on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXMMJDIYHeader.h"
#import "WXMBaseListViewModel.h"
@interface WXMBaseListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
typedef NS_ENUM(NSUInteger, WXMShowErrorType) {
    WXMShowErrorType_full = 0,
    WXMShowErrorType_foot,
};

#pragma mark 属性

/** 异常显示默认 full*/
@property (nonatomic, assign) WXMShowErrorType showErrorType;

/** tableView */
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) WXMBaseListViewModel *listViewModel;

/** 刷新控件 */
@property (nonatomic, strong) WXMMJDIYHeader *listHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *listFoot;

#pragma mark 函数

/** 初始化缓存回调并调用 */
- (void)rac_initializeCache;

/** 初始化请求回调不调用 调refreshHeader */
- (void)rac_initializeRequest;

/** 判断是否有缓存 */
- (void)judgeListViewCache;

/** 刷新头部 */
- (void)refreshHeader;

/** 刷新尾部 */
- (void)refreshFoot;

/** 结束刷新 */
- (void)endRefreshLoading;

/** 缺省图 */
- (void)setDefaultInterface;

/** 切换成分组模式 */
- (UITableView *)mainTableViewGrouped;
@end
