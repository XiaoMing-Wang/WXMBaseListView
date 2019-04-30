//
//  WXMBaseListViewModel.h
//
//  Created by edz on 2019/4/29.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXMMJDIYHeader.h"
#import <ReactiveObjC.h>

typedef NS_ENUM(NSUInteger, WXMExistCacheType) {
    WXMExistCacheTypeNone = 0,   /** 无缓存 */
    WXMExistCacheTypeExistCache, /** 有缓存 */
};

typedef NS_ENUM(NSUInteger, WXRequestType) {
    WXRequestTypeSuccess = 0, /** 状态码0 */
    WXRequestTypeErrorCode,   /** 请求成功但是状态码不为0 */
    WXRequestTypeFail = 2,    /** 请求异常 */
};

@interface WXMBaseListViewModel : NSObject

/** 页码 */
@property (nonatomic, assign) NSInteger lastPage;
@property (nonatomic, assign) NSInteger currentPage;

/** 状态 */
@property (nonatomic, assign) BOOL isRequest;               /** YES正在请求 */
@property (nonatomic, assign) WXMExistCacheType existCache; /** 是否存在缓存 */
@property (nonatomic, assign) WXMMJRefreshType refreType;   /** 上下拉状态 */

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** RAC */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;/* 请求 */
@property (nonatomic, strong, readonly) RACCommand *cacheCommand; /* 判断缓存 */

#pragma mark 函数
+ (instancetype)wxmListWithViewController:(UIViewController *)vc;

#pragma mark 子类需要重写
/** 有缓存把缓存赋值给dataSource 不重写默认无缓存 */
- (WXMExistCacheType)subclassCacheType;
- (void)requestDataSourceWithBlock:(void (^) (WXRequestType resType)) result;
@end
