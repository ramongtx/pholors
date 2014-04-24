//
//  RBSharedFunctions.m
//  Pholors
//
//  Created by Felix Dumit on 10/30/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "RBSharedFunctions.h"
#import "RBGame.h"

@implementation RBSharedFunctions

+ (void)playSound:(NSString*)soundName withExtension:(NSString*)extension
{
    SystemSoundID sound1;
    NSURL* soundURL = [[NSBundle mainBundle] URLForResource:soundName
                                              withExtension:extension];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
    AudioServicesPlaySystemSound(sound1);
}

+ (void)shareItems:(NSArray*)items
         forSender:(UIViewController*)vc
    withCompletion:(void (^)(NSString* activityType, BOOL completed))completion
{

    /*
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
     
     SLComposeViewController* tweetSheet = [SLComposeViewController
     composeViewControllerForServiceType:SLServiceTypeTwitter];
     [tweetSheet setInitialText:text];
     
     [tweetSheet addImage:image];
     [tweetSheet addURL:url];
     
     tweetSheet.completionHandler = ^(SLComposeViewControllerResult result)
     {
     if (result == SLComposeViewControllerResultDone) {
     [RBGame increaseLevelPackCount];
     [RBSharedFunctions playSound:@"whistle"
     withExtension:@"mp3"];
     }
     NSLog(@"here");
     };
     
     [self presentViewController:tweetSheet
     animated:YES
     completion:nil];
     }
     */

    UIActivityViewController* controller =
        [[UIActivityViewController alloc]
            initWithActivityItems:items
            applicationActivities:nil];

    [controller setCompletionHandler:completion];
    controller.excludedActivityTypes = @[
        UIActivityTypePostToWeibo,
        //UIActivityTypeMessage,
        //UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        //UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        //UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop
        //UIActivityTypePostToFacebook,
        //UIActivityTypePostToTwitter
    ];

    [vc presentViewController:controller
                     animated:YES
                   completion:nil];
}

@end
