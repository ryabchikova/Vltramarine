//
//  ApplicationAssembly.swift
//  Vltramarine
//
//  Created by Ryabchikova Elena on 28/06/2018.
//  Copyright © 2018 ryabchikova. All rights reserved.
//

import Foundation
import Typhoon

class ApplicationAssembly: TyphoonAssembly {
    
    @objc dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) as AnyObject
    }
    
//    // UI
//    @objc dynamic func menuViewController() -> AnyObject {
//
//        return TyphoonDefinition.withClass(MenuViewController.self, configuration: { definition in
////            definition!.useInitializer(Selector("initWithViewModel:"), parameters: { initializer in
////                initializer!.injectParameter(with: self.menuViewModel())
////            })
//
//            definition!.injectProperty(Selector("viewModel"), with: self.menuViewModel())
//
//        }) as AnyObject
//    }
    
    
    // View molels
    
    @objc dynamic func menuViewModel() -> AnyObject {
        return TyphoonDefinition.withClass(MenuViewModel.self) as AnyObject
    }
    
    // DAO
    
}
