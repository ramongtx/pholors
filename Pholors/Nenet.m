//
//  Nenet.m
//  Pholors
//
//  Created by Felix Dumit on 4/14/14.
//  Copyright (c) 2014 Rock Bottom. All rights reserved.
//

#import "Nenet.h"
#include "doublefann.c"

@implementation Nenet

+ (void)learn
{
    const unsigned int num_input = 6;
    const unsigned int num_output = 1;
    const unsigned int num_layers = 3;
    const unsigned int num_neurons_hidden = 10;
    const float desired_error = (const float)0.001;
    const unsigned int max_epochs = 500000;
    const unsigned int epochs_between_reports = 1000;

    struct fann* ann = fann_create_standard(num_layers, num_input,
                                            num_neurons_hidden, num_output);

    fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC);
    fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC);

    fann_train_on_file(ann, "train.csv", max_epochs,
                       epochs_between_reports, desired_error);

    fann_save(ann, "ne.net");

    fann_destroy(ann);
}

@end
