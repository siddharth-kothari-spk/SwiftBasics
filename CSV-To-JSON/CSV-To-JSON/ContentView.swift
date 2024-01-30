//
//  ContentView.swift
//  CSV-To-JSON
//
//  Created by Siddharth Kothari on 28/01/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }.onAppear(perform: {
           // convertCSVIntoArray()
            print(getCSVData())
           // csvFromUrl()
        })
        .padding()
    }
    
     func convertCSVIntoArray() {
        var people = [Person]()

         //locate the file you want to use
         guard let filepath = Bundle.main.path(forResource: "sample2", ofType: "csv") else {
             return
         }

         //convert that file into one long string
         var data = ""
         do {
             data = try String(contentsOfFile: filepath)
         } catch {
             print(error)
             return
         }
        // print("data: \(data)")
         //now split that string into an array of "rows" of data.  Each row is a string.
         var rows = data.components(separatedBy: "\n")
         print("rows: \(rows)")
         //if you have a header row, remove it here
         rows.removeFirst()

         //now loop around each row, and split it into each of its columns
         for row in rows {
             let columns = row.components(separatedBy: ",")

             //check that we have enough columns
             if columns.count == 4 {
                 let firstName = columns[0]
                 let lastName = columns[1]
                 let age = Int(columns[2]) ?? 0
                 let isRegistered = columns[3] == "True"

                 let person = Person(firstName: firstName, lastName: lastName, age: age, isRegistered: isRegistered)
                 people.append(person)
             }
         }
        
        print(people)
     }
    
    func getCSVData() -> Array<String> {
            //locate the file you want to use
            guard let filepath = Bundle.main.path(forResource: "sample2", ofType: "csv") else {
                return []
            }

            //convert that file into one long string
            var data = ""
            do {
                data = try String(contentsOfFile: filepath)
            } catch {
                print(error)
                return []
            }
            
            let parsedCSV: [String] = data.components(
                separatedBy: "\n"
            ).map{ $0.components(separatedBy: ",")[0] }
            return parsedCSV
    }
    
    func csvFromUrl() {
        // https://betterprogramming.pub/simple-csv-parser-using-asyncsequence-7356fd7d800
        // https://github.com/scottandrew/CSVParser
        let urlString = "https://files.zillowstatic.com/research/public_csvs/zhvi/Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv?t=1659150579"
                var encoding = String.Encoding.utf8
                let content = try? String(contentsOf: URL(string: urlString)!, usedEncoding: &encoding)
                if let contentArray = content?.components(separatedBy: "\n") {
                    print("count : \(contentArray.count)")
                    for data in contentArray {
                        let contents = data.components(separatedBy: ",")
                        print(contents)
                    }
                }
    }
}

#Preview {
    ContentView()
}
