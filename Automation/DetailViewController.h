//
//  DetailViewController.h
//  Automation
//
//  Created by Filip Sandborg-Olsen on 20/01/16.
//  Copyright © 2016 Sandborg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <NSNetServiceDelegate> {
    NSString *serverHost;
    
    NSLock *isUpdating;
}

@property NSNetService* service;
@property IBOutlet UISlider* brightnessA;
@property IBOutlet UISlider* brightnessB;
@property IBOutlet UISlider* brightnessC;

-(IBAction) didChangeSlider:(id)sender;

@end
