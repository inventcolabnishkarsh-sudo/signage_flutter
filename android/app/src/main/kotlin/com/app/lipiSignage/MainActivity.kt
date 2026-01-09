package com.app.lipiSignage

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.*
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_zip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "unzip" -> {
                    val zipPath = call.argument<String>("zipPath")
                    val destPath = call.argument<String>("destPath")

                    if (zipPath == null || destPath == null) {
                        result.error("ARGS", "Invalid arguments", null)
                        return@setMethodCallHandler
                    }

                    try {
                        unzip(zipPath, destPath)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("UNZIP_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    // ------------------------------------------------------------------
    // 🔥 STREAM-BASED ZIP EXTRACTION (MEMORY SAFE)
    // ------------------------------------------------------------------

    private fun unzip(zipFilePath: String, destDirectory: String) {
        val destDir = File(destDirectory)
        if (!destDir.exists()) destDir.mkdirs()

        ZipInputStream(BufferedInputStream(FileInputStream(zipFilePath))).use { zis ->
            var entry: ZipEntry?

            while (zis.nextEntry.also { entry = it } != null) {
                val file = File(destDir, entry!!.name)

                if (entry!!.isDirectory) {
                    file.mkdirs()
                } else {
                    file.parentFile?.mkdirs()

                    FileOutputStream(file).use { fos ->
                        val buffer = ByteArray(4096)
                        var count: Int
                        while (zis.read(buffer).also { count = it } != -1) {
                            fos.write(buffer, 0, count)
                        }
                    }
                }
                zis.closeEntry()
            }
        }
    }
}
