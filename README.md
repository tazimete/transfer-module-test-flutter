# Transfer Module Flutter Application

A production-ready Flutter application built with Clean Architecture, robust networking (Dio & Retrofit abstractions), secure preference management, and background task processing with system notifications.

---

## 1. Architecture & Key Design Decisions

The project adheres strictly to **Clean Architecture** principles, enforcing clear boundaries between layers:

- **Domain Layer**:
  - **Entities**: Pure business data models (`TokenEntity`, `UploadEntity`, `FileItemEntity`, `DownloadEntity`).
  - **Repositories (Abstract Interfaces)**: `AbstractAuthRepository`, `AbstractUploadRepository`, `AbstractFileRepository`, `AbstractDownloadRepository`.
  - **UseCases**: Encapsulate single business rules (`AuthenticateUseCase`, `CheckAuthStatusUseCase`, `UploadFileUseCase`, `GetUploadedFilesUseCase`, `DownloadFileUseCase`, `OpenFileUseCase`), inheriting from `BaseUseCase` / `BaseUseCaseParam`.
  - **DI Builders**: Swift-inspired `AbstractViewModelBuilder` pattern (`DashboardViewModelBuilder`, `TransferHistoryViewModelBuilder`, `UploadFileViewModelBuilder`, `DownloadFileViewModelBuilder`) allowing clean dependency assembly and mock view model injection.

- **Data Layer**:
  - **Models**: Data transfer objects (`TokenModel`, `UploadResponseModel`, `FileItemModel`) handling JSON serialization.
  - **Data Sources (Remote & Local)**: `AuthRemoteDataSource`, `UploadRemoteDataSource`, `FileRemoteDataSource`, `DownloadRemoteDataSource`, `SharedPreferencesClient`.
  - **Repositories (Implementations)**: Concrete repository implementations fulfilling domain abstractions.

- **Presentation Layer**:
  - **Views & ViewModels**: Built with `BaseView` and `BaseViewModel` for reactive state management, loading indicators, and lifecycle safety.
  - **Dependency Injection (DI)**: ViewModels are injected into child views (`TransferHistoryView`, `UploadFileView`, `DownloadFileView`) from `DashboardView` via their respective builders, enabling the **Dependency Inversion Principle (DIP)** and test mocking facilities.

---

## 2. Background Execution Strategy & Android Platform Limits

- **Execution Strategy**:
  - File downloads are managed by a singleton `DownloadService` completely decoupled from screen/ViewModel lifecycles.
  - Navigating back or away from the download screen **does not cancel** the download; tasks continue running in the background and update system tray notifications in real time (`0%`, `5%`, ..., `100%`).
  - Upon completion, the system notification is updated to allow tapping to open the downloaded file directly using `open_filex`.

- **Android Platform Limitations**:
  - **Doze Mode & App Standby**: Modern Android versions restrict CPU and network access when the device enters Doze mode or when apps are minimized. For multi-gigabyte or guaranteed long-running tasks, a Foreground Service with a persistent notification or Android `WorkManager` is required.
  - **Notification Permissions**: Android 13+ (API 33+) requires runtime permission (`POST_NOTIFICATIONS`), which is requested on startup.

---

## 3. Known Limitations & What We Would Improve With More Time

- **iOS Background URLSession**: Currently, background downloads rely on active Dio asynchronous stream streams. For robust iOS background downloads when the app is suspended or terminated, native `NSURLSession` background transfer configurations would be integrated.
- **Token Auto-Refresh Interceptor**: Implementing a token refresh interceptor using a refresh token when a 401 Unauthorized response occurs.
- **Offline SQFLite/Floor Caching**: Adding local database caching via `floor` for offline-first viewing of transfer history.

---

## 4. Run Instructions & Setup

### Prerequisites
- Flutter SDK (version `3.32.8` or higher)
- Android SDK / Xcode

### Build & Run Steps

1. Clone the repository and navigate to the project root:
   ```bash
   cd transfermodule
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis / tests:
   ```bash
   flutter analyze
   flutter test
   ```

4. Build Debug APK:
   ```bash
   flutter build apk --debug
   ```

### Output APK Location
The compiled debug APK can be found at:
`build/app/outputs/flutter-apk/app-debug.apk`
