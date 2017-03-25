//
//  ScrollNumberLabel.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/23.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class ScrollNumberLabel: UIView {
    private(set) var number: UInt = 0
    var font = UIFont.systemFont(ofSize: 14) {
        didSet {
            for label in numberLabels {
                label.font = font
            }
        }
    }
    var textColor = UIColor.black {
        didSet {
            for label in numberLabels {
                label.textColor = textColor
            }
        }
    }
    
    fileprivate var numbers: [UInt] = []
    fileprivate var numberLabels: [CyclicNumberLabel] = []
    fileprivate lazy var containerView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        return view
    }()
    
    init(frame: CGRect, originNumber: UInt) {
        super.init(frame: frame)
        clipsToBounds = true
        number = originNumber
        addSubview(containerView)
        initNumberLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initNumberLabels() {
        numbers = getNumbersArray(from: number)
        let width = "9".widthWithConstrainedHeight(font.lineHeight, font: font)
        numberLabels = numbers.map { (value) -> CyclicNumberLabel in
            let label = CyclicNumberLabel(frame: CGRect(x: 0, y: 0, width: width, height: self.xb_height))
            label.font = self.font
            label.textColor = self.textColor
            label.change(toNewNumber: "\(value)", by: .add, isAnimation: false)
            return label
        }
        
        containerView.xb_width = ceil(CGFloat(numberLabels.count) * width)
        containerView.xb_height = xb_height
        containerView.center = CGPoint(x: xb_width/2, y: xb_height/2)
        var index = 0
        while index < numberLabels.count {
            let label = numberLabels[index]
            label.xb_left = CGFloat(index) * label.xb_width
            containerView.addSubview(label)
            index += 1
        }
    }
    
    fileprivate func resetNumberLabels(newValue: UInt) {
        for label in numberLabels {
            label.removeFromSuperview()
        }
        numberLabels.removeAll()
        
        let newNumbers = getNumbersArray(from: newValue)
        let numberCount = newNumbers.count
        var index: Int = 0
        let width = "9".widthWithConstrainedHeight(font.lineHeight, font: font)
        while index < numberCount {
            let label = CyclicNumberLabel(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: xb_height))
            label.font = self.font
            label.textColor = self.textColor
            label.change(toNewNumber: "\(newNumbers[index])", by: .add, isAnimation: false)
            
            index += 1
            numberLabels.append(label)
            containerView.addSubview(label)
        }
        
        containerView.xb_width = ceil(CGFloat(numberLabels.count) * width)
        containerView.xb_height = xb_height
        containerView.center = CGPoint(x: xb_width/2, y: xb_height/2)
    }
    
    fileprivate func getNewContainerView(from newValue: UInt) -> UIView {
        let containerView = UIView()
        let newNumbers = getNumbersArray(from: newValue)
        let numberCount = newNumbers.count
        var index: Int = 0
        let width = "9".widthWithConstrainedHeight(font.lineHeight, font: font)
        while index < numberCount {
            let label = CyclicNumberLabel(frame: CGRect(x: CGFloat(index) * width, y: 0, width: width, height: xb_height))
            label.font = self.font
            label.textColor = self.textColor
            label.change(toNewNumber: "\(newNumbers[index])", by: .add, isAnimation: false)
            
            index += 1
            containerView.addSubview(label)
        }
        
        containerView.xb_width = ceil(CGFloat(newNumbers.count) * width)
        containerView.xb_height = xb_height
        containerView.center = CGPoint(x: xb_width/2, y: xb_height/2)
        
        return containerView
    }
    
    fileprivate func setNumberLabels(to newNumbers: [UInt], type: CyclicNumberLabelType) {
        var index = 0
        while index < newNumbers.count {
            let label = numberLabels[index]
            label.change(toNewNumber: "\(newNumbers[index])", by: type)
            index += 1
        }
    }
    
    fileprivate func getNumbersArray(from number: UInt) -> [UInt] {
        let numberString = NSString(format: "%d", number)
        var numberArray: [UInt] = Array(repeating: 0, count: numberString.length)
        var index = 0
        while index < numberArray.count {
            numberArray[index] = UInt(numberString.substring(with: NSRange(location: index, length: 1))) ?? 0
            index += 1
        }
        
        return numberArray
    }
    
    func change(toNewNumber value: UInt) {
        if number == value {return}
        
        let oldValue = number
        let oldNumbersCount = numbers.count
        
        number = value
        numbers = getNumbersArray(from: value)
        
        let newNumbersCount = numbers.count
        if newNumbersCount == oldNumbersCount {
            let type = oldValue < value ? CyclicNumberLabelType.add : CyclicNumberLabelType.reduce
            setNumberLabels(to: numbers, type: type)
        } else {
            let type = newNumbersCount > oldNumbersCount ? CyclicNumberLabelType.add : CyclicNumberLabelType.reduce
            
            containerView.isHidden = true
            resetNumberLabels(newValue: number)
            
            var multiplier: CGFloat = 0
            if type == .add {
                multiplier = 1
            } else {
                multiplier = -1
            }
            
            let oldContainer = getNewContainerView(from: oldValue)
            oldContainer.xb_top = 0
            addSubview(oldContainer)
            
            let newContainer = getNewContainerView(from: value)
            newContainer.xb_top = multiplier * xb_height
            addSubview(newContainer)
            
            UIView.animate(withDuration: 0.25, animations: {
                oldContainer.xb_top = -multiplier * self.xb_height
                newContainer.xb_top = 0
            }, completion: { (finished) in
                oldContainer.removeFromSuperview()
                newContainer.removeFromSuperview()
                self.containerView.isHidden = false
            })
        }
    
    }
}


fileprivate enum CyclicNumberLabelType {
    case add, reduce
}

fileprivate class CyclicNumberLabel: UIView {
    var font = UIFont.systemFont(ofSize: 14) {
        didSet {
            topLabel.font = font
            centerLabel.font = font
            bottomLabel.font = font
        }
    }
    var textColor = UIColor.black {
        didSet {
            topLabel.textColor = textColor
            centerLabel.textColor = textColor
            bottomLabel.textColor = textColor
        }
    }
    
    fileprivate lazy var topLabel: UILabel = self.createLabel()
    fileprivate lazy var centerLabel: UILabel = self.createLabel()
    fileprivate lazy var bottomLabel: UILabel = self.createLabel()
    fileprivate lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0,
                                        y: -self.xb_height,
                                        width: self.xb_width,
                                        height: self.xb_height*3))
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configViews() {
        addSubview(containerView)
        
        topLabel.xb_top = 0
        containerView.addSubview(topLabel)
        
        centerLabel.xb_top = xb_height
        containerView.addSubview(centerLabel)
        
        bottomLabel.xb_top = xb_height * 2
        containerView.addSubview(bottomLabel)
    }
    
    fileprivate func createLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
    
    func change(toNewNumber value: String, by type: CyclicNumberLabelType, isAnimation: Bool = true) {
        if centerLabel.text == "\(value)" {return}
        
        if !isAnimation {return self.centerLabel.text = value}
        
        if type == .add {
            bottomLabel.text = value
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.xb_top = -2*self.xb_height
            }, completion: { (finished) in
                self.centerLabel.text = value
                self.containerView.xb_top = -self.xb_height
            })
        } else {
            topLabel.text = value
            UIView.animate(withDuration: 0.25, animations: { 
                self.containerView.xb_top = 0
            }, completion: { (finished) in
                self.centerLabel.text = value
                self.containerView.xb_top = -self.xb_height
            })
        }
    }
}
