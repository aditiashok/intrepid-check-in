//
//  SlackRequestManager.m
//  intrepid-check-in
//
//  Created by Aditi Ashok on 6/17/15.
//  Copyright (c) 2015 Aditi Ashok. All rights reserved.
//

#import "SlackRequestManager.h"
#import <AFNetworking/AFNetworking.h>


@interface SlackRequestManager ()

@end

@implementation SlackRequestManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SlackRequestManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [SlackRequestManager new];
    });
    return sharedManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessage:(NSString *)message
                   :(NSString *) name
                 success:(void (^)(BOOL success))success
                 failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = [[NSDictionary alloc] init];
    
    if (name != nil) {
        params = @{@"text":message, @"username":name};
    }
    else {
       params = @{@"text":message, @"username":@"unidentified-user"};
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"https://hooks.slack.com/services/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"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(YES);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(error);
          }];
    

}

@end
