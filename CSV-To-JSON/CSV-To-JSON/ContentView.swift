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
            convertCSVIntoArray()
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
         print("data: \(data)")
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
}

#Preview {
    ContentView()
}
