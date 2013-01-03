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

#if TARGET_OS_IPHONE
#import "NXOAuth2.h"
#else
#import <OAuth2Client/NXOAuth2.h>
#endif
#import <QuartzCore/QuartzCore.h>

#import "SCSoundCloud.h"
#import "SCSoundCloud+Private.h"
#import "SCConstants.h"
#import "SCBundle.h"
#import "SCLoginView.h"
#import "SCGradientButton.h"
#import "SCAlertView.h"
#import "SCDrawing.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface SCLoginView () <OHAttributedLabelDelegate>
@property (nonatomic, readwrite, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) SCGradientButton *fbButton;
@property (nonatomic, assign) SCGradientButton *loginButton;
//@property (nonatomic, assign) OHAttributedLabel *forgotPwLabel;
@property (nonatomic, assign) OHAttributedLabel *tosLabel;
- (void)commonAwake;
@end

@implementation SCLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonAwake];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Separator Line
    CGFloat lineWidth = 1.3;
    CGFloat topLineY = 133.0;
    CGFloat bottomLineY = topLineY + lineWidth;

    // Top part
    CGColorRef topLineColor = [UIColor colorWithRed:0.8
                                              green:0.8
                                               blue:0.8
                                              alpha:1.0].CGColor;

    CGPoint topLineStartPoint = CGPointMake(0, topLineY);
    CGPoint topLineEndPoint   = CGPointMake(CGRectGetWidth(self.bounds), topLineY);
    drawLine(context, topLineStartPoint, topLineEndPoint, topLineColor, lineWidth);

    // Bottom part
    CGColorRef bottomLineColor = [UIColor colorWithRed:1.0
                                                 green:1.0
                                                  blue:1.0
                                                 alpha:1.0].CGColor;

    CGPoint bottomLineStartPoint = CGPointMake(0, bottomLineY);
    CGPoint bottomLineEndPoint   = CGPointMake(CGRectGetWidth(self.bounds), bottomLineY);
    drawLine(context, bottomLineStartPoint, bottomLineEndPoint, bottomLineColor, lineWidth);

}

- (void)commonAwake;
{
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	self.activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
	self.activityIndicator.hidesWhenStopped = YES;
	[self addSubview:self.activityIndicator];
    
    self.backgroundColor = [UIColor colorWithRed:0.949
                                           green:0.949
                                            blue:0.949
                                           alpha:1.0];

    [self layoutTitleLabel];
    [self layoutFbButton];
    [self layoutCredentialsView];
    [self layoutLoginButton];
    //[self layoutForgotPasswordLabel];
    [self layoutTermsAndPrivacy];
}

- (void)dealloc;
{
    [super dealloc];
}

#pragma mark -
#pragma mark Layout all of the things

- (void)layoutTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = UITextAlignmentLeft;
    self.titleLabel.text = [NSString stringWithFormat:SCLocalizedString(@"credential_title", @"Title"),
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    self.titleLabel.textColor = [UIColor colorWithRed:0.4
                                                green:0.4
                                                 blue:0.4
                                                alpha:1.0];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.titleLabel.shadowColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
}

- (void)layoutFbButton
{
    NSArray *fbButtonColors = [NSArray arrayWithObjects:
                                [UIColor colorWithRed:0
                                                green:0.4
                                                 blue:0.8
                                                alpha:1.0],
                                [UIColor colorWithRed:0.043
                                                green:0.314
                                                 blue:0.588
                                                alpha:1.0],
                                nil];

    self.fbButton = [[SCGradientButton alloc] initWithFrame:CGRectZero
                                                     colors:fbButtonColors];
    self.fbButton.backgroundColor = [UIColor whiteColor];
    [self.fbButton setTitle:SCLocalizedString(@"fb_sign_in",@"Facebook")
                   forState:UIControlStateNormal];
    self.fbButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.fbButton.titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    self.fbButton.titleLabel.shadowOffset = CGSizeMake(0.0, -0.9);
    self.fbButton.titleLabel.shadowColor = [UIColor blackColor];
    [self.fbButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    self.fbButton.layer.borderColor = [UIColor colorWithRed:0
                                                      green:0.286
                                                       blue:0.569
                                                      alpha:1.0].CGColor;
    self.fbButton.layer.borderWidth = 1.0;

    [self.fbButton addTarget:self
                      action:@selector(signInWithFacebook:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.fbButton];

   // Facebook logo
    UIImageView *fbLogo = [[UIImageView alloc] init];
    fbLogo.image = [SCBundle imageWithName:@"facebook"];
    [fbLogo sizeToFit];
    fbLogo.frame = CGRectMake(7.0,
                              6.0,
                              CGRectGetWidth(fbLogo.frame),
                              CGRectGetHeight(fbLogo.frame));
    [self.fbButton addSubview:fbLogo];
}

- (void)layoutCredentialsView
{
    self.credentialsView = [[SCCredentialsView alloc] init];
    self.credentialsView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    [self addSubview:self.credentialsView];
}

- (void)layoutLoginButton
{
    self.loginButton = [[SCGradientButton alloc] initWithFrame:CGRectZero
                                                        colors:nil];
    self.loginButton.backgroundColor = [UIColor colorWithPatternImage:[SCBundle imageWithName:@"continue"]];

    [self.loginButton setTitle:SCLocalizedString(@"connect_to_sc",@"Connect")
                      forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.4
                                                    green:0.4
                                                     blue:0.4
                                                    alpha:1.0]
                           forState:UIControlStateNormal];

    [self.loginButton setTitleShadowColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];

    self.loginButton.titleLabel.shadowOffset  = CGSizeMake(0.0, 1.0);
    self.loginButton.layer.borderColor        = [UIColor colorWithRed:0.8
                                                                green:0.8
                                                                 blue:0.8
                                                                alpha:1.0].CGColor;
    [self.loginButton addTarget:self
                         action:@selector(login:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
}

- (void)layoutTermsAndPrivacy
{
    NSMutableAttributedString *text = [NSMutableAttributedString attributedStringWithString:SCLocalizedString(@"sign_in_tos_pp_body", nil)];
    [text setFont:[UIFont systemFontOfSize:13.0]];

    self.tosLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    self.tosLabel.attributedText = text;
    self.tosLabel.centerVertically = NO;
    self.tosLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.tosLabel.textAlignment = UITextAlignmentCenter;
    self.tosLabel.textColor = [UIColor colorWithRed:0.6
                                              green:0.6
                                               blue:0.6
                                              alpha:1.0];
    self.tosLabel.backgroundColor = [UIColor clearColor];
    self.tosLabel.delegate = self;

    NSRange touLinkRange = [text.string rangeOfString:SCLocalizedString(@"terms_of_use_substring", nil)];
    NSAssert((touLinkRange.location != NSNotFound), @"Localisation of sign_in_tos_pp_body needs to contain substring");
    [self.tosLabel addCustomLink:[NSURL URLWithString:kTermsOrServiceUrl]
                         inRange:touLinkRange];

    NSRange ppLinkRange = [text.string rangeOfString:SCLocalizedString(@"privatcy_policy_substring", nil)];
    NSAssert((ppLinkRange.location != NSNotFound), @"Localisation of sign_in_tos_pp_body needs to contain substring");
    [self.tosLabel addCustomLink:[NSURL URLWithString:kPrivacyPolicyUrl]
                         inRange:ppLinkRange];

    [self addSubview:self.tosLabel];
}

#pragma mark View

- (void)layoutSubviews;
{
    CGFloat titleLabelX = 18.0;
    CGFloat titleLabelY = 13.0;
    CGFloat titleLabelHeight = 40.0;

    self.titleLabel.frame = CGRectMake(titleLabelX,
                                       titleLabelY,
                                       self.bounds.size.width - self.frame.origin.x,
                                       titleLabelHeight);

    self.credentialsView.frame = CGRectMake(13.0,
                                            155.0,
                                            self.bounds.size.width - 27.0,
                                            97.0);

    self.fbButton.frame = CGRectMake(self.credentialsView.frame.origin.x,
                                     69.0,
                                     self.credentialsView.frame.size.width,
                                     43.0);

    self.loginButton.frame = CGRectMake(self.credentialsView.frame.origin.x,
                                        self.credentialsView.frame.origin.y + self.credentialsView.frame.size.height + 21.0,
                                        self.credentialsView.frame.size.width,
                                        43.0);
    self.fbButton.titleEdgeInsets = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ?
                                                                    UIEdgeInsetsMake(0, -278.0, 0, 0) : UIEdgeInsetsMake(0, -30.0, 0, 0);

    self.activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    self.tosLabel.frame = CGRectMake(self.loginButton.frame.origin.x,
                                     self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 17.0,
                                     CGRectGetWidth(self.bounds) - 20.0,
                                     80.0);
    [self setNeedsDisplay];
}

- (void)askForOpeningURL:(NSURL*)URL
{
    [SCAlertView showAlertViewWithTitle:SCLocalizedString(@"open_in_safari_title", nil)
                                message:SCLocalizedString(@"open_in_safari_message", nil)
                      cancelButtonTitle:SCLocalizedString(@"alert_cancel", nil)
                      otherButtonTitles:[NSArray arrayWithObject:SCLocalizedString(@"alert_ok", nil)]
                                  block:^(NSInteger buttonIndex, BOOL didCancel) {
                                      if (!didCancel) {
                                          [[UIApplication sharedApplication] openURL:URL];
                                      }
                                  }];
}

#pragma mark Accessors

@synthesize loginDelegate;
@synthesize activityIndicator;
@synthesize credentialsView;
@synthesize fbButton;
@synthesize loginButton;
@synthesize titleLabel;
//@synthesize forgotPwLabel;
@synthesize tosLabel;

- (void)loadURL:(NSURL *)anURL;
{
    // WORKAROUND: Remove all Cookies to enable the use of facebook user accounts
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark Button Actions

- (void)login:(id)sender
{
   if (![self.credentialsView.username isEqualToString:@""] &&
       ![self.credentialsView.password isEqualToString:@""]) {
        [[SCSoundCloud shared] requestAccessWithUsername:self.credentialsView.username
                                                password:self.credentialsView.password];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCLocalizedString(@"credentials_error", @"Credentials Error")
                                                        message:SCLocalizedString(@"credentials_error_message", @"Credentials Message Error")
                                                       delegate:nil
                                              cancelButtonTitle:SCLocalizedString(@"alert_ok", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)signInWithFacebook:(id)sender
{
#warning To-Do: api-team redirect flow -> input/output?
    [[NXOAuth2AccountStore sharedStore] configurationForAccountType:kSCAccountType];
}

- (void)cancel:(id)sender
{
    [(UIViewController *)self.loginDelegate dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark OHAttributedLabel delegate

- (BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo;
{
    if ([linkInfo.URL.absoluteString isEqualToString:kTermsOrServiceUrl]) {
        [self askForOpeningURL:[NSURL URLWithString:kTermsOrServiceUrl]];
    } else if ([linkInfo.URL.absoluteString isEqualToString:kPrivacyPolicyUrl]) {
        [self askForOpeningURL:[NSURL URLWithString:kPrivacyPolicyUrl]];
    }
    return NO;
}

- (UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle; //!< Combination of CTUnderlineStyle and CTUnderlineStyleModifiers
{
    *underlineStyle = kCTUnderlineStyleSingle;
    return [UIColor colorWithRed:0.4
                           green:0.4
                            blue:0.4
                           alpha:1.0];
}

@end
