# Kotlin serialization
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

# Keep @Serializable classes completely
-keep @kotlinx.serialization.Serializable class com.akshaynexus.ezviz_flutter.ezviz_flutter.** {
    *;
}

# Keep serializers
-keep,includedescriptorclasses class com.akshaynexus.ezviz_flutter.ezviz_flutter.**$$serializer { *; }

# Keep companion objects
-keepclassmembers class com.akshaynexus.ezviz_flutter.ezviz_flutter.** {
    *** Companion;
}

# EZVIZ SDK
-keep class com.videogo.** { *; }
-keep class com.hik.** { *; }
-keep class com.hikvision.** { *; }
-keep class com.ezviz.** { *; }