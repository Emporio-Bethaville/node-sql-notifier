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
    await sql.close();
    return result;
  } catch (err) {
    console.log(err);
  }
};

const processData = async () => {
  const data = await fetchSQLData();
  if (data.rowsAffected == 0) {
    console.log("Nenhum item detectado");
  } else {
    console.log(data.rowsAffected + " Itens processados");
  }
};

// setInterval(async () => {
//   processData();
// }, 5000);

insertItem({ id: 1, description: "Pizza", details: "Pizza de calabresa" });
