//
//  ListVC.swift
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

final class ListVC: BaseVC {
    // MARK: - UI Properties
    private let topView = UIView(frame: .zero)
    
    private let topTitleLb = LabelHelper(style: LabelStyle(textFont: .InterBold(size: 18),
                                                           textAlignment: .center),
                                         text: "List Geofences")
    private let topCancelTitleLb = LabelHelper(style: LabelStyle(textColor: .Cerulean,
                                                                 textFont: .InterRegular(size: 18)),
                                               text: "Back")
    private let topCancelBtn = ButtonHelper(style: ButtonStyle())
    
    private let tableView = TableViewHelper(style: TableViewStyle(),
                                            cellClasses: [ListCell.self],
                                            cellIdentifiers: [ListCell.reuseIdentifier])
    
    // MARK: - Local Properties
    private var appStateStore: Store<AppState> {
        return mainAssemblerResolver.resolve(Store.self)!
    }
    
    let viewModel: ListVM = ListVM()
    private var disposeBag: DisposeBag?
    
    init() {
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
            .get()
            .done({ [weak self] geofences in
                self?.viewModel.geofences = geofences
                self?.tableView.reloadData()
            })
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
            make.height.equalTo(60)
        }
        
        // MARK: topTitleLb
        topView.addSubview(topTitleLb)
        
        topTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // MARK: topCancelTitleLb
        topView.addSubview(topCancelTitleLb)
        
        topCancelTitleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(topTitleLb)
        }
        
        // MARK: topCancelBtn
        topView.addSubview(topCancelBtn)
        
        topCancelBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        // MARK: tableView
        tableView.registerCells()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(16)
        }
    }
    
    // MARK: setupRx
    override func setupRx() {
        disposeBag = DisposeBag()
        
        // MARK: topCancelBtn
        topCancelBtn.rx.tap
            .bind(to: viewModel.input.onCancelAction)
            .disposed(by: disposeBag!)
        
        // MARK: onStartCancelAction
        viewModel.output.onStartCancelAction
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartDeleteGeofenceAction
        viewModel.output.onStartDeleteGeofenceAction
            .subscribe(onNext: { [weak self] geofence in
                self?.viewModel.geofences.removeAll(where: { $0.identifier == geofence.identifier })
                _ = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
                    .remove(geofence)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag!)
    }
}

// MARK: - UITableViewDataSource
extension ListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.geofences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier,
                                                       for: indexPath) as? ListCell else {
            return ListCell()
        }
        
        let item = viewModel.geofences[indexPath.row]
        
        cell.loadData(data: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ViewHelper(style: ViewStyle())
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = ViewHelper(style: ViewStyle())
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Private Functions
extension ListVC {
    
}
