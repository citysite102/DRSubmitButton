//
//  submitButton.swift
//  blastButton_s
//
//  Created by YU CHONKAO on 2016/7/20.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit

@objc public enum SubmitButtonState: Int {
    case normal = 0
    case loading = 1
    case success = 2
    case warning = 3
}

public class submitButton: UIView {
    
    // Color with default value
    var normalBackgrounColor: UIColor   = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var submitIconColor: UIColor        = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    var loadingBackgrounColor: UIColor  = UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0)
    var loadingIconColor: UIColor       = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    var successBackgroundColor: UIColor = UIColor(red: 65/255, green: 195/255, blue: 143/255, alpha: 1.0)
    var successIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var warningBackgroundColor: UIColor = UIColor(red: 1.0, green: 131/255, blue: 98/255, alpha: 1.0)
    var warningIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var shadowColor: UIColor            = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.5)
    
    // Custom UI Element
    var submitImage: UIImage! {
        didSet {
            self.submitImageView.image = submitImage;
        }
    }
    var successImage: UIImage! {
        didSet {
            self.submitImageView.image = submitImage;
        }
    }
    var warningImage: UIImage! {
        didSet {
            self.warningImageView.image = submitImage;
        }
    }
    
    // Custom UI Setting
    var shouldShowShadow: Bool = true {
        didSet {
            self.layer.shadowOpacity = shouldShowShadow ? 1.0 : 0.0;
        }
    }
    var buttonState: SubmitButtonState = .normal {
        didSet {
            switch buttonState {
            case .normal:
                self.performBackgroundColorAnimation(normalBackgrounColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            case .loading:
                self.performBackgroundColorAnimation(loadingBackgrounColor, completion: nil);
                self.loadingShapeLayer.hidden = false;
                self.performLoadingAnimation();
            case .success:
                self.performBackgroundColorAnimation(successBackgroundColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            case .warning:
                self.performBackgroundColorAnimation(warningBackgroundColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            }
        }
    }

    // Loading circle radius
    var kLoadingRadius: CGFloat         = 12
    
    // Private UI Element
    private var backgroundView: UIView!
    private var tapAnimationView: UIView!
    private var loadingShapeLayer: CAShapeLayer!
    private var tapMaskLayer: CAShapeLayer!
    private var submitImageView: UIImageView!
    private var successImageView: UIImageView!
    private var warningImageView: UIImageView!
    
    // Gesture
    private var tapGesture: UITapGestureRecognizer!
    
    // Target & Selector
    private var target: AnyObject?;
    private var selector: Selector?;
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Self Setting
        self.layer.shadowColor = shadowColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0;
        
        
        // Basic UI Element
        submitImageView = UIImageView.init(image: UIImage(named: "icon_submit")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        submitImageView.tintColor = submitIconColor;
        successImageView = UIImageView.init(image: UIImage(named: "icon_success")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        successImageView.tintColor = successIconColor;
        warningImageView = UIImageView.init(image: UIImage(named: "icon_warning")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate));
        warningImageView.tintColor = warningIconColor;
        successImageView.alpha = 0;
        warningImageView.alpha = 0;
        
        backgroundView = UIView.init();
        backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        backgroundView.backgroundColor = UIColor.whiteColor();
        backgroundView.layer.cornerRadius = self.frame.height / 2;
        
        tapAnimationView = UIView.init();
        tapAnimationView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        tapAnimationView.backgroundColor = loadingBackgrounColor;
        tapAnimationView.userInteractionEnabled = false;
        tapAnimationView.hidden = true;
        tapAnimationView.layer.cornerRadius = self.frame.height / 2;
        
        self.addSubview(backgroundView);
        self.addSubview(tapAnimationView);
        self.addSubview(submitImageView);
        self.addSubview(successImageView);
        self.addSubview(warningImageView);
        
        loadingShapeLayer = CAShapeLayer();
        loadingShapeLayer.strokeColor = loadingIconColor.CGColor;
        loadingShapeLayer.lineWidth   = 3.0;
        loadingShapeLayer.fillColor   = UIColor.clearColor().CGColor;
        loadingShapeLayer.lineCap     = kCALineCapRound;
        loadingShapeLayer.strokeEnd   = 0.8;
        loadingShapeLayer.hidden      = true;
        self.layer.addSublayer(loadingShapeLayer);
        
        // Autolayout
        setConstraintWithBackgroundView(submitImageView);
        setConstraintWithBackgroundView(successImageView);
        setConstraintWithBackgroundView(warningImageView);
        
        // Original transform
        self.successImageView.transform = CGAffineTransformIdentity;
        self.successImageView.transform = CGAffineTransformRotate(self.successImageView.transform, CGFloat(-M_PI_4/2));
        self.warningImageView.transform = CGAffineTransformIdentity;
        self.warningImageView.transform = CGAffineTransformRotate(self.warningImageView.transform, CGFloat(-M_PI_4/2));
        
        // Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(blastButton.handleSelfOnTapped(_:)));
        self.backgroundView.addGestureRecognizer(tapGesture);
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        self.loadingShapeLayer.path =
            UIBezierPath.init(ovalInRect: CGRectMake(CGRectGetWidth(self.frame)/2 - kLoadingRadius,
                                            CGRectGetHeight(self.frame)/2 - kLoadingRadius, 2 * kLoadingRadius, 2 * kLoadingRadius)).CGPath;
        self.loadingShapeLayer.frame = self.bounds;
    }
    
    private func setConstraintWithBackgroundView(constrainedImage: UIView) {
        constrainedImage.translatesAutoresizingMaskIntoConstraints = false;
        self.addConstraint(constrainedImage.centerXAnchor.constraintEqualToAnchor(backgroundView.centerXAnchor));
        self.addConstraint(constrainedImage.centerYAnchor.constraintEqualToAnchor(backgroundView.centerYAnchor));
    }
    
    // API
    
    func addTarget(target: AnyObject?, action: Selector) {
        self.target = target;
        self.selector = action;
    }
    
    // MARK: - Event
    
    func handleSelfOnTapped(gestureRecognizer: UITapGestureRecognizer) {
        if self.buttonState == .normal {
            self.performTapAnimation(gestureRecognizer.locationInView(self));
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.backgroundView.backgroundColor = self.loadingBackgrounColor;
                self.performSubmitHiddenAnimation();
                self.buttonState = .loading;
                if ((self.target?.respondsToSelector(self.selector!)) != nil) {
                    self.target?.performSelector(self.selector!, withObject: self);
                }
            }
        } else if self.buttonState == .loading {
            self.performAppearAnimation(self.successImageView, completion: nil);
            self.loadingShapeLayer.hidden = true;
            self.buttonState = .success;
        } else if self.buttonState == .success {
            self.performHiddenAnimation(self.successImageView, completion: nil);
            self.performAppearAnimation(self.warningImageView, completion: { (result: Bool) in
                if result {
                    self.performShakeAnimation(self.backgroundView, completion: nil);
                    self.performShakeAnimation(self.warningImageView, completion: nil);
                }
            });
            self.buttonState = .warning;
        } else {
            self.performHiddenAnimation(self.warningImageView, completion: nil);
            self.performSubmitAppearAnimation();
            self.buttonState = .normal;
        }
    }
    
    // MARK: - Animation
    
    private func performLoadingAnimation() {
        let spinAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation");
        spinAnimation.fromValue             = 0;
        spinAnimation.toValue               = M_PI * 2;
        spinAnimation.duration              = 0.8;
        spinAnimation.repeatCount           = Float.infinity;
        self.loadingShapeLayer.addAnimation(spinAnimation, forKey: nil);
    }
    
    private func performTapAnimation(point: CGPoint) {
        
        // Remove Old Mask Layer
        if self.tapMaskLayer != nil {
            self.tapMaskLayer.removeFromSuperlayer();
            self.tapMaskLayer = nil;
        }
        
        // Set Up Mask Layer
        self.tapAnimationView.hidden = false;
        self.tapMaskLayer = CAShapeLayer();
        self.tapMaskLayer.opacity = 1.0;
        self.tapMaskLayer.fillColor   = UIColor.greenColor().CGColor;
        self.tapMaskLayer.path = UIBezierPath.init(ovalInRect: CGRectMake(point.x - 150, point.y - 150, 300, 300)).CGPath;
        self.tapMaskLayer.frame = self.bounds;
        layer.addSublayer(tapMaskLayer);
        tapAnimationView.layer.mask = tapMaskLayer;
        
        // Animation
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale");
        scaleAnimation.fromValue = 0;
        scaleAnimation.toValue = 1.0;
        scaleAnimation.duration = 0.2;
        scaleAnimation.delegate = self;
        scaleAnimation.removedOnCompletion = false;
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        self.tapMaskLayer.addAnimation(scaleAnimation, forKey: "tapAnimation");
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim == self.tapMaskLayer.animationForKey("tapAnimation") {
            self.tapMaskLayer.opacity = 0.0;
        }
    }
    
    private func performHiddenAnimation(hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.3,
                                   animations: { 
                                    hiddenImage.alpha = 0.0;
                                    hiddenImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4/2));
        }) { (result: Bool) in
            hiddenImage.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2));
            completion?(true);
        }
    }
    
    private func performAppearAnimation(hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.5,
                                   animations: {
                                    hiddenImage.alpha = 1.0;
                                    hiddenImage.transform = CGAffineTransformMakeRotation(0);
        }) { (result: Bool) in
            completion?(true);
        }
    }
    
    private func performShakeAnimation(hiddenImage: UIView, completion: ((Bool) -> Void)?) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-6, 6, -6, 6, -4, 4, -3, 3, 0]
        hiddenImage.layer.addAnimation(translation, forKey: "shakeIt");
    }
    
    private func performSubmitHiddenAnimation() {
        UIView.animateWithDuration(0.4,
                                   animations: {
                                    self.submitImageView.alpha = 0.0;
                                    self.submitImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4/2));
                                    self.backgroundView.frame =
                                        CGRectMake((CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame))/2, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                                    
        }) { (result: Bool) in
            self.submitImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2));
        }
    }
    
    private func performSubmitAppearAnimation() {
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.submitImageView.alpha = 1.0;
                                    self.submitImageView.transform = CGAffineTransformMakeRotation(0);
                                    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        });
    }
    
    private func performBackgroundColorAnimation(backgroundColor: UIColor, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(0.4,
                                   animations: { 
                                    self.backgroundView.backgroundColor = backgroundColor;
        });
    }
    
}
