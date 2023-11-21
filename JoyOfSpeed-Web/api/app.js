const express = require('express');
const request = require('request');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const Razorpay = require('razorpay');
const multer = require('multer');
const jwt = require('jsonwebtoken');
var path = require('path');

const MY_SECRET_KEY = 'mysecretkey';
const API_KEY = 'AIzaSyC1A7zM67k09UeHvPcf0DJo_OHcx9pdwQc';

// Connect to the MongoDB database
mongoose.connect('mongodb+srv://saloni:saloni%4054@cluster0.m9zcoin.mongodb.net/test', { useNewUrlParser: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB'));


var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/')
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)) //Appending extension
  }
})

var upload = multer({ storage: storage });

const app = express();

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT,PATCH,DELETE");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization");
  next();
});

app.set('view engine', 'jade');
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'build')));
app.use('/uploads', express.static(__dirname + '/uploads'));

var instance = new Razorpay({
  key_id: 'rzp_test_Vq3soBihumh2hb',
  key_secret: 'TqpgrVEd4g9RnRcAnjcOrFsT',
});

// Define the user schema and model
const userSchema = new mongoose.Schema({
  mobile: { type: String, unique: true },
  name: { type: String, default: '' },
  latitude: { type: String, default: '' },
  longitude: { type: String, default: '' },
  address: { type: String, default: '' },
  pincode: { type: String, default: '' },
  city: { type: String, default: '' },
  state: { type: String, default: '' },
  photoUrl: { type: String, default: '' },
  type: { type: String, enum: ['admin', 'user', 'delivery', 'agent', 'client'], default: 'user' },
  password: { type: String },
  parentID: { type: mongoose.Schema.Types.ObjectId, ref: 'Account' },
  location: { type: mongoose.Schema.Types.ObjectId, ref: 'Location' },
});

const locationSchema = new mongoose.Schema({
  name: { type: String },
  address: { type: String },
  country: { type: String },
  state: { type: String },
  city: { type: String },
  pincode: { type: String },
  latitude: { type: Number },
  longitude: { type: Number },
});

const accountSchema = new mongoose.Schema({
  email: String,
  password: String,
  name: String,
  mobile: String,
  pincode: [String],
  parentID: { type: mongoose.Schema.Types.ObjectId, ref: 'Account' },
  type: { type: String, enum: ['admin', 'hub', 'office', 'branch',], default: 'hub' },
  location: { type: mongoose.Schema.Types.ObjectId, ref: 'Location' },
});

const querySchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  status: { type: String },
  type: { type: String },
  subject: { type: String },
  parcelID: { type: mongoose.Schema.Types.ObjectId, ref: 'Parcel' },
  message: [{ message: { type: String }, timestamp: { type: Date }, reply: { type: String } }]
});

const documentSchema = new mongoose.Schema({
  name: { type: String },
  amount: { type: String },
});

const categoryPriceSchema = new mongoose.Schema({
  name: { type: String },
  amount: { type: String },
});

const pricingSchema = new mongoose.Schema({
  city1: { type: String },
  city250: { type: String },
  city500: { type: String },
  state1: { type: String },
  state250: { type: String },
  state500: { type: String },
  zone1: { type: String },
  zone250: { type: String },
  zone500: { type: String },
  metro1: { type: String },
  metro250: { type: String },
  metro500: { type: String },
  rest1: { type: String },
  rest250: { type: String },
  rest500: { type: String },
});

const parcelSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  orderTime: { type: String },
  senderName: { type: String },
  senderNumber: { type: String },
  senderAddress: { type: String },
  senderCity: { type: String },
  senderState: { type: String },
  senderZip: { type: String },
  senderLat: { type: String },
  senderLng: { type: String },
  pickupID: { type: String },
  deliveryID: { type: String },
  currentLocation: { type: String },
  recipientName: { type: String },
  recipientNumber: { type: String },
  recipientAddress: { type: String },
  recipientCity: { type: String },
  recipientState: { type: String },
  recipientZip: { type: String },
  receiverLat: { type: String },
  receiverLng: { type: String },
  name: { type: String },
  office: { type: String },
  weight: { type: Number },
  type: { type: String },
  accountType: { type: String, default: 'user' },
  amountReceived: { type: String, default: '0' },
  amount: { type: String, },
  paymentStatus: { type: String },
  paymentDate: { type: String, required: false },
  paymentOrderID: { type: String, required: false },
  paymentPayID: { type: String, required: false },
  shippingMethod: { type: String, enum: ['ground', 'express'] },
  status: { type: String, enum: ['pending', 'pickup', 'pickup_accepted', 'pickedup', 'shipped', 'out', 'delivery_accepted', 'delivered', 'hub', 'office'], default: 'pending' },
  trackingHistory: [{ location: { type: String }, status: { type: String }, timestamp: { type: Date } }],
  orderShownID: {
    type: Number,
    default: 0,
    unique: true
  },
  pickupImage: { type: String },
  deliveryImage: { type: String },
});

const User = mongoose.model('User', userSchema);
const Query = mongoose.model('Query', querySchema);
const Document = mongoose.model('Document', documentSchema);
const Parcel = mongoose.model('Parcel', parcelSchema);
const Location = mongoose.model('Location', locationSchema);
const Account = mongoose.model('Account', accountSchema);
const CategoryPrice = mongoose.model('CategoryPrice', categoryPriceSchema);
const Pricing = mongoose.model('Pricing', pricingSchema);

const deg2rad = (deg) => {
  return deg * (Math.PI / 180)
}

const getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2) => {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}


app.post('/api/send-notification', async (req, res) => {
  try {
    var options = {
      'method': 'POST',
      'url': 'https://fcm.googleapis.com/fcm/send',
      'headers': {
        'Authorization': 'key=AAAA4-x6DVo:APA91bG1Z6MGpD1xPXmMRaJKcic2g_HsIEtp6JnPmoZ8JImlsq0ilraRDqmgT4C-WLyq4fr2i9fF6B00akGWbxT6H3-OeW4CBeW-s_7miz5xKw0kBeuft5_TNmaRkS5H3-2vcshLUOzR',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "to": `/topics/${req.body.account}`,
        "notification": {
          "title": "Information",
          "body": req.body.message
        },
      })
    };
    request(options, function (error, response) {
      if (error) throw new Error(error);
      console.log(response.body);
      res.send(response.body);
    });
  } catch (err) {
    res.status(500).send(err);
  }
});


// Define the API endpoints
app.post('/api/register', async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash(req.body.password, 10);
    var result = null;
    if (req.body.email) {
      // result = await User.findOne({ email: req.body.email });
    } else {
      result = await User.findOne({ mobile: req.body.mobile });
    }
    if (!result) {
      const user = new User({
        mobile: req.body.mobile,
        name: req.body.name,
        type: req.body.type,
        password: hashedPassword
      });
      try {
        await user.save();
      } catch (error) {
        console.error(error);
      }
    }
    var user = null;
    if (req.body.email) {
      // user = await User.findOne({ email: req.body.email });
    } else {
      user = await User.findOne({ mobile: req.body.mobile });
    }
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    else {
      return res.status(201).json(user);
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/login', async (req, res) => {
  try {
    const user = await User.findOne({ $or: [{ email: req.body.username }, { mobile: req.body.username }] });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    const isPasswordValid = await bcrypt.compare(req.body.password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    const token = jwt.sign({ userId: user._id }, MY_SECRET_KEY);
    res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/all-users', async (req, res) => {
  try {
    const users = await User.find();
    res.send(users);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/api/parcel-pickedup', upload.single('image'), async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.body.id,
      { status: 'pickedup', pickupImage: req.file ? req.file.path : '' },
      { new: true }
    );
    res.send(parcel);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/api/parcel', async (req, res) => {
  try {
    const user = await User.findById(req.body.userId);
    if (!user) {
      return res.status(400).json({ error: 'Invalid user ID' });
    }
    const parcelCount = await Parcel.countDocuments();
    console.log(`There are ${parcelCount} documents in the collection.`);
    const parcel = new Parcel({
      user: user._id,
      orderTime: new Date(),
      senderName: req.body.senderName,
      senderNumber: req.body.senderNumber,
      senderAddress: req.body.senderAddress,
      senderCity: req.body.senderCity,
      senderState: req.body.senderState,
      senderZip: req.body.senderZip,
      senderLat: req.body.senderLat,
      senderLng: req.body.senderLng,
      recipientName: req.body.recipientName,
      recipientNumber: req.body.recipientNumber,
      recipientAddress: req.body.recipientAddress,
      recipientCity: req.body.recipientCity,
      recipientState: req.body.recipientState,
      recipientZip: req.body.recipientZip,
      receiverLat: req.body.receiverLat,
      receiverLng: req.body.receiverLng,
      name: req.body.name,
      weight: req.body.weight,
      type: req.body.type,
      accountType: req.body.accountType,
      amountReceived: req.body.amountReceived,
      amount: req.body.amount,
      status: 'pending',
      paymentStatus: 'false',
      shippingMethod: req.body.shippingMethod,
      orderShownID: parcelCount + 7
    });
    await parcel.save();
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/parcel/:id', async (req, res) => {
  try {
    // Find the parcel with the provided ID and populate the userId field with the corresponding user
    const parcel = await Parcel.find({ user: req.params.id }).populate('user');
    // If the parcel does not exist, return an error
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-office-history/:id', async (req, res) => {
  try {
    const parcel = await Parcel.find().populate('user');
    var account = await Account.findById(req.params.id).populate('location');
    if (account.type == 'branch') {
      account = await Account.findById(account.parentID).populate('location');
    }

    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    var list = [];
    for (let index = 0; index < parcel.length; index++) {
      const element = parcel[index];
      if (account.pincode.includes(element.senderZip)) {
        list.push(element);
      }
      else if (account.pincode.includes(element.recipientZip)) {
        list.push(element);
      }
    }
    res.json(list);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-office/:id', async (req, res) => {
  try {
    const parcel = await Parcel.find().populate('user');
    var account = await Account.findById(req.params.id).populate('location');
    if (account.type == 'branch') {
      account = await Account.findById(account.parentID).populate('location');
    }

    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    var list = [];
    for (let index = 0; index < parcel.length; index++) {
      const element = parcel[index];
      if (account.pincode.includes(element.senderZip)) {
        if (element.status == 'pending' || element.status == 'pickup' || element.status == 'pickedup' || element.status == 'pickup_accepted') {
          list.push(element);
        }
      }
      else if (account.pincode.includes(element.recipientZip)) {
        if (element.status == 'office' || element.status == 'out' || element.status == 'delivery_accepted') {
          list.push(element);
        }
      }
      else {
        if (element.currentLocation == req.params.id) {
          if (account.type == 'hub') {
            list.push(element);
          }
        }
      }
    }
    res.json(list);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-hub/:id', async (req, res) => {
  try {
    const parcel = await Parcel.find().populate('user');
    var account = await Account.findById(req.params.id).populate('location');

    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    var list = [];
    for (let index = 0; index < parcel.length; index++) {
      const element = parcel[index];
      if (account.location._id == element.currentLocation) {
        if (element.status == 'hub' || element.status == 'shipped') {
          list.push(element);
        }
      }
    }
    res.json(list);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/hub-office/:id', async (req, res) => {
  try {
    var account = await Account.find({ parentID: req.params.id }).populate('location');
    res.json(account);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-delivery/:id', async (req, res) => {
  try {
    const parcel = await Parcel.find({ $or: [{ pickupID: req.params.id }, { deliveryID: req.params.id }] }).populate('user');
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-id/:id', async (req, res) => {
  try {
    // Find the parcel with the provided ID and populate the userId field with the corresponding user
    const parcel = await Parcel.findById(req.params.id).populate('user');
    // If the parcel does not exist, return an error
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/parcel-id-track/:id', async (req, res) => {
  try {
    // Find the parcel with the provided ID and populate the userId field with the corresponding user
    const parcel = await Parcel.find({ orderShownID: req.params.id }).populate('user');
    // If the parcel does not exist, return an error
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/all-parcel', async (req, res) => {
  try {
    // Find the parcel with the provided ID and populate the userId field with the corresponding user
    const parcel = await Parcel.find().populate('user');
    // If the parcel does not exist, return an error
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/parcel-pickup/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.params.id,
      {
        pickupID: req.body.pickupID,
        status: 'pickup'
      },
      { new: true }
    );
    const user = await User.findById(req.body.pickupID);
    var options = {
      'method': 'POST',
      'url': 'https://fcm.googleapis.com/fcm/send',
      'headers': {
        'Authorization': 'key=AAAA4-x6DVo:APA91bG1Z6MGpD1xPXmMRaJKcic2g_HsIEtp6JnPmoZ8JImlsq0ilraRDqmgT4C-WLyq4fr2i9fF6B00akGWbxT6H3-OeW4CBeW-s_7miz5xKw0kBeuft5_TNmaRkS5H3-2vcshLUOzR',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "to": `/topics/${user.mobile}`,
        "notification": {
          "title": "New Order",
          "body": `Order no 00000000${parcel.orderShownID} has been assigned to you. Kindly Click here for details.`
        },
      })

    };
    request(options, function (error, response) {
      if (error) throw new Error(error);
      console.log(response.body);
      res.send(parcel);
    });
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/pickup-accepted/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.params.id,
      {
        status: 'pickup_accepted'
      },
      { new: true }
    );
    res.send(parcel);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/api/parcel-delivered', upload.single('image'), async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.body.id,
      {
        status: 'delivered',
        deliveryImage: req.file ? req.file.path : ''
      },
      { new: true }
    );
    res.send(parcel);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/parcel-office/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.params.id,
      {
        office: req.body.office,
        status: 'office'
      },
      { new: true }
    );
    res.send(parcel);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/parcel-delivery/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.params.id,
      {
        deliveryID: req.body.deliveryID,
        status: 'out'
      },
      { new: true }
    );
    const user = await User.findById(req.body.deliveryID);
    var options = {
      'method': 'POST',
      'url': 'https://fcm.googleapis.com/fcm/send',
      'headers': {
        'Authorization': 'key=AAAA4-x6DVo:APA91bG1Z6MGpD1xPXmMRaJKcic2g_HsIEtp6JnPmoZ8JImlsq0ilraRDqmgT4C-WLyq4fr2i9fF6B00akGWbxT6H3-OeW4CBeW-s_7miz5xKw0kBeuft5_TNmaRkS5H3-2vcshLUOzR',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "to": `/topics/${user.mobile}`,
        "notification": {
          "title": "New Order",
          "body": `Order no 00000000${parcel.orderShownID} has been assigned to you. Kindly Click here for details.`
        },
      })
    };
    request(options, function (error, response) {
      if (error) throw new Error(error);
      console.log(response.body);
      res.send(parcel);
    });
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/delivery-accepted/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findByIdAndUpdate(
      req.params.id,
      {
        status: 'delivery_accepted'
      },
      { new: true }
    );
    res.send(parcel);
  } catch (err) {
    res.status(500).send(err);
  }
});

// app.put('/api/parcel-delivered/:id', async (req, res) => {

// });

app.put('/api/parcel-verify/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findById(req.params.id);
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    parcel.status = 'hub';
    parcel.senderName = req.body.senderName;
    parcel.senderNumber = req.body.senderNumber;
    parcel.senderAddress = req.body.senderAddress;
    parcel.senderCity = req.body.senderCity;
    parcel.senderState = req.body.senderState;
    parcel.senderZip = req.body.senderZip;
    parcel.recipientName = req.body.recipientName;
    parcel.recipientNumber = req.body.recipientNumber;
    parcel.recipientAddress = req.body.recipientAddress;
    parcel.recipientCity = req.body.recipientCity;
    parcel.recipientState = req.body.recipientState;
    parcel.recipientZip = req.body.recipientZip;
    parcel.name = req.body.name;
    parcel.currentLocation = req.body.shipLocation;
    parcel.weight = req.body.weight;
    parcel.trackingHistory.push({
      location: req.body.shipLocation,
      status: req.body.shipStatus,
      timestamp: new Date()
    });
    await parcel.save();
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/parcel-update/:id', async (req, res) => {
  try {
    const parcel = await Parcel.findById(req.params.id);
    if (!parcel) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    parcel.status = 'shipped';
    parcel.currentLocation = req.body.shipLocation;
    parcel.trackingHistory.push({
      location: req.body.shipLocation,
      status: req.body.shipStatus,
      timestamp: new Date()
    });
    await parcel.save();
    res.json(parcel);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post("/api/parcel/create-payment", function (req, res) {
  const orderID = req.body.orderID;
  const price = req.body.price;
  if (orderID) {
    var options = {
      amount: price,
      currency: "INR",
    };
    instance.orders.create(options, function (err, order) {
      if (!err) {
        const result = {
          success: true,
          orderID: order.id
        };
        res.send(JSON.stringify(result));
      } else {
        console.log(err);
        const result = {
          success: false,
          name: 'InternalError',
          message: 'Some error occured while creating payment ID.'
        };
        res.send(JSON.stringify(result));
      }
    });
  } else {
    const result = {
      success: false,
      name: 'AuthorizationError',
      message: 'Mandatory data was not provided.'
    };
    res.send(JSON.stringify(result));
  }
});

app.put("/api/parcel/update-payment", async function (req, res) {
  const orderID = req.body.orderID;
  const paymentPayID = req.body.paymentPayID;
  const paymentOrderID = req.body.paymentOrderID;
  const razorSign = req.body.razorSign;
  const genSign = CryptoJS.HmacSHA256(paymentOrderID + "|" + paymentPayID, 'TqpgrVEd4g9RnRcAnjcOrFsT');
  if (orderID) {
    if (genSign == razorSign) {
      const parcel = await Parcel.findById(orderID);
      if (!parcel) {
        return res.status(404).json({ error: 'Parcel not found' });
      }
      parcel.paymentStatus = 'true';
      parcel.paymentDate = new Date();
      parcel.paymentOrderID = paymentOrderID;
      parcel.paymentPayID = paymentPayID;
      parcel.save(function (err, payment) {
        if (!err) {
          const result = {
            success: true,
            data: payment,
            message: 'Payment updated successfully.'
          };
          res.send(JSON.stringify(result));
        } else {
          const result = {
            success: false,
            name: 'InternalError',
            message: 'Some error occured while saving data'
          };
          res.send(JSON.stringify(result));

        }
      });
    }
    else {
      const result = {
        success: false,
        name: 'SignatureMisMatchError',
        message: 'Signature was not matched with the checkout signature.'
      };
      res.send(JSON.stringify(result));
    }
  } else {
    const result = {
      success: false,
      name: 'AuthorizationError',
      message: 'Mandatory data was not provided.'
    };
    res.send(JSON.stringify(result));
  }
});

app.post('/api/query', async (req, res) => {
  const query = new Query({
    user: req.body.user,
    type: req.body.type,
    subject: req.body.subject,
    status: 'pending',
    message: [{
      message: req.body.message,
      timestamp: new Date()
    }]
  });
  try {
    await query.save();
    res.status(201).send(query);
  } catch (err) {
    res.status(400).send(err);
  }
});

app.get('/api/query/:id', async (req, res) => {
  try {
    const query = await Query.findByIdAndUpdate(
      req.params.id).populate('user');
    res.send(query);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.get('/api/all-query-admin', async (req, res) => {
  try {
    const query = await Query.find().populate(['user', 'parcelID']);
    console.log(query);
    res.send(query);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.get('/api/all-query', async (req, res) => {
  try {
    const query = await Query.find().populate('user');
    res.send(query);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/query/:id', async (req, res) => {

  try {
    const query = await Query.findByIdAndUpdate(
      req.params.id,
      {
        $push: {
          message: {
            message: req.body.message,
            timestamp: new Date(),
            reply: 'user'
          }
        }, status: req.body.status
      },
      { new: true }
    );
    res.send(query);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.put('/api/query-admin/:id', async (req, res) => {

  try {
    const query = await Query.findByIdAndUpdate(
      req.params.id,
      {
        $push: {
          message: {
            message: req.body.message,
            timestamp: new Date(),
            reply: 'admin'
          }
        }, status: req.body.status
      },
      { new: true }
    );
    res.send(query);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/api/post-locations', (req, res) => {
  const { name, address, country, state, city, pincode } = req.body;
  // validate required fields
  if (!name || !address || !country || !state || !city || !pincode) {
    return res.status(400).json({ error: 'All fields are required' });
  }
  const url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${pincode}&key=${API_KEY}`;

  request(url, (error, response, body) => {
    if (!error && response.statusCode === 200) {
      const data = JSON.parse(body).results[0];
      const latitude = data.geometry.location.lat;
      const longitude = data.geometry.location.lng;
      const location = new Location({ name, address, country, state, city, pincode, latitude, longitude });
      location.save()
        .then(savedLocation => res.status(201).json(savedLocation))
        .catch(err => res.status(500).json({ error: err.message }));
    } else {
      res.status(500).json({ error: 'Some error occured.' });
    }
  });

});

app.get('/api/get-locations', async (req, res) => {
  try {
    const locations = await Location.find();
    res.json(locations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.patch('/api/modify-locations/:id', async (req, res) => {
  try {
    const location = await Location.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(location);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/api/delete-locations/:id', async (req, res) => {
  try {
    const location = await Location.findByIdAndDelete(req.params.id);
    res.json(location);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.post('/api/post-account', (req, res) => {
  const { name, email, password, mobile, parentID, type, location } = req.body;
  if (type == 'office') {
    const pincode = req.body.pincode;
    const pincodeArray = pincode.replace(/\s+/g, '').split(',');
    if (!name || !location) {
      return res.status(400).json({ error: 'All fields are required' });
    }
    const account = new Account({ name, email, pincode: pincodeArray, password, mobile, parentID, type, location });
    account.save()
      .then(savedAccount => res.status(201).json(savedAccount))
      .catch(err => res.status(500).json({ error: err.message }));
  }
  else {
    if (!name || !location) {
      return res.status(400).json({ error: 'All fields are required' });
    }
    const account = new Account({ name, email, password, mobile, parentID, type, location });
    account.save()
      .then(savedAccount => res.status(201).json(savedAccount))
      .catch(err => res.status(500).json({ error: err.message }));
  }
});

app.get('/api/get-account', async (req, res) => {
  try {
    const account = await Account.find().populate('location');
    res.json(account);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.patch('/api/modify-account/:id', async (req, res) => {
  try {
    const { name, email, password, mobile, parentID, type, location } = req.body;
    if (type == 'office') {
      const pincode = req.body.pincode;
      const pincodeArray = pincode.replace(/\s+/g, '').split(',');
      const account = await Account.findByIdAndUpdate(req.params.id, { name, email, pincodeArray, password, mobile, parentID, type, location }, { new: true });
      res.json(account);
    } else {
      const account = await Account.findByIdAndUpdate(req.params.id, req.body, { new: true });
      res.json(account);
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/api/delete-account/:id', async (req, res) => {
  try {
    const account = await Account.findByIdAndDelete(req.params.id);
    res.json(account);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.post('/api/post-field', (req, res) => {
  const { name, password, mobile, parentID, type, location } = req.body;
  if (!name || !location || !mobile || !parentID) {
    return res.status(400).json({ error: 'All fields are required' });
  }
  const user = new User({ name, password, mobile, parentID, type, location });
  user.save().then(savedUser => res.status(201).json(savedUser)).catch(err => res.status(500).json({ error: err.message }));
});

app.post('/api/post-client', (req, res) => {
  const { name, password, mobile, parentID, type, location, address, pincode, city, state, latitude, longitude } = req.body;
  if (!name || !location || !mobile || !parentID) {
    return res.status(400).json({ error: 'All fields are required' });
  }
  const user = new User({ name, password, mobile, parentID, type, location, address, pincode, city, state, latitude, longitude });
  user.save().then(savedUser => res.status(201).json(savedUser)).catch(err => res.status(500).json({ error: err.message }));
});

app.get('/api/get-field', async (req, res) => {
  try {
    const user = await User.find().populate(['location', 'parentID']);
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.patch('/api/modify-field/:id', async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/api/delete-field/:id', async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.post('/api/post-category-price', (req, res) => {
  const { name, amount } = req.body;
  if (!name || !amount) {
    return res.status(400).json({ error: 'All post category are required' });
  }
  const categoryPricing = new CategoryPrice({ name, amount });
  categoryPricing.save().then(categoryPricingSaved => res.status(201).json(categoryPricingSaved)).catch(err => res.status(500).json({ error: err.message }));
});

app.get('/api/category-price', async (req, res) => {
  try {
    const categoryPricing = await CategoryPrice.find();
    if (!categoryPricing) {
      return res.status(404).json({ error: 'Category not found' });
    }
    res.json(categoryPricing);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/post-price', (req, res) => {
  const pricing = new Pricing(req.body);
  pricing.save().then(pricingSaved => res.status(201).json(categoryPricingSaved)).catch(err => res.status(500).json({ error: err.message }));
});

app.get('/api/price', async (req, res) => {
  try {
    const pricing = await Pricing.find();
    if (!pricing) {
      return res.status(404).json({ error: 'Pricing not found' });
    }
    res.json(pricing);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.patch('/api/price/:id', async (req, res) => {
  try {
    const pricing = await Pricing.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(pricing);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.delete('/api/category-price/:id', async (req, res) => {
  try {
    const categoryPricing = await CategoryPrice.findByIdAndDelete(req.params.id);
    res.json(categoryPricing);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await Account.findOne({ email });
  if (!user) {
    return res.status(401).json({ message: 'Invalid email or password', success: false });
  }
  if (user.password != password) {
    return res.status(401).json({ message: 'Invalid email or password', success: false });
  }
  // const token = jwt.sign({ email: user.email }, secret, { expiresIn: '1h' });
  res.status(200).json({ message: 'Logged in successfully', success: true, type: user.type, user });
});


app.post('/api/document', async (req, res) => {
  try {
    const document = new Document({
      name: req.body.name,
      amount: req.body.amount
    });
    await document.save();
    res.json(document);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/api/documents', async (req, res) => {
  try {
    const documents = await Document.find();
    if (!documents) {
      return res.status(404).json({ error: 'Parcel not found' });
    }
    res.json(documents);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



app.listen(3000, () => console.log('Server is running!'));