//
//  ListVM.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import TSwiftHelper
import RxSwift
import RxCocoa
import MapKit

protocol ListInput {
    var onCancelAction: AnyObserver<()> { get }
}

protocol ListOutput {
    var onStartCancelAction: Driver<()> { get }
    var onStartDeleteGeofenceAction: DeleteGeofenceObservable { get }
}

final class ListVM {
    var input: ListInput {
        return self
    }
    
    var output: ListOutput {
        return self
    }
    var geofences: [Geofence] = [Geofence]()
    
    private var disposeBag: DisposeBag?
    
    private let cancelSubject = PublishSubject<()>()
    
    init() {
        disposeBag = DisposeBag()
    }
}

// MARK: - ListInput
extension ListVM: ListInput {
    var onCancelAction: AnyObserver<()> {
        return cancelSubject.asObserver()
    }
}

// MARK: - ListOutput
extension ListVM: ListOutput {
    var onStartCancelAction: Driver<()> {
        return cancelSubject.asDriver(onErrorJustReturn: ())
    }
    
    var onStartDeleteGeofenceAction: DeleteGeofenceObservable {
        return mainAssemblerResolver.resolve(DeleteGeofenceObservable.self,
                                             name: GeofenceStateType.delete.rawValue)!
    }
}
