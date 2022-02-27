//
//  VDSRainingAnimation.swift
//  VDSRainAnimation
//
//  Created by Vimal Das on 24/02/22.
//

import UIKit

class VDSRainingAnimation: UIView {
    private let data = Array("abcdefghijklmnopqrstuvwxyz")

    private var horizontalStack: UIStackView = {
       let stckVw = UIStackView()
        stckVw.alignment = .fill
        stckVw.axis = .horizontal
        stckVw.distribution = .fillEqually
        return stckVw
    }()
            
    @IBInspectable
    var letterColor: UIColor = .green {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable
    var animationTime: CGFloat = 4 {
        didSet {
            refresh()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func refresh() {
        for sub in horizontalStack.arrangedSubviews {
            sub.removeFromSuperview()
        }
        setupStackviews()
    }
    
    private func initialSetup() {
        clipsToBounds = true
        
        addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        horizontalStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setupStackviews()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func setupStackviews() {
        for _ in 0...10 {
            let verticalStack = createVerticalStack()
            for (index, alphabet) in data.enumerated() {
                let lbl = createLabel(alphabet: String(describing: alphabet), index: index)
                verticalStack.addArrangedSubview(lbl)
            }

            horizontalStack.addArrangedSubview(verticalStack)
            let randomDelay = CGFloat.random(in: 0..<10) / 5
            animateDown(stackVw: verticalStack, delay: CGFloat(randomDelay))
        }
    }
    
    @objc private func timerAction() {
        for verticalStackView in horizontalStack.arrangedSubviews {
            for label in (verticalStackView as! UIStackView).arrangedSubviews {
                let text = String(data[Int.random(in: 0..<data.count)])
                (label as? UILabel)?.text = text
            }
        }
    }
    
    private func animateDown(stackVw: UIStackView, delay: CGFloat) {
        stackVw.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
        UIView.animate(withDuration: animationTime, delay: delay, options: [.repeat, .curveLinear]) {
            stackVw.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
        }
    }
    
    private func createVerticalStack() -> UIStackView {
        let verticalSV = UIStackView()
        verticalSV.alignment = .fill
        verticalSV.axis = .vertical
        verticalSV.distribution = .fillEqually
        verticalSV.spacing = 0
        return verticalSV
    }
    
    private func createLabel(alphabet: String, index: Int) -> UILabel {
        let alpha = index % data.count
        let lbl = UILabel()
        lbl.text = alphabet
        lbl.backgroundColor = .clear
        lbl.textColor = letterColor.withAlphaComponent(CGFloat(alpha)/25)
        lbl.textAlignment = .center
        print(alpha)
        return lbl
    }
}
