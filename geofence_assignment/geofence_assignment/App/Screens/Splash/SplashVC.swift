//
//  SplashVC.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import RxSwift
import ReSwift
import UIKit
import SVProgressHUD
import TSwiftHelper

final class SplashVC: BaseVC {
    
    // MARK: - UI Properties
    
    // MARK: - Local Properties
    let viewModel: SplashVM = SplashVM()
    private var disposeBag: DisposeBag?
    
    init() {
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = mainAssemblerResolver.resolve(HomeVC.self)!
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = nil
    }
    
    deinit {
        Log.verbose("\(nameOfClass) deinit")
    }
    
    // MARK: setupUI
    override func setupUI() {
        view.backgroundColor = .white
    }
    
    // MARK: setupRx
    override func setupRx() {
        disposeBag = DisposeBag()
    }
}

// MARK: - Private Functions
extension SplashVC {
    
}
