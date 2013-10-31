//
//  GalleryViewController.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

//Responsible for the gallery view, where the user can select a picture from
//the gallery or take a photo with the camera

//We do not garantee the camera feature is working, as we cannot test it

#import <UIKit/UIKit.h>

@protocol GalleryViewProtocol <NSObject>
@required
-(void) didFinishLoadingImage:(UIImage *)image original:(UIImage*)originalImage;

@end

@interface CameraVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) id <GalleryViewProtocol> galleryDelegate;

-(void) launchBrowser;

@end
