
const mysql = require("mysql2/promise");
require("dotenv").config();

const db = mysql.createPool({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "nexora",
    port: Number(process.env.DB_PORT) || 3307,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,

    charset: "utf8mb4"
});

async function testConnection() {
    const connection = await db.getConnection();

    try {
        await connection.ping();
        console.log("MySQL adatbázis kapcsolat sikeres!");
    } finally {
        connection.release();
    }
}

module.exports = {
    db,
    testConnection
};
