//
//  SwipeCardViewController.swift
//  likeOrDislike
//
//  Created by hanif hussain on 22/10/2023.
//

import UIKit
import Shuffle
import UnsplashFramework

class SwipeCardViewController: UIView, SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    var cardPics = [UIImage]()
    var swipeableView = SwipeCardStack()
    let cardImages = CardImages()
    var likeLabel = UILabel()
    var dislikeLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardImages.delegate = self
        swipeableView.dataSource = self
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadImages(pics: [UIImage]) {
        cardPics = pics
        swipeableView.reloadData()
    }
    
    func setupView() {
        swipeableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(swipeableView)
        NSLayoutConstraint.activate([
            swipeableView.topAnchor.constraint(equalTo: topAnchor),
            swipeableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func card(fromImage image: UIImage) -> SwipeCard {
        likeLabel = UILabel(frame: CGRect(x: 0, y: 150, width: 100, height: 100))
        likeLabel.text = "like"
        likeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        likeLabel.textColor = .red
        
        dislikeLabel = UILabel(frame: CGRect(x: 195, y: 150, width: 100, height: 100))
        dislikeLabel.text = "dislike"
        dislikeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        dislikeLabel.textColor = .red
        
        
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = UIImageView(image: image)
        card.content?.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        card.content?.contentMode = .scaleAspectFill
        card.content?.clipsToBounds = true
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .clear
        leftOverlay.addSubview(dislikeLabel)
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .clear
        rightOverlay.addSubview(likeLabel)
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(fromImage: cardPics[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardPics.count
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize(width: 300, height: 300)
    }
}
