//
//  LCNotificationsTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/17/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCNotificationsTutorial.h"

@implementation LCNotificationsTutorial

- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  NSString *labelString = @"This is your FEED. On it you’ll see all\nof the activity for your INTERESTS,\nCAUSES and FRIENDS. Use your\nFEED to learn how others are\nhelping, to THANKS them for helping\nand to find OPPORTUNITIES to help";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"FEED", @"INTERESTS", @"CAUSES", @"FRIENDS", @"FEED", @"THANKS", @"OPPORTUNITIES"];
  // -- Add Font -- //
  [attributtedString addAttributes:@{
                                     NSFontAttributeName : self.font,
                                     } range:NSMakeRange(0, attributtedString.length)];
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:self.colorFontGrey
                            range:NSMakeRange(0, labelString.length)];
  
  for(NSString *word in colorWords)
  {
    [attributtedString addAttribute:NSForegroundColorAttributeName
                              value:self.colorFontRed
                              range:[labelString rangeOfString:word]];
  }
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:self.lineSpacing];
  [attributtedString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, labelString.length)];
  
//  [label1 setAttributedText:attributtedString];
//  
//  view1.backgroundColor = self.colorTransparentBlack;
}

@end
