//
//  Utils.h
//  PopularTvShows
//
//  Created by Edmilson Neto on 21/01/17.
//  Copyright © 2017 Edmilson Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (NSString*) ApiKey;
+ (NSString*) ServiceUrl;
+ (BOOL) IsOnline;
+ (NSURL*)GetImageURL:(NSString*)poster_path;
+ (BOOL)IsLessTheIphone6;

@end
