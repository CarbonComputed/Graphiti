//
//  GraphitiGLViewController.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/3/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "CameraScene.h"
#import "Node.h"

@interface GraphitiGLViewController : GLKViewController<GLKViewControllerDelegate, GLKViewDelegate>

@property (strong) GLKBaseEffect * effect;

-(id)initWithView:(GLKView*)view;
@property (strong) CameraScene * scene;

@property double currentRoll;
@property double currentPitch;
@property double currentYaw;


@end

