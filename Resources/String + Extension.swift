//
//  String + Extension.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import Foundation
extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
