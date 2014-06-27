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
@synthesize mode;
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
    BoardViewController *boardView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:@"boardView"];
    self.boardViewController = boardView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickOnBot:(UIButton *) sender{
    NSLog(@"!!clickonbot");
    mode = sender.tag;

//    boardViewController = [[ViewController alloc] initWithNibName:@"boardView" bundle:nil];
    self.boardViewController.mode1 = 1;
    [self presentViewController:boardViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:secondView animated:YES];
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
