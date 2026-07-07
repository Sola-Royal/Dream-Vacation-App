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

module.exports = { findCountry };
