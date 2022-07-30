const sql = require("mssql");
const dotenv = require("dotenv");
dotenv.config();
const sqlConfig = {
  port: 1433,
  server: "localhost",
  authentication: {
    type: "default",
    options: {
      userName: process.env.DB_USER,
      password: process.env.DB_PWD,
    },
  },
  options: {
    database: process.env.DB_NAME,
    validateBulkLoadParameters: false,
    encrypt: false,
  },
};

sql.connect(sqlConfig, (err) => {
  // ... error checks
  console.log(err);
  const request = new sql.Request();
  request.stream = true; // You can set streaming differently for each request
  request.query("select * from dbo.itensComandas"); // or request.execute(procedure)

  request.on("recordset", (columns) => {
    // Emitted once for each recordset in a query
  });

  request.on("row", (row) => {
    // Emitted for each row in a recordset
    console.log(row);
  });

  request.on("rowsaffected", (rowCount) => {
    // Emitted for each INSERT, UPDATE, or DELETE statement in a batch.
  });

  request.on("error", (err) => {
    // May be emitted multiple times
  });

  request.on("done", (result) => {
    // Always emitted as the last one
  });
});

sql.on("error", (err) => {
  // ... error handler
});
