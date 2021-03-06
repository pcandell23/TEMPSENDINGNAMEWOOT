//
//  DoneTrackingVC.swift
//  SendAR
//
//  Created by Bennett Baker on 7/30/20.
//  Copyright © 2020 Bennett Baker. All rights reserved.
//

import UIKit

class DoneTrackingVC: UIViewController {

    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    
    enum CardViewState {
        case expanded
        case normal
    }
    
    var cardViewState : CardViewState = .normal
    var cardPanStartingTopConstraint : CGFloat = 30.0
    
    var backingImage: UIImage?
    
    //Variables For Displaying Data
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var routeHeight: UILabel!
    @IBOutlet weak var routeTime: UILabel!
    
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var discardButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var discardButtonBottomConstraint: NSLayoutConstraint!
    
    var trackedRoute: TrackedRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDiscardButton()
        routeName.text = trackedRoute?.getName()
        if let heightInMeters = trackedRoute?.getElapsedAltitude() {
            routeHeight.text = String(format: "%.1f m", heightInMeters)
        }
        if let timeInSeconds = trackedRoute?.getElapsedTime() {
            routeTime.text = String(format: "%.2f minutes", (timeInSeconds / 60.0))
        }

        // update backing image view
        backingImageView.image          = backingImage
        
        //round top left and top right corners of card view
        cardView.clipsToBounds          = true
        cardView.layer.cornerRadius     = 10.0
        cardView.layer.maskedCorners    = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //hide the card view at the bottom when the view first load
        // '.windows.filter({$0.isKeyWindow}).first?' replaces '.keyWindow?'
        if let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height,let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        //set dimmer view to transparent
        dimmerView.alpha = 0.0
        
        //dimmerViewTapped() will be called when user taps on the dimmer view
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
        
        //add pan gesture to VC's view
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
        
        //round handle view
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        hideCardAndGoBack()
    }
    
    @IBAction func discardButtonPressed(_ sender: Any) {
        //TODO: delete route object from core data
        hideCardAndGoBack()
    }
    
    
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        //distance dragged; positive = down, negative = up
        let translation = panRecognizer.translation(in: self.view)
        
        //speed dragged
        let velocity = panRecognizer.velocity(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstraint = cardViewTopConstraint.constant
        case .changed:
            if self.cardPanStartingTopConstraint + translation.y > 30.0 {
                self.cardViewTopConstraint.constant = self.cardPanStartingTopConstraint + translation.y
            }
            dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint.constant)
        case .ended:
            //dismiss if user swipes down fast, expand if user swipes up fast
            if velocity.y > 1500.0 {
                //saves by default, then dismisses
                hideCardAndGoBack()
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.bottom {
                if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                    //show expanded
                    showCard(atState: .expanded)
                } else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
                    //show normal
                    showCard(atState: .normal)
                } else {
                    //saves by default, then dismisses
                    hideCardAndGoBack()
                }
            }
        default:
            break
        }
    }
    
    func setupDiscardButton() {
        discardButton.setTitleColor(.white, for: .normal)
        discardButton.backgroundColor       = UIColor.lightGray
        discardButton.layer.shadowColor     = UIColor.black.cgColor
        discardButton.layer.shadowOffset    = CGSize(width: 0.0, height: 0.0)
        discardButton.layer.shadowRadius    = 5
        discardButton.layer.shadowOpacity   = 0.25
        discardButton.layer.cornerRadius    = 5
        discardButton.clipsToBounds         = true
        discardButton.layer.masksToBounds   = false
        
        
        if let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height {
            discardButtonTopConstraint.constant = (safeAreaHeight - (44 + discardButtonBottomConstraint.constant))
        }
        
    }
    
    // MARK: - Animations
    private func showCard(atState: CardViewState = .normal) {
        self.view.layoutIfNeeded()
        
        //set top constraint
        if let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.bottom {
            
            if atState == .expanded {
                cardViewTopConstraint.constant = 30.0
            } else {
                cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2
            }
            
            cardPanStartingTopConstraint = cardViewTopConstraint.constant
        }
        
        //move card up by refreshing view, create new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        //show dimmer view
        showCard.addAnimations({
            self.dimmerView.alpha = 0.7
        })
        
        showCard.startAnimation()
    }
    
    private func hideCardAndGoBack() {
        //implement card moving downward animation, dimmer fade, dismiss current VC
        
        //ensure no pending layout changes
        self.view.layoutIfNeeded()
        
        //set new top constraint
        if let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.bottom {
            //move card view to bottom
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        //move card to bottom, create property animator
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        //hide dimmer
        hideCard.addAnimations {
            self.dimmerView.alpha = 0.0
        }
        
        //when animation completes, dismiss VC
        hideCard.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
        
        hideCard.startAnimation()
    }
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        
        //ensure safe area height and padding is not nil
        guard let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaLayoutGuide.layoutFrame.size.height, let bottomPadding = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.bottom else {
            return fullDimAlpha
        }
        
        //when card view top constraint is equal to this, dimmer view alpha is dimmest
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2
        //when this, lightest
        let noDimPosition = safeAreaHeight + bottomPadding
        
        //if card view top is less than fullDimPosition, it is dimmest
        if value < fullDimPosition {
            return fullDimAlpha
        }
    
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }

}
