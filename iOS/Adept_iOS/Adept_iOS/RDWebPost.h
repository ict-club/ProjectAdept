//
//  RGWebPost.h
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIDataDetectors.h>
#import <UIKit/UIWebView.h>
#import <UIKit/UIKit.h>


@interface RDWebPost : NSObject
{

    NSString * device;
}
@property NSString* responseString;
@property (nonatomic, retain) NSURL *requestURL;
@property NSString* appName;


-(void)postToServerWithUserDictionary:(NSMutableDictionary*)fieldsDictionary completionHandler:(void (^)(BOOL success, NSMutableDictionary* mutableDictionary, NSError* error))completionHandler;


@end
