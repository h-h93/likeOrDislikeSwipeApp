//
//  SwipeCardViewController.swift
//  likeOrDislike
//
//  Created by hanif hussain on 22/10/2023.
//

import UIKit
import Shuffle

class SwipeCardViewController: UIView, SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    var cardImages = [UIImage]()
    var swipeableView = SwipeCardStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCards(images: [UIImage]) {
        cardImages = images
    }
    
    func setupView() {
        swipeableView = SwipeCardStack()
        swipeableView.translatesAutoresizingMaskIntoConstraints = false
        swipeableView.dataSource = self
        addSubview(swipeableView)
        NSLayoutConstraint.activate([
            swipeableView.topAnchor.constraint(equalTo: topAnchor),
            swipeableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    func card(fromImage image: UIImage) -> SwipeCard {
      let card = SwipeCard()
      card.swipeDirections = [.left, .right]
      card.content = UIImageView(image: image)
      
      let leftOverlay = UIView()
      leftOverlay.backgroundColor = .green
      
      let rightOverlay = UIView()
      rightOverlay.backgroundColor = .red
      
      card.setOverlays([.left: leftOverlay, .right: rightOverlay])
      
      return card
    }

    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(fromImage: cardImages[index])
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardImages.count
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
      }
    
    override var intrinsicContentSize: CGSize {
      //preferred content size, calculate it if some internal state changes
      return CGSize(width: 300, height: 300)
    }
}
