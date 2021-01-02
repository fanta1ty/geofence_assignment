//
//  ListCell.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 1/2/21.
//

import Foundation
import UIKit
import TSwiftHelper
import ReSwift

final class ListCell: UITableViewCell {
    // MARK: UI Properties
    private let containerView = ViewHelper(style: ViewStyle(backgroundColor: .White))
    private let seperateView = ViewHelper(style: ViewStyle(backgroundColor: .Concrete))
    
    private let titleLb = LabelHelper(style: LabelStyle())
    private let detailTitleLb = LabelHelper(style: LabelStyle())
    
    private let deleteBtn = ButtonHelper(style: ButtonStyle(),
                                         normalImage: DefinedAssets.deleteIcon.rawValue.uiImage)
    private var localGeofence: Geofence?
    
    private var appStateStore: Store<AppState> {
        mainAssemblerResolver.resolve(Store.self)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Functions
extension ListCell {
    // MARK: loadData
    final func loadData(data: Geofence?) {
        guard let data = data else { return }
        localGeofence = data
        
        titleLb.text = "Lat: \(data.coordinate.latitude) \nLon: \(data.coordinate.longitude)\nId: \(data.identifier)"
        detailTitleLb.text = "Radius: \(data.radius) m\nType: \(data.type.name)"
    }
}

extension ListCell {
    // MARK: onDeleteBtn
    @objc final private func onDeleteBtn(_ sender: UIButton?) {
        guard let localGeofence = localGeofence else { return }
        appStateStore.dispatch(UpdateDeleteGeofenceAction(state: localGeofence))
    }
}

// MARK: - Private Functions
extension ListCell {
    // MARK: setupUI
    final private func setupUI() {
        selectionStyle = .none
        backgroundColor = DefinedColors.Clear.value
        
        // MARK: containerView
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // MARK: titleLb
        containerView.addSubview(titleLb)
        
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        // MARK: detailTitleLb
        containerView.addSubview(detailTitleLb)
        
        detailTitleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLb.snp.bottom).offset(8)
        }
        
        // MARK: seperateView
        containerView.addSubview(seperateView)
        
        seperateView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(detailTitleLb.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        // MARK: deleteBtn
        deleteBtn.addTarget(self, action: #selector(onDeleteBtn(_:)), for: .touchUpInside)
        containerView.addSubview(deleteBtn)
        
        deleteBtn.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.bottom.equalTo(seperateView.snp.top)
            make.width.equalTo(60)
        }
    }
}
