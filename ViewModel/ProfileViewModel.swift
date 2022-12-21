//
//  ProfileViewModel.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 09/12/2022.
//

import Foundation
import UIKit
enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let color: UIColor
    let handler: (() -> Void)?
}

