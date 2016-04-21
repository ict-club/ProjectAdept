//
//  RDWebGet.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDWebGet : NSObject

-(void)getFromServerWithUserId:(NSInteger)userId AndIsUserData:(BOOL)isUserData;

@end
