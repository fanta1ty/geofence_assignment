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
        return mainAssemblerResolver.resolve(Store.self)!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStoredGeofence()
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
        mapView.delegate = self
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
        viewModel.output
            .onStartAddAction
            .drive(onNext: { [weak self] in
                self?.navigateToAddScreen()
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartListAction
        viewModel.output
            .onStartListAction
            .drive(onNext: { [weak self] in
                self?.navigateToListScreen()
            })
            .disposed(by: disposeBag!)
        
        // MARK: onRequestLocationServiceAction
        viewModel.input
            .onRequestLocationServiceAction
            .onNext(())
        
        // MARK: onLocationAuthAction
        viewModel.output
            .onStartLocationAuthAction
            .subscribe(onNext: { [weak self] auth in
                switch auth {
                case .authorized:
                    self?.mapView.showsUserLocation = true
                    self?.viewModel.input
                        .onGetCurrentLocationAction
                        .onNext(())
                    
                default:
                    self?.mapView.showsUserLocation = false
                }
            })
            .disposed(by: disposeBag!)
        
        // MARK: onGetCurrentLocationAction
        viewModel.output
            .onStartCurrentLocationAction
            .subscribe(onNext: { [weak self] coordinate in
                self?.focusToCurrentLocation(coordinate: coordinate)
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartAddGeofenceAction
        viewModel.output
            .onStartAddGeofenceAction
            .subscribe(onNext: { [weak self] geofence in
                self?.addGeofenceOnMap(geofence: geofence)
                self?.viewModel.input
                    .onMonitorGeofenceAction.onNext(())
            })
            .disposed(by: disposeBag!)
        
        // MARK: onMonitorGeofenceAction
        viewModel.input
            .onMonitorGeofenceAction.onNext(())
        
        // MARK:
        viewModel.output
            .onStartDeleteGeofenceAction
            .subscribe(onNext: { [weak self] geofence in
                guard let self = self else { return }
                
                for overlay in self.mapView.overlays {
                    if let circleOverlay = overlay as? MKCircle {
                        if circleOverlay.coordinate.latitude == geofence.coordinate.latitude &&
                            circleOverlay.coordinate.longitude == geofence.coordinate.longitude &&
                            circleOverlay.radius == geofence.radius {
                            self.mapView.removeOverlay(circleOverlay)
                            break
                        }
                    }
                }
                
                for annotation in self.mapView.annotations {
                    if annotation.coordinate.latitude == geofence.coordinate.latitude && annotation.coordinate.longitude == geofence.coordinate.longitude {
                        self.mapView.removeAnnotation(annotation)
                        break
                    }
                }
                
                
                self.viewModel.input
                    .onMonitorGeofenceAction.onNext(())
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartEnterRegionAction
        viewModel.output
            .onStartEnterRegionAction
            .subscribe(onNext: { [weak self] region in
                guard let self = self else { return }
                self.showAlert(title: "Geofence",
                               message: "Did enter region: \(region)")
            })
            .disposed(by: disposeBag!)
        
        // MARK: onStartExitRegionAction
        viewModel.output
            .onStartExitRegionAction
            .subscribe(onNext: { [weak self] region in
                guard let self = self else { return }
                self.showAlert(title: "Geofence",
                               message: "Did exit region: \(region)")
            })
            .disposed(by: disposeBag!)
    }
}

// MARK: - MKMapViewDelegate
extension HomeVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKCircle else { return MKOverlayRenderer() }
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = .green
        circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.4)
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Geofence else { return nil }
        
        let identifier = "GeofenceView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView != nil {
            annotationView?.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        }
        
        return annotationView
    }
}

// MARK: - Private Functions
extension HomeVC {
    // MARK: navigateToAddScreen
    private func navigateToAddScreen() {
        let controller = mainAssemblerResolver.resolve(AddVC.self)!
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    // MARK: navigateToListScreen
    private func navigateToListScreen() {
        let controller = mainAssemblerResolver.resolve(ListVC.self)!
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    // MARK: focusToCurrentLocation
    private func focusToCurrentLocation(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: updateGeofenceOnMap
    private func addGeofenceOnMap(geofence: Geofence) {
        mapView.addAnnotation(geofence)
        
        let circleOverlay = MKCircle(center: geofence.coordinate,
                                     radius: geofence.radius)
    
        mapView.addOverlay(circleOverlay)
    }
    
    // MARK: loadStoredGeofence
    private func loadStoredGeofence() {
        let geofenceDataStore = mainAssemblerResolver.resolve(LocalGeofenceDataStore.self)!
        _ = geofenceDataStore.get()
            .done { [weak self] geofences in
                for geofence in geofences {
                    self?.addGeofenceOnMap(geofence: geofence)
                }
            }
    }
    
    // MARK: showSimpleAlertWithTitle
    private func showAlert(title: String!,
                           message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        
        navigationController?.present(alert,
                                      animated: true,
                                      completion: nil)
    }
}
