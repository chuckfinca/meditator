//
//  AppDictionariesList.m
//  mindtimer
//
//  Created by Charles Feinn on 7/24/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppDictionariesList.h"

@implementation AppDictionariesList

+(NSDictionary *)appDictionaryForID:(NSInteger)appID
{
    NSDictionary *appDictionary;
    switch (appID) {
        case 672076838:
            appDictionary = @{APP_NAME : @"Guided Mind – Relieve Stress & Suffering Caused By Anxiety, Insomnia, Pregnancy & More Using Guided Meditation, Imagery & Mindfulness",
                              APP_ICON_NAME : @"GuidedMind_AppIcon",
                              APP_SCREENSHOT_NAME : @"GuidedMind_Screenshot",
                              APP_DESCRIPTION : @"Relax and get guided through meditations on a variety of topics dealing with the stresses of day-to-day life.\n\nUpdated frequently with new guides and meditations.\n\nFEATURES\n・Easy & effective step-by-step, voice-guided meditations\n・Short (~5min), medium (~15min), and long (30+ min) meditations\n・8 different guides (speakers)\n・20+ FREE high quality meditations\n・100+ high quality meditations\n・14 FREE nature soundscapes\n・20+ instrumental tracks\n・Loop audio for continuous play\n・Download any meditation to listen without an internet connection\n・Easy-to-use interface\n・Instructions on how to use the app to meditate\n・Information about each guide\n・Meditations for both beginners & experienced meditators\n\nTOPICS\n・Body image\n・Change\n・Creativity\n・Health\n・Insomnia\n・Letting go\n・Mortality\n・Motivation\n・Pain\n・Pregnancy\n・Stress\n・Weight loss\n・And many, many more!\n\nGUIDES\n・Brad Austen\n・Glenda Cedarleaf\n・Kerie Logan\n・Marcelo Mansour\n・Dr. Emmett Miller\n・Yvonne Racine\n・Candi Raudebaugh\n・Travis Usinger\n\nREVIEWS\n\n“Love the variety of the meditations! - You can find the one or ones that are right for you.” - LawlwyL\n\n“Highest Recommendation - This app is rich in content even without in-app purchases. The new version works smoothly. This app is top quality throughout.” - Gates of Eden\n\n“One of the best apps i own. - Has helped me greatly in times I needed to de-stress, relax while crocheting, and even with my anxiety. This is my go-to app when I'm feeling the tension or I just want a few minutes to relax and gather myself.” - DoctorMom77\n\n“Guided Mind is a great app for guided meditation, whether you're a 'pro' or just getting started. The user interface is clean and easy to navigate and the app runs smooth as butter. It's also great that you can pick and choose which topics you want for incredibly low prices (these same GM Topics can cost anywhere from $5-$20 anywhere else). It's a great deal.” - syntheticvoid\n\n“Very helpful - By far and away the best guided imagery app I have found. With a vast range of in app purchases, there is something for everyone. This app is helping me through a tough time in my life and I appreciate this so much. Thanks to the developers.” - GubTrain\n\n\nMore topics are added frequently. If you or anyone you know would like to get their content in this app, please email support@appsimple.io.",
                              APP_SHORT_NAME : @"Guided Mind"};
            break;
            case 901569488:
            appDictionary =  @{APP_NAME : @"Mind Timer - The Simple Insight Meditation Timer",
                               APP_ICON_NAME : @"MindTimer_AppIcon",
                               APP_SCREENSHOT_NAME : @"MindTimer_Screenshot",
                               APP_DESCRIPTION : @"Mind Timer is a simple app that keeps track of the time while you meditate.\n\n\nFEATURES\n\n・Meditation intervals\n・5 high quality chime sounds\n・5 timer backgrounds\n・Easy-to-use interface\n・Instructions on how to use the app to meditate\n・Link to the Guided Mind app's library of guided meditations",
                               APP_SHORT_NAME : @"Mind Timer"};
            
        default:
            break;
    }
    return appDictionary;
}
@end
