//
//  ViewController.m
//  intrepid-check-in
//
//  Created by Aditi Ashok on 6/16/15.
//  Copyright (c) 2015 Aditi Ashok. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import Foundation;
@import UIKit;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *monitorButton;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property(readonly, nonatomic, copy) NSSet *geoFences;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *intrepidOffice;





@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    self.locationManager.delegate = self; // we set the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(42.367010, -71.08021);
    self.intrepidOffice = [[CLCircularRegion alloc] initWithCenter:location
                                                            radius:100
                                                        identifier:@"intrepidOffice"];
    
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





#pragma mark - Location Manger Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation *currentLocation = [locations lastObject];
    NSString *lattitude = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];

    
    NSLog(@"lattitude is: %@ longitude is: %@", lattitude, longitude);
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"reaching did enter region");
    [self sendNotificiation];
    
    
}

-(void) sendNotificiation {
    /* notification stuff */
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Entering Intrepid";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"reaching did exit");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}

/* perform action on button click here */
- (IBAction)monitorLocation:(id)sender {
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager startMonitoringForRegion:self.intrepidOffice];
    
    
    
  
    
    
    /*
        1. Get Location - how often?
        2. Are you near Intrepid
        2a. If yes:
                i. Send notification
                ii. Message Slack
                (iii. prevent future check ins for x amount of time)
        2b. If no:
                i. Go back to get location
    */
    
}





@end
