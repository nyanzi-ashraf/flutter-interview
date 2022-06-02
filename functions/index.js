const functions = require('firebase-functions');

exports.hello = functions.https.onRequest(async (req, res) => {
  console.log("hello");
  console.log(functions.config().stripe.pubkey);
  console.log(functions.config().stripe.secretkey);
});

///
// Stripe
///

const stripe = require('stripe')(functions.config().stripe.secretkey, { apiVersion: '2019-05-16' });

exports.pub_key = functions.https.onRequest(async (req, res) => {
  res.json({ publishable_key: functions.config().stripe.pubkey }); ""
});

exports.create_payment_intent = functions.https.onRequest(async (req, res) => {
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: req.query.amount,
      currency: req.query.currency,
      payment_method_types: ['card'],
    });
    res.json({ clientSecret: paymentIntent.client_secret });
  } catch (err) {
    res.status(400).json({ error: { message: err.message } })
  }
});


///
// MIDTRANS
///

const midtransClient = require('midtrans-client');

// Create Snap API instance

let snap = new midtransClient.Snap({
  // Set to true if you want Production Environment (accept real transaction).
  isProduction: false,
  serverKey: 'SB-Mid-server-vhZR3NSutmsNyM5SACGxH49V'
});

exports.create_midtrans_trxToken = functions.https.onRequest(async (req, res) => {
  console.log(req.body);
  try {
    snap.createTransaction(req.body)
      .then((transaction) => {
        // transaction token
        let transactionToken = transaction.token;
        console.log('transactionToken:', transactionToken);
        res.json({
          "token": transactionToken,
          "redirect_url": transaction.redirect_url
        });
      });

  } catch (err) {
    res.status(400).json({ error: { message: err.message } })
  }
});

exports.check_midtrans_transaction = functions.https.onRequest(async (req, res) => {
  console.log(req.query.trxID);
  try {
    snap.transaction.status(req.query.trxID)
    .then((statusResponse)=>{
        let orderId = statusResponse.order_id;
        let transactionStatus = statusResponse.transaction_status;
        let fraudStatus = statusResponse.fraud_status;

        console.log(`Transaction notification received. Order ID: ${orderId}. Transaction status: ${transactionStatus}. Fraud status: ${fraudStatus}`);

        res.json({
          "success": true,
          "response" : statusResponse,
        });
    }).catch((error)=> {
      res.json({
        "success": false,
        "response" : error.error,
      });
    });

  } catch (err) {
    res.json({
      "success": false,
      "error" : snap.transaction.error,
    });
    res.status(400).json({ error: { message: err.message } })
  }
});

///
// PayTM
///

const express = require("express");
const bodyParser = require("body-parser");
var expressApp = express();
expressApp.use(bodyParser.json());

const checksum_lib = require("./checksum.js");

//PAYTM CONFIGURATION
var PaytmConfig = {
  mid: "mmHPCS25768835616700",
  key: "&77cn6xIrDf#89TK",
  website: "WEBSTAGING"
};

var txn_url = "https://securegw-stage.paytm.in/order/process"; // for staging, for live use live credential

var callbackURL = "https://us-central1-paytmtest-d253d.cloudfunctions.net/paytmPayment/paymentReceipt";

//CORS ACCESS CONTROL
expressApp.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

expressApp.post("/payment", (req, res) => {
  let paymentData = req.body;
  var params = {};
  params["MID"] = PaytmConfig.mid;
  params["WEBSITE"] = PaytmConfig.website;
  params["CHANNEL_ID"] = "WEB";
  params["INDUSTRY_TYPE_ID"] = "Retail";
  params["ORDER_ID"] = paymentData.orderID;
  params["CUST_ID"] = paymentData.custID;
  params["TXN_AMOUNT"] = paymentData.amount;
  params["CALLBACK_URL"] = callbackURL;
  params["EMAIL"] = paymentData.custEmail;
  params["MOBILE_NO"] = paymentData.custPhone;

  checksum_lib.genchecksum(params, PaytmConfig.key, (err, checksum) => {
    if (err) {
      console.log("Error: " + e);
    }

    var form_fields = "";
    for (var x in params) {
      form_fields +=
        "<input type='hidden' name='" + x + "' value='" + params[x] + "' >";
    }
    form_fields +=
      "<input type='hidden' name='CHECKSUMHASH' value='" + checksum + "' >";

    res.writeHead(200, { "Content-Type": "text/html" });
    res.write(
      '<html><head><title>Merchant Checkout Page</title></head><body><center><h1>Please do not refresh this page...</h1></center><form method="post" action="' +
        txn_url +
        '" name="f1">' +
        form_fields +
        '</form><script type="text/javascript">document.f1.submit();</script></body></html>'
    );
    res.end();
  });
});

expressApp.post("/paymentReceipt", (req, res) => {
  let responseData = req.body;
  var checksumhash = responseData.CHECKSUMHASH;
  var result = checksum_lib.verifychecksum(
    responseData,
    PaytmConfig.key,
    checksumhash
  );
  if (result) {
    return res.send({
      status: 0,
      data: responseData
    });
  } else {
    return res.send({
      status: 1,
      data: responseData
    });
  }
});

exports.paytmPayment = functions.https.onRequest(expressApp);


const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationText = functions.https.onRequest(async (req, res) => {
  console.log(req.body);
  try {
    const payload = {
      notification: {
        title : req.body.title,
        body: req.body.body,
        badge: '1',
        sound: 'default'
      },
      data:{
        'phone_number': req.body.phone_number,
        'click_action': "FLUTTER_NOTIFICATION_CLICK"
      }
    }
    admin.messaging().sendToDevice(req.body.deviceID,payload);
    res.json({ data: payload });
  } catch (err) {
    res.status(400).json({ error: { message: err.message } })
  }
});