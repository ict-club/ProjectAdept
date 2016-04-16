//
//  RGWebPost.m
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import "RDWebPost.h"

@implementation RDWebPost

-(void)postToServerWithUserDictionary:(NSMutableDictionary*)fieldsDictionary completionHandler:(void (^)(BOOL success, NSMutableDictionary* mutableDictionary, NSError* error))completionHandler {
    
    NSURL * loginUrl = self.requestURL;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:loginUrl];
    NSMutableString *postStr = [[NSMutableString alloc] initWithString:@""];
        
    [fieldsDictionary setValue:self.appName forKey:@"app_name"];
    [fieldsDictionary setValue:device forKey:@"dp"];
    
    for(NSString *aKey in fieldsDictionary){
        if (![postStr isEqual:@""]) {
            [postStr appendFormat:@"&%@=%@",aKey,[fieldsDictionary objectForKey:aKey]];
        } else {
            [postStr appendFormat:@"%@=%@",aKey,[fieldsDictionary objectForKey:aKey]];
        }
    }
    NSData *postData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *userAgent = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:300];////////////////
    //        NSLog(@"AllHTTPHeaderFields: %@", request.allHTTPHeaderFields);
    
    //create the task
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
                                                                     [self logRespons:response data:data error:error];
                                                                     
                                                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                                     //                                                                     NSLog(@"httpResponse code: %@", [NSString stringWithFormat:@"%ld", (unsigned long)httpResponse.statusCode]);
                                                                     //                                                                     NSLog(@"httpResponse head: %@", httpResponse.allHeaderFields);
                                                                     
                                                                     if (error) {
                                                                         NSLog(@"Error in updateInfoFromServer: %@ %@", error, [error localizedDescription]);
                                                                         NSLog(@"Error code: %li", (long)error.code);
                                                                         completionHandler(NO, nil, error);
                                                                     }else{
                                                                         
                                                                         switch (httpResponse.statusCode) {
                                                                             case 200:/* Success */
                                                                             {
                                                                                 NSMutableDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                                                 //                                                                                 NSString* title = jsonData[@"title"];
                                                                                 //                                                                                 NSString* msg = jsonData[@"message"];
                                                                                 //                                                                                 NSString* redirectUrl = jsonData[@"redirect_url"];
                                                                                 
                                                                                 //BOOL success = [(NSNumber *) [jsonData objectForKey:@"success"] boolValue];
                                                                                 //NSLog(@"success = %ld",(long)success);
                                                                                 
                                                                                 completionHandler(YES, jsonData, error);
                                                                             }
                                                                                 break;
                                                                             default:
                                                                             {
                                                                                 completionHandler(NO, nil, error);
                                                                             }
                                                                                 break;
                                                                         }
                                                                     }
                                                                 }];
    [task resume];
}
#pragma mark - Debug Helpers
-(void)logRespons:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error{
    //#if DEVELOPMENT
    NSLog(@"Error in ResponseFromServer: %@ %@", error, [error localizedDescription]);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"httpResponse code: %@", [NSString stringWithFormat:@"%ld", (unsigned long)httpResponse.statusCode]);
    NSLog(@"httpResponse head: %@", httpResponse.allHeaderFields);
    
    NSDictionary* responseJSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Response ==> %@", responseJSONData);
    
    NSString *responseData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response String: ==> %@", responseData);
    self.responseString= responseData;
    //#endif
}
@end