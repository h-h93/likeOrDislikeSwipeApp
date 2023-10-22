//
//  SwipeViewController.swift
//  likeOrDislike
//
//  Created by hanif hussain on 20/10/2023.
//

import UIKit
import Shuffle

class SwipeViewController: UIViewController {
    
    var swipeView = SwipeCardViewController()
    
    var cardImages = [UIImage]()
    
    
//    var imageViewOne: TinderSwipeView?
    
    var divisionParam: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //swipeableView.backgroundColor = .blue
        
        
        // initialise swipe gesture recogniser
        //let rightSwipeGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(didSwipe))
      //  let leftSwipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        // configure swipe gesture recogniser
//        rightSwipeGestureRecogniser.direction = .right
//        leftSwipeGestureRecogniser.direction = .left
        
        // add swipe gesture recogniser to view
        //swipeableView.addGestureRecognizer(rightSwipeGestureRecogniser)
        //swipeableView.addGestureRecognizer(leftSwipeGestureRecogniser)
        
        divisionParam = (view.frame.size.width/2)/0.61
        let image = UIImage(named: "hang in there.jpg")
        cardImages.append(UIImage(named: "hang in there cat.jpg")!)
        cardImages.append(UIImage(named: "hang in there cat.jpg")!)
        
        
        setupSwipeableView()
        swipeView.cardImages = cardImages
        swipeView.swipeableView.reloadData()
    }
    
    func setupSwipeableView() {
        
        //swipeableView.getCards(images: cardImages)
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(swipeView)
        //swipeableView.addSubview(imageViewOne)
        
        NSLayoutConstraint.activate([
            swipeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            swipeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            swipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            swipeView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    


}
