//
//  GalleryViewController.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GalleryViewProtocol <NSObject>
@required
-(void) didFinishLoadingImage:(UIImage *)image original:(UIImage*)originalImage;

@end

@interface GalleryViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) id <GalleryViewProtocol> galleryDelegate;

-(void) launchBrowser;

@end
