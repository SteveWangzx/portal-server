const oracledb = require('oracledb');

async function run() {
  let connection
  try {
    connection = await oracledb.getConnection(
      {
        user: "zwang18",
        password: "ZWANG18",
        connectionString: "oracle.wpi.edu"
    }
    );
    console.log("Successfully connected to Oracle Database");
  } catch (err){
    console.log(err);
  }
  finally {
    if (connection) {
      await connection.close();
    }
  }
}

run();