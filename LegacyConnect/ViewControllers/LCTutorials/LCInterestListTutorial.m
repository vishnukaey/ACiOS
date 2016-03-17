//
//  LCInterestListTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/17/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInterestListTutorial.h"

@interface LCInterestListTutorial ()
{
  IBOutlet UILabel *label1;
  IBOutlet UIView *view1;
}
@end

@implementation LCInterestListTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  NSString *labelString = @"This is your INTEREST menu. You\ncan use it to browse your favourite\ninterests or discover new ones.";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"INTEREST"];
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


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

