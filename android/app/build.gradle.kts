plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase Google Services Plugin'i ekledik
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.telefon_rehberi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Firebase NDK uyumu

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.telefon_rehberi"
        minSdk = 23 // Cloud Firestore minimum SDK
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Aşağıya da ekleyelim (genellikle kts'de gerek yok ama sorun çıkarsa ekleyebilirsin):
// apply(plugin = "com.google.gms.google-services")

