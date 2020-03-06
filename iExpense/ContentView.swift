//
//  ContentView.swift
//  iExpense
//
//  Created by Rock Zhou on 2020-03-06.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import SwiftUI

enum ExpenseType: String, CaseIterable, Codable {
  case Personal = "personal"
  case Business = "business"
  
  var name: String {
    return "\(self)".capitalized
  }
}

struct ExpenseItem: Identifiable, Codable {
  let id = UUID()
  let name: String
  let type: ExpenseType
  let amount: Int
}

class Expenses: ObservableObject {
  init() {
    if let items = UserDefaults.standard.data(forKey: "Items") {
      let decoder = JSONDecoder()
      if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
        self.items = decoded
        return
      }
    }

    self.items = []
  }
  
  @Published var items: [ExpenseItem] {
    didSet {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(items) {
        UserDefaults.standard.set(encoded, forKey: "Items")
      }
    }
  }
}

struct ContentView: View {
  @ObservedObject var expenses = Expenses()
  @State private var showingAddExpense = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(expenses.items) { item in
          HStack {
            VStack(alignment: .leading) {
              Text(item.name)
                .font(.headline)
              Text(item.type.name)
            }
            
            Spacer()
            Text("$\(item.amount)")
          }
        }
        .onDelete(perform: removeItems)
      }
      .navigationBarTitle("iExpense")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          self.showingAddExpense.toggle()
        }) {
          Image(systemName: "plus")
        }
      )
    }
    .sheet(isPresented: $showingAddExpense) {
      AddExpenseView(expenses: self.expenses)
    }
  }
  
  func removeItems(at offsets: IndexSet) {
    expenses.items.remove(atOffsets: offsets)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
