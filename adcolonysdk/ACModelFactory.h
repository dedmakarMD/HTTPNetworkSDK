//
//  ACModelFactory.h
//  adcolonysdk
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACModelFactory : NSObject

+ (NSArray *)postsWithJSONData:(NSData *)data errorRef:(NSError**)pError;

@end
