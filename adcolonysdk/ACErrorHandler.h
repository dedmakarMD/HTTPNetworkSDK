//
//  ACErrorHandler.h
//  adcolonysdk
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ACErrorCode) {
    ACErrorCodeGeneral=0,
    ACErrorCodeHTTP=100,
    ACErrorCodeAuthorization=200,
};

@interface ACErrorHandler : NSObject
+ (NSError *)responseVerification:(NSURLResponse*)response withError:(NSError *)error;
@end
