//
//  File.swift
//  Breakout
//
//  Created by Sakina Ali on 6/22/17.
//  Copyright © 2017 Sakina Ali. All rights reserved.
//

import Foundation

protocol Alertable { }
extension Alertable where Self: SKScene
{
    
    func showAlert(withTitle title: String, message: String)
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        { _ in }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    func showAlertWithSettings(withTitle title: String, message: String)
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url)
            } else
            {
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
}
