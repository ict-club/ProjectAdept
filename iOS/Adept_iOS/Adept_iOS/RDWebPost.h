//
//  RGWebPost.h
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RDWebPost : NSObject


/**
 *	@author Martin Kuvandzhiev, 16-04-24 00:04:16
 *
 *	@brief Use this to post an async request to an interenet site
 *
 *	@param url							Destination URL
 *	@param data							Data that are posted in body
 *	@param notificationName	Name of the notification that will be posted to the default center when the request is complete
 */

+ (void) executePostRequestWithURL: (NSURL *) url andData:(NSData *) data onCompletePostNotificationWithName: (NSString *) notificationName;
@end
