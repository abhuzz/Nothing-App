//
//  INCGradientView.m
//  Clicker
//
//  Created by Tomasz Szulc on 20/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

#import "INCGradientView.h"

@interface INCGradientView ()
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end

@implementation INCGradientView {

}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.fromColor && self.toColor) {
        [self refresh];
    }
}

- (void)_createGradient {
    self.layer.colors = @[(id)self.fromColor.CGColor,
                          (id)self.toColor.CGColor];
    self.layer.locations = @[@0, @1];
}

- (void)refresh {
    [self _createGradient];
}

@end
