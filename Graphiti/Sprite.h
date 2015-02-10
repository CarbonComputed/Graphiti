//
//  SGGSprite.h
//  SimpleGLKitGame
//
//  Created by Ray Wenderlich on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Node.h"

@interface Sprite : Node

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;
- (id)initWithUIImage:(UIImage *)image effect:(GLKBaseEffect *)effect;

@end
