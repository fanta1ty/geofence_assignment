//
//  HomeVM.swift
//  geofence_assignment
//
//  Created by Thinh Nguyen on 12/30/20.
//

import Foundation
import TSwiftHelper
import RxSwift
import RxCocoa

protocol HomeInput {
    var onAddAction: AnyObserver<()> { get }
    var onListAction: AnyObserver<()> { get }
    var onRequestLocationServiceAction: AnyObserver<()> { get }
    var onGetCurrentLocationAction: AnyObserver<()> { get }
    var onMonitorGeofenceAction: AnyObserver<()> { get }
}

protocol HomeOutput {
    var onStartAddAction: Driver<()> { get }
    var onStartListAction: Driver<()> { get }
    var onStartLocationAuthAction: LocationAuthObservable { get }
    var onStartCurrentLocationAction: CurrentLocationObservable { get }
    var onStartAddGeofenceAction: AddGeofenceObservable { get }
    var onStartMonitorGeofenceAction: Driver<()> { get }
}

final class HomeVM {
    var input: HomeInput {
        return self
    }
    
    var output: HomeOutput {
        return self
    }
    
    private var disposeBag: DisposeBag?
    
    private let addSubject = PublishSubject<()>()
    private let listSubject = PublishSubject<()>()
    private let requestLocationServiceSubject = PublishSubject<()>()
    private let getCurrentLocationSubject = PublishSubject<()>()
    private let monitorGeofenceSubject = PublishSubject<()>()
    
    private let requestLocationServiceUC: (() -> RequestLocationServiceUC) = {
        mainAssemblerResolver.resolve(RequestLocationServiceUC.self)!
    }
    
    private let getCurrentLocationUC: (() -> GetCurrentLocationUC) = {
        mainAssemblerResolver.resolve(GetCurrentLocationUC.self)!
    }
    
    private let monitorGeofenceUC: (() -> MonitorGeofenceUC) = {
        mainAssemblerResolver.resolve(MonitorGeofenceUC.self)!
    }
    
    init() {
        disposeBag = DisposeBag()
        
        // MARK: requestLocationServiceSubject
        requestLocationServiceSubject
            .subscribe(onNext: { [weak self] in
                self?.requestLocationServiceUC().start()
            })
            .disposed(by: disposeBag!)
        
        // MARK: getCurrentLocationSubject
        getCurrentLocationSubject
            .subscribe(onNext: { [weak self] in
                self?.getCurrentLocationUC().start()
            })
            .disposed(by: disposeBag!)
        
        // MARK: monitorGeofenceSubject
        monitorGeofenceSubject
            .subscribe(onNext: { [weak self] in
                self?.monitorGeofenceUC().start()
            })
            .disposed(by: disposeBag!)
    }
    
    deinit {
        disposeBag = nil
    }
}

// MARK: - HomeInput
extension HomeVM: HomeInput {
    var onAddAction: AnyObserver<()> {
        return addSubject.asObserver()
    }
    
    var onListAction: AnyObserver<()> {
        return listSubject.asObserver()
    }
    
    var onRequestLocationServiceAction: AnyObserver<()> {
        return requestLocationServiceSubject.asObserver()
    }
    
    var onGetCurrentLocationAction: AnyObserver<()> {
        return getCurrentLocationSubject.asObserver()
    }
    
    var onMonitorGeofenceAction: AnyObserver<()> {
        return monitorGeofenceSubject.asObserver()
    }
}

// MARK: - HomeOutput
extension HomeVM: HomeOutput {
    var onStartAddAction: Driver<()> {
        return addSubject.asDriver(onErrorJustReturn: ())
    }
    
    var onStartListAction: Driver<()> {
        return listSubject.asDriver(onErrorJustReturn: ())
    }
    
    var onStartLocationAuthAction: LocationAuthObservable {
        return mainAssemblerResolver.resolve(LocationAuthObservable.self,
                                             name: LocationStateType.LocationAuthStatus.rawValue)!
    }
    
    var onStartCurrentLocationAction: CurrentLocationObservable {
        return mainAssemblerResolver.resolve(CurrentLocationObservable.self,
                                             name: LocationStateType.CurrentLocation.rawValue)!
    }
    
    var onStartAddGeofenceAction: AddGeofenceObservable {
        return mainAssemblerResolver.resolve(AddGeofenceObservable.self,
                                             name: GeofenceStateType.add.rawValue)!
    }
    
    var onStartMonitorGeofenceAction: Driver<()> {
        return monitorGeofenceSubject.asDriver(onErrorJustReturn: ())
    }
}

extension HomeVM {
    
}
