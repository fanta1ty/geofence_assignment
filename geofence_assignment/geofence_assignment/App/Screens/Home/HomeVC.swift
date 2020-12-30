//
//  HomeVC.swift
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
import SnapKit
import MapKit

final class HomeVC: BaseVC {
    // MARK: - UI Properties
    private let topView = UIView(frame: .zero)
    
    private let topTitleLb = LabelHelper(style: LabelStyle(textFont: .InterBold(size: 18),
                                                           textAlignment: .center),
                                         text: "Home")
    private let topListTitleLb = LabelHelper(style: LabelStyle(textColor: .Cerulean,
                                                               textFont: .InterRegular(size: 18)),
                                             text: "List")
    
    private let addImageView = ImageViewHelper(style: ImageViewStyle(),
                                               iconImage: DefinedAssets.addIcon.rawValue.uiImage)
    
    private let mapView = MKMapView(frame: .zero)
    
    private let addBtn = ButtonHelper(style: ButtonStyle())
    private let topListBtn = ButtonHelper(style: ButtonStyle())
    
    // MARK: - Local Properties
    private var appStateStore: Store<AppState> {
        return mainAssemblerResolver.resolve(Store.self,
                                             name: CoreAssemblyType.Store.rawValue)!
    }
    
    let viewModel: HomeVM = HomeVM()
    private var disposeBag: DisposeBag?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // MARK: topView
        topView.makeBigShadow()
        topView.backgroundColor = .white
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // MARK: topTitleLb
        topView.addSubview(topTitleLb)
        
        topTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        // MARK: addImageView
        topView.addSubview(addImageView)
        
        addImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(topTitleLb)
            make.right.equalToSuperview().offset(-16)
        }
        
        // MARK: addBtn
        topView.addSubview(addBtn)
        
        addBtn.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(60)
        }
        
        // MARK: topListTitleLb
        topView.addSubview(topListTitleLb)
        
        topListTitleLb.snp.makeConstraints { make in
            make.centerY.equalTo(topTitleLb)
            make.left.equalToSuperview().offset(16)
        }
        
        // MARK: topListBtn
        topView.addSubview(topListBtn)
        
        topListBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        // MARK: mapView
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
    }
    
    // MARK: setupRx
    override func setupRx() {
        disposeBag = DisposeBag()
        
        // MARK: addBtn
        addBtn.rx.tap
            .bind(to: viewModel.input.onAddAction)
            .disposed(by: disposeBag!)
        
        // MARK: topListBtn
        topListBtn.rx.tap
            .bind(to: viewModel.input.onListAction)
            .disposed(by: disposeBag!)
        
        // MARK: onStartAddAction
        viewModel.output.onStartAddAction
            .drive(onNext: { [weak self] in
                self?.navigateToAddScreen()
            })
            .disposed(by: disposeBag!)
        
        viewModel.output.onStartListAction
            .drive(onNext: { [weak self] in
                self?.navigateToListScreen()
            })
            .disposed(by: disposeBag!)
    }
}

// MARK: - Functions
extension HomeVC {
    // MARK: navigateToAddScreen
    func navigateToAddScreen() {
        let controller = mainAssemblerResolver.resolve(AddVC.self)!
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func navigateToListScreen() {
        let controller = mainAssemblerResolver.resolve(ListVC.self)!
        navigationController?.present(controller, animated: true, completion: nil)
    }
}
