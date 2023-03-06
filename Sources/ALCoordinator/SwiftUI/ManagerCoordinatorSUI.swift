//
//  ManagerCoordinatorSUI.swift
//
//  Copyright (c) Andres F. Lozano
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import SwiftUI

public class ManagerCoordinatorSUI<Router: NavigationRouter> {
  
  
  // ---------------------------------------------------------------------
  // MARK: Helper funcs
  // ---------------------------------------------------------------------
  
  
  open func show(
    _ coordinator: Coordinator,
    router: Router,
    transitionStyle: NavigationTranisitionStyle? = nil,
    animated: Bool = true
  ) {
    let ctrl = buildHostingCtrl(view: router.view())
    handlePresentCtrl(
      ctrl,
      transitionStyle: transitionStyle ?? router.transition,
      coordinator: coordinator,
      animated: animated
    )
  }
  
  
  open func getTopCoordinator(mainCoordinator: Coordinator?) -> Coordinator? {
    guard let mainCoordinator else { return nil }
    return mainCoordinator.topCoordinator()
  }
  
  
  open func restartMainCoordinator(mainCoordinator: Coordinator?, animated: Bool, completion: (() -> Void)?){
    guard let mainCoordinator
    else { return }
    mainCoordinator.restart(animated: animated, completion: completion)
  }
  
  
  // ---------------------------------------------------------------------
  // MARK: Helper funcs
  // ---------------------------------------------------------------------
  
  
  private func buildHostingCtrl(view: some View) -> UIViewController {
    let ctrl = UIHostingController(rootView: view)
    return ctrl
  }
  
  
  private func handlePresentCtrl(
    _ ctrl: UIViewController,
    transitionStyle: NavigationTranisitionStyle,
    coordinator: Coordinator,
    animated: Bool
  ) {
    switch transitionStyle {
      case .presentModally:
        handlePresentCtrl(ctrl: ctrl, coordinator: coordinator, animated: animated)
      case .presentFullscreen:
        ctrl.modalPresentationStyle = .fullScreen
        handlePresentCtrl(ctrl: ctrl, coordinator: coordinator, animated: animated)
      case .push, .tab:
        handlePushCtrl(ctrl: ctrl, coordinator: coordinator, animated: animated)
      case .pushModally:
        coordinator.present(ctrl, animated: animated)
        //        handlePushTransition(ctrl, coordinator: coordinator, animated: animated)
    }
  }
  
  
  private func handlePushTransition(_ ctrl: UIViewController, coordinator: Coordinator, animated: Bool) {
    
  }
  
  
  private func handlePresentCtrl(ctrl: UIViewController, coordinator: Coordinator, animated: Bool) {
    if coordinator.root.viewControllers.isEmpty {
      coordinator.root.viewControllers = [ctrl]
    } else {
      coordinator.present(ctrl, animated: animated)
    }
  }
  
  
  private func handlePushCtrl(ctrl: UIViewController, coordinator: Coordinator, animated: Bool) {
    if coordinator.root.viewControllers.isEmpty {
      coordinator.root.viewControllers = [ctrl]
    } else {
      coordinator.push(ctrl, animated: animated)
    }
  }
}


