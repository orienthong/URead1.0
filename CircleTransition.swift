//
//  CircleTransition.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
public class CircleTransition: NSObject {
    
    public var startingPoint = CGPointZero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    /**
     Defaults to `0.5`
     */
    public var duration = 0.5
    
    public var bubbleColor: UIColor = .whiteColor()
    
    public private(set) var bubble = UIView()
    
}

extension CircleTransition: UIViewControllerAnimatedTransitioning {
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        let containerView = transitionContext.containerView()
        
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let originalCenter = presentedControllerView.center
        let originalSize = presentedControllerView.frame.size
        
        
        
        bubble = UIView()
        bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
        bubble.layer.cornerRadius = bubble.frame.size.height / 2
        bubble.center = startingPoint
        bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
        bubble.backgroundColor = bubbleColor
        containerView?.addSubview(bubble)
        
        //presentedControllerView.center = startingPoint
        //presentedControllerView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        presentedControllerView.alpha = 0.7
        containerView?.addSubview(presentedControllerView)
        
//        UIView.animateWithDuration(duration, animations: {
//            
//        })
        
        UIView.animateWithDuration(duration, animations: {
            self.bubble.transform = CGAffineTransformIdentity
            //presentedControllerView.transform = CGAffineTransformIdentity
            presentedControllerView.alpha = 1
            //presentedControllerView.center = originalCenter
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            //                    if !transitionContext.transitionWasCancelled() {
            //                        UIApplication.sharedApplication().keyWindow?.addSubview(presentedControllerView)
            //                    }
        }
    }
}

private extension CircleTransition {
    private func frameForBubble(originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x);
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPointZero, size: size)
    }
}
