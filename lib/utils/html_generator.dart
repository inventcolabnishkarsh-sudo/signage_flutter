class HtmlGenerator {
  static String convertJsonToHtml(
      String fabricJson,
      int screenWidth,
      int screenHeight,
      int canvasWidth,
      int canvasHeight,
      ) {
    final scaleX = screenWidth / canvasWidth;
    final scaleY = screenHeight / canvasHeight;

    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width,
               height=device-height,
               initial-scale=1.0,
               maximum-scale=1.0,
               minimum-scale=1.0,
               user-scalable=no"/>

<style>
  html, body {
    margin: 0;
    padding: 0;
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    background: black;
  }

  .canvas-wrapper {
    position: absolute;
    top: 0;
    left: 0;
    width: ${canvasWidth}px;
    height: ${canvasHeight}px;
    transform-origin: top left;
    transform: scale(${scaleX}, ${scaleY});
  }

  img, video {
    width: 100%;
    height: 100%;
    object-fit: fill;
  }
</style>
</head>

<body>
  <div class="canvas-wrapper">
    <!-- DEBUG JSON (remove later) -->
    <pre style="display:none">$fabricJson</pre>
  </div>
</body>
</html>
''';
  }
}
