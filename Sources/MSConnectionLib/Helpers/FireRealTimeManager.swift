//
//  FireRealTimeManager.swift
//  MSConnectionLib
//
//  Created by Moha on 9/2/25.
//

import Firebase
import FirebaseDatabase

public actor FireRealTimeManager<C:Codable & Identifiable> {
    var ref: DatabaseReference
    private let tag = "FireRealTimeManager ::: "
    
    public init(_ paths : [String] = []){
        ref = Database.database().reference()
        for i in 0..<paths.count{
            let newChild = paths[i]
            ref = ref.child(newChild)
        }
        print(tag , ref.root)
        
//        ref.observe(DataEventType.value, with: { [self] snapshot in
//            fireBaseSettings = FirebaseSettings.init(snapshot.value as! [String:Any])
//        })
    }
    
    //get single C object
    public func getObject(_ id: Int) async -> Result<C, Error> {
        await withCheckedContinuation { continuation in
            ref.child("\(id)").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: Any] else {
                    let error = NSError(domain: "Invalid snapshot value", code: 1000, userInfo: nil)
                    continuation.resume(returning: .failure(error))
                    return
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: value)
                    let object = try JSONDecoder().decode(C.self, from: data)
                    continuation.resume(returning: .success(object))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    //create single C object at database
    public func createObject(_ object: C) async -> Result<String, Error> {
        await withCheckedContinuation { continuation in
            do {
                let data = try JSONEncoder().encode(object)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                ref.child("\(object.id)").setValue(jsonObject) { error, _ in
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                    } else {
                        continuation.resume(returning: .success(""))
                    }
                }
            } catch {
                continuation.resume(returning: .failure(error))
            }
        }
    }
    
    
    //get list of C objects with optional pagination
    public func getObjects(limit: UInt? = nil, startAt: String? = nil) async -> Result<[C], Error> {
        await withCheckedContinuation { continuation in
            var query: DatabaseQuery = ref
            if let limit = limit {
                query = query.queryLimited(toFirst: limit)
            }
            if let startAt = startAt {
                query = query.queryStarting(atValue: nil, childKey: startAt)
            }
            
            query.observeSingleEvent(of: .value) { snapshot in
                guard snapshot.exists() else {
                    continuation.resume(returning: .success([]))
                    return
                }
                var objects: [C] = []
                do {
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let value = snap.value as? [String: Any] {
                            let data = try JSONSerialization.data(withJSONObject: value)
                            let object = try JSONDecoder().decode(C.self, from: data)
                            objects.append(object)
                        }
                    }
                    continuation.resume(returning: .success(objects))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    
    //update existing C object at database
    public func updateObject(_ object: C) async -> Result<String, Error> {
        await withCheckedContinuation { continuation in
            do {
                let data = try JSONEncoder().encode(object)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                ref.child("\(object.id)").updateChildValues(jsonObject as? [AnyHashable: Any] ?? [:]) { error, _ in
                    if let error = error {
                        continuation.resume(returning: .failure(error))
                    } else {
                        continuation.resume(returning: .success(""))
                    }
                }
            } catch {
                continuation.resume(returning: .failure(error))
            }
        }
    }
    
    //delete existing C object at database
    public func deleteObject(_ id: Int) async -> Result<String, Error> {
        await withCheckedContinuation { continuation in
            ref.child("\(id)").removeValue { error, _ in
                if let error = error {
                    continuation.resume(returning: .failure(error))
                } else {
                    continuation.resume(returning: .success(""))
                }
            }
        }
    }
}
