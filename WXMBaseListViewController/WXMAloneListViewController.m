//
//  WXMAloneListViewController.m
//  Demo2
//
//  Created by edz on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//
#define KWidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height
#define KIPHONE_X ((KHeight == 812.0f) ? YES : NO)
#define KBarHeight ((KIPHONE_X) ? 88.0f : 64.0f)
#import "WXMAloneListViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "UIView+WXMErrorStatusView.h"

@interface WXMAloneListViewController ()
@property (nonatomic, assign) BOOL isGrouped;
@end

@implementation WXMAloneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/** 判断是否有缓存 */
- (void)judgeListViewCache {
    if (self.dataSource.count == 0) {
        self.hideErrorProgressHUD = YES;
        self.mainTableView.mj_footer.hidden = YES;
        [self.mainTableView showErrorStatusViewWithType:WXMErrorStatusTypeNorecord];
    } else if (self.dataSource.count > 0) {
        self.mainTableView.mj_footer.hidden = NO;
        [self.mainTableView showErrorStatusViewWithType:WXMErrorStatusTypeNormal];
    }
}
/** 上下拉 */
- (void)refreshHeader {
    if (self.refreType == WXMRefreshHeader) return;
    self.mainTableView.scrollEnabled = NO;
    self.refreType = WXMRefreshHeader;
    self.lastPage = self.currentPage = 1;
    [self requestDataSource];
}
- (void)refreshFoot {
    if (self.refreType == WXMRefreshFoot) return;
    if (self.refreType == WXMRefreshHeader) {
        [self.mainTableView.mj_footer endRefreshing];
    } else {
        self.refreType = WXMRefreshFoot;
        self.currentPage += 1;
        [self requestDataSource];
    }
}
/** 请求数据源 子类重写 */
- (void)requestDataSource {
    
}

/** 请求成功 */
- (void)requestDataSourceSuccess {
    self.lastPage = self.currentPage;
    self.refreType = WXMRefreshFree;
    self.isRequest = NO;
}

/** 请求失败 */
- (void)requestDataSourceFail {
    self.currentPage = self.lastPage;
    self.refreType = WXMRefreshFree;
    self.isRequest = NO;
    [self setDefaultInterface];
}
/** 结束刷新 */
- (void)endRefreshLoading {
    [self.mainTableView.mj_header endRefreshing];
    [self.mainTableView.mj_footer endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideLoadingImage];
        self.mainTableView.mj_footer.hidden = (self.dataSource.count == 0);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mainTableView.scrollEnabled = YES;
    });
}

/** 缺省图 */
- (void)setDefaultInterface {
    
    /** 全屏 */
    if (self.showErrorType == WXMShowErrorType_full) {
        
        if (self.refreType == WXMRefreshFoot) {
            self.mainTableView.mj_footer.hidden = NO;
            [self.mainTableView showErrorStatusViewWithType:WXMErrorStatusTypeNormal];
        } else {
            WXMErrorStatusType types = WXMErrorStatusTypeNormal;
            if (self.dataSource.count == 0) types = WXMErrorStatusTypeNorecord;
            if (self.dataSource.count == 0) self.hideErrorProgressHUD = YES;
            [self.mainTableView showErrorStatusViewWithType:types];
            self.mainTableView.mj_footer.hidden = (self.dataSource.count == 0);
        }
        
        /** 半屏 */
    } else if (self.showErrorType == WXMShowErrorType_foot) {
        [self.mainTableView showErrorStatusViewWithType:WXMErrorStatusTypeNormal];
        if (self.refreType == WXMRefreshFoot) {
            self.mainTableView.mj_footer.hidden = NO;
        } else {
            if (self.dataSource.count == 0) {
                CGFloat tableH = self.mainTableView.tableHeaderView.frame.size.height;
                CGFloat footH = self.mainTableView.frame.size.height - tableH;
                WXMErrorStatusView *er = [WXMErrorStatusView errorsViewWithType:WXMErrorStatusTypeNorecord];
                CGFloat realH = MAX(footH, er.minHeight);
                UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, realH)];
                [footView addSubview:er];
                self.mainTableView.tableFooterView = footView;
            } else {
                self.mainTableView.tableFooterView = [UIView new];
            }
        }
    }
}

#pragma mark -------------------------------- tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isGrouped) return self.dataSource.count;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isGrouped) return 1;
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * iden = NSStringFromClass(self.class);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -------------------------------- lazy

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        NSString * iden = NSStringFromClass(self.class);
        CGFloat height = KHeight - KBarHeight;
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KBarHeight, KWidth, height)];
        _mainTableView.rowHeight = 65;
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_mainTableView registerClass:UITableViewCell.class forCellReuseIdentifier:iden];
    }
    return _mainTableView;
}

- (UITableView *)mainTableViewGrouped {
    NSString * iden = NSStringFromClass(self.class);
    CGFloat height = KHeight - KBarHeight;
    CGRect rect = CGRectMake(0, KBarHeight, KWidth, height);
    _isGrouped= YES;
    _mainTableView = nil;
    _mainTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _mainTableView.rowHeight = 65;
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [_mainTableView registerClass:UITableViewCell.class forCellReuseIdentifier:iden];
    return _mainTableView;
}

- (WXMMJDIYHeader *)listHeader {
    if (!_listHeader) {
        SEL sel = NSSelectorFromString(@"refreshHeader");
        _listHeader = [WXMMJDIYHeader headerWithRefreshingTarget:self refreshingAction:sel];
    }
    return _listHeader;
}
- (MJRefreshAutoNormalFooter *)listFoot {
    if (!_listFoot) {
        SEL sel = NSSelectorFromString(@"refreshFoot");
        _listFoot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:sel];
        _listFoot.hidden = YES;
    }
    return _listFoot;
}

@end
