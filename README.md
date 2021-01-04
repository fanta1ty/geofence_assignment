# geofence assignment
# iOS PROJECT GUIDE

* *Project name*:  Geofence
* *Language*:  Swift 5
* *Support*:  iOS 12 and later
* *Dependency management*:  CocoaPods
* *Source Control*:  GIT with BitBucket
* *Flow chart*:

![alt text](https://github.com/fanta1ty/geofence_assignment/blob/master/ios_architect.png)

### 1. PROBLEM SOLVED
- Detect if the device is located inside of a geofence area.
- If device coordinates are reported outside of the zone, but the device still connected to the specific Wifi network, then the device is treated as being inside the geofence area.

### 2. PROJECT ARCHITECTURE
1. Organization:
    * ** App**: Contains all the code relate to UI/UX and logic from UI/UX 
        * Modules
        * Extension
        * DI
        * Others
        * Helper
    * ** Core**:
        * Usecase set
        * API set
        * DataStore set
        * Redux: State, Action, Reducer
        * Models: all the model for nesting app data 
        * Other utilities

2. *Protocol oriented programming*:
    * https://www.raywenderlich.com/148448/introducing-protocol-oriented-programming
    * https://academy.realm.io/posts/appbuilders-natasha-muraschev-practical-protocol-oriented-programming/
    * https://medium.com/ios-os-x-development/how-protocol-oriented-programming-in-swift-saved-my-day-75737a6af022

3. *Redux (ReSwift) for 1 direction data flow and app data store*:
    * Idea: For managing the unified app state and data flow so that we decide to use Redux to conform this demand, it would be fine for code base expandation among team members  and easy to code-base maintaining later on    
    * Concept:
    * https://medium.com/seyhunakyurek/unidirectional-data-flow-architecture-redux-in-swift-6fa2ed5c3c76
    * https://medium.com/monitisemea/using-redux-with-mvvm-on-ios-18212454d676
    * In our architect: Most of Redux action will be call to be executed from the UseCase, other Object like View, ViewModel, ViewController will interact with UseCase and by the way they're also the subscribers and listen the data change.
    
4. *UseCases*:
    * All the logic executions will be defined into usecase. 
    * Application will use usecase to process the logic such as: API call, do the local caching, process the image, photos....
    * Every UseCase normally contain 2 functions: start() and cancel()
    * Every UseCase normally handle all the logic execution behind the scene of application.
    * Initialize a UseCase should specify params: API provider, AppStateStore, DataStore and some parameter for input.
    * After a UseCase finish the logic, new action will be send to Reducer(Redux) and change some state from AppStateStore then App UI can receive the change and do the UI update.
    * Example: in the project normally we has has a module User so we will create a groups of UseCase relate to User module such as: LoginUseCase, RegisterUseCase, GerPorfileUseCase, UpdateProfileUseCase, CacheProfileDataUseCase, UploadProfileImageUseCase ...
    

5. *RxSwift and RxCocoa for UI processing and data binding*:
    * RxSwift will use in the App State, all app state should be wrapped by Variable or BehaviorSubject.
    * https://www.raywenderlich.com/138547/getting-started-with-rxswift-and-rxcocoa
    * RxSwift and RxCocoa will be the main coding style
    * From logic and UI binding RxSwift combine with MVVM pattern will be the best choice
    * Data change from AppState will be handled from ViewModel, ViewModel will emit change to UI via RxSwift and RxCocoa
    * Only use RxSwift and RxCocoa from the App UI, Redux and PromiseKit will be replace from the App Core.


### 3. 3RD PARTY LIBRARY
   1. ReSwift
   2. RxSwift
   3. PromiseKit
   4. RxCocoa
   5. RxBlocking
   6. SnapKit
   7. Swinject
   8. IQKeyboardManager
   9. TSwiftHelper
   10. SVProgressHUD
   11. SwiftLocation
   12. RxTest
