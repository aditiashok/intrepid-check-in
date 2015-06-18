//
//  ViewController.m
//  intrepid-check-in
//
//  Created by Aditi Ashok on 6/16/15.
//  Copyright (c) 2015 Aditi Ashok. All rights reserved.
//

#import "ViewController.h"
#import "SlackRequestManager.h"

@import CoreLocation;
@import Foundation;
@import UIKit;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *intrepidOffice;

@property (strong, nonatomic) NSString *name;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    

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
    
    [self.startButton setBackgroundColor:[UIColor grayColor]];
    [self.stopButton setBackgroundColor:[UIColor grayColor]];
    
    [self enterUsername];
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertView textFieldAtIndex:0].text != nil) {
            self.name = [alertView textFieldAtIndex:0].text;
        }
    }
    else{
        NSLog(@"Done");
    }
}


#pragma mark - Location Manger Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"There was an error retrieving your location" delegate:nil
                                                        cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self sendNotificiation:@"Entering Intrepid"];
    [self sendAlert:@"Entering Intrepid"];
    [self messageSlack:@"I'm here!" :self.name];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self sendNotificiation:@"Leaving Intrepid"];
    [self sendAlert:@"Leaving Intrepid"];
    [self messageSlack:@"I'm leaving!" :self.name];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}


#pragma mark - Internal Helper Methods
- (void) enterUsername {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Name" message:@"Enter your name" delegate:self
                                           cancelButtonTitle:@"Cancel" otherButtonTitles: @"Enter", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    
}

- (void) messageSlack: (NSString *) message :(NSString *) name {
    [[SlackRequestManager sharedManager] sendMessage:message :name success:^(BOOL success) {
    } failure:^(NSError *error) {
        if (error == nil) {
            NSLog(@"Nothing was downloaded");
            
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];

}

- (void) sendNotificiation: (NSString *) message {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

    
}

- (void) sendAlert: (NSString *) message {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Location Change!"
                              message:message
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    [alertView show];
}

#pragma mark - button actions
- (IBAction)startMonitoringLocation:(id)sender {
    [self.stopButton setBackgroundColor:[UIColor grayColor]];
    [self.startButton setBackgroundColor:[UIColor greenColor]];
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringForRegion:self.intrepidOffice];

}

- (IBAction)stopMonitoringLocation:(id)sender {
    [self.startButton setBackgroundColor:[UIColor grayColor]];
    [self.stopButton setBackgroundColor:[UIColor greenColor]];
    [self.locationManager stopMonitoringForRegion:self.intrepidOffice];
    [self.locationManager stopUpdatingLocation];
    
    
}




@end
