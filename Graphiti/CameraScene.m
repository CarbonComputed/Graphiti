//
//  CameraScene.m
//  Graphiti
//
//  Created by Kevin Carbone on 8/3/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "CameraScene.h"

@interface CameraScene ()
@property (strong) GLKBaseEffect * effect;


@end

@implementation CameraScene

- (id)initWithEffect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        self.effect = effect;
        //self.moveVelocity = GLKVector3Make(0,0,0);
        //self.xRotation = -45;
        //self.xRotationVelocity = 75;
        self.children = [NSMutableArray array];
        Sprite* _sprite2 = [[Sprite alloc] initWithFile:@"547436_10151516812888567_866005295_n.jpg" effect:self.effect];
        _sprite2.position = GLKVector3Make(0, 700,-350);
        _sprite2.xRotation = 90;
        _sprite2.rotationMatrix = self.rotationMatrix;

        [self.children addObject:_sprite2];

    }
    return self;
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
    
    GLKMatrix4 modelMatrix = self.rotationMatrix;
   modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y,self.position.z);
    
    float radiansX = GLKMathDegreesToRadians(self.xRotation);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansX, 1, 0, 0);
    
    float radiansY = GLKMathDegreesToRadians(self.yRotation);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansY, 0, 1, 0);

    float radiansZ = GLKMathDegreesToRadians(self.zRotation);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, radiansZ, 0, 0, 1);
    
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale);
    
    if (renderingSelf) {
        modelMatrix = GLKMatrix4Translate(modelMatrix, -self.contentSize.width/2, -self.contentSize.height/2, 0);
    }
    return modelMatrix;
    
}


@end
