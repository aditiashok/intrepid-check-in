//
//  SlackRequestManager.h
//  intrepid-check-in
//
//  Created by Aditi Ashok on 6/17/15.
//  Copyright (c) 2015 Aditi Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlackRequestManager : UIViewController

+ (instancetype)sharedManager;
- (void)sendMessage:(NSString *)message
            success:(void (^)(BOOL success))success
            failure:(void (^)(NSError *error))failure;
@end
