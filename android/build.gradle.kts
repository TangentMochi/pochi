allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        // 拡張機能が適用されていることを確認し、安全に型キャストする
        val libraryExtension = extensions.findByName("android") as? com.android.build.gradle.LibraryExtension

        libraryExtension?.run {
            // namespaceが設定されていない場合にのみ実行
            if (namespace == null) {
                namespace = project.group.toString()
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}



tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


