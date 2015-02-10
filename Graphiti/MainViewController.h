//
//  MainViewController.h
//  Graphiti
//
//  Created by Kevin Carbone on 8/11/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ObjectiveDDP.h"
#import <ObjectiveDDP/MeteorClient.h>
#import "GraphitiGLViewController.h"
#import "CameraScene.h"
#import "Node.h"
#import "GraphitiProtocol.h"

@interface MainViewController : UIViewController<CLLocationManagerDelegate,GraphitiProtocol>{
@private
    int cameraOrientation;
}
@property (strong, nonatomic) MeteorClient* meteorClient;

@property (strong) CameraScene * scene;
@property (nonatomic, strong) AVCaptureSession          *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//@property (weak, nonatomic) IBOutlet GLKView *glView;
@property (weak, nonatomic) IBOutlet GLKView *glView;
@property (strong) GraphitiGLViewController* glViewController;
@property (nonatomic, retain) CLLocationManager         *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;

@property NSMutableArray* postArray;

@property NSMutableDictionary* postCache;

@property UIImage* currentImage;

@property (strong) AVCaptureStillImageOutput* stillImageOutput;

@end
