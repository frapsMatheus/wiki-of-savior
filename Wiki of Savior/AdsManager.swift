//
//  AdsManager.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/19/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsManager: NSObject,GADInterstitialDelegate {
    
    static let sharedInstance = AdsManager()
    let defaults = NSUserDefaults.standardUserDefaults()
    let ADS_COUNTER_KEY = "AdsCounter"
    var interstitial: GADInterstitial!
    
    private override init() {
        super.init()
        
        interstitial = createAndLoadInterstitial()
        
        if (defaults.objectForKey(ADS_COUNTER_KEY) == nil) {
            defaults.setObject(0, forKey: ADS_COUNTER_KEY)
        }
    }
    
    func showAd(vc:UIViewController){
        var adsCounter = defaults.objectForKey(ADS_COUNTER_KEY) as! Int
        adsCounter += 1
        if (adsCounter == 5) {
            adsCounter = 0
            if interstitial.isReady {
                interstitial.presentFromRootViewController(vc)
            }
        }
        defaults.setObject(adsCounter, forKey: ADS_COUNTER_KEY)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1164099775703792/3992176063")
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitial.loadRequest(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }

}
