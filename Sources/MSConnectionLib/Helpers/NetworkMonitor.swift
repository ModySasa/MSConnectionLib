//
//  NetworkMonitor.swift
//  MSConnectionLib
//
//  Created by systemira mobile on 15/10/2025.
//


import Network
import SwiftUI

public class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published public var isConnected = true
    @Published public var connectionType: NWInterface.InterfaceType?
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.usesInterfaceType(.wifi) ? .wifi :
                                       path.usesInterfaceType(.cellular) ? .cellular :
                                       path.usesInterfaceType(.wiredEthernet) ? .wiredEthernet : nil
            }
        }
        monitor.start(queue: queue)
    }
    
    public deinit {
        monitor.cancel()
    }
}
