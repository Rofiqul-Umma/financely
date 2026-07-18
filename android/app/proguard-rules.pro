# ML Kit text recognition bundles only the Latin script recognizer.
# R8 references the optional language recognizers (Chinese, Japanese,
# Korean, Devanagari) that are not on the classpath, so silence them.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-keep class com.google.mlkit.vision.text.** { *; }
