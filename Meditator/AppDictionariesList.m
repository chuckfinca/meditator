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
                              APP_DESCRIPTION : @"Relax and get guided through meditations on a variety of topics dealing with the stresses of day-to-day life.\nUpdated frequently with new guides and meditations.\n\nFEATURES\n・Easy & effective step-by-step, voice-guided meditations\nShort (~5min), medium (~15min), and long (30+ min) meditations\n8 different guides (speakers)\n20+ FREE high quality meditations\n100+ high quality meditations\n14 FREE nature soundscapes\n20+ instrumental tracks\nLoop audio for continuous play\nDownload any meditation to listen without an internet connection\nEasy-to-use interface\nInstructions on how to use the app to meditate\nInformation about each guide\nMeditations for both beginners & experienced meditators\n\nTOPICS\nBody image\nChange\nCreativity\nHealth\nInsomnia\nLetting go\nMortality\nMotivation\nPain\nPregnancy\nStress\nWeight loss\nAnd many, many more!\n\nGUIDES\nBrad Austen\nGlenda Cedarleaf\nKerie Logan\nMarcelo Mansour\nDr. Emmett Miller\nYvonne Racine\nCandi Raudebaugh\nTravis Usinger\n\nREVIEWS\n“Love the variety of the meditations! - You can find the one or ones that are right for you.” - LawlwyL\n\n“Highest Recommendation - This app is rich in content even without in-app purchases. The new version works smoothly. This app is top quality throughout.” - Gates of Eden\n\n“One of the best apps i own. - Has helped me greatly in times I needed to de-stress, relax while crocheting, and even with my anxiety. This is my go-to app when I'm feeling the tension or I just want a few minutes to relax and gather myself.” - DoctorMom77\n\n“Guided Mind is a great app for guided meditation, whether you're a 'pro' or just getting started. The user interface is clean and easy to navigate and the app runs smooth as butter. It's also great that you can pick and choose which topics you want for incredibly low prices (these same GM Topics can cost anywhere from $5-$20 anywhere else). It's a great deal.” - syntheticvoid\n\n“Very helpful - By far and away the best guided imagery app I have found. With a vast range of in app purchases, there is something for everyone. This app is helping me through a tough time in my life and I appreciate this so much. Thanks to the developers.” - GubTrain\n\n\nMore topics are added frequently. If you or anyone you know would like to get their content in this app, please email support@appsimple.io.",
                              APP_SHORT_NAME : @"Guided Mind"};
            break;
            
        default:
            break;
    }
    return appDictionary;
}
@end
