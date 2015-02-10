//
//  SGGNode.h
//  SimpleGLKitGame
//
//  Created by Ray Wenderlich on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Node : NSObject

@property GLKMatrix4 rotationMatrix;

@property (assign) GLKVector3 position;
@property (assign) CGSize contentSize;
@property (assign) GLKVector3 moveVelocity;
@property (retain) NSMutableArray * children;

@property (assign) float xRotationVelocity;
@property (assign) float yRotationVelocity;
@property (assign) float zRotationVelocity;

@property (assign) float xRotation;
@property (assign) float yRotation;
@property (assign) float zRotation;

@property (assign) float scale;
@property (assign) float rotationVelocity;
@property (assign) float scaleVelocity;

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix; 
- (void)update:(float)dt;
- (GLKMatrix4) modelMatrix:(BOOL)renderingSelf;
- (CGRect)boundingBox;
- (void)addChild:(Node *)child;
//**
- (void)handleTap:(CGPoint)touchLocation;
//**

@end
