//
//  Model.swift
//  MSConnectionLib
//
//  Created by Moha on 9/4/24.
//


//import Foundation
//import SwiftUI
//
//open class Model : Equatable , Identifiable , Hashable {
//    public static func == (lhs: Model, rhs: Model) -> Bool {
//        if(lhs._id.isEmpty || rhs._id.isEmpty) {
//            return lhs.id == rhs.id
//        } else {
//            return lhs._id == rhs._id
//        }
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        if(_id.isEmpty) {
//            hasher.combine(id)
//        } else {
//            hasher.combine(_id)
//        }
//    }
//    
//    public var id: Int
//    public var _id: String
//    public var data:[String:AnyObject] = .init()
//    
//    public init (_ data:[String:AnyObject]) {
//        self.id = HandlingData.shared.getInt(data: data, dataName: "id")
//        self._id = HandlingData.shared.getString(data: data, dataName: "id")
//        self.data = data
//    }
//}
//
//open class ModelHasPaging {
//    public var paginationModel : PaginationModel = PaginationModel.init()
//    public var list : [Model] = .init()
//    
//    public init(_ data: [String: AnyObject] ,_ listName: String = "data") {
//        self.paginationModel = PaginationModel.init()
//        HandlingData.shared.fillListByName(jsonObject: data, jsonName: listName) { obj in
//            self.list.append(.init(obj))
//        }
//    }
//
//    public func setWithPaging(_ viewModel : BaseViewModel , shouldClearData:Bool = false){
//        viewModel.setPaging(self.paginationModel)
//        if(shouldClearData) {
//            viewModel.pagingList = .init()
//        }
//        if(viewModel.isLoadingMore){
//            viewModel.pagingList.append(contentsOf: self.list)
//            viewModel.networkViewModel.paginationViewModel.isLoadingMore = false
//        } else {
//            if(viewModel.pagingList.isEmpty) {
//                viewModel.pagingList = self.list
//            } else {
//                viewModel.pagingList.append(contentsOf: self.list)
//            }
//        }
//    }
//}

//
//struct PagingModifier : ViewModifier {
//    let viewModel : BaseViewModel
//    let lastItem : Model
//    let getDataFunc : ()->Void
//    
//    func body(content:Content) -> some View {
//        content
//            .onAppear { [self] in
//                if(viewModel.networkViewModel.paginationViewModel.hasNextPage) {
//                    if(viewModel.pagingList.last! == lastItem) {
//                        viewModel.networkViewModel.paginationViewModel.isLoadingMore = true
//                        getDataFunc()
//                    }
//                }
//            }
//    }
//    
//}
//
//public extension View {
//    @ViewBuilder
//    func initPaging(viewModel: BaseViewModel, lastItem: Model, getDataFunc: @escaping () -> Void)->some View{
//        modifier(PagingModifier(viewModel: viewModel, lastItem: lastItem, getDataFunc: getDataFunc))
//    }
//}
