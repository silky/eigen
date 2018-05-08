//
//  ARAcceptConditionsView.m
//  Artsy
//
//  Created by Luc Succes on 5/8/18.
//  Copyright © 2018 Artsy. All rights reserved.
//

#import "ARAcceptConditionsView.h"
#import "UIColor+ArtsyColors.h"
#import "ARFonts.h"

#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@interface ARAcceptConditionsView () <UITextViewDelegate>
@end

@implementation ARAcceptConditionsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupHelpTextLabel];
        [self setupCheckboxButton];
    }
    return self;
}


- (void)setupHelpTextLabel
{
    UIColor *textColor = [UIColor artsyGraySemibold];

    self.helpTextLabel = [UITextView new];
    self.helpTextLabel.scrollEnabled = NO;
    self.helpTextLabel.editable = NO;
    self.helpTextLabel.selectable = YES;
    self.helpTextLabel.bounces = NO;
    self.helpTextLabel.opaque = YES;
    self.helpTextLabel.tintColor = textColor;
    self.helpTextLabel.textContainerInset = UIEdgeInsetsZero;
    self.helpTextLabel.textContainer.lineFragmentPadding = 0;
    self.helpTextLabel.delegate = self;

    NSString *string = @"Please agree to Artsy's Terms of Use and Privacy Policy, and to receive emails from Artsy.";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                         attributes:@{
                                                                                                      NSFontAttributeName : [UIFont serifFontWithSize:20],
                                                                                                      NSForegroundColorAttributeName : textColor,
                                                                                                      NSParagraphStyleAttributeName: paragraphStyle
                                                                                                      }];
    
    NSRange termsRange = [attributedString.string rangeOfString:@"Terms of Use"];
    NSRange privacyRange = [attributedString.string rangeOfString:@"Privacy Policy"];
    [attributedString beginEditing];
    [attributedString addAttribute:NSLinkAttributeName
                             value:[NSURL URLWithString:@"/terms"]
                             range:termsRange];
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                             range:termsRange];
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:@(NSUnderlineStyleSingle)
                             range:privacyRange];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:[NSURL URLWithString:@"/privacy"]
                             range:privacyRange];
    
    [attributedString endEditing];
    
    [self.helpTextLabel setAttributedText:attributedString];
    [self addSubview:self.helpTextLabel];
    
    [self.helpTextLabel alignTopEdgeWithView:self predicate:@"0"];
    [self.helpTextLabel alignLeadingEdgeWithView:self predicate:@"20"];
    [self.helpTextLabel alignTrailingEdgeWithView:self predicate:@"-20"];
}

- (void)setupCheckboxButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"followButton"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"followButtonChecked"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"followButtonChecked"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"followButtonChecked"] forState:UIControlStateHighlighted];
    
    NSAttributedString *checkboxDescription = [[NSAttributedString alloc] initWithString:@"I agree"
                                                                              attributes:@{
                                                                                NSFontAttributeName: [UIFont serifFontWithSize:20],
                                                                                NSForegroundColorAttributeName: [UIColor artsyGraySemibold]
                                                                                }];
    
    [button setAttributedTitle:checkboxDescription forState:UIControlStateNormal];
    [button constrainTopSpaceToView:self.helpTextLabel predicate:@"0"];
    [button alignLeadingEdgeWithView:self predicate:@"20"];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4, 10, 0, 10)];
    [button constrainWidth:@"140"];
    [button constrainHeight:@"50"];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.enabled = @YES;
    
    [self addSubview:button];
    self.checkboxButton = button;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString *path = [[URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    if ([path isEqualToString:@"terms"]) {
        [[UIApplication sharedApplication] sendAction:@selector(openTerms) to:nil from:self forEvent:nil];
        
    } else if ([path isEqualToString:@"privacy"]) {
        [[UIApplication sharedApplication] sendAction:@selector(openPrivacy) to:nil from:self forEvent:nil];
    }
    
    return NO;
}


@end