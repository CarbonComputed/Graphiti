//
//  DrawingViewController.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/13/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphitiProtocol.h"


@interface DrawingViewController : UIViewController

@property (nonatomic,weak) id<GraphitiProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage* currentImage;
@property (weak, nonatomic) IBOutlet UIImageView *test;

@end
