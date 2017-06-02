//
//  Constants.swift
//  workoutApp
//
//  Created by Alexander Kvamme on 12/05/2017.
//  Copyright © 2017 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Fileprivate

fileprivate let standardBoxWidth: CGFloat = UIScreen.main.bounds.width - 2*Constant.components.Box.spacingFromSides
fileprivate let standardBoxHeight: CGFloat = 80

// MARK: - Globals

enum Constant {
    enum UI {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
    
    enum alpha {
        static let faded: CGFloat = 0.5
    }
    
    enum Attributes {
        enum letterSpacing {
            case medium
            case more
        }
    }
    
    enum components {
        enum Box {
            static let spacingFromSides: CGFloat = 10
            static let shimmerInset: CGFloat = 7
            
            enum Standard {
                static let height = standardBoxHeight
                static let width = standardBoxWidth
            }
            
            enum History {
                static let width = standardBoxWidth
                static let height = standardBoxHeight
            }
            enum Selection {
                static let width: CGFloat = standardBoxWidth / 2
                static let height: CGFloat = 60
            }
        }
        
        enum SelectionVC {
            enum Header {
                static let spacingTop: CGFloat = 100
            }
            
            enum Stack {
                static let spacing: CGFloat = 15
            }
        }
    }
}
