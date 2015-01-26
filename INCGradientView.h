//
//  INCGradientView.h
//  Clicker
//
//  Created by Tomasz Szulc on 20/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INCGradientView : UIView

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;

- (void)refresh;

@end
