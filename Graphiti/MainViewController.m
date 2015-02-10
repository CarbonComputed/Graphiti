//
//  MainViewController.m
//  Graphiti
//
//  Created by Kevin Carbone on 8/11/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

#define IMAGE_PREFIX @"https://s3-us-west-2.amazonaws.com/graphiti001/"


#import <SDWebImageManager.h>

#import "MainViewController.h"
#import "DrawingViewController.h"
#import "Post.h"
#import "Sprite.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_postCache = [NSMutableDictionary new];
#if !TARGET_IPHONE_SIMULATOR
	_glViewController = [[GraphitiGLViewController alloc] initWithView:self.glView];
	self.glView.opaque = NO;

	[self addChildViewController:_glViewController];


	NSError *error = nil;
	AVCaptureSession *avCaptureSession = [[AVCaptureSession alloc] init];
	AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];

	if (videoInput) {
		[avCaptureSession addInput:videoInput];
	}
	else {
		// Handle the failure.
	}

	AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:avCaptureSession];
	//newCaptureVideoPreviewLayer.opacity = 0.9;
	//[[arView layer] setMasksToBounds:YES];
	[newCaptureVideoPreviewLayer setFrame:[self.view bounds]];
	[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

	if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported])
		[[newCaptureVideoPreviewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];


	[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	//[self.view.layer addSublayer:newCaptureVideoPreviewLayer];
	[self.view.layer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
	[self setPreviewLayer:newCaptureVideoPreviewLayer];

	[avCaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
	[avCaptureSession startRunning];

	[self setCaptureSession:avCaptureSession];
	_stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
	[_stillImageOutput setOutputSettings:outputSettings];

	[avCaptureSession addOutput:_stillImageOutput];

#endif

	_locationManager = [[CLLocationManager alloc] init];
	_locationManager.delegate = self;
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[_locationManager startUpdatingLocation];

	self.meteorClient = [[MeteorClient alloc] initWithDDPVersion:@"pre2"];

	ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:@"ws://10.0.0.17:3000/websocket" delegate:self.meteorClient];
	self.meteorClient.ddp = ddp;
	[self.meteorClient.ddp connectWebSocket];
	[self.meteorClient addSubscription:@"posts"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportConnection) name:@"connected" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportDisconnection) name:MeteorClientDidDisconnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(didReceiveUpdate:)
	                                             name:@"added"
	                                           object:nil];


	// Do any additional setup after loading the view.
}

- (void)didReceiveUpdate:(NSNotification *)notification {
	_postArray = self.meteorClient.collections[@"posts"];
	if (!_postCache) {
		_postCache = [NSMutableDictionary new];
	}
//	[_glViewController.scene.children removeAllObjects];
	for (NSDictionary *val in _postArray) {
		Post *post = [_postCache objectForKey:val[@"_id"]];
		if (!post) {
			post = [[Post alloc] initWithDictionary:val];
			[_postCache setObject:post forKey:post.id];
		}
		NSString *image1Id = val[@"image1"];
		NSString *imageURL1 = [NSString stringWithFormat:@"%@%@", IMAGE_PREFIX, val[@"image1"]];
        NSLog(imageURL1);
		if (image1Id && post) {
			SDWebImageManager *manager = [SDWebImageManager sharedManager];
			[manager downloadWithURL:imageURL1
			                 options:0
			progress: ^(NSInteger receivedSize, NSInteger expectedSize)
			{
			    // progression tracking code
			}

			completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
			{
			    if (image) {
			        Sprite *sprite = [[Sprite alloc] initWithUIImage:image effect:_glViewController.effect];
			        sprite.xRotation = 90;
			        sprite.zRotation = 90;
			        post.sprite = sprite;
			        CLLocation *currentLocation = _locationManager.location;
			        CLLocation *other = [[CLLocation alloc] initWithLatitude:post.latitude longitude:post.longitude];
			        float di = [self getHeadingForDirectionFromCoordinate:currentLocation.coordinate toCoordinate:other.coordinate];
			        CLLocationDistance d = [currentLocation distanceFromLocation:other];

			        float x = cos(degreesToRadians(di)) * d;
			        float y = sin(degreesToRadians(di)) * d;
//			        _glViewController.scene.sprite = sprite;
			        sprite.position = GLKVector3Make(-150, x+200+(arc4random() % 500), y+200+(arc4random() % 500));
                    sprite.rotationMatrix = rotationMatrix(post.yaw, post.pitch, post.roll);
			        [_glViewController.scene addChild:sprite];
                    NSLog(@"%@",image);
                    NSLog(@"COUNT! %d %f",_glViewController.scene.children.count, post.yaw);
			        // do something with image
				}
			}];
		}
	}
//	//[_postCache removeAllObjects];
//	//[_glViewController.scene add]
//	for (NSDictionary *val in _postArray) {
//		//NSString* imageURL1 = [NSString stringWithFormat:@"%@%@", prefix,val[@"image1"]];
//		//NSString* imageURL1 = [NSString stringWithFormat:@"%@%@",prefix, @"test"];
//		//NSString* imageURL2 = [NSString stringWithFormat:@"%@%@", prefix,val[@"image2"]];
//		Post *post = [_postCache objectForKey:val[@"_id"]];
//		if (!post) {
//			post = [[Post alloc] initWithDictionary:val];
//		}
//		if (val[@"image1"] && val[@"image2"] && !_postCache[post.id]) {
//		}
////        if(post.sprite){
////            [_glViewController.scene addChild:post.sprite];
////        }
////        CLLocation *currentLocation = _locationManager.location;
////        CLLocation *other = [[CLLocation alloc] initWithLatitude:post.latitude longitude:post.longitude];
////        float di = [self getHeadingForDirectionFromCoordinate:currentLocation.coordinate toCoordinate:other.coordinate];
////        CLLocationDistance d = [currentLocation distanceFromLocation:other];
////
////        float x = cos(degreesToRadians(di))*d;
////        float y = sin(degreesToRadians(di))*d;
////        _glViewController.scene.sprite.position = GLKVector3Make(x, y, 0);
////
//	}
}

GLKMatrix4 rotationMatrix(double yaw, double pitch, double roll){
    GLKMatrix4 rotationMat = GLKMatrix4Identity;
    
    rotationMat = GLKMatrix4RotateZ(rotationMat, roll);
    rotationMat = GLKMatrix4RotateX(rotationMat, pitch);
    rotationMat = GLKMatrix4RotateY(rotationMat, yaw);
    rotationMat = GLKMatrix4Make(rotationMat.m00, rotationMat.m02, rotationMat.m01, 0.0f,
                                 rotationMat.m20, rotationMat.m22, rotationMat.m21, 0.0f,
                                 rotationMat.m10, rotationMat.m12, rotationMat.m11, 0.0f,
                                 0.0f,  0.0f,  0.0f,  1.0f);
    return rotationMat;
}

- (void)reportConnection {
	NSLog(@"================> Connected to server!");
	[self.meteorClient logonWithEmail:@"blah@blah.com" password:@"blahblah" responseCallback: ^(NSDictionary *response, NSError *error) {
	    if (error) {
	        NSLog(@"Failure Logging In");
	        return;
		}

	    NSLog(@"Success");
	}];
}

- (void)reportDisconnection {
	NSLog(@"================> Disconnected from server!");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIImage *)imageFromLayer:(CALayer *)layer {
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
		UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, [UIScreen mainScreen].scale);
	else
		UIGraphicsBeginImageContext([layer frame].size);

	[layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return outputImage;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"didFailWithError: %@", error);
	UIAlertView *errorAlert = [[UIAlertView alloc]
	                           initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//NSLog(@"didUpdateToLocation: %@", newLocation);
	CLLocation *currentLocation = newLocation;

	CLLocation *other = [[CLLocation alloc] initWithLatitude:37.37830 longitude:-121.91672];
	float di = [self getHeadingForDirectionFromCoordinate:currentLocation.coordinate toCoordinate:other.coordinate];
	CLLocationDistance d = [currentLocation distanceFromLocation:other];

	float x = cos(degreesToRadians(di)) * d;
	float y = sin(degreesToRadians(di)) * d;
	//_glViewController.scene.sprite.position = GLKVector3Make(x, y, 0);
//    if(di>275&&di<360){
//        y *= -1;
//    }
//    if(di>90&&di<180){
//        x *= -1;
//    }

	if (currentLocation != nil) {
	}
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc {
	float fLat = degreesToRadians(fromLoc.latitude);
	float fLng = degreesToRadians(fromLoc.longitude);
	float tLat = degreesToRadians(toLoc.latitude);
	float tLng = degreesToRadians(toLoc.longitude);
	float dy = toLoc.latitude - fromLoc.latitude;
	float dx = cosf(M_PI / 180 * fromLoc.latitude) * (toLoc.longitude - fromLoc.longitude);
	float angle = atan2f(dy, dx);
	return radiandsToDegrees(angle);
}

- (IBAction)pictureButtonPressed:(id)sender {
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in _stillImageOutput.connections) {
		for (AVCaptureInputPort *port in[connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
			break;
		}
	}

	NSLog(@"about to request a capture from: %@", _stillImageOutput);
	[_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
	{
//		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer,kCGImagePropertyExifDictionary, NULL);
//		 if (exifAttachments)
//		 {
//             // Do something with the attachments.
//             NSLog(@"attachements: %@", exifAttachments);
//		 }
//         else
//             NSLog(@"no attachments");

	    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
	    UIImage *image = [[UIImage alloc] initWithData:imageData];
	    _currentImage = image;
	    [self performSegueWithIdentifier:@"drawingSegue" sender:self];

	    //[self.imageView setImage:image];
	}];
	UIImage *img = [self imageFromLayer:_previewLayer];


	//[_imageView setImage:img];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];

	// Save image.
	[UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES];
}

- (void)createPost:(UIImage *)image1:(UIImage *)image2:(NSString *)title {
	NSData *image1Data = UIImagePNGRepresentation(image1);
	NSData *image2Data = UIImagePNGRepresentation(image2);
	NSArray *parameters = @[@{ @"title": title,
	                           @"fileData": [image1Data base64EncodedStringWithOptions:0],
	                           @"fileData2": [image2Data base64EncodedStringWithOptions:0],
	                           @"lat": @(_locationManager.location.coordinate.latitude),
	                           @"lon": @(_locationManager.location.coordinate.longitude),
	                           @"roll": @(_glViewController.currentRoll),
	                           @"pitch": @(_glViewController.currentPitch),
	                           @"yaw": @(_glViewController.currentYaw),
	                           @"lon": @(_locationManager.location.coordinate.longitude), }];

	[self.meteorClient callMethodName:@"createPost" parameters:parameters responseCallback: ^(NSDictionary *response, NSError *error) {
	    NSString *message = response[@"result"];
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meteor Todos"
	                                                    message:message
	                                                   delegate:nil
	                                          cancelButtonTitle:@"Great"
	                                          otherButtonTitles:nil];
	    [alert show];
	}];
}
             


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"drawingSegue"]) {
		DrawingViewController *controller = [segue destinationViewController];
		controller.currentImage = _currentImage;
		controller.delegate = self;
	}
}

@end
