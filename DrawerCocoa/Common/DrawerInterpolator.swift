//
//  DrawerInterpolator.swift
//  DrawerCocoa
//
//  Created by Fatih Şen on 24.02.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import UIKit

public protocol DrawerInterpolator {	
	func interpolate(_ sender: UIPanGestureRecognizer)
}
