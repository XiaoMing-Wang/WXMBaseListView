//
//  WXMBaseListViewModel.m
//
//  Created by edz on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "WXMBaseListViewModel.h"
#import "WXMHttpRequestManager+Operation.h"

@interface WXMBaseListViewModel ()
@property (nonatomic, weak) UIViewController *viewcontroller;
@end

@implementation WXMBaseListViewModel

/** viewcontroller网络请求时显示弹窗 */
+ (instancetype)wxmListWithViewController:(UIViewController *)vc {
    WXMBaseListViewModel *nextwork = [[self alloc] init];
    nextwork.viewcontroller = vc;
    return nextwork;
}

- (instancetype)init {
    if (self = [super init]) {
        _lastPage = 1;
        _currentPage = 1;
        _refreType = WXMRefreshFree;
        _isRequest = NO;
        _existCache = NO;
        _dataSource = @[].mutableCopy;
        [self initCacheCommand];
        [self initRequestCommand];
    }
    return self;
}

/** 判断缓存 */
- (void)initCacheCommand {
    _cacheCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> subscriber) {
            self.existCache =  [self subclassCacheType];
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}
/** 网络请求 */
- (void)initRequestCommand {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> subscriber) {
           
            WXMMJRefreshType inpuType = [input integerValue];
            if (inpuType == WXMRefreshHeader) [self dropDown];
            if (inpuType == WXMRefreshFoot) [self dropUp];
            [self requestDataSourceWithBlock:^(WXRequestType resType) {
                [subscriber sendNext:@(resType)];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

#pragma mark 子类需要重写的方法
/** 判断缓存  */
- (WXMExistCacheType)subclassCacheType {
    return WXMExistCacheTypeNone;
}
/** 请求数据 */
- (void)requestDataSourceWithBlock:(void (^) (WXRequestType resType)) result {
//    [WXMHttpManager requestWithPath:@"" parameters:nil viewController:self.viewcontroller success:^(WXMNetworkRespose *resposeObj) {
//        
//        /** 成功 */
//        if (resposeObj.successful && result) {
//            result(WXRequestTypeSuccess);
//            [self requestDataSourceSuccess];
//        }
//        
//        /** 失败 */
//        if (!resposeObj.successful && result) {
//            result(WXRequestTypeErrorCode);
//            [self requestDataSourceFail];
//        }
//        
//    
//    } failure:^(WXMNetworkRespose *resposeObj) {
////        [self.dataSource addObject:@(1)];
////        [self.dataSource addObject:@(2)];
//        if (result) result(WXRequestTypeFail);
//        [self requestDataSourceFail];
//    }];
    
    [self requestDataSourceFail];
    result(WXRequestTypeSuccess);
}
/** 上下拉 */
- (void)dropDown {
    if (self.refreType == WXMRefreshHeader) return;
    self.refreType = WXMRefreshHeader;
    self.lastPage = self.currentPage = 1;
}
- (void)dropUp {
    if (self.refreType == WXMRefreshFoot || self.refreType == WXMRefreshHeader) return;
    self.refreType = WXMRefreshFoot;
    self.currentPage += 1;
}
/** 请求成功 */
- (void)requestDataSourceSuccess {
    if (self.refreType == WXMRefreshHeader || self.refreType == WXMRefreshFree)  {
        self.lastPage = self.currentPage = 1;
    } else {
        self.lastPage = self.currentPage;
    }
    self.refreType = WXMRefreshFree;
    self.isRequest = NO;
}
/** 请求失败 */
- (void)requestDataSourceFail {
    if (self.refreType == WXMRefreshHeader || self.refreType == WXMRefreshFree)  {
        self.lastPage = self.currentPage = 1;
    } else {
        self.currentPage = self.lastPage;
    }
    self.refreType = WXMRefreshFree;
    self.isRequest = NO;
}


@end
