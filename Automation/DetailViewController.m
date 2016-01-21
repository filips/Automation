//
//  DetailViewController.m
//  Automation
//
//  Created by Filip Sandborg-Olsen on 20/01/16.
//  Copyright © 2016 Sandborg. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController


-(void) updateState {
    if(![_service hostName]) {
        return;
    } else {
        serverHost = [NSString stringWithFormat:@"%@:%ld",[_service hostName], (long)[_service port]];
    }
    
    NSMutableURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/state/", serverHost]]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:req completionHandler:^(NSData* data, NSURLResponse* response, NSError *error){
        if(!error) {
            NSString* res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray* parts = [res componentsSeparatedByString:@" "];
            if([parts count] == 3) {
                float A = [[parts objectAtIndex:0] floatValue] / 100.0;
                float B = [[parts objectAtIndex:1] floatValue] / 100.0;
                float C = [[parts objectAtIndex:2] floatValue] / 100.0;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_brightnessA setValue:A animated:YES];
                    [_brightnessB setValue:B animated:YES];
                    [_brightnessC setValue:C animated:YES];
                });
            }
        } else {
            NSLog(@"%@", error);
        }
    }] resume];
}

-(void) viewDidLoad {
    _service.delegate = self;
    [_service resolveWithTimeout:0.0];
    
    isUpdating = [[NSLock alloc] init];
    [self updateState];
}


-(void) netServiceDidResolveAddress:(NSNetService *)sender {
    [self updateState];
}

-(IBAction)didChangeSlider:(id)sender {
    
    int A = (int) (100 * [_brightnessA value]);
    int B = (int) (100 * [_brightnessB value]);
    int C = (int) (100 * [_brightnessC value]);
    
    NSMutableURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/set/?ch1=%d&ch2=%d&ch3=%d", serverHost, A, B, C]]];

    NSURLSession *session = [NSURLSession sharedSession];
    
    if([isUpdating tryLock]) {
        [[session dataTaskWithRequest:req completionHandler:^(NSData* data, NSURLResponse* response, NSError *error){
            dispatch_sync(dispatch_get_main_queue(), ^{
                [isUpdating unlock];
            });
            if(error) {
                NSLog(@"%@", error);
            }
        }] resume];
    }
}

@end
