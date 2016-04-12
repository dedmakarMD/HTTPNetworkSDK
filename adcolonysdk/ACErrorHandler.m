//
//  ACErrorHandler.m
//  adcolonysdk
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import "ACErrorHandler.h"

#define kErrorDomain @"com.opera.error_handler"

@implementation ACErrorHandler

+ (NSError *)responseVerification:(NSURLResponse *)response withError:(NSError *)error
{
    NSError *newError = nil;
    
    if (error)
    {
        newError = error;
    }
    else if(((NSHTTPURLResponse*)response).statusCode != 200) {
        newError = [NSError errorWithDomain:kErrorDomain
                                       code:ACErrorCodeHTTP
                                   userInfo:@{NSLocalizedDescriptionKey: [ACErrorHandler stringForErrorCode:ACErrorCodeHTTP]}];
    }
    
    return newError;
}

+ (NSString *)stringForErrorCode:(ACErrorCode)errorCode
{
    NSString *message;
    
    switch (errorCode) {
        case ACErrorCodeHTTP:
            message = NSLocalizedString(@"Some problems on the server. Try again or contact with us.", nil);
            break;
            
        default:
            message = NSLocalizedString(@"General error message! Bla-bla-bla...", nil);
            break;
    }
                                        
    return message;
}
@end
