//
//  WXMAloneListViewController.h
//  Demo2
//
//  Created by edz on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMBaseListViewController.h"
#import "WXMBaseListViewModel.h"

@interface WXMAloneListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

#pragma mark 属性

/** 异常显示默认 full*/
@property (nonatomic, assign) WXMShowErrorType showErrorType;

/** tableView */
@property (nonatomic, strong) UITableView *mainTableView;

/** 刷新控件 */
@property (nonatomic, strong) WXMMJDIYHeader *listHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *listFoot;

/** 页码 */
@property (nonatomic, assign) NSInteger lastPage;
@property (nonatomic, assign) NSInteger currentPage;

/** 状态 */
@property (nonatomic, assign) BOOL isRequest;               /** YES正在请求 */
@property (nonatomic, assign) WXMExistCacheType existCache; /** 是否存在缓存 */
@property (nonatomic, assign) WXMMJRefreshType refreType;   /** 上下拉状态 */

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

#pragma mark 函数
#pragma mark 需要重写
- (void)judgeListViewCache;      /** 判断是否有缓存子类需要重写 */
- (void)requestDataSourceSuccess;/** 请求成功 */

/** 刷新头部 */
- (void)refreshHeader;

/** 刷新尾部 */
- (void)refreshFoot;

/** 结束刷新 */
- (void)endRefreshLoading;

/** 请求失败 */
- (void)requestDataSourceFail;

/** 切换成分组模式 */
- (UITableView *)mainTableViewGrouped;

/** 缺省图 */
- (void)setDefaultInterface;

/** 请求数据源 子类重写 */
- (void)requestDataSource;
@end
