//
//  FLHFirstPageInfo.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import <Foundation/Foundation.h>
#import "FLHBaseToolMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFirstPageInfo : NSObject

AS_SINGLETON(FLHFirstPageInfo)

@property (nonatomic, copy, readonly) NSString *route;
@property (nonatomic, strong, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly) NSString *uniqueID;
@property (nonatomic, assign, readonly, getter=hasInitialized) BOOL initialized;

- (void)initializeWithRoute:(NSString *)route params:(nullable NSDictionary *)params uniqueID:(NSString *)uniqueID;

@end

NS_ASSUME_NONNULL_END
