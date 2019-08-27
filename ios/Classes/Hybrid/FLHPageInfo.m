//
//  FLHPageInfo.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import "FLHPageInfo.h"

@implementation FLHPageInfo

- (instancetype)initWithRouteName:(NSString *)routeName params:(nullable NSDictionary *)params uniqueID:(NSString *)uniqueID {
    if (self = [super init]) {
        _routeName = [routeName copy];
        _params = params;
        _uniqueID = [uniqueID copy];
    }
    return self;
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *JSONInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    JSONInfo[@"routeName"] = self.routeName;
    JSONInfo[@"params"] = self.params;
    JSONInfo[@"uniqueID"] = self.uniqueID;
    return JSONInfo.copy;
}

@end
