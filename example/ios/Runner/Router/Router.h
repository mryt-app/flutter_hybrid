//
//  Router.h
//  Runner
//
//  Created by JianFei Wang on 2019/8/28.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <flutter_hybrid/FLHRouter.h>

NS_ASSUME_NONNULL_BEGIN

@interface Router : NSObject <FLHRouter>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
