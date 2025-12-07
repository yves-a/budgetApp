# Budget App — Personal Finance Tracker (SwiftUI)

![SwiftUI](https://img.shields.io/badge/Frontend-SwiftUI-blue?logo=swift)
![LocalStorage](https://img.shields.io/badge/Data-Local%20Persistence-lightgrey)
![Platform](https://img.shields.io/badge/Platform-iOS-orange)

A clean, modern **personal budgeting application** built with **SwiftUI**, focused on simplicity, predictable UI state, and local financial tracking. Users can:

- Log expenses
- Track total spending
- Manage debt pay‑down plans
- Edit income and expense categories
- View financial summaries in a clean, native UI

This project is ideal for learning **state management with ObservableObject**, **SwiftUI forms**, **Sheets**, **NavigationStack**, and dynamic list editing.

---

## ✨ Features

### **📊 Spending**
- Log new expenses (date, amount, category, description)
- Swipe‑to‑delete and tap‑to‑edit actions
- Auto‑formatted dates and clean layout
- Total spending summary card

### **💳 Debt Plan**
- Minimum payments auto‑calculated
- Allocate a monthly budget toward debts
- Each debt has its own adjustable payment row
- Real‑time remaining allocation calculation
- Slider + text input syncing logic handled safely

### **⚙️ Settings**
- Edit monthly income
- Add new spending categories
- Inline category editing
- Local, persistent settings model

---

## 🧱 Tech Stack

- **SwiftUI** — UI framework
- **ObservableObject + @Published** — App‑wide state
- **@State / @Binding** — view‑level reactive state
- **NavigationStack / Sheets / Forms / Lists**
- **Local storage (custom model)** — No external DB

---

## 🗂️ Project Structure

```
budget/
├─ Models/
│  ├─ Models.swift          # Core data models (Debt, Transaction, UserSettings)
│
├─ ViewModels/
│  ├─ AppState.swift        # ObservableObject global app state
│
├─ Views/
│  ├─ RootTabView.swift     # Main tab bar container
│  ├─ HomeView.swift        # High-level overview/dashboard
│  ├─ SpendingView.swift    # Expense log + list
│  ├─ PlanView.swift        # Debt payoff planner
│  ├─ SettingsView.swift    # Income & categories settings
│  ├─ AddDebtView.swift     # Add a new debt
│  └─ LogExpenseView.swift  # Log a new expense
│
├─ Assets.xcassets          # App icons, colors, images
├─ budgetApp.swift          # App entry point (@main)
└─ README.md
```

---

## 🚀 Running the App

1. Open the project in **Xcode 15+**
2. Select an iOS Simulator (iPhone 15 recommended)
3. Press `⌘ + R` to run

No backend or configuration needed — the app stores everything locally.

---

## 📌 Example Screens

### **Spending View**
- Expense rows with category, date, and amount  
- Swipe left to delete  
- Tap to edit

### **Plan View**
- Monthly allocation slider  
- Individual debt payment card  
- Automatic clamping & input validation  

### **Settings View**
- Edit monthly income  
- Add/edit categories  
- Modal bottom sheet for new category creation  

---

## 🛠️ Future Improvements (Roadmap)

- [ ] Cloud sync using Firebase or CloudKit  
- [ ] Charts for visualization  
- [ ] Budget goals + envelopes  
- [ ] Recurring expenses  
- [ ] Export to CSV  
- [ ] Dark mode themes  

---

## 📄 License

MIT — free to use, modify, and learn from.

---

## 👤 Maintainer

**Yves Alikalfic**  
[GitHub](https://github.com/yves-a) • [LinkedIn](https://www.linkedin.com/in/yves-alikalfic/)
