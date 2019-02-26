//
//  DrawerDeletegate.swift
//  DrawerCocoa
//
//  Created by Fatih Şen on 26.02.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public protocol DrawerDelegate {
	
	func drawerState(_ state: DrawerState, _ factor: CGFloat)
}
