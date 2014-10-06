//
//  MenuViewController.m
//  Chess
//
//  Created by Liu Di on 6/26/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize boardViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Override point for customization after application launch.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            BoardViewController *boardView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:@"boardView"];
            self.boardViewController = boardView;
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            BoardViewController *boardView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:@"boardView"];
            self.boardViewController = boardView;
        }
        
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {   // The iOS device = iPad
        
        BoardViewController *boardView = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:NULL] instantiateViewControllerWithIdentifier:@"boardView"];
        self.boardViewController = boardView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickOnBot:(UIButton *) sender{
    NSLog(@"!!clickonbot");

//    boardViewController = [[ViewController alloc] initWithNibName:@"boardView" bundle:nil];
    self.boardViewController.mode1 = 1;
    [self presentViewController:boardViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:secondView animated:YES];
}

- (IBAction)clickOnHardBot:(UIButton *)sender{
    NSLog(@"!!clickonHardBot");
    self.boardViewController.mode1 = 2;
    [self presentViewController:boardViewController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
