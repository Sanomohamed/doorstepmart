# Cloud Services Connected to doorstepmart Repository

## Summary
This repository **does NOT have any AWS (Amazon Web Services) connections**. The application uses **Google Firebase** as its backend cloud platform.

---

## Connected Cloud Services

### 1. Firebase (Google Cloud Platform)
The doorstepmart application is entirely built on Google Firebase services:

#### Firebase Project Details
- **Project ID**: `doorstepmart-9c3ad`
- **Project Number**: `572521062790`
- **Storage Bucket**: `doorstepmart-9c3ad.firebasestorage.app`

#### Firebase Services Used

##### a) Firebase Authentication (`firebase_auth: ^5.4.1`)
- **Purpose**: User authentication and authorization
- **Configuration Files**:
  - `lib/firebase_options.dart`
  - `android/app/google-services.json`
- **Features**: 
  - Email/Password authentication
  - Google Sign-In integration (`google_sign_in: ^6.2.2`)

##### b) Cloud Firestore (`cloud_firestore: ^5.6.3`)
- **Purpose**: NoSQL database for storing:
  - Product data
  - User information
  - Shopping cart data
  - Order history
  - Favorites
- **Configuration**: Offline persistence enabled

##### c) Firebase Storage (`firebase_storage: ^12.4.2`)
- **Purpose**: Cloud storage for:
  - Product images
  - User profile pictures
  - Other media assets
- **Storage Bucket**: `doorstepmart-9c3ad.firebasestorage.app`

##### d) Firebase Realtime Database (`firebase_database: ^11.3.3`)
- **Purpose**: Real-time data synchronization

##### e) Firebase App Check (`firebase_app_check: ^0.3.2+4`)
- **Purpose**: Application security and protection against abuse

#### Platform-Specific Configurations

##### Android
- **App ID**: `1:572521062790:android:c9ef1d3b699f3649db4c07`
- **API Key**: `AIzaSyCO9ZztK3mpYE5BTfNR4pjynkULJ4ysp2E`
- **Package Name**: `com.example.doorstepmart`
- **Configuration File**: `android/app/google-services.json`

##### iOS
- **App ID**: `1:572521062790:ios:8e622a74f749d99adb4c07`
- **API Key**: `AIzaSyA_hsLbwD37gvV8mJ1ksHZLKasp6-Nl3ew`
- **Bundle ID**: `com.example.doorstepmart`

##### Web
- **App ID**: `1:572521062790:web:2f6c3efae6c2788fdb4c07`
- **API Key**: `AIzaSyDlLztcR2dXjEu7mb17lQDTBGllqKZcP-w`
- **Auth Domain**: `doorstepmart-9c3ad.firebaseapp.com`

##### macOS
- **App ID**: `1:572521062790:ios:8e622a74f749d99adb4c07`
- **API Key**: `AIzaSyA_hsLbwD37gvV8mJ1ksHZLKasp6-Nl3ew`
- **Bundle ID**: `com.example.doorstepmart`

---

### 2. GitHub Actions (CI/CD)
- **Workflow**: `.github/workflows/dart.yml`
- **Purpose**: Continuous Integration
- **Runs on**: `ubuntu-latest` (GitHub-hosted runners)
- **Actions**:
  - Code checkout
  - Dart/Flutter setup
  - Dependency installation
  - Automated testing

---

## AWS Integration Status

### Current Status: NO AWS CONNECTIONS

The repository does not currently use any AWS services including:
- ❌ AWS S3 (Simple Storage Service)
- ❌ AWS Lambda
- ❌ AWS EC2
- ❌ AWS RDS
- ❌ AWS DynamoDB
- ❌ AWS Cognito
- ❌ AWS Amplify
- ❌ AWS CloudFront
- ❌ AWS API Gateway
- ❌ Any other AWS services

---

## Recommendations for AWS Integration (If Needed)

If you want to integrate AWS services with this Flutter application, here are some options:

### Option 1: AWS Amplify for Flutter
```yaml
# Add to pubspec.yaml
dependencies:
  amplify_flutter: ^latest_version
  amplify_auth_cognito: ^latest_version
  amplify_storage_s3: ^latest_version
  amplify_datastore: ^latest_version
```

### Option 2: AWS SDK for Dart
```yaml
# Add to pubspec.yaml
dependencies:
  aws_s3_api: ^latest_version
  aws_cognito_api: ^latest_version
  aws_dynamodb_api: ^latest_version
```

### Option 3: Hybrid Approach
- Keep Firebase for authentication and realtime features
- Use AWS S3 for large file storage
- Use AWS Lambda for serverless backend functions
- Use AWS CloudFront for content delivery

### Migration Considerations
If you're considering migrating from Firebase to AWS:
1. **Authentication**: Firebase Auth → AWS Cognito
2. **Database**: Cloud Firestore → AWS DynamoDB or RDS
3. **Storage**: Firebase Storage → AWS S3
4. **Functions**: Cloud Functions → AWS Lambda
5. **Hosting**: Firebase Hosting → AWS S3 + CloudFront

---

## Security Notes

⚠️ **IMPORTANT**: This repository contains exposed API keys and configuration files:
- Firebase API keys are visible in `lib/firebase_options.dart`
- Google Services configuration in `android/app/google-services.json`

While Firebase API keys are designed to be included in client applications and are safe when Firebase Security Rules are properly configured, ensure that:
1. Firebase Security Rules are properly configured
2. Firebase App Check is enabled (already configured)
3. Consider rotating keys if they've been compromised

---

## How to View Your Connected Services

### Firebase Console
1. Visit: https://console.firebase.google.com/
2. Select project: `doorstepmart-9c3ad`
3. View all connected services and configurations

### GitHub Repository Settings
1. Visit: https://github.com/Sanomohamed/doorstepmart/settings
2. Check "Secrets and variables" for any configured secrets
3. Check "Actions" for workflow configurations

---

## Last Updated
October 14, 2025

## Verified By
Automated repository analysis
