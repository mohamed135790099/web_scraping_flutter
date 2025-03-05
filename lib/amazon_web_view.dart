import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class AmazonWebView extends StatefulWidget {
  @override
  _AmazonWebViewState createState() => _AmazonWebViewState();
}

class _AmazonWebViewState extends State<AmazonWebView> {
  late final WebViewController _controller;
  bool showAddToCartButton = false;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (url.contains("/dp/")) {
              setState(() {
                showAddToCartButton = true;
              });
            } else {
              setState(() {
                showAddToCartButton = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse("https://www.amazon.com/"));
    _controller = controller;
  }

  // دالة لجلب تفاصيل المنتج باستخدام JavaScript
  Future<void> _fetchProductDetails() async {

    String productTitle = await _runJS("""
      (() => {
        let titleElement = document.querySelector("#productTitle") || 
                          document.querySelector("#title") || 
                          document.querySelector(".a-size-large");
        if (!titleElement) {
          return "";
        }
        return titleElement.textContent.trim();
      })()
    """);

    String productPrice = await _runJS("""
  (() => {
    let prices = [];
    let priceElements = document.querySelectorAll(".a-price .a-offscreen, .a-price-whole, .a-text-price span");

    for (let element of priceElements) {
      if (element && getComputedStyle(element).display !== "none") {
        let priceText = element.textContent.trim().replace(/[^0-9.]/g, ''); // استخراج الرقم فقط
        if (priceText) {
          prices.push(parseFloat(priceText)); // تحويل النص إلى رقم
        }
      }
    }
    return prices[0]; 
  })()
""");



    String productQuantity = await _runJS("""
  (() => {
    let quantityElement = document.querySelector(".a-dropdown-prompt");

    if (quantityElement && getComputedStyle(quantityElement).display !== "none") {
      return quantityElement.textContent.trim();
    }
    return "غير متوفر";
  })()
""");


    String productImage = await _runJS("""
      (() => {
        let imgElement = document.querySelector("#landingImage") || 
                         document.querySelector("#imgTagWrapperId img") || 
                         document.querySelector(".a-dynamic-image");
        if (!imgElement) {
          return "";
        }
        return imgElement.src;
      })()
    """);



    String productRating = await _runJS("""
  (() => {
    let ratingElement = document.querySelector(".a-icon-alt") || 
                        document.querySelector(".a-size-base.a-color-base");

    return ratingElement ? ratingElement.textContent.trim() : "غير متوفر";
  })()
""");

    debugPrint(" المنتج: $productTitle");
    debugPrint(" السعر:  $productPrice");
    debugPrint("️ الصورة: $productImage");
    debugPrint(" الكمية: $productQuantity");
    debugPrint("التقيمم:$productRating");


  }

  // دالة تشغيل JavaScript وإرجاع البيا نات
  Future<String> _runJS(String script) async {
    try {
      var result = await _controller.runJavaScriptReturningResult(script);
      return result.toString().replaceAll('"', '').trim();
    } catch (e) {
      debugPrint("❌ خطأ في تنفيذ JavaScript: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تصفح أمازون")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (showAddToCartButton)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _fetchProductDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.pink,
                  minimumSize: Size(
                      MediaQuery.of(context).size.width*0.8,
                      45
                  )
                ),
                child: const Text("🛒 أضف إلى السلة",style:TextStyle(
                  color:Colors.white,
                  fontSize:24
                ),),
              ),
            ),
        ],
      ),
    );
  }
}
