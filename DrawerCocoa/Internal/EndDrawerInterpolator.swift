//
//  EndDrawerInterpolator.swift
//  DrawerCocoa
//
//  Created by Fatih Şen on 26.02.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import UIKit

open class EndDrawerInterpoaltor: DrawerInterpolator {
	
	private let lowerBound: CGFloat
	private let upperBound: CGFloat
	private let drawerFrame: CGRect
	
	private let navigationView: UIView
	private let overlayView: UIView
	
	private var drawerState: DrawerState = .closed
	
	var drawerDelegate: DrawerDelegate? = nil
	
	init(lowerBound: CGFloat = 0, upperBound: CGFloat = 1, drawerFrame: CGRect = .zero, navigationView: UIView, overlayView: UIView) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
		self.drawerFrame = drawerFrame
		self.navigationView = navigationView
		self.overlayView = overlayView
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_ :)))
		self.overlayView.addGestureRecognizer(tap)
	}
	
	public func interpolate(_ sender: UIPanGestureRecognizer) {
		if isVelocityValid(sender) {
			let t = interpolateInternal(sender)
			// progress or alpha
			let p = 1 - t
			// translate alpha
			overlayView.alpha = p
			// translate view
			navigationView.transform = CGAffineTransform(translationX: drawerFrame.width * t, y: 0)
			// change state
			drawerState = .draging
			// will notify my drawer
			drawerDelegate?.drawerState(drawerState, p)
			// check if pan ended
			if sender.state == .ended {
				let a = abs(t)
				let newState: DrawerState = a >= 0.4 ? .closed : .opened
				animate(newState)
			}
		}
	}
	
	private func interpolateInternal(_ sender: UIPanGestureRecognizer) -> CGFloat {
		let translation = sender.translation(in: nil)
		let factor = translation.x / drawerFrame.width
		
		let t = factor < 0 ? factor + 1: factor
		return max(lowerBound, min(upperBound, t))
	}
	
	private func isVelocityValid(_ sender: UIPanGestureRecognizer) -> Bool {
		let velocity = sender.velocity(in: nil)
		switch drawerState {
			case .opened:
				return velocity.x > 0
			case .closed:
				return velocity.x < 0
			case .draging:
				return true
		}
	}
	
	private func animate(_ state: DrawerState) {
		if state == .closed || state == .opened {
			let t = state == .closed ? drawerFrame.width : 0
			let p: CGFloat = state == .closed ? 0 : 1
			
			UIView.animate(withDuration: 0.3, animations: {
				self.navigationView.transform = CGAffineTransform(translationX: t, y: 0)
				self.overlayView.alpha = p
			}) { _ in
				self.drawerState = state
				self.drawerDelegate?.drawerState(state, p)
			}
		}
	}
	
	@objc private func tap(_ sender: UITapGestureRecognizer) {
		if drawerState == .opened {
			animate(.closed)
		}
	}
}
