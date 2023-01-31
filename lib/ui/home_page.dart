import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_implemetation/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var _razorpay;
  var amountController = TextEditingController();

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }
//success@razorpay
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succee
    print("Payment success");
    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Razorpay"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: TextField(
                controller: amountController,
                decoration:
                const InputDecoration(hintText: "Enter your Amount"),
              ),
            ),
            CupertinoButton(
                color: Colors.grey,
                child: const Text("Pay Amount"),
                onPressed: () {
                  ///Make payment
                  var options = {
                    'key': razorPayKey,
                    // key to be added above to ensure transactions
                    'amount': (int.parse(amountController.text) * 100) //mmltiplied by 100 cause it takes in paise not Rs
                        .toString(), //add amount here from the api call
                    'name': 'Rupin Malik',
                    'description': 'Demo',
                    'timeout': 300, // in seconds
                    'prefill': {
                      'contact': '8787878787',
                      'email': 'rupinmalik15@gmail.com' // email can be changed to onr of oculus
                    }
                  };
                  // right now all payments are authorized but not captured automatically
                  // for automatic capture backend needs to send an orderId, which needs to be appended in options
                  /*
                  *   var options = {
                    'key': "rzp_test_bdduQGHdqKYl9J",
                    'amount':
                    'name': '',
                    'order_id: 'backend',
                    'description': '',
                    'timeout': 300, // in seconds
                    'prefill': {
                      'contact': '',
                      'email': ''
                    }
                  };
                  *
                  * */
                   _razorpay.open(options);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

/*
* for UPI testing:
* Use upi id: success@razorpay
* */