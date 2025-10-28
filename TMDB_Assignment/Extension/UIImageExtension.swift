//
//  UIImageExtension.swift
//  TMDB_Assignment
//
//  Created by Tarun on 28/10/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
