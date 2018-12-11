//
//  HapticAlerts.swift
//  Best Movies
//
//  Created by Vitor Maura on 11/12/18.
//  Copyright © 2018 Vitor Maura. All rights reserved.
//

import UIKit

class HapticAlerts{
    class func HapticReturn(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    class func hapticReturnLight(){
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    class func hapticReturnSuccess(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    class func hapticReturnCancel(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

