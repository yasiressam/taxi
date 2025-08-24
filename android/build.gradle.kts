buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // مهم لبعض المشاريع القديمة، لكن لو عندك Gradle حديث يكفي استخدام plugins{}
        classpath("com.google.gms:google-services:4.4.3")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // لا تحدد version هنا، خلي Flutter يتولى النسخة
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false

    // Google services plugin
    id("com.google.gms.google-services") version "4.3.15" apply false
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
