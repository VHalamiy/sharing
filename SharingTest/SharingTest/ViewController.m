//
//  ViewController.m
//  SharingTest
//
//  Created by Little Yoda on 26.12.15.
//  Copyright (c) 2015 Little Yoda. All rights reserved.
//

#import "ViewController.h"
#import "BranchUniversalObject.h"
#import "ImgurUploader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedShareBtn:(id)sender {
    
    BranchUniversalObject *branchUniversalObject =
    [[BranchUniversalObject alloc] initWithCanonicalIdentifier:@"1000"];
    [branchUniversalObject registerView];
    
    branchUniversalObject.title = @"Some test";
    branchUniversalObject.contentDescription =
    [NSString stringWithFormat:@"Lat: %f, Lon: %f", 53.21, 44.23];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *locationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(locationImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *stringPath = [documentsDirectory stringByAppendingPathComponent:@"locationImage.png"];
    [data writeToFile:stringPath atomically:YES];
    
    NSString *clientId = @"ead609445b92b0c";
    
    NSString *title = @"Some test";
    NSString *description = [NSString stringWithFormat:@"Lat: %f, Lon: %f", 53.21, 44.23];;
    
    [ImgurUploader uploadPhoto:data title:title description:description imgurClientId:clientId completionBlock:^(NSString *result) {
        
        branchUniversalObject.imageUrl = result;
        NSLog(@"%@", result);
        
    } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
        
        [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                    message:[NSString stringWithFormat:@"%@ (Status code %ld)",
                                             [error localizedDescription], (long)status]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        
    }];
    
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    
    linkProperties.feature = @"sharing";
    linkProperties.channel = @"default";
    [linkProperties addControlParam:@"$desktop_url"
                          withValue:@"http://hitchwiki.org/maps/?zoom=13&lat=52.788339264551105&lon=29.411055903688872"];
    [linkProperties addControlParam:@"$ios_url"
                          withValue:@"sharingtest://"];
    
    [branchUniversalObject
     getShortUrlWithLinkProperties:linkProperties
     andCallback:^(NSString *url, NSError *error) {
         if (!error) {
             NSLog(@"Success getting url: %@", url);
         }
     }];
    [branchUniversalObject showShareSheetWithLinkProperties:linkProperties
                                               andShareText:nil
                                         fromViewController:self
                                                andCallback:^{
                                                    NSLog(@"Finished presenting");
                                                }];
}

@end
