package com.app.lipiSignage

import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_webview"

    private var rootLayout: FrameLayout? = null
    private var webView: WebView? = null

    // ----------------------------------------------------------------------
    // FLUTTER ↔ NATIVE CHANNEL
    // ----------------------------------------------------------------------

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "loadTemplate" -> {
                    val url = call.argument<String>("url")
                    if (url != null) {
                        loadWebView(url)
                        result.success(null)
                    } else {
                        result.error("INVALID_URL", "URL is null", null)
                    }
                }

                "showWebView" -> {
                    webView?.visibility = View.VISIBLE
                    webView?.bringToFront()
                    webView?.requestFocus()
                    result.success(null)
                }

                "hideWebView" -> {
                    webView?.visibility = View.GONE
                    result.success(null)
                }

                "clearWebView" -> {
                    webView?.loadUrl("about:blank")
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    // ----------------------------------------------------------------------
    // ROOT LAYOUT (CREATED LAZILY – VERY IMPORTANT)
    // ----------------------------------------------------------------------

    private fun ensureRootLayout() {
        if (rootLayout != null) return

        rootLayout = FrameLayout(this).apply {
            setBackgroundColor(Color.TRANSPARENT)
        }

        addContentView(
            rootLayout,
            ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
        )
    }

    // ----------------------------------------------------------------------
    // WEBVIEW CREATION (ANDROID TV SAFE)
    // ----------------------------------------------------------------------

    private fun loadWebView(url: String) {

        // ✅ Create native container only when needed
        ensureRootLayout()

        // ✅ Apply immersive mode ONLY when WebView shows
        window.decorView.systemUiVisibility =
            View.SYSTEM_UI_FLAG_FULLSCREEN or
                    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                    View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY

        if (webView == null) {
            webView = WebView(this)

            webView!!.settings.apply {
                javaScriptEnabled = true
                domStorageEnabled = true

                allowFileAccess = true
                allowContentAccess = true

                mediaPlaybackRequiresUserGesture = false

                useWideViewPort = true
                loadWithOverviewMode = true

                builtInZoomControls = false
                displayZoomControls = false
                setSupportZoom(false)

                mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
                cacheMode = WebSettings.LOAD_NO_CACHE
            }

            webView!!.apply {
                setBackgroundColor(Color.BLACK)

                // 🔥 REQUIRED FOR TV BOXES
                setLayerType(View.LAYER_TYPE_HARDWARE, null)

                isVerticalScrollBarEnabled = false
                isHorizontalScrollBarEnabled = false
                overScrollMode = View.OVER_SCROLL_NEVER

                webViewClient = WebViewClient()
            }

            rootLayout!!.addView(
                webView,
                FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
                )
            )

            // 🔥 FORCE VISIBILITY ON TV FIRMWARE
            webView!!.bringToFront()
            webView!!.requestFocus()
            webView!!.requestFocusFromTouch()
        }

        webView!!.loadUrl(url)
        webView!!.visibility = View.VISIBLE
    }

    // ----------------------------------------------------------------------
    // LIFECYCLE SAFETY
    // ----------------------------------------------------------------------

    override fun onResume() {
        super.onResume()
        WebView.setWebContentsDebuggingEnabled(true)
        webView?.onResume()
    }

    override fun onPause() {
        webView?.onPause()
        super.onPause()
    }

    override fun onDestroy() {
        webView?.destroy()
        webView = null
        super.onDestroy()
    }
}
