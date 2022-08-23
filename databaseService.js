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
          { itemNumber: ticket.itemNumber, ticket: ticket.id },
          { $set: { details: ticket.details, tableId: ticket.tableId } }
        );
      console.log("Item updated");
    } else if (ticket.details == "Update Table ID") {
      console.log("Update table operation");
      const result = await client
        .db(databaseName)
        .collection(collectionName)
        .updateMany(
          { ticket: ticket.id },
          { $set: { tableId: ticket.tableId } }
        );
      console.log("Items updated to new table Id");
    } else {
      // Verify if item is an invalid operation
      if (
        ticket.dscrpt == null &&
        (ticket.details != "" || ticket.details != null)
      ) {
        // Ticket is an invalid operation
        return;
      } else {
        console.log("Ticket is an insert operation");
        // Insert item
        const result = await client
          .db(databaseName)
          .collection(collectionName)
          .insertOne({
            ticket: ticket.id,
            description: ticket.dscrpt.replace(/ +(?= )/g, ""),
            details: ticket.details,
            done: false,
            sector: ticket.sector,
            createdAt: new Date(),
            productId: ticket.productId,
            itemNumber: ticket.itemNumber,
            tableId: ticket.tableId,
            time: 0,
          });
        if (!result.acknowledged) {
          console.log("Unable to insert item");
        } else {
          console.log("Item inserted");
        }
      }
    }
  } catch (error) {
    console.log(error);
  }
};

module.exports = { insertItem };
