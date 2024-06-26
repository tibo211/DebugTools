//
//  UIWindow+Shake.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake,
              let store = DebugTools.sharedStore,
              !DebugTools.isConsolePresented else {
            return
        }
        
        let vc = UIHostingController(rootView: ConsoleView(store: store))
        rootViewController?.topMostViewController
            .present(vc, animated: true)
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
#endif
