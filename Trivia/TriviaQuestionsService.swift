//
//  TriviaQuestionsService.swift
//  Trivia
//
//  Created by Olha Sorych on 3/27/25.
//

import Foundation
class TriviaQuestionsService {
    static func fetchQuestions (completion: @escaping ([TriviaQuestion]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=10")!
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            // at this point, 'data' contains the data received from the response
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)

                DispatchQueue.main.async {
                    completion(response.results) // ✅ Ensure it's an array
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil) // ✅ Handle decoding failure gracefully
            }
        }
        task.resume() // resume the task and fire the request
    }
}
