//
//  CardItem.swift
//  CardItem
//
//  Created by chq on 2018/1/27.
//  Copyright © 2018年 chq. All rights reserved.
//

import UIKit

protocol CardItemDelegate: AnyObject {
    func removeFromSuperView(item: CardItem)
}

class CardItem: UIView {
    
    override var frame: CGRect {
        didSet {
            originalCenter = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        }
    }
    
    weak var delegate: CardItemDelegate?
    
    /// 子视图最好加在contentView上
    var contentView: UIView
    var cornerRadius: CGFloat = 5
    var originalCenter: CGPoint
    var currentAngle: CGFloat = 0
    var isRight = false
    var isDown = false
    /// 如果不想让item可以拖动可以设置为false, 默认是true
    var isPan = true
    
    override init(frame: CGRect) {
        originalCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        contentView = UIView()
        super.init(frame: frame)
        addSubview(contentView)
        addPanGesture()
        layout()
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    
    func addPanGesture() {
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    func layout() {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        contentView.layer.shouldRasterize = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    @objc func panGesture(_ pan: UIPanGestureRecognizer) {
        guard isPan else { return }
        if pan.state == .changed {
            let movePoint = pan.translation(in: self)
            isRight = movePoint.x > 0
            isDown = movePoint.y > 0
            center = CGPoint(x: center.x + movePoint.x, y: center.y + movePoint.y)
            currentAngle = (center.x - frame.width * 0.5) / frame.width / 4.0
            transform = CGAffineTransform(rotationAngle: currentAngle)
            pan.setTranslation(CGPoint.zero, in: self)
        } else if pan.state == .ended {
            let vel = pan.velocity(in: self)
            if vel.x > 800 {
                remove(with: .right, angle: currentAngle)
                return
            } else if vel.x < -800 {
                remove(with: .left, angle: currentAngle)
                return
            } else if vel.y > 800 {
                remove(with: .down, angle: currentAngle)
                return
            } else if vel.y < -800 {
                remove(with: .up, angle: currentAngle)
                return
            }
            
            if (frame.origin.x + frame.width > 150 && frame.origin.x < frame.width - 150) &&
                (frame.origin.y + frame.height > 150 && frame.origin.y < frame.height - 150) {
                UIView.animate(withDuration: 0.5, animations: {
                    [weak self] in guard let `self` = self else { return }
                    self.center = self.originalCenter
                    self.transform = CGAffineTransform.identity
                })
            } else {
                let distanceX = center.x - originalCenter.x
                let distanceY = center.y - originalCenter.y
                if abs(distanceX) > abs(distanceY) {
                    remove(with: distanceX > 0 ? .right : .left, angle: currentAngle)
                } else {
                    remove(with: distanceY > 0 ? .down : .up, angle: currentAngle)
                }
            }
        }
    }
    
    /// 移除item
    ///
    /// - Parameters:
    ///   - direction: 移除方向
    ///   - angle: 移除时候的角度,默认0
    func remove(with direction: CardDirection = .right, angle: CGFloat = 0) {
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in guard let `self` = self else { return }
            switch direction {
            case .up:
                self.center = CGPoint(x: self.center.x + self.currentAngle * self.frame.width + angle, y: self.frame.height - 1000)
            case .left:
                self.center = CGPoint(x: -1000, y: self.center.y + self.currentAngle * self.frame.height + angle)
            case .down:
                self.center = CGPoint(x: self.center.x + self.currentAngle * self.frame.width + angle, y: 1000)
            case .right:
                self.center = CGPoint(x: self.frame.width + 1000, y: self.center.y - self.currentAngle * self.frame.height + angle)
            }
        }) { [weak self] (_) in
            guard let `self` = self else { return }
            self.removeFromSuperview()
            self.delegate?.removeFromSuperView(item: self)
        }
    }
    
}
