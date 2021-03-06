//
//  TwoRowStack.swift
//  workoutApp
//
//  Created by Alexander Kvamme on 23/05/2017.
//  Copyright © 2017 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

fileprivate var stackFont: UIFont = UIFont.custom(style: .bold, ofSize: .medium)

public class TwoRowStack: UIStackView {
    
    var topRow = UILabel()
    var bottomRow = UILabel()
    
    init(topText: String, bottomText: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        setTopLabel(topText)
        
        bottomRow.text = bottomText.uppercased()
        bottomRow.font = stackFont
        bottomRow.textColor = .lightest
        topRow.textAlignment = .center
        bottomRow.sizeToFit()
    
        addArrangedSubview(topRow)
        addArrangedSubview(bottomRow)
        
        setupStack()
    }
    
    convenience init(topText: String, sets: Int, reps: Int) {
        self.init(topText: topText, bottomText: "replace with attributedString")
        self.setTopLabel(topText)

        let attrString = NSMutableAttributedString(string: "\(sets)")
        let xmark = NSTextAttachment()
        xmark.image = UIImage(named: "xmarkBeige")
        xmark.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
        let stringifiedXmark = NSAttributedString(attachment: xmark)
        attrString.append(stringifiedXmark)
        attrString.append(NSAttributedString(string: "\(reps)"))
        
        bottomRow.attributedText = attrString
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Helpers
    
    private func setTopLabel(_ str: String) {
        topRow.text = str.uppercased()
        topRow.font = stackFont
        topRow.textColor = .light
        topRow.textAlignment = .center
        topRow.sizeToFit()
    }
    
    private func setupStack() {
        distribution = .equalCentering
        alignment = .center
        axis = .vertical
        spacing = 0
    }
}
