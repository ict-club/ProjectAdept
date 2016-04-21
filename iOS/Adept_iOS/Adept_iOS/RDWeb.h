//
//  RDWeb.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIDataDetectors.h>
#import <UIKit/UIWebView.h>
#import <UIKit/UIKit.h>


@interface RDWeb : NSObject
{
    
    NSString * device;
}
@property NSString* responseString;
@property (nonatomic, retain) NSURL *requestURL;
@property NSString* appName;


-(void)postToServerWithUserDictionary:(NSMutableDictionary*)fieldsDictionary completionHandler:(void (^)(BOOL success, NSMutableDictionary* mutableDictionary, NSError* error))completionHandler;


@end
