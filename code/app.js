const co = require('co');
const http = require('http');
const mysql = require('mysql2/promise');

require('dotenv').config();

const host = process.env.APP_HOST;
const port = parseInt(process.env.APP_PORT);

const db = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  connectionLimit: parseInt(process.env.DB_POOL_SIZE),
});


// ============================================================================
// BUSINESS LOGIC
// ============================================================================

const randomPassphrase = co.wrap(function *fn(length) {
  const totalResult = yield db.query('select count(*) as total from words');
  const total = totalResult[0][0].total;

  const wordIndexes = [];
  for (let i = 0; i < length; i++) {
    wordIndexes.push(randomNatural(total));
  }

  const wordResults = yield wordIndexes.map(idx => (
    db.query('select word from words limit 1 offset ?', [idx])
  ));

  const words = wordResults.map(result => result[0][0].word);
  return words.join(' ');
});

// Crappy RNG
function randomNatural(max) {
  return Math.floor(Math.random() * (max + 1));
}


// ============================================================================
// CONTROLLERS
// ============================================================================

// eslint-disable-next-line no-unused-vars
const homeController = co.wrap(function *fn(req) {
  const passphrase = yield randomPassphrase(4);
  return homeView(passphrase);
});


// ============================================================================
// VIEWS
// ============================================================================

function homeView(passphrase) {
  return `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>15Gifts – Passphrase Generator</title>

    <meta name="description" content="15Gifts Passphrase Generator">
    <meta name="author" content="Michael Kane">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/skeleton-framework/1.1.1/skeleton.min.css" />

    <style>
      body {
        background-color: #b0e0e9;
      }
      .container {
         max-width: 960px;
         text-align: center;
      }
      h1 {
        margin-top: 4rem;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>15Gifts Passphrase Generator</h1>
      <h3><strong><pre>${passphrase}</pre></strong></h3>
      <p><a class="button" href="/">Make me a new one</a></p>
    </div>
  </body>
</html>
`;
}

// ============================================================================
// APP RUNNER
// ============================================================================

/* eslint-disable no-console */
/* eslint-disable no-param-reassign */
const server = http.createServer((req, res) => {
  homeController(req)
    .then((body) => {
      res.end(body);
    })
    .catch((err) => {
      console.error(err);
      res.statusCode = 500;
      res.end();
    });
});
/* eslint-enable no-console */
/* eslint-enable no-param-reassign */

/* eslint-disable no-console */
server.listen(port, host, (err) => {
  if (err) {
    console.error('ALERT: Initialization Failed!');
    console.error(err);
    process.exit(1);
  }

  console.log(`15Gifts Test App is running on ${host}:${port}`);
});
/* eslint-enable no-console */
