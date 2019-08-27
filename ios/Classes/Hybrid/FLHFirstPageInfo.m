//
//  FLHFirstPageInfo.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import "FLHFirstPageInfo.h"

@interface FLHFirstPageInfo ()

@property (nonatomic, strong) FLHPageInfo *firstPageInfo;

@end

@implementation FLHFirstPageInfo

DEF_SINGLETON(FLHFirstPageInfo)

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo {
    if (_firstPageInfo == nil) {
        _firstPageInfo = firstPageInfo;
    }
}

@end
