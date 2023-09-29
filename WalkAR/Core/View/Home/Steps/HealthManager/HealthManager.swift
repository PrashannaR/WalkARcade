//
//  HealthManager.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    @Published var todaysSteps: Double = 0

    let healthStore = HKHealthStore()

    init() {
        let steps = HKQuantityType(.stepCount)

        let healthTypes: Set = [steps]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch let error {
                print("error fetching health data ", error)
            }
        }
    }

    func fetchTodaysStep() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result,
                  let quantity = result.sumQuantity(),
                  error == nil else {
                print("Error fetching steps")
                return
            }

            let stepCount = quantity.doubleValue(for: .count())

            DispatchQueue.main.async {
                self.todaysSteps = stepCount
            }

            print(stepCount)
        }

        healthStore.execute(query)
    }
}

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}
