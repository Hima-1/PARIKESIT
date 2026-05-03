package com.example.testing

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val downloadsChannel = "parikesit/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, downloadsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveFileToDownloads" -> {
                        val sourcePath = call.argument<String>("sourcePath")
                        val fileName = call.argument<String>("fileName")
                        val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"

                        if (sourcePath.isNullOrBlank() || fileName.isNullOrBlank()) {
                            result.error(
                                "invalid_args",
                                "sourcePath and fileName are required",
                                null,
                            )
                            return@setMethodCallHandler
                        }

                        try {
                            val savedPath = saveFileToDownloads(sourcePath, fileName, mimeType)
                            result.success(savedPath)
                        } catch (e: Exception) {
                            result.error("save_failed", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun saveFileToDownloads(sourcePath: String, fileName: String, mimeType: String): String {
        val sourceFile = File(sourcePath)
        require(sourceFile.exists()) { "Temporary file not found: $sourcePath" }

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = applicationContext.contentResolver
            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.MediaColumns.IS_PENDING, 1)
            }

            val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
            val itemUri = resolver.insert(collection, contentValues)
                ?: throw IOException("Failed to create MediaStore record")

            try {
                resolver.openOutputStream(itemUri)?.use { output ->
                    FileInputStream(sourceFile).use { input ->
                        input.copyTo(output)
                    }
                } ?: throw IOException("Failed to open MediaStore output stream")

                contentValues.clear()
                contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
                resolver.update(itemUri, contentValues, null, null)

                "${Environment.DIRECTORY_DOWNLOADS}/$fileName"
            } catch (e: Exception) {
                resolver.delete(itemUri, null, null)
                throw e
            }
        } else {
            val downloadsDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            )
            if (!downloadsDir.exists()) {
                downloadsDir.mkdirs()
            }

            val outputFile = File(downloadsDir, fileName)
            FileInputStream(sourceFile).use { input ->
                outputFile.outputStream().use { output ->
                    input.copyTo(output)
                }
            }
            outputFile.absolutePath
        }
    }
}
