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

protocol AddInput {
    var onCancelAction: AnyObserver<()> { get }
    var onCurrentLocationAction: AnyObserver<()> { get }
    var onSaveAction: AnyObserver<()> { get }
}

protocol AddOutput {
    var onStartCancelAction: Driver<()> { get }
    var onStartCurrentLocationAction: CurrentLocationObservable { get }
    var onStartSaveAction: Driver<()> { get }
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
    private let saveSubject = PublishSubject<()>()
    
    private let getCurrentLocationUC: (() -> GetCurrentLocationUC) = {
        mainAssemblerResolver.resolve(GetCurrentLocationUC.self)!
    }
    
    init() {
        disposeBag = DisposeBag()
        
        // MARK: getCurrentLocationSubject
        currentLocationSubject
            .subscribe(onNext: { [weak self] in
                self?.getCurrentLocationUC().start()
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
    
    var onSaveAction: AnyObserver<()> {
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
    
    var onStartSaveAction: Driver<()> {
        return saveSubject.asDriver(onErrorJustReturn: ())
    }
}
