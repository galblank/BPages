//
//  definitions.h
//  missingkids
//
//  Created by Gal Blank on 9/30/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#ifndef definitions_h
#define definitions_h


#define THEME_WARNING_COLOR [UIColor colorWithRed:245.0 / 255.0 green:203.0  / 255.0 blue:34.0 / 255.0 alpha:1.0]
#define TITLE_HEADER_COLOR [UIColor colorWithRed:133.0 / 255.0 green:150.0  / 255.0 blue:166.0 / 255.0 alpha:1.0]
#define THEME_GRAY_BG_COLOR [UIColor colorWithRed:243.0 / 255.0 green:243.0  / 255.0 blue:243.0 / 255.0 alpha:1.0]

#define GRAY_BG_COLOR [UIColor colorWithRed:240.0 / 255.0 green:240.0  / 255.0 blue:240.0 / 255.0 alpha:1.0]
#define TITLE_BUTTONS_COLOR [UIColor colorWithRed:11 / 255.0 green:192  / 255.0 blue:255.0 / 255.0 alpha:1.0]

#define THEME_COLOR_DISABLED [UIColor colorWithRed:105.0 / 255.0 green:217.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]

#define AwsBucketUrl     @"http://s3.amazonaws.com"


#define ROOT_API    @"http://www.backpage.com"
#define API_SUFFIX  @"/online/api/"


#define DEFAULT_TTL 15.0
#define TTL_NOW 0.5;
#define CLEANUP_TIMER 10.0

typedef enum{
    MENU_COUNTRY = 0,
    MENU_STATE,
    MENU_CITY,
    MENU_SECTION,
    MENU_CATEGORY
}MENU_TYPES;

#define ROOT_IMAGES @"http://www.missingkids.com/photographs/"

typedef enum{
    MENU_BUTTON_MENU = 0,
    MENU_BUTTON_BACK
}MENU_BUTTON_TYPE;


typedef enum{
    ITEM_TYPE_COUNTRY = 0,
    ITEM_TYPE_STATE,
    ITEM_TYPE_CITY
}ITEMTYPE;

#endif /* definitions_h */
