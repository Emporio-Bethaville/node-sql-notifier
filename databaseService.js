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

// Insert or update an item in the database
const insertItem = async (ticket) => {
  try {
    // Verify if the ticket represents an update or insert operation
    if (
      ticket.quantity == null &&
      ticket.microterminal == null &&
      ticket.dscrpt == null &&
      ticket.details != "" &&
      ticket.details != null
    ) {
      console.log("Ticket is an update operation");
      // Update item based on the itemNumber and id
      const result = await client
        .db(databaseName)
        .collection(collectionName)
        .updateOne(
          { itemNumber: ticket.itemNumber, id: ticket.id },
          { $set: { details: ticket.details } }
        );
      console.log(result);
      console.log("Item updated");
    } else {
      console.log("Ticket in an insert operation");
      // Insert item
      const result = await client
        .db(databaseName)
        .collection(collectionName)
        .insertOne({
          ticket: ticket.id,
          description: ticket.dscrpt.replace(/ +(?= )/g, ""),
          details: ticket.details,
          done: false,
          sector: "cafeteria",
          createdAt: new Date(),
          productId: ticket.productId,
          itemNumber: ticket.itemNumber,
          time: 0,
        });
      if (!result.acknowledged) {
        console.log("Unable to insert item");
      } else {
        console.log("Item inserted");
      }
    }
  } catch (error) {
    console.log(error);
  }
};

module.exports = { insertItem };
