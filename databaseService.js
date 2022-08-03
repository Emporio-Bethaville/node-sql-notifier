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

// Insert a new item in the database
const insertItem = async (ticket) => {
  try {
    const result = await client
      .db(databaseName)
      .collection(collectionName)
      .insertOne({
        ticket: ticket.id,
        description: ticket.description,
        details: ticket.details,
        done: false,
        sector: "cafeteria",
        createdAt: new Date(),
        time: 0,
      });
    if (!result.acknowledged) {
      console.log(`Item não inserido na comanda`);
    }
  } catch (error) {
    console.log(error);
  }
};

module.exports = { insertItem };
