//
//  KeyboardObserverDelegate.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import UIKit

public protocol KeyboardObserverDelegate: NSObjectProtocol {
    func startObservingKeyboard()
    func keyboardWillShow(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval)
    func keyboardWillHide(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval)
}

public extension KeyboardObserverDelegate where Self: UIViewController {
    
    func startObservingKeyboard() {
        let infosFrom: (_ notification: Notification) -> ((frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval)?) = { notification in
            
            guard let userInfo = notification.userInfo,
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
            
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            return (frame: endFrame, animationOptions: animationCurve, animationDuration: duration)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let infos = infosFrom(notification) else { return }
            self?.keyboardWillShow(with: infos.frame,
                                   animationOptions: infos.animationOptions,
                                   animationDuration: infos.animationDuration)
        })
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let infos = infosFrom(notification) else { return }
            self?.keyboardWillHide(with: infos.frame,
                                   animationOptions: infos.animationOptions,
                                   animationDuration: infos.animationDuration)
        })
    }
    
    func keyboardWillShow(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) { }
    
    func keyboardWillHide(with frame: CGRect, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) { }
}

// MARK: - NEW KeyboardObserver

extension UIView {
    
    public var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return .none
    }
    
}

protocol KeyboardObserver {
    func startObservingKeyboard()
    func keyboardDidUpdate(height keyboardHeight: CGFloat)
    func keyboardDidClose()
    func keyboardDidOpen()
    func keyboardWillOpen()
    func keyboardWillClose()
    func keyboardWillOpenAnimated(keyboardY: CGFloat)
    func keyboardWillCloseAnimated(keyboardY: CGFloat)
}

extension KeyboardObserver where Self: UIViewController {
    
    func keyboardWillOpenAnimated(keyboardY: CGFloat) {
        if let firstResponder = view.firstResponder {
            let point = view.convert(
                CGPoint(
                    x: firstResponder.bounds.maxX,
                    y: firstResponder.bounds.maxY
                ),
                from: firstResponder
            )
            
            let diff = point.y - keyboardY
            if diff > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: -(diff + 10))
            } else {
                view.transform = .identity
            }
        }
        
        view.layoutIfNeeded()
    }
    
    func keyboardWillCloseAnimated(keyboardY: CGFloat) {
        view.transform = .identity
        view.layoutIfNeeded()
    }
    
}

extension KeyboardObserver {
    
    func startObservingKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main, using: { notification in
            guard let info = self.getInfo(from: notification) else { return }
            self.keyboardWillClose()
            
            UIView.animate(withDuration: info.duration, delay: TimeInterval(0), options: info.animationCurve, animations: {
                self.keyboardWillCloseAnimated(keyboardY: info.keyboardHeight)
            }, completion: { _ in
                // ...
            })
            
        })
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main, using: { notification in
            guard let info = self.getInfo(from: notification) else { return }
            self.keyboardWillOpen()
            
            UIView.animate(withDuration: info.duration, delay: TimeInterval(0), options: info.animationCurve, animations: {
                self.keyboardWillOpenAnimated(keyboardY: info.keyboardHeight)
            }, completion: { _ in
                // ...
            })
        })
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main, using: { notification in
            
            guard let info = self.getInfo(from: notification) else { return }
            
            UIView.animate(withDuration: info.duration, delay: TimeInterval(0), options: info.animationCurve, animations: {
                self.keyboardDidUpdate(height: info.keyboardHeight)
            }, completion: { _ in
                if info.keyboardHeight <= 0 {
                    self.keyboardDidClose()
                } else {
                    self.keyboardDidOpen()
                }
            })
            
        })
    }
    
    private func getInfo(from notification: Notification) -> (duration: TimeInterval, keyboardHeight: CGFloat, animationCurve: UIView.AnimationOptions)? {

        guard let userInfo = notification.userInfo else { return nil }
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
        
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        var keyboardHeight: CGFloat = 0
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            keyboardHeight = 0.0
        } else {
            keyboardHeight = endFrame.origin.y
        }
        
        return (duration: duration, keyboardHeight: keyboardHeight, animationCurve: animationCurve)
    }
    
    func keyboardDidUpdate(height keyboardHeight: CGFloat) { }
    
    func keyboardWillOpen() { }
        
    func keyboardWillClose() { }
        
    func keyboardDidClose() { }
    
    func keyboardDidOpen() { }
    
    func keyboardWillOpenAnimated(keyboardY: CGFloat) { }
    
    func keyboardWillCloseAnimated(keyboardY: CGFloat) { }
    
}
