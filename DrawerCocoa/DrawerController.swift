//
//  DrawerController.swift
//  DrawerCocoa
//
//  Created by Fatih Şen on 26.02.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import UIKit

open class DrawerController: UIViewController {
	
	open var navigationViewController: UIViewController? = nil
	open var contentViewController: UIViewController? = nil
	open var drawerGravity: DrawerGravity = .start
	
	open var drawerDelegate: DrawerDelegate? = nil

	private lazy var overlayView: UIView = {
		return UIView(frame: self.view.frame)
	}()
	
	private lazy var overlayColor: UIColor = {
		return UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
	}()
	
	private var interpolator: DrawerInterpolator = NoneDrawerInterpolator()
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		setUp()
	}
	
	open func setUp() {
		guard let navigationViewController = navigationViewController else {
			fatalError("you must specify navigation controller")
		}
		
		guard let contentViewController = contentViewController else {
			fatalError("you must specify content controller")
		}
		// add child controller
		addChild(contentViewController)
		contentViewController.view.bounds = self.view.bounds
		self.view.addSubview(contentViewController.view)
		contentViewController.didMove(toParent: self)
		// add overlay
		self.view.addSubview(overlayView)
		overlayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
		overlayView.alpha = 0
		// add navigation
		addChild(navigationViewController)
		let halfWidth = self.view.bounds.width / 2
		let height = self.view.bounds.height
		if drawerGravity == .start {
			navigationViewController.view.bounds = CGRect(x: 0, y: 0, width: halfWidth, height: height)
			navigationViewController.view.transform = CGAffineTransform(translationX: -halfWidth, y: 0)
			let inter = StartDrawerInterpoaltor(drawerFrame: navigationViewController.view.frame, navigationView: navigationViewController.view, overlayView: overlayView)
			inter.drawerDelegate = drawerDelegate
			interpolator = inter
		} else {
			navigationViewController.view.bounds = CGRect(x: halfWidth, y: 0, width: halfWidth, height: height)
			navigationViewController.view.transform = CGAffineTransform(translationX: halfWidth, y: 0)
			let inter = EndDrawerInterpoaltor(drawerFrame: navigationViewController.view.frame, navigationView: navigationViewController.view, overlayView: overlayView)
			inter.drawerDelegate = drawerDelegate
			interpolator = inter
		}
		self.view.addSubview(navigationViewController.view)
		navigationViewController.didMove(toParent: self)
		
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
		self.view.addGestureRecognizer(gesture)
	}
	
	@objc func pan(_ sender: UIPanGestureRecognizer) {
		interpolator.interpolate(sender)
	}
}
