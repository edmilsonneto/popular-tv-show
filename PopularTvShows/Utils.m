//
//  Utils.m
//  PopularTvShows
//
//  Created by Edmilson Neto on 21/01/17.
//  Copyright © 2017 Edmilson Neto. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"
#import "TvShow.h"

@implementation Utils

+ (NSString*)ApiKey {
    return @"814a8e000a55aef7cd311f1390b1e97d";
}

+ (NSString*)ServiceUrl {
    return @"https://api.themoviedb.org";
}

+ (BOOL)IsOnline {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}

+ (NSURL*)GetImageURL:(NSString*)poster_path {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", poster_path]];
}

+ (BOOL)IsLessTheIphone6 {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if((screenHeight < 569) && (screenWidth < 321)) {
        return YES;
    }
    
    return NO;
}

@end
