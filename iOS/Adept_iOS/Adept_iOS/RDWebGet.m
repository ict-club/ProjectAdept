//
//  RDWebGet.m
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "RDWebGet.h"

@interface RDWebGet ()

@end

@implementation RDWebGet

+ (void) executeGet // for test. Currenly working
{
    NSURL * url = [NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/userData_calories_select"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    request.allHTTPHeaderFields = @{@"parameters" : @"[{\"UserId\":1}]"};
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSArray * array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"%@", array);
        
    }];
    
    [downloadTask resume];
}

+ (void) executeGetRequestWithURL: (NSURL *) url andHeaders:(NSDictionary *) headers andWriteDataTo: (NSArray *) array onCompletePostNotificationWithName: (NSString *) nofitficationName
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    request.allHTTPHeaderFields = headers;
    
    __block NSArray * responseArray = [[NSArray alloc] init];
    
    array = responseArray;
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        responseArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingMutableContainers error: &error];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:nofitficationName object:responseArray];
        
    }];
    
    [downloadTask resume];
    
    
}
@end