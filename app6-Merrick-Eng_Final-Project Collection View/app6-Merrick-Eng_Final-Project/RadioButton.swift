//
//  RadioButton.swift
//  app6-Merrick-Eng_Final-Project
//
//  Code borrowed from crubio
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor(named: "Forest Green")?.cgColor
                UIColor.lightGray
                self.layer.backgroundColor = UIColor(named: "Forest Green")?.cgColor
                self.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                self.layer.borderColor = UIColor(named: "Tan")?.cgColor
                self.layer.backgroundColor = UIColor(named: "Tan")?.cgColor
                self.setImage(nil, for: .normal)
            }
        }
    }
}
