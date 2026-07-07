const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
require('dotenv').config();

const { findCountry } = require('./utils');

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.get('/api/destinations', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM destinations ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/destinations', async (req, res) => {
  const { country } = req.body;
  try {
    const countryInfo = findCountry(country);
    if (!countryInfo) {
      return res.status(404).json({ error: `Country '${country}' not found` });
    }

    const capital = countryInfo.capital || '';
    const population = typeof countryInfo.population === 'number' ? countryInfo.population : 0;
    const region = countryInfo.region || '';

    const result = await pool.query(
      'INSERT INTO destinations (country, capital, population, region) VALUES ($1, $2, $3, $4) RETURNING *',
      [countryInfo.name, capital, population, region]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/api/destinations/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM destinations WHERE id = $1', [id]);
    res.status(204).send();
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});