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
}

protocol HomeOutput {
    var onStartAddAction: Driver<()> { get }
    var onStartListAction: Driver<()> { get }
    var onStartLocationAuthAction: LocationAuthObservable { get }
    var onStartCurrentLocationAction: CurrentLocationObservable { get }
    var onStartAddGeofenceAction: AddGeofenceObservable { get }
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
    
    private let requestLocationServiceUC: (() -> RequestLocationServiceUC) = {
        mainAssemblerResolver.resolve(RequestLocationServiceUC.self)!
    }
    
    private let getCurrentLocationUC: (() -> GetCurrentLocationUC) = {
        mainAssemblerResolver.resolve(GetCurrentLocationUC.self)!
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
}

extension HomeVM {
    
}
