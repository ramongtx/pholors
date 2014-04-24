//
//  GalleryViewController.m
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import "CameraVC.h"

@interface CameraVC ()

@end

@implementation CameraVC

@synthesize galleryDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        NSLog(@"No camera");
}

- (void)launchBrowser
{
    if (!galleryDelegate)
        NSLog(@"galleryDelegate not yet set!");

    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;

    // no camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    else
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    picker.showsCameraControls = YES;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    view.backgroundColor = [UIColor redColor];
    //picker.cameraOverlayView = view;
    
    picker.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    picker.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    picker.navigationBar.tintColor = [UIColor redColor];


    
    
    [self presentViewController:picker
                       animated:YES
                     completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage* originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage* chosenImage = info[UIImagePickerControllerEditedImage];

    [picker dismissViewControllerAnimated:YES
                               completion:NULL];

    [self.galleryDelegate didFinishLoadingImage:chosenImage
                                       original:originalImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{

    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

@end
