//
//  LoadingAnimation.swift
//  Rocket Go
//
//  Created by Gabriela Bezerra on 04/07/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import Foundation
import UIKit

class LoadingAnimation {
    
    static private var activityIndicatorView: UIActivityIndicatorView? = nil
    static private var bgView: UIView? = nil
    static private var isRunning: Bool = false
    
    static func run() {
        if !isRunning {
            if let keyWindow = UIApplication.shared.keyWindow
            {
                DispatchQueue.main.async {
                    activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                    bgView = UIView(frame: UIScreen.main.bounds)
                    guard let bgView = bgView, let activityIndicatorView = activityIndicatorView else { return }
                    
                    bgView.backgroundColor = UIColor.darkGray
                    bgView.alpha = 0.5
                    
                    keyWindow.addSubview(bgView)
                    keyWindow.addSubview(activityIndicatorView)
                    
                    bgView.center = CGPoint(x: keyWindow.center.x, y: keyWindow.center.y)
                    activityIndicatorView.center = CGPoint(x: keyWindow.center.x, y: keyWindow.center.y)
                    activityIndicatorView.startAnimating()
                }
                isRunning = true
            } else {
                print("Erro! Não foi possível encontrar a view controller atualmente visível na tela na hierarquia da keyWindow.")
            }
        }
    }
    
    static func stop() {
        if isRunning {
            isRunning = false
            guard let bgView = bgView, let activityIndicatorView = activityIndicatorView else {
                return
            }
            
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
                bgView.removeFromSuperview()
            }
        }
    }
    
}
