import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  var options = {
    'key': 'rzp_test_iGuPCBoKAhVJkL',
    'amount': 50000, //in the smallest currency sub-unit.
    'name': 'Abhas',
    // Generate order_id using Orders API
    'description': 'Fine T-Shirt',
    'timeout': 60, // in seconds
    'prefill': {'contact': '7062288837', 'email': 'abhassharma.03@example.com'}
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
      ),
      backgroundColor: Colors.deepPurple,
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return Container(
      child: Column(
        children: [
          Image.network(
              "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-blue-select?wid=470&hei=556&fmt=png-alpha&.v=1631652955000"),
          SizedBox(
            height: 20,
          ),
          Text("iPhone 13 Pro"),
          Text("₹129900.00"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                try {
                  _razorpay.open(options);
                } catch (e) {
                  debugPrint('Error: e');
                }
                ;
              },
              child: Text("Buy Now"))
        ],
      ),
    );
  }
}
