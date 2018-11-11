//
//  Extension.swift
//  NewsApp-URLSessionAndCodeable
//
//  Created by Win Than Htike on 11/9/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImageUsingUrlString(url : String) {
        
        if let url = URL(string: url) {
         
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
                
                }.resume()
            
        } else {
            self.image = UIImage(named: "news")
        }
        
    }
    
}
