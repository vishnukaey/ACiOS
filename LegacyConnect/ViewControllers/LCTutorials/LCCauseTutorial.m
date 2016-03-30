//
//  LCCauseTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/17/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCCauseTutorial.h"


@interface LCCauseTutorial ()
{
  IBOutlet UILabel *label1;
  IBOutlet UIView *view1;
}
@end

@implementation LCCauseTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [self setCauseLabels];
}


- (void)setCauseLabels
{
  NSString *labelString = @"This is a CAUSE page. Use it to find\n other people who support this\nCAUSE, to learn how they HELPED\nthis Cause and to discover\nOPPORTUNITIES for you to help,\ntoo. Support CAUSES to see their\nactivity in your FEED.";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"CAUSE", @"HELPED", @"OPPORTUNITIES", @"CAUSES", @"FEED"];
  // -- Add Font -- //
  [attributtedString addAttributes:@{
                                     NSFontAttributeName : self.lightFont,
                                     } range:NSMakeRange(0, attributtedString.length)];
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:self.colorFontGrey
                            range:NSMakeRange(0, labelString.length)];
  
  for(NSString *word in colorWords)//some words occur at more than one places... thats why this complexity
  {
    NSRange searchRange = NSMakeRange(0,labelString.length);
    NSRange foundRange;
    while (searchRange.location < labelString.length) {
      searchRange.length = labelString.length-searchRange.location;
      foundRange = [labelString rangeOfString:word options:0 range:searchRange];
      if (foundRange.location != NSNotFound) {
        // found an occurrence of the substring! do stuff here
        searchRange.location = foundRange.location+foundRange.length;
        [attributtedString addAttribute:NSForegroundColorAttributeName
                                  value:self.colorFontRed
                                  range:foundRange];
        [attributtedString addAttributes:@{
                                           NSFontAttributeName : self.boldFont,
                                           } range:foundRange];
      } else {
        // no more substring to find
        break;
      }
    }
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

