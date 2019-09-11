//
//  FLHPageInfo.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The native pages is corresponding to flutter pages.
 * `PageInfo` is the relationship.
 */
@interface FLHPageInfo : NSObject

@property (nonatomic, copy) NSString *routeName;
@property (nonatomic, strong, nullable) NSDictionary *params;
@property (nonatomic, copy) NSString *uniqueID;

- (instancetype)initWithRouteName:(NSString *)routeName params:(nullable NSDictionary *)params uniqueID:(NSString *)uniqueID;
- (NSDictionary *)toJSON;

@end

NS_ASSUME_NONNULL_END
