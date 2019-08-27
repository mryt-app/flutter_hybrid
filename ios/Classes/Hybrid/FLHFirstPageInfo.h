//
//  FLHFirstPageInfo.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import <Foundation/Foundation.h>
#import "FLHPageInfo.h"
#import "FLHBaseToolMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFirstPageInfo : NSObject

AS_SINGLETON(FLHFirstPageInfo)

@property (nonatomic, readonly) FLHPageInfo *firstPageInfo;

- (void)initializeFirstPageInfo:(FLHPageInfo *)firstPageInfo;

@end

NS_ASSUME_NONNULL_END
