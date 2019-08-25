//
//  FLHFirstPageInfo.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import "FLHFirstPageInfo.h"

@interface FLHFirstPageInfo ()

@property (nonatomic, copy) NSString *route;
@property (nonatomic, strong, nullable) NSDictionary *params;
@property (nonatomic, copy) NSString *uniqueID;
@property (nonatomic, assign, getter=hasInitialized) BOOL initialized;

@end

@implementation FLHFirstPageInfo

DEF_SINGLETON(FLHFirstPageInfo)

- (void)initializeWithRoute:(NSString *)route params:(NSDictionary *)params uniqueID:(NSString *)uniqueID {
    guard(!_initialized) else { return; }
    
    _initialized = YES;
    _route = [route copy];
    _params = params;
    _uniqueID = [uniqueID copy];
}

@end
