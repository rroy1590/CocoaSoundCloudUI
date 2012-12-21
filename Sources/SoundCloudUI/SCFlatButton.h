//
//  SCFlatButton.h
//  SoundCloud
//
//  Created by Ullrich Schäfer on 13.11.12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFlatButton : UIButton

@property (nonatomic) UIRectCorner roundedCorners;

@property (nonatomic) NSArray *gradientColors;
@property (nonatomic) NSArray *gradientPositions; // NSNumber floats

@property (nonatomic) UIColor *outlineColor;

@property (nonatomic) NSArray *pressedGradientColors;
@property (nonatomic) NSArray *pressedGradientPositions; // NSNumber floats

@property (nonatomic) UIColor *pressedOutlineColor;

@end
