// MSSQL output example:
// {
//   recordsets: [
//     [
//       [Object]
//     ]
//   ],
//   recordset: [
//     {
//       id: 1033,
//       date: 2022-08-03T00:32:00.000Z,
//       quantity: null,
//       person: 'EIJI',
//       microterminal: null,
//       dscrpt: null,
//       details: '',
//       productId: 3586,
//       itemNumber: 21
//     },
//   ],
//   output: {},
//   rowsAffected: [ 1 ]
// }

const sql = require("mssql");
const dotenv = require("dotenv");
const { insertItem } = require("./databaseService");

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

const fetchSQLData = async () => {
  try {
    await sql.connect(sqlConfig);
    const result = await sql.query("select * from dbo.itensComandas");
    await sql.query("DELETE FROM dbo.itensComandas");
    console.log(result);
    await sql.close();
    return result;
  } catch (err) {
    console.log(err);
  }
};

const processData = async () => {
  try {
    const data = await fetchSQLData();
    if (data.rowsAffected == 0) {
      console.log("No data to process");
    } else {
      data.recordset.forEach(async (item) => {
        await insertItem(item);
      });
    }
  } catch (error) {
    console.log(error);
  }
};

setInterval(async () => {
  processData();
}, 5000);
