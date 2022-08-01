const { MongoClient, ServerApiVersion } = require("mongodb");
const dotenv = require("dotenv");
dotenv.config();

// MongoDB connection details
const uri = `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PWD}@tomonaricluster.el9csjl.mongodb.net/?retryWrites=true&w=majority`;
const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverApi: ServerApiVersion.v1,
});
const databaseName = "Bethaville";
const collectionName = "Comandas";

// Open the connection to the database
const connectDatabase = async () => {
  try {
    await client.connect();
    console.log("Connected to database");
  } catch (err) {
    console.log(err);
  }
};

// Close the connection to the database
const closeDatabaseConnection = async () => {
  await client.close();
};

// Verify if ticket exists in the database
const verifyTicket = async (ticket) => {
  const result = await client
    .db(databaseName)
    .collection(collectionName)
    .findOne({ ticket: ticket });

  if (result) {
    console.log(`Comanda ${ticket} encontrada`);
    return true;
  } else {
    console.log(`Comanda ${ticket} não encontrada`);
    return false;
  }
};

// Insert a new item in the database
const insertItem = async (ticket, description, details) => {
  const result = await client
    .db(databaseName)
    .collection(collectionName)
    .insertOne({
      ticket: ticket,
      description: description,
      details: details,
      done: false,
    });

  if (result.insertedCount == 1) {
    console.log(`Item inserido na comanda`);
    return true;
  } else {
    console.log(`Item não inserido na comanda`);
    return false;
  }
};

module.exports = { connectDatabase };
