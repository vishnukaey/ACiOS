//
//  LCProfileTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/17/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCProfileTutorial.h"

@interface LCProfileTutorial ()
{
  IBOutlet UILabel *label1;
  IBOutlet UIView *view1;
}
@end

@implementation LCProfileTutorial

- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  NSString *labelString = @"This is your ThatHelps PROFILE.\n\nWhen someone THANKS you it tells\nyou they think it made a difference\n\nHELPS are posts you make to share\nhow you've helped\n\nINTERESTS are the subjects you're\npassionate about\n\nOPPORTUNITIES are ways to help\nthat you've created";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"PROFILE", @"THANKS", @"HELPS", @"INTERESTS", @"OPPORTUNITIES"];
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
  
  [label1 setAttributedText:attributtedString];
  
  view1.backgroundColor = self.colorTransparentBlack;
}

@end

