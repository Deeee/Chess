//
//  MenuViewController.h
//  Chess
//
//  Created by Liu Di on 6/26/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardViewController.h"
@interface MenuViewController : UIViewController
@property (nonatomic, strong) BoardViewController *boardViewController;

- (IBAction)clickOnBot:(UIButton *) sender;
- (IBAction)clickOnHardBot:(UIButton *)sender;
@end
