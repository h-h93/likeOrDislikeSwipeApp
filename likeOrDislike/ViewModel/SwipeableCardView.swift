//
//  SwipeableCardViewDataSource.swift
//  likeOrDislike
//
//  Created by hanif hussain on 20/10/2023.
//

import Foundation
import UIKit

class SwipeableCardView: UIView {
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var originalCenter: CGPoint = .zero
    private var cardWidth: CGFloat = 0.0

    var onSwipeLeft: (() -> Void)?
    var onSwipeRight: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))

        cardWidth = frame.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
@objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: self)

    transform = CGAffineTransform(translationX: translation.x, y: translation.y)

    if gestureRecognizer.state == .ended {
        if abs(translation.x) > self.frame.width / 4 {
            animateOffScreen(inDirection: translation.x > 0 ? .right : .left)
        } else {
            animateBackToOriginalPosition()
        }
    }
}

private func animateOffScreen(inDirection direction: SwipeDirection) {
    let offScreenTransform: CGAffineTransform

    switch direction {
    case .right:
        offScreenTransform = CGAffineTransform(translationX: self.frame.width, y: 0)
    case .left:
        //self.transform = CGAffineTransform(rotationAngle: distanceMoved/divisionParam)
        offScreenTransform = CGAffineTransform(translationX: -self.frame.width, y: 0)
    }

    UIView.animate(withDuration: 0.3, animations: {
        self.transform = offScreenTransform
    }, completion: { _ in
        self.removeFromSuperview()
    })
}

private func animateBackToOriginalPosition() {
    UIView.animate(withDuration: 0.3) {
        self.transform = .identity
    }
}

}

enum SwipeDirection {
case right
case left
}
