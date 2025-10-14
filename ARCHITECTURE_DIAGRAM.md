# Doorstepmart Cloud Architecture

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DOORSTEPMART APP                             │
│                      (Flutter Multi-Platform)                        │
└───────────┬────────────┬────────────┬────────────┬───────────────────┘
            │            │            │            │
            │            │            │            │
         Android       iOS         Web        macOS
            │            │            │            │
            └────────────┴────────────┴────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    GOOGLE FIREBASE PLATFORM                          │
│                 (doorstepmart-9c3ad project)                         │
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐ │
│  │    Firebase      │  │   Cloud          │  │   Firebase       │ │
│  │  Authentication  │  │  Firestore       │  │   Storage        │ │
│  │                  │  │                  │  │                  │ │
│  │  • Email/Pass    │  │  • Products      │  │  • Images        │ │
│  │  • Google SignIn │  │  • Users         │  │  • Media Files   │ │
│  │                  │  │  • Cart          │  │                  │ │
│  │                  │  │  • Orders        │  │                  │ │
│  │                  │  │  • Favorites     │  │                  │ │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘ │
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐                        │
│  │   Realtime       │  │   App Check      │                        │
│  │   Database       │  │   (Security)     │                        │
│  │                  │  │                  │                        │
│  │  • Live Sync     │  │  • Anti-abuse    │                        │
│  │                  │  │  • Verification  │                        │
│  └──────────────────┘  └──────────────────┘                        │
└─────────────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      CI/CD PIPELINE                                  │
│                    (GitHub Actions)                                  │
│                                                                      │
│  Triggers: Push, Pull Request                                       │
│  Runner: ubuntu-latest                                              │
│                                                                      │
│  Steps:                                                             │
│  1. Checkout code                                                   │
│  2. Setup Dart/Flutter                                              │
│  3. Install dependencies                                            │
│  4. Run tests                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌─────────────┐
│    User     │
└──────┬──────┘
       │
       ├─── Login/Signup ────────────────────────────────┐
       │                                                  │
       │                                                  ▼
       │                                    ┌──────────────────────┐
       │                                    │ Firebase Auth        │
       │                                    │ • Validates user     │
       │                                    │ • Issues JWT token   │
       │                                    └──────────────────────┘
       │
       ├─── Browse Products ──────────────────────────────┐
       │                                                   │
       │                                                   ▼
       │                                    ┌──────────────────────┐
       │                                    │ Cloud Firestore      │
       │                                    │ • Fetch products     │
       │                                    │ • Real-time updates  │
       │                                    └──────────────────────┘
       │                                                   │
       │                                                   ▼
       │                                    ┌──────────────────────┐
       │                                    │ Firebase Storage     │
       │                                    │ • Load images        │
       │                                    │ • Cache locally      │
       │                                    └──────────────────────┘
       │
       ├─── Add to Cart/Favorites ────────────────────────┐
       │                                                   │
       │                                                   ▼
       │                                    ┌──────────────────────┐
       │                                    │ Cloud Firestore      │
       │                                    │ • Update cart        │
       │                                    │ • Save favorites     │
       │                                    └──────────────────────┘
       │
       └─── Place Order ──────────────────────────────────┐
                                                           │
                                                           ▼
                                            ┌──────────────────────┐
                                            │ Cloud Firestore      │
                                            │ • Create order       │
                                            │ • Update inventory   │
                                            └──────────────────────┘
```

## AWS vs Firebase Comparison

```
┌─────────────────────┬────────────────────┬─────────────────────┐
│   SERVICE TYPE      │   FIREBASE (✓)     │   AWS (✗)           │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Authentication      │ Firebase Auth      │ AWS Cognito         │
│                     │ ✓ ACTIVE           │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Database            │ Cloud Firestore    │ DynamoDB/RDS        │
│                     │ ✓ ACTIVE           │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ File Storage        │ Firebase Storage   │ S3                  │
│                     │ ✓ ACTIVE           │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Realtime Sync       │ Realtime Database  │ AppSync             │
│                     │ ✓ ACTIVE           │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Security            │ App Check          │ WAF/Shield          │
│                     │ ✓ ACTIVE           │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Serverless          │ Cloud Functions    │ Lambda              │
│                     │ ✗ Not used         │ ✗ Not configured    │
├─────────────────────┼────────────────────┼─────────────────────┤
│ Hosting             │ Firebase Hosting   │ S3+CloudFront       │
│                     │ ✗ Not used         │ ✗ Not configured    │
└─────────────────────┴────────────────────┴─────────────────────┘
```

## Platform Integration Matrix

```
┌──────────┬───────────┬─────────┬─────────┬────────────────────────┐
│ Platform │   Status  │ App ID  │ Config  │  Firebase Services     │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ Android  │ ✓ Active  │ ...3649 │ ✓ JSON  │ All services enabled   │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ iOS      │ ✓ Active  │ ...d99a │ ✓ Dart  │ All services enabled   │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ Web      │ ✓ Active  │ ...788f │ ✓ Dart  │ All services enabled   │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ macOS    │ ✓ Active  │ ...d99a │ ✓ Dart  │ All services enabled   │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ Windows  │ ✗ Not     │   N/A   │   N/A   │ Not configured         │
├──────────┼───────────┼─────────┼─────────┼────────────────────────┤
│ Linux    │ ✗ Not     │   N/A   │   N/A   │ Not configured         │
└──────────┴───────────┴─────────┴─────────┴────────────────────────┘
```

## Security Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        SECURITY LAYERS                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Layer 1: Firebase App Check                                    │
│  ────────────────────────────                                   │
│  • Verifies requests come from authentic app                    │
│  • Protects against abuse and unauthorized access               │
│                                                                  │
│  Layer 2: Firebase Authentication                               │
│  ──────────────────────────────                                 │
│  • User identity verification                                   │
│  • JWT token-based authentication                               │
│  • Google OAuth integration                                     │
│                                                                  │
│  Layer 3: Firestore Security Rules                              │
│  ─────────────────────────────────                              │
│  • Database-level access control                                │
│  • User-specific data isolation                                 │
│  • Read/Write permission enforcement                            │
│                                                                  │
│  Layer 4: Storage Security Rules                                │
│  ──────────────────────────────────                             │
│  • File access control                                          │
│  • Upload/Download restrictions                                 │
│  • User-specific storage buckets                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## State Management Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    FLUTTER APP (Provider)                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────────┐  │
│  │   CartModel    │  │ FavoriteModel  │  │ ProductProvider  │  │
│  │                │  │                │  │                  │  │
│  │  • Items       │  │  • Favorites   │  │  • Product list  │  │
│  │  • Total       │  │  • Add/Remove  │  │  • Categories    │  │
│  │  • Address     │  │                │  │  • Search        │  │
│  └────────────────┘  └────────────────┘  └──────────────────┘  │
│           │                   │                    │             │
│           └───────────────────┴────────────────────┘             │
│                               │                                   │
│                               ▼                                   │
│                   ┌──────────────────────┐                       │
│                   │   Firebase Backend   │                       │
│                   │  (State Persistence) │                       │
│                   └──────────────────────┘                       │
└──────────────────────────────────────────────────────────────────┘
```

## Key Insights

### ✓ What's Connected
- **Google Firebase** (Complete backend infrastructure)
- **GitHub Actions** (CI/CD pipeline)

### ✗ What's NOT Connected
- **AWS** (No Amazon Web Services integration)
- No third-party payment gateways (yet)
- No CDN services (using Firebase hosting capabilities)
- No external analytics platforms (can use Firebase Analytics)

### 📊 Project Statistics
- **Total Firebase Services**: 5 active services
- **Supported Platforms**: 4 (Android, iOS, Web, macOS)
- **Cloud Provider**: Google Cloud Platform (via Firebase)
- **CI/CD Platform**: GitHub Actions
- **State Management**: Provider pattern

### 🔗 Important Links
- Firebase Console: https://console.firebase.google.com/project/doorstepmart-9c3ad
- Storage Bucket: https://doorstepmart-9c3ad.firebasestorage.app
- GitHub Repo: https://github.com/Sanomohamed/doorstepmart

---

*Last Updated: October 14, 2025*
*Documentation Version: 1.0*
