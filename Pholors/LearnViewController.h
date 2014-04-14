//
//  LearnViewController.h
//  Pholors
//
//  Created by Rafael Padilha on 14/04/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *rightColorView;
@property (weak, nonatomic) IBOutlet UIView *leftColorView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewPickSC;
@property (weak, nonatomic) IBOutlet UISlider *RSlider;
@property (weak, nonatomic) IBOutlet UISlider *GSlider;
@property (weak, nonatomic) IBOutlet UISlider *BSlider;
@property (weak, nonatomic) IBOutlet UILabel *RLabel;
@property (weak, nonatomic) IBOutlet UILabel *GLabel;
@property (weak, nonatomic) IBOutlet UILabel *BLabel;
@property (weak, nonatomic) IBOutlet UITextField *pointsTF;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
