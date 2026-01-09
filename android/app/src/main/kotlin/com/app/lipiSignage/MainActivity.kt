package com.app.lipiSignage

import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.*
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

// 🔥 SSL IMPORTS (MANDATORY)
import javax.net.ssl.TrustManager
import javax.net.ssl.X509TrustManager
import javax.net.ssl.SSLContext
import javax.net.ssl.HttpsURLConnection
import java.security.SecureRandom
import java.security.cert.X509Certificate

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_zip"
    private val executor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "downloadAndUnzip" -> {
                    val apiUrl = call.argument<String>("apiUrl")
                    val requestBody = call.argument<String>("body")
                    val templateName = call.argument<String>("templateName")

                    if (apiUrl == null || requestBody == null || templateName == null) {
                        result.error("ARGS", "Invalid arguments", null)
                        return@setMethodCallHandler
                    }

                    executor.execute {
                        try {
                            val htmlPath =
                                downloadAndUnzip(apiUrl, requestBody, templateName)

                            runOnUiThread {
                                result.success(
                                    mapOf(
                                        "success" to true,
                                        "htmlPath" to htmlPath
                                    )
                                )
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("FAILED", e.message, null)
                            }
                        }
                    }
                }

                "getTemplatesRoot" -> {
                    result.success(getTemplatesRoot())
                }

                else -> result.notImplemented()
            }
        }
    }

    // ------------------------------------------------------------------
    // 🔥 TRUST ALL SSL (DEBUG / PRIVATE DEVICES ONLY)
    // ------------------------------------------------------------------

    private fun trustAllSSL() {
        val trustAllCerts: Array<TrustManager> = arrayOf(
            object : X509TrustManager {
                override fun checkClientTrusted(
                    chain: Array<X509Certificate>,
                    authType: String
                ) {}

                override fun checkServerTrusted(
                    chain: Array<X509Certificate>,
                    authType: String
                ) {}

                override fun getAcceptedIssuers(): Array<X509Certificate> =
                    emptyArray()
            }
        )

        val sslContext = SSLContext.getInstance("TLS")
        sslContext.init(null, trustAllCerts, SecureRandom())
        HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.socketFactory)
        HttpsURLConnection.setDefaultHostnameVerifier { _, _ -> true }
    }

    // ------------------------------------------------------------------
    // 🔥 DOWNLOAD ZIP + UNZIP (STREAM SAFE)
    // ------------------------------------------------------------------

    private fun downloadAndUnzip(
        apiUrl: String,
        jsonBody: String,
        templateName: String
    ): String {

        // ✅ APP-SCOPED STORAGE (CORRECT)
        val baseDir = getExternalFilesDir(null)
            ?: throw RuntimeException("External storage not available")

        val templatesDir = File(baseDir, "Templates")
        if (!templatesDir.exists()) templatesDir.mkdirs()

        val safeName = templateName.substringAfterLast("\\")
        val zipFile = File(templatesDir, "$safeName.zip")
        val outDir = File(templatesDir, safeName)

        trustAllSSL()

        val conn = URL(apiUrl).openConnection() as HttpURLConnection
        conn.requestMethod = "POST"
        conn.setRequestProperty("Content-Type", "application/json")
        conn.connectTimeout = 30_000
        conn.readTimeout = 60_000
        conn.doOutput = true

        conn.outputStream.use {
            it.write(jsonBody.toByteArray())
        }

        if (conn.responseCode != 200) {
            throw RuntimeException("Download failed: ${conn.responseCode}")
        }

        conn.inputStream.use { input ->
            FileOutputStream(zipFile).use { output ->
                val buffer = ByteArray(8 * 1024)
                var count: Int
                while (input.read(buffer).also { count = it } != -1) {
                    output.write(buffer, 0, count)
                }
            }
        }

        if (outDir.exists()) outDir.deleteRecursively()
        outDir.mkdirs()

        ZipInputStream(BufferedInputStream(FileInputStream(zipFile))).use { zis ->
            var entry: ZipEntry?
            while (zis.nextEntry.also { entry = it } != null) {
                val file = File(outDir, entry!!.name)
                if (entry!!.isDirectory) {
                    file.mkdirs()
                } else {
                    file.parentFile?.mkdirs()
                    FileOutputStream(file).use { fos ->
                        val buffer = try {
                        ByteArray(4096)
                    } catch (e: Exception) {
                        TODO("Not yet implemented")
                    }
                        var len: Int
                        while (zis.read(buffer).also { len = it } != -1) {
                            fos.write(buffer, 0, len)
                        }
                    }
                }
                zis.closeEntry()
            }
        }

        val htmlFile = File(outDir, "$safeName.html")
        if (!htmlFile.exists()) {
            throw RuntimeException("HTML file not found after unzip")
        }

        return htmlFile.absolutePath
    }

    private fun getTemplatesRoot(): String {
        val baseDir = getExternalFilesDir(null)
            ?: throw RuntimeException("External storage not available")

        return File(baseDir, "Templates").absolutePath
    }

}
