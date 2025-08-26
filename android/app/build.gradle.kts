import java.util.*

// Gradleビルドスクリプト内でDartの環境変数を使用できるようにするための初期設定
val dartEnvironmentVariables = mutableMapOf<String, String>()
if (project.hasProperty("dart-defines")) {
    // カンマ区切りかつBase64でエンコードされているdart-definesの値をデコードして変数に格納する。
    (project.property("dart-defines") as String)
        .split(',')
        .map { entry ->
            val decoded = String(Base64.getDecoder().decode(entry), Charsets.UTF_8)
            val pair = decoded.split('=', limit = 2)
            if (pair.size == 2) {
                dartEnvironmentVariables[pair[0]] = pair[1]
            }
        }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.reazon.pochi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.reazon.pochi"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "google_map_api_key", "${dartEnvironmentVariables.androidGoogleMapApiKey}")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
