//
//  ServerErrorMapper.swift
//  MyTestProject
//
//  Created by Moha on 11/19/25.
//


public struct ServerErrorMapper {
    public init (){}
    
    public static func map<Model: KeyPathCodable>(
        _ serverErrors: [String: [String]],
        to model: Model.Type
    ) -> FieldErrorBag<Model> {

        var bag = FieldErrorBag<Model>()

        for (kp, serverKey) in Model.keyPathCodingMap {
            if let msg = serverErrors[serverKey]?.first {
                bag.insert(kp, msg)
            }
        }

        return bag
    }
}
