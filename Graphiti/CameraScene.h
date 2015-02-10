//
//  CameraScene.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/3/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//
#import "Sprite.h"
#import "Node.h"

@interface CameraScene : Node
- (id)initWithEffect:(GLKBaseEffect *)effect;

@property (assign) float xRotationVelocity;
@property (assign) float yRotationVelocity;
@property (assign) float zRotationVelocity;


@property (assign) float xRotation;
@property (assign) float yRotation;
@property (assign) float zRotation;

@property (strong) Sprite * sprite;


@end
