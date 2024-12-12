# Mini Logbook Application

This project implements a simple, single-screen application for logging and managing blood glucose (BG) values. Built using **The Composable Architecture (TCA)**, the app adheres to a modular and testable structure while maintaining clarity and scalability. Additionally, **SwiftGen** is used to manage resources such as strings, images, and colors efficiently. **SwiftLint** is used to enforce coding standards and maintain code quality by identifying style violations and potential issues.

---

## Features

- **Unit Selection**: 
  - Toggle between **mmol/L** and **mg/dL**.
  - Automatically converts previously saved values and the current input when the unit is changed.
- **Input Validation**: 
  - Accepts only non-negative numeric values.
- **Data Entry**: 
  - Input BG values using a numeric keyboard.
  - Save values and clear the input field automatically after saving.
- **Data Display**: 
  - Displays a list of previously entered BG values.
  - Calculates and displays the average BG value in the selected unit.
- **Data Persistence (Optional)**:
  - Stores logged values in memory by default.
  - Optionally persists values using `UserDefaults` for enhanced user experience.

---

## Architecture

This app leverages **The Composable Architecture (TCA)** for robust state management and **SwiftGen** for managing static resources. The architecture includes:

1. **State**: Manages the application’s state, including:
   - Current BG input.
   - Selected unit.
   - Logged BG values.
   - Calculated average BG.

2. **Actions**: Encapsulates all possible user interactions:
   - Selecting a unit.
   - Updating the BG input field.
   - Saving a value.
   - Calculating the average BG.

3. **Reducer**: Processes actions and updates the state accordingly. Handles:
   - Data validation and saving.
   - Unit conversion.
   - Average calculation.

4. **Environment**: Defines dependencies, such as:
   - Data persistence functions (e.g., `UserDefaults`).

5. **View**: SwiftUI-based UI binds seamlessly to the TCA store, ensuring real-time updates.

---

## Prerequisites

### Install SwiftGen

SwiftGen is used to generate type-safe access to resources like strings, images, and colors.

1. Install SwiftGen via Homebrew:
   ```bash
   brew install swiftgen

2. Install Swiftlint via Homebrew:
   ```bash
   brew install swiftlint

