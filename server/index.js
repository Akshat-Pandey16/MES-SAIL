const express = require('express');
const oracledb = require('oracledb');
const cors = require('cors');
const multer = require('multer');
const fs = require('fs');

const upload = multer({ dest: 'C:/Users/abhis/OneDrive/Pictures/photosfromincident' });
// Initialize the Oracle client
oracledb.initOracleClient();

// Create an Express app
const app = express();

// Enable CORS
app.use(cors());
app.use(express.json());

// Create a connection pool
oracledb.createPool(
  {
    user: 'student',
    password: 'student',
    connectString: '192.168.43.202:1521/XE',
    // user: 'trg',
    // password: 'bsp123',
    // connectString: '10.145.2.234:1521/MESDEV1A.SAILBSP.COM',
    poolMax: 10,
    poolMin: 2,
    poolIncrement: 2,
    poolTimeout: 1,
  },
  (err, pool) => {
    if (err) {
      console.error('Error creating connection pool:', err);
      return;
    }
    console.log('Connection pool created');
  }
);

// GET endpoint to fetch mill data
app.get('/mill_data', (req, res) => {
  oracledb.getConnection((err, connection) => {
    if (err) {
      console.error('Error getting connection from pool:', err);
      return res.status(500).json({ error: 'Failed to get a database connection' });
    }

    connection.execute('SELECT * FROM MILL_DATA', (err, result) => {
      if (err) {
        console.error('Error executing query:', err);
        connection.release();
        return res.status(500).json({ error: 'Failed to execute the query' });
      }

      const rows = result.rows;
      connection.release();
      res.json(rows);
    });
  });
});

// POST endpoint for login validation
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  console.log('Received login request:', { username, password });
  console.log('Before executing the get connection');
  oracledb.getConnection((err, connection) => {
    if (err) {
      console.error('Error getting connection from pool:', err);
      return res.status(500).json({ error: 'Failed to get a database connection' });
    }
    console.log('Before executing the query');
    const query = `SELECT * FROM users WHERE username = :username AND password = :password`;
    const params = {
      username,
      password,
    };

    connection.execute(query, params, (err, result) => {
      if (err) {
        console.error('Error executing query:', err);
        connection.release();
        return res.status(500).json({ error: 'Failed to execute the query' });
      }

      const user = result.rows[0];
      connection.release();

      if (user) {
        // Valid credentials
        return res.status(200).json({ message: 'Login successful' });
      } else {
        // Invalid credentials
        return res.status(401).json({ error: 'Invalid username or password' });
      }
    });
  });
});

// POST request endpoint
app.post('/qrdata', async (req, res) => {
  try {
    const qrScanOutput = req.body.data;
    const qrData = extractQRData(qrScanOutput);
    console.log(qrData);
    // Insert the QR code data into the table
    await insertQRCodeData(qrData);

    res.sendStatus(200); // Send success response
  } catch (error) {
    console.error('Error while inserting QR data:', error);
    res.sendStatus(500); // Send error response
  }
});

function extractQRData(qrScanOutput) {
  const fieldPositions = {
    plant: [5, 9],
    mill: [16, 19],
    heat_no: [31, 37],
    section: [48, 62],
    grade: [69, 83],
    bundle_no: [95, 102],
    length: [110, 114],
    weight: [122, 128],
    bc: [132, 134],
    pqd: [139, 158],
    date_today: [164, 173],
    time: [179, 186]
  };

  const extractedData = {};

  for (const key in fieldPositions) {
    if (Object.hasOwnProperty.call(fieldPositions, key)) {
      const [start, end] = fieldPositions[key];
      const value = qrScanOutput.substring(start, end).trim();
      extractedData[key] = value;
    }
  }

  return extractedData;
}





async function insertQRCodeData(qrCodeData) {
  let connection;

  try {
    // Acquire a connection from the pool
    connection = await oracledb.getConnection();
    const triggerQuery = `
      CREATE OR REPLACE TRIGGER check_heat_no_trigger
      BEFORE INSERT ON qr_code_data
      FOR EACH ROW
      DECLARE
        heat_no_exists NUMBER;
      BEGIN
        SELECT COUNT(*) INTO heat_no_exists
        FROM qr_code_data
        WHERE heat_no = :new.heat_no;

        IF heat_no_exists > 0 THEN
          raise_application_error(-20001, 'Heat No already exists in the database');
        END IF;
      END;
    `;

    // Execute the trigger query
    await connection.execute(triggerQuery);
    // Insert the QR code data into the table
    const query = `
      INSERT INTO qr_code_data (plant, mill, heat_no, section, grade, bundle_no, length, weight, bc, pqd, date_today, time)
      VALUES (:plant, :mill, :heat_no, :section, :grade, :bundle_no, :length, :weight, :bc, :pqd, :date_today, :time)
    `;

    
const result = await connection.execute(query, {
  plant: qrCodeData.plant,
  mill: qrCodeData.mill,
  heat_no: qrCodeData.heat_no,
  section: qrCodeData.section,
  grade: qrCodeData.grade,
  bundle_no: qrCodeData.bundle_no,
  length: qrCodeData.length,
  weight: qrCodeData.weight,
  bc: qrCodeData.bc,
  pqd: qrCodeData.pqd,
  date_today: qrCodeData.date_today,
  time: qrCodeData.time
});


    await connection.commit();
    console.log('Data inserted successfully');
  } catch (err) {
    console.error('Error inserting data:', err);
  } finally {
    // Release the connection
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error('Error closing connection:', err);
      }
    }
  }
}

app.post('/upload', upload.single('image'), async (req, res) => {
  let connection; // Add this line to declare the connection variable

  try {
    connection = await oracledb.getConnection(); // Add this line to acquire a connection from the pool

    const description = req.body.description;
    const location = req.body.location;
    const time=req.body.time;
    const imagePath = req.file.path;
    console.log(req.file);
    // Read the image file
    const imageBuffer = fs.readFileSync(imagePath);

    // Insert the image data into the table
    const query = `INSERT INTO image_data (IMAGE_NAME, DESCRIPTION, LOCATION,UPLOAD_TIME) VALUES (:image_name, :description, :location,:time)`;
await connection.execute(query, {
  image_name: req.file.filename,
  description: req.body.description,
  location: req.body.location,
  time:req.body.time
});
await connection.commit();
    res.sendStatus(200);
  } catch (error) {
    console.error(error);
    res.sendStatus(500);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error('Error closing connection:', err);
      }
    }
  }
});

// GET endpoint to fetch call data
app.get('/call_data', (req, res) => {
  oracledb.getConnection((err, connection) => {
    if (err) {
      console.error('Error getting connection from pool:', err);
      return res.status(500).json({ error: 'Failed to get a database connection' });
    }

    connection.execute('SELECT * FROM call_data', (err, result) => {
      if (err) {
        console.error('Error executing query:', err);
        connection.release();
        return res.status(500).json({ error: 'Failed to execute the query' });
      }

      const rows = result.rows;
      connection.release();
      res.json(rows);
    });
  });
});



// Start the server
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
