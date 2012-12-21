//
//  SCFlatButton.m
//  SoundCloud
//
//  Created by Ullrich Schäfer on 13.11.12.
//  Copyright (c) 2012 SoundCloud. All rights reserved.
//

#import "QuartzCore+NXKit.h"
#import "UIColor+Hex.h"

#import "SCFlatButton.h"

@interface SCFlatButton ()
- (void)commonAwake;
@end

@implementation SCFlatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonAwake];
    }
    return self;
}

- (void)awakeFromNib;
{
    [super awakeFromNib];
    [self commonAwake];
}

- (void)commonAwake;
{
    self.contentMode = UIViewContentModeRedraw;

    /*
     Button Grey
     Gradient: Position: 6%, #fcfcfc -> Position 38%, #f2f2f2 -> Position 100%, #ffffff
     Outline: 1px(Retina 2px) #e3e3e3
     Inner Shadow: 2px (Retina 4px), #ffffff, Opacity: 0.4
     */
    _gradientColors    = [NSArray arrayWithObjects:
                          [UIColor sc_colorWithRGB:0xfcfcfc],
                          [UIColor sc_colorWithRGB:0xf2f2f2],
                          [UIColor sc_colorWithRGB:0xffffff], nil];
    _gradientPositions = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.06f],
                          [NSNumber numberWithFloat:0.38f],
                          [NSNumber numberWithFloat:1.00f], nil];
    _outlineColor      = [UIColor sc_colorWithRGB:0xe3e3e3];

    /*
     Button Grey Pressed
     Gradient: Position: 6%, #f0f0f0 -> Position 62%, #e5e5e5 -> Position 100%, #f2f2f2
     Outline: 1px(Retina 2px) #666666
     Inner shadow 6px (Retina 12px), #000000, Opacity: 0.55
     */
    _pressedGradientColors    = [NSArray arrayWithObjects:
                                 [UIColor sc_colorWithRGB:0xf0f0f0],
                                 [UIColor sc_colorWithRGB:0xe5e5e5],
                                 [UIColor sc_colorWithRGB:0xf2f2f2], nil];
    _pressedGradientPositions = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.06f],
                                 [NSNumber numberWithFloat:0.62f],
                                 [NSNumber numberWithFloat:1.00f], nil];
    _pressedOutlineColor      = [UIColor sc_colorWithRGB:0x666666];
}

#pragma mark Accessors

@synthesize roundedCorners = _roundedCorners;

@synthesize gradientColors = _gradientColors;
@synthesize gradientPositions = _gradientPositions;
@synthesize outlineColor = _outlineColor;

@synthesize pressedGradientColors = _pressedGradientColors;
@synthesize pressedGradientPositions = _pressedGradientPositions;
@synthesize pressedOutlineColor = _pressedOutlineColor;

- (void)setRoundedCorners:(UIRectCorner)roundedCorners;
{
    _roundedCorners = roundedCorners;
    [self setNeedsDisplay];
}

- (void)setGradientColors:(NSArray *)gradientColors;
{
    _gradientColors = gradientColors;
    [self setNeedsDisplay];
}

- (void)setGradientPositions:(NSArray *)gradientPositions;
{
    _gradientPositions = gradientPositions;
    [self setNeedsDisplay];
}

- (void)setOutlineColor:(UIColor *)outlineColor;
{
    _outlineColor = outlineColor;
    [self setNeedsDisplay];
}

- (void)setPressedGradientColors:(NSArray *)pressedGradientColors;
{
    _pressedGradientColors = pressedGradientColors;
    [self setNeedsDisplay];
}

- (void)setPressedGradientPositions:(NSArray *)pressedGradientPositions;
{
    _pressedGradientPositions = pressedGradientPositions;
    [self setNeedsDisplay];
}

- (void)setPressedOutlineColor:(UIColor *)pressedOutlineColor;
{
    _pressedOutlineColor = pressedOutlineColor;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted;
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}


#pragma mark Drawing

- (void)drawRect:(CGRect)rect;
{
    [super drawRect:rect];

    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context       = UIGraphicsGetCurrentContext();

    CGFloat cornerRadius       = 4.00f;

    //// Color Declerations
    NSArray *gradientColors    = self.gradientColors;
    NSArray *gradientLocations = self.gradientPositions;
    UIColor *outlineColor      = self.outlineColor;

    //// Shadow Declarations
    UIColor *shadow          = [UIColor sc_colorWithRGB:0xffffff andAlpha:0.40f];
    CGSize  shadowOffset     = CGSizeMake(0.00f, -0.00f);
    CGFloat shadowBlurRadius = 2.00f;

    ///// Selected State
    if (self.state & UIControlStateHighlighted) {
        gradientColors    = self.pressedGradientColors;
        gradientLocations = self.pressedGradientPositions;
        outlineColor      = self.pressedOutlineColor;

        shadow           = [UIColor sc_colorWithRGB:0x000000 andAlpha:0.55f];
        shadowBlurRadius = 6.00f;
    }


    //// Gradient Declarations
    NSAssert(gradientColors.count == gradientLocations.count, @"There should be as many gradient colors as gradient positions");

    NSUInteger gradientColorCount = gradientLocations.count;
    CGFloat cfGradientLocations[gradientLocations.count];
    CFMutableArrayRef cfGradientColors = CFArrayCreateMutable(CFAllocatorGetDefault(), gradientColorCount, &kCFTypeArrayCallBacks);

    for (NSUInteger gradientIndex = 0; gradientIndex < gradientColorCount; gradientIndex++) {
        UIColor *gradientColor = [gradientColors objectAtIndex:gradientIndex];
        NSNumber *gradientPosition = [gradientLocations objectAtIndex:gradientIndex];

        cfGradientLocations[gradientIndex] = [gradientPosition floatValue];
        CFArrayAppendValue(cfGradientColors, gradientColor.CGColor);
    }

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, cfGradientColors, cfGradientLocations);
    CFRelease(cfGradientColors);

    //// Rounded Rectangle Drawing
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                               byRoundingCorners:self.roundedCorners
                                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient,
                                self.bounds.origin,
                                CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds)),
                                0);
    CGContextRestoreGState(context);

    ////// Rounded Rectangle Inner Shadow
    CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -shadowBlurRadius, -shadowBlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);

    UIBezierPath *roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect:roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath: roundedRectanglePath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;

    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    shadowBlurRadius,
                                    shadow.CGColor);

        [roundedRectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
        [roundedRectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [roundedRectangleNegativePath fill];
    }
    CGContextRestoreGState(context);

    [self.outlineColor setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];

    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect;
{
    CGRect result = [super imageRectForContentRect:contentRect];
    result.origin = CGPointMake(CGRectGetMinY(result), CGRectGetMinY(result));
    return result;
}
@end
