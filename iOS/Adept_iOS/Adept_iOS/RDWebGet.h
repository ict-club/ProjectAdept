//
//  RDWebGet.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDWebGet : NSObject

/**
 *	@author Martin Kuvandzhiev, 16-04-24 01:04:31
 *
 *	@brief Use this method to execute get request to remote site
 *
 *	@param url								Destination site URL
 *	@param headers						Dictionary with get request headers
 *	@param array							array to save the data on receive
 *	@param nofitficationName	On complete will post notification with this name
 */
+ (void) executeGetRequestWithURL: (NSURL *) url andHeaders:(NSDictionary *) headers andWriteDataTo: (NSArray *) array onCompletePostNotificationWithName: (NSString *) nofitficationName;
@end
