//
//  DeviceBrowserController.m
//  Automation
//
//  Created by Filip Sandborg-Olsen on 20/01/16.
//  Copyright © 2016 Sandborg. All rights reserved.
//

#import "DeviceBrowserController.h"

@interface DeviceBrowserController ()

@end

@implementation DeviceBrowserController

@synthesize nb;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    servers = [[NSMutableArray alloc] init];
    
    nb = [[NSNetServiceBrowser alloc] init];
    if(!nb) {
        NSLog(@"Could not start net service browser..");
        return;
    }
    
    [nb setDelegate:self];
}

-(IBAction) performRefresh:(id)sender {
    if(nb) {
        [nb stop];
    }
    [nb searchForServicesOfType:@"_homeauto._tcp." inDomain:@""];
}
-(void) viewDidAppear:(BOOL)animated {
    [self performRefresh:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser {
    NSLog(@"Stopped search");
}


- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"Found");
    if(![servers containsObject:service]) {
        [servers addObject:service];
    }
    
    if(!moreComing) {
        [[self tableView] reloadData];
    }
}

-(void) netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"Removed");
    if([servers containsObject:service]) {
        [servers removeObject:service];
    }
    
    if(!moreComing){
        [[self tableView] reloadData];
    }
}

- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *,NSNumber *> *)errorDict {
    NSLog(@"Did not search");
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serviceCell"];
    }
    
    cell.textLabel.text = [(NSNetService*)[servers objectAtIndex:[indexPath row]] name];
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailView"]) {
        DetailViewController* destination = (DetailViewController*)[segue destinationViewController];
        UITableViewCell *cell = (UITableViewCell*) sender;
        [destination setService:[servers objectAtIndex:[[[self tableView] indexPathForCell:cell] row]]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [servers count];
}


@end
