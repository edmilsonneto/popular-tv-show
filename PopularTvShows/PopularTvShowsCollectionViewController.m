//
//  PopularTvShowsCollectionViewController.m
//  PopularTvShows
//
//  Created by Edmilson Neto on 21/01/17.
//  Copyright © 2017 Edmilson Neto. All rights reserved.
//

#import "PopularTvShowsCollectionViewController.h"
#import "PopularTvShows.h"
#import "TvShow.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import "CustomActivityIndicatorView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <sys/utsname.h>

@interface PopularTvShowsCollectionViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

@implementation PopularTvShowsCollectionViewController {
    CustomActivityIndicatorView *act;
    NSMutableArray *listTvShow;
    TvShow *currentTvShow;
}

static NSString * const reuseIdentifier = @"ShowCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = @"Shows";
    
    [self GetPopularTvShows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return listTvShow.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if([Utils IsLessTheIphone6]) {
        return UIEdgeInsetsMake(35 , 35, 35, 35);
    }
    return UIEdgeInsetsMake(10 , 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSInteger index = (indexPath.section)+indexPath.row;
   
    currentTvShow = [listTvShow objectAtIndex:index];
    
    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    if(image == nil) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,105,160)];
        image.tag = 1;
        [cell addSubview:image];
    }
    [image setImageWithURL:[Utils GetImageURL:currentTvShow.poster_path] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    if(label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 128, 104, 100)];
        label.tag = 2;
        [cell addSubview:label];
    }
    label.text = currentTvShow.name;
    label.font = [UIFont fontWithName:@"Arial" size:13];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines=2;
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
}

- (void)GetPopularTvShows {
    if([Utils IsOnline]){
        act = [CustomActivityIndicatorView alloc];
        [self.navigationController.view addSubview:[act initWithView:self.navigationController.view size:70 style:UIActivityIndicatorViewStyleWhiteLarge]];
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[PopularTvShows class]];
        
        RKObjectMapping *tvShowMapping = [RKObjectMapping mappingForClass:[TvShow class]];
        [tvShowMapping addAttributeMappingsFromArray:@[@"name", @"poster_path"]];
        
        RKRelationshipMapping *tvShowRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"results" withMapping:tvShowMapping];
        [mapping addPropertyMappingsFromArray:[NSArray arrayWithObjects:tvShowRelationship, nil]];
        
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
        
        NSURL *url = [NSURL URLWithString:[Utils ServiceUrl]];
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
        [manager addResponseDescriptorsFromArray:@[ responseDescriptor ]];
        
        [manager postObject:nil path:[NSString stringWithFormat:@"/3/tv/popular?api_key=%@&language=en-US&page=1", [Utils ApiKey]] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            PopularTvShows *popularTvShows = [mappingResult array][0];
            listTvShow = popularTvShows.results;
            
            [self.collectionView reloadData];
            
            if(act != nil) {
                [act removeFromSuperview];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error.description);
            
            if(act != nil) {
                [act removeFromSuperview];
            }
            
            [self Alertar:@"Failed to get list of shows. Try again?"];
        }];
    } else {
        [self Alertar:@"No internet connection. Try again?"];
    }
}

- (void)Alertar:(NSString*)message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self GetPopularTvShows];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   exit(0);
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
