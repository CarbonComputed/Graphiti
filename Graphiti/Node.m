//
//  SGGNode.m
//  SimpleGLKitGame
//
//  Created by Ray Wenderlich on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Node.h"

@implementation Node
@synthesize position = _position;
@synthesize contentSize = _contentSize;
@synthesize moveVelocity = _moveVelocity;
@synthesize children = _children;
@synthesize scale = _scale;
@synthesize rotationVelocity = _rotationVelocity;
@synthesize scaleVelocity = _scaleVelocity;

- (id)init {
    if ((self = [super init])) {
        self.children = [NSMutableArray array];
        self.scale = 1;
        _rotationMatrix = GLKMatrix4Identity;
    }
    return self;
}

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix {
    GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:NO]);
    for (Node * node in self.children) {
        [node renderWithModelViewMatrix:childModelViewMatrix];
    }
}

- (void)update:(float)dt {
    
    for (Node * node in self.children) {
        [node update:dt];
    }
    
    GLKVector3 curMove = GLKVector3MultiplyScalar(self.moveVelocity, 1);
    self.position = GLKVector3Add(self.position, curMove);
    
    float curRotateX = self.xRotationVelocity * dt;
    self.xRotation = self.xRotation + curRotateX;
    
    float curRotateY = self.yRotationVelocity * dt;
    self.yRotation = self.yRotation + curRotateY;
    
    float curRotateZ = self.zRotationVelocity * dt;
    self.zRotation = self.zRotation + curRotateZ;
    
    float curScale = self.scaleVelocity * dt;
    self.scale = self.scale + curScale;
    
}

- (GLKMatrix4) modelMatrix:(BOOL)renderingSelf {
    
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y,self.position.z);
    
//    float radiansX = GLKMathDegreesToRadians(self.xRotation);
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansX, 1, 0, 0);
//    
//    float radiansY = GLKMathDegreesToRadians(self.yRotation);
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansY, 0, 1, 0);
//    
//    float radiansZ = GLKMathDegreesToRadians(self.zRotation);
//    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansZ, 0, 0, 1);
//    
//    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale);
//    
//    if (renderingSelf) {
//        modelMatrix = GLKMatrix4Translate(modelMatrix, -self.contentSize.width/2, -self.contentSize.height/2, 0);
//    }
    modelMatrix = GLKMatrix4Multiply(_rotationMatrix, modelMatrix);

    return modelMatrix;
    
}


- (CGRect)boundingBox {    
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    GLKMatrix4 modelMatrix = [self modelMatrix:YES];
    CGAffineTransform transform = CGAffineTransformMake(modelMatrix.m00, modelMatrix.m01, modelMatrix.m10, modelMatrix.m11, modelMatrix.m30, modelMatrix.m31);    
    return CGRectApplyAffineTransform(rect, transform);
}

- (void)addChild:(Node *)child {
    [self.children addObject:child];
}

//**
- (void)handleTap:(CGPoint)touchLocation {
    
}
//**

@end
