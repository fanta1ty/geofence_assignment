//
//  AddVM.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import TSwiftHelper
import RxSwift
import RxCocoa
import MapKit

protocol AddInput {
    var onCancelAction: AnyObserver<()> { get }
    var onCurrentLocationAction: AnyObserver<()> { get }
    var onSaveAction: AnyObserver<Geofence> { get }
}

protocol AddOutput {
    var onStartCancelAction: Driver<()> { get }
    var onStartCurrentLocationAction: CurrentLocationObservable { get }
    var onStartSaveAction: AddGeofenceObservable { get }
}

final class AddVM {
    var input: AddInput {
        return self
    }
    
    var output: AddOutput {
        return self
    }

    private var disposeBag: DisposeBag?
    
    private let cancelSubject = PublishSubject<()>()
    private let currentLocationSubject = PublishSubject<()>()
    private let saveSubject = PublishSubject<Geofence>()
    
    private let getCurrentLocationUC: (() -> GetCurrentLocationUC) = {
        mainAssemblerResolver.resolve(GetCurrentLocationUC.self)!
    }
    
    private let addGeofenceUC: ((Geofence) -> AddGeofenceUC) = { geofence in
        mainAssemblerResolver.resolve(AddGeofenceUC.self,
                                      argument: geofence)!
    }
    
    init() {
        disposeBag = DisposeBag()
        
        // MARK: getCurrentLocationSubject
        currentLocationSubject
            .subscribe(onNext: { [weak self] in
                self?.getCurrentLocationUC().start()
            })
            .disposed(by: disposeBag!)
        
        // MARK: saveSubject
        saveSubject
            .subscribe(onNext: { [weak self] geofence in
                self?.addGeofenceUC(geofence).start()
            })
            .disposed(by: disposeBag!)
    }
    
    deinit {
        disposeBag = nil
    }
}

// MARK: - AddInput
extension AddVM: AddInput {
    var onCancelAction: AnyObserver<()> {
        return cancelSubject.asObserver()
    }
    
    var onCurrentLocationAction: AnyObserver<()> {
        return currentLocationSubject.asObserver()
    }
    
    var onSaveAction: AnyObserver<Geofence> {
        return saveSubject.asObserver()
    }
}

// MARK: - AddOutput
extension AddVM: AddOutput {
    var onStartCancelAction: Driver<()> {
        return cancelSubject.asDriver(onErrorJustReturn: ())
    }
    
    var onStartCurrentLocationAction: CurrentLocationObservable {
        return mainAssemblerResolver.resolve(CurrentLocationObservable.self,
                                             name: LocationStateType.CurrentLocation.rawValue)!
    }
    
    var onStartSaveAction: AddGeofenceObservable {
        return mainAssemblerResolver.resolve(AddGeofenceObservable.self,
                                             name: GeofenceStateType.add.rawValue)!
    }
}
