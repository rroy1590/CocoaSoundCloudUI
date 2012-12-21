/*
 * Copyright 2010, 2011 nxtbgthng for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

#import <QuartzCore/QuartzCore.h>

#import "SCTextField.h"
#import "UIColor+SoundCloudUI.h"
#import "SCConstants.h"
#import "SCBundle.h"

@interface SCTextField ()
- (void)roundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
@end

@implementation SCTextField

@synthesize needsSeparatorLine;
@synthesize cornerStyle;

- (void)drawPlaceholderInRect:(CGRect)rect;
{
    [[UIColor listSubtitleColor] setFill];
    [self.placeholder drawInRect:rect withFont:self.font];
}

// Placeholder Text Bounds
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10.0, 15.0);
}

// Actual Text Bounds
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10.0, 15.0);
}

- (void)drawRect:(CGRect)rect
{
    switch (cornerStyle) {
        case SCTextFieldCornerStyleTop:
            [self roundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                       withRadii:CGSizeMake(kSCBorderRadius, kSCBorderRadius)];
            break;

        case SCTextFieldCornerStyleBottom:
            [self roundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                       withRadii:CGSizeMake(kSCBorderRadius, kSCBorderRadius)];
            break;

        default:
            break;
    }

    // Separator line
    if (self.needsSeparatorLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGColorRef color = [UIColor colorWithRed:0.8
                                           green:0.8
                                            blue:0.8
                                           alpha:1.0].CGColor;
        CGContextSetStrokeColorWithColor(context, color);
        CGContextSetLineWidth(context, 1.0);

        CGPoint startPoint = CGPointMake(rect.origin.x,
                                         rect.origin.y + rect.size.height - 1);
        CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width - 10,
                                       rect.origin.y + rect.size.height - 1);

        CGContextMoveToPoint(context, startPoint.x + 10.0, startPoint.y + 0.5);
        CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

- (void)roundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           byRoundingCorners:corners
                                                 cornerRadii:radii].CGPath;

    self.layer.mask = maskLayer;
}

- (void)addInnerShadow
{
    UIImageView *innerShadowView = [[UIImageView alloc] init];
    innerShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    innerShadowView.image = [SCBundle imageWithName:@"input"];
    [innerShadowView sizeToFit];
    innerShadowView.frame = CGRectMake(1.0, 0,
                                       CGRectGetWidth(innerShadowView.frame) - 1.0,
                                       90.0);
    [self insertSubview:innerShadowView atIndex:0];
}

@end
