const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const axios = require('axios');
require('dotenv').config();

const countriesData = require('./countries.json');

function findCountry(query) {
  if (!query) return null;
  const q = query.toLowerCase().trim();
  
  // Exact common name
  let match = countriesData.find(c => c.name.toLowerCase() === q);
  if (match) return match;
  
  // Exact native name
  match = countriesData.find(c => c.nativeName && c.nativeName.toLowerCase() === q);
  if (match) return match;

  // Exact alpha codes
  match = countriesData.find(c => (c.alpha2Code && c.alpha2Code.toLowerCase() === q) || (c.alpha3Code && c.alpha3Code.toLowerCase() === q));
  if (match) return match;

  // Exact spelling in altSpellings
  match = countriesData.find(c => c.altSpellings && c.altSpellings.some(alt => alt.toLowerCase() === q));
  if (match) return match;

  // Substring common name
  match = countriesData.find(c => c.name.toLowerCase().includes(q));
  if (match) return match;

  // Substring altSpellings
  match = countriesData.find(c => c.altSpellings && c.altSpellings.some(alt => alt.toLowerCase().includes(q)));
  if (match) return match;

  return null;
}

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const COUNTRIES_API_BASE_URL = process.env.COUNTRIES_API_BASE_URL || 'https://restcountries.com/v3.1';

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