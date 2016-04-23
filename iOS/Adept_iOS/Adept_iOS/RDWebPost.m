//
//  RGWebPost.m
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import "RDWebPost.h"

@implementation RDWebPost

- (void) postServerRequest
{
    NSURL * postUrl = [NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/userData_calories_insert"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:postUrl];
    request.HTTPMethod = @"POST";
    
    NSDictionary *postDictonary = @{@"UserId":@(1), @"CaloriesToBeBurned":@(1000), @"CaloriesBalance":@(800), @"Timestamp":@"2016-04-21T19:48:47.000Z"};
    
    NSError * error;
    NSArray * array = [NSArray arrayWithObject:postDictonary];
    
    NSData * postData = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];
    
    if(!error)
    {
        NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:postData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CaloriesDataAddedToDB" object:self];
        }];
        
        [uploadTask resume];
    }
}

+ (void) executePostRequestWithURL: (NSURL *) url andData:(NSData *) data onCompletePostNotificationWithName: (NSString *) notificationName
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }];
    
    [uploadTask resume];
    
}

@end