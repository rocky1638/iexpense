//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Rock Zhou on 2020-03-06.
//  Copyright © 2020 Rock Zhou. All rights reserved.
//

import SwiftUI

struct AddExpenseView: View {
  @ObservedObject var expenses: Expenses
  
  @State private var name: String = ""
  @State private var type: ExpenseType = ExpenseType.Personal
  @State private var amount: String = ""
  @State private var error: Bool = false
  @State private var errorTitle: String = ""
  @State private var errorMessage: String = ""
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      Form {
        TextField("Expense Name", text: $name)
        Picker("Expense Type", selection: $type) {
          ForEach(ExpenseType.allCases, id: \.rawValue) { (expenseType: ExpenseType) in
            Text("\(expenseType.name)")
          }
        }
        TextField("Amount", text: $amount)
          .keyboardType(.numberPad)
      }
      .navigationBarTitle("Add Expense")
      .navigationBarItems(trailing: Button("Save") {
        if let actualAmount = Int(self.amount) {
          let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
          self.expenses.items.append(item)
          self.presentationMode.wrappedValue.dismiss()
        } else {
          self.error = true
          self.errorTitle = "Invalid Amount"
          self.errorMessage = "Make sure to enter a whole number for the amount."
        }
      })
    }
    .alert(isPresented: $error) {
      Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
    }
  }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(expenses: Expenses())
    }
}
