//
//  ViewController.h
//  Load Gallery
//
//  Created by Ramon Carvalho Maciel on 10/22/13.
//  Copyright (c) 2013 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewController.h"
#import "GameLogic.h"

@interface ViewController : GalleryViewController <GalleryViewProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *color;

@end
