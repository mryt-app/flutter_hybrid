//
//  FLHFlutterHybridViewController.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/9/13.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "FLHFlutterPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterHybridViewController : FlutterViewController <FLHFlutterPage>

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithEngine:(FlutterEngine*)engine
                       nibName:(NSString*)nibNameOrNil
                        bundle:(NSBundle*)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithProject:(FlutterDartProject*)projectOrNil
                        nibName:(NSString*)nibNameOrNil
                         bundle:(NSBundle*)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithRoute:(NSString *)route params:(nullable NSDictionary *)params NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
