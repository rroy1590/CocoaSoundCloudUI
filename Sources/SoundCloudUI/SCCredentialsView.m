//
//  SCCredentialsView.m
//  SoundCloudUI
//
//  Created by r/o/b on 12/20/12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SCCredentialsView.h"
#import "SCConstants.h"
#import "SCBundle.h"


float const kSCBorderRadius = 4.0;
NSUInteger const kSCUsernameTextFieldTag = 1001;
NSUInteger const kSCPasswordTextFieldTag = 1002;

@interface SCCredentialsView () <UITextFieldDelegate>

@property (nonatomic, assign) SCTextField *usernameField;
@property (nonatomic, assign) SCTextField *passwordField;
@end

@implementation SCCredentialsView

@synthesize usernameField;
@synthesize passwordField;
@synthesize username;
@synthesize password;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kSCBorderRadius;
        self.layer.borderColor = [UIColor colorWithRed:0.8
                                                 green:0.8
                                                  blue:0.8
                                                 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1.0, 5.0);

        [self layoutUsernameField];
        [self layoutPasswordField];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateInterface)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)updateInterface
{
    [self.usernameField setNeedsDisplay];
    [self.passwordField setNeedsDisplay];
}

- (void)dealloc
{
    username = nil;
    password = nil;
    [username release];
    [password release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark Layout all of the things

- (void)layoutUsernameField
{
    self.usernameField = [[SCTextField alloc] init];
    self.usernameField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.usernameField.needsSeparatorLine = YES;
    self.usernameField.delegate = self;
    self.usernameField.backgroundColor = [UIColor clearColor];
    self.usernameField.placeholder = SCLocalizedString(@"username", @"Email");
    self.usernameField.font = [UIFont systemFontOfSize:16.0];

    self.usernameField.textColor = [UIColor colorWithRed:0.2
                                                   green:0.2
                                                    blue:0.2
                                                   alpha:1.0];
    self.usernameField.clearButtonMode = UITextFieldViewModeAlways;
    self.usernameField.tag = kSCUsernameTextFieldTag;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.cornerStyle = SCTextFieldCornerStyleTop;
    [self.usernameField addInnerShadow];
    [self addSubview:self.usernameField];
}

- (void)layoutPasswordField
{
    self.passwordField = [[SCTextField alloc] init];
    self.passwordField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.passwordField.delegate = self;
    self.passwordField.backgroundColor = [UIColor clearColor];
    self.passwordField.placeholder = SCLocalizedString(@"password", @"Password");
    self.passwordField.font = [UIFont systemFontOfSize:16.0];
    self.passwordField.textColor = [UIColor colorWithRed:0.2
                                                   green:0.2
                                                    blue:0.2
                                                   alpha:1.0];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.clearButtonMode = UITextFieldViewModeAlways;
    self.passwordField.tag = kSCPasswordTextFieldTag;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.cornerStyle = SCTextFieldCornerStyleBottom;
    [self addSubview:self.passwordField];
}

#pragma mark View

- (void)layoutSubviews
{
    self.usernameField.frame = CGRectMake(self.bounds.origin.x,
                                          self.bounds.origin.y,
                                          CGRectGetWidth(self.bounds),
                                          CGRectGetHeight(self.bounds)/2);

    self.passwordField.frame = CGRectMake(self.usernameField.frame.origin.x,
                                          self.usernameField.frame.origin.y + self.usernameField.frame.size.height,
                                          self.usernameField.frame.size.width,
                                          self.usernameField.frame.size.height);

}

#pragma mark UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kSCUsernameTextFieldTag:
            self.username = textField.text;
            break;

        case kSCPasswordTextFieldTag:
            self.password = textField.text;
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textColor = [UIColor colorWithRed:0.8
                                          green:0.8
                                           blue:0.8
                                          alpha:1.0];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kSCUsernameTextFieldTag:
            self.username = textField.text;
            break;

        case kSCPasswordTextFieldTag:
            self.password = textField.text;
            break;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case kSCUsernameTextFieldTag:
            self.username = textField.text;
            [self.passwordField becomeFirstResponder];
            break;

        case kSCPasswordTextFieldTag:
            self.password = textField.text;
            [self.passwordField resignFirstResponder];
//            [(SCLoginViewController *)self.superview login:nil];
            break;
    }

    return YES;
}

@end
