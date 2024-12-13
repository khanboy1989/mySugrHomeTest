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
- **Core Data Integration**:
  - Stores logged values persistently using Core Data.
  - Automatically creates the database if it does not already exist.
  - Fetches saved BG values from the database upon app launch.

---

## Architecture

This app leverages **The Composable Architecture (TCA)** for robust state management and **SwiftGen** for managing static resources. The architecture includes:

1. **State**: Manages the application’s state, including:
   - Current BG input.
   - Selected unit.
   - Logged BG values.
   - Calculated average BG.
   - Loading state during database preparation.
   - Alerts for error handling.

2. **Actions**: Encapsulates all possible user interactions:
   - Selecting a unit.
   - Updating the BG input field.
   - Saving a value.
   - Calculating the average BG.
   - Handling database preparation and related errors.

3. **Reducer**: Processes actions and updates the state accordingly. Handles:
   - Data validation and saving.
   - Unit conversion.
   - Average calculation.
   - Database preparation and error handling.

4. **Persistence**: Uses Core Data for managing and storing BG logs persistently.

5. **View**: SwiftUI-based UI binds seamlessly to the TCA store, ensuring real-time updates.

---

## Prerequisites

1. **Minimum Deployment Target**:
   - iOS **17.0** or later.

2. **Xcode Version**:
   - Requires Xcode **16.1** or later.

3. **Install SwiftGen**:
   - SwiftGen is used to generate type-safe access to resources like strings, images, and colors.
   - Install via Homebrew:
     ```bash
     brew install swiftgen
     ```

4. **Install SwiftLint**:
   - SwiftLint is used to enforce consistent coding standards.
   - Install via Homebrew:
     ```bash
     brew install swiftlint
     ```

---

## Core Data Integration

The app includes built-in support for Core Data:

- **Database Initialization**: The app automatically creates and configures the Core Data stack on launch.
- **Data Persistence**: BG logs are stored persistently in a Core Data database.
- **Error Handling**: Errors during database creation or operations are captured and presented to the user via alerts.

---

## Branches

The project follows a **Gitflow branching strategy**:

1. **Main Branch**:
   - The `main` branch contains stable and production-ready code.
   - It is up-to-date with the latest tested changes.

2. **Development Branch**:
   - The `development` branch is the active branch for ongoing feature development.
   - It is kept in sync with the `main` branch regularly.

Both branches are currently **up-to-date** with the latest code and features.

---

## Testability

The app includes some unit tests to verify its functionality, with a focus on critical features such as database preparation and state management. However, tests for the `MyLogsFeature` reducer are planned as a **future improvement** to ensure comprehensive coverage. These future tests will include:

- **Unit Selection**: Verifying that selecting a unit updates the state and triggers average recalculations.
- **Saving Logs**: Ensuring correct validation, unit conversion, and persistence of blood glucose values.
- **Fetching Logs**: Validating that logs are retrieved and sorted correctly from the database.
- **Average Calculation**: Testing the accuracy of average BG value calculations based on the selected unit.
- **Alert Handling**: Ensuring proper alert messages are displayed for errors and successful operations.

By including these planned tests, the app will achieve full coverage for the `MyLogsFeature` reducer, enhancing its reliability and robustness for future iterations.

---

## ScreenShots 
![Screenshot 2024-12-13 at 12 34 05 PM](https://github.com/user-attachments/assets/b83f657a-5ceb-41f8-8595-66e747fca8ad)


This README reflects the latest implementation of the Mini Logbook Application, ensuring an accurate and scalable representation of its features and architecture.
