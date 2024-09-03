//
//  BaseViewModel.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//

import Foundation

open class BaseViewModel : GeneralViewModel {
    public init(
        isLoading: [Bool] = .init(),
        mainUrl: String = "",
        testUrl: String = "",
        passedData : [AnyObject] = .init(),
        savedData : [String:Any] = .init(),
        drawerIndex : Int = 0,
        bottomNavIndex : Int = 0,
        shouldRestore : Bool = false,
        _ generalViewModel : GeneralViewModel? = nil
    ) {
        if let viewModel = generalViewModel {
            super.init(
                isLoading: [Bool](),
                mainUrl: viewModel.firebaseViewModel.mainUrl,
                testUrl: viewModel.firebaseViewModel.testUrl,
                passedData: viewModel.passedData,
                savedData: viewModel.savedData,
                isFirstTime: false,
                drawerIndex: 0,
                bottomNavIndex: 0,
                shouldRestore: false,
                firebaseViewModel: viewModel.firebaseViewModel
            )
        } else {
            super.init(isLoading: isLoading, mainUrl: mainUrl, testUrl: testUrl, passedData: passedData , savedData: savedData, drawerIndex: drawerIndex , bottomNavIndex: bottomNavIndex,shouldRestore: shouldRestore)
        }
    }
}
