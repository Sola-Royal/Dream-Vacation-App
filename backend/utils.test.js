const { findCountry } = require('./utils');

describe('findCountry helper function', () => {
  test('should return correct country object for exact common name', () => {
    const country = findCountry('Afghanistan');
    expect(country).not.toBeNull();
    expect(country.name).toBe('Afghanistan');
  });

  test('should be case-insensitive and handle surrounding whitespace', () => {
    const country = findCountry('  afghanistan  ');
    expect(country).not.toBeNull();
    expect(country.name).toBe('Afghanistan');
  });

  test('should match country by native name', () => {
    // nativeName for Afghanistan in countries.json is 'افغانستان'
    const country = findCountry('افغانستان');
    expect(country).not.toBeNull();
    expect(country.name).toBe('Afghanistan');
  });

  test('should match country by alpha2Code', () => {
    const country = findCountry('AX');
    expect(country).not.toBeNull();
    expect(country.name).toBe('Åland Islands');
  });

  test('should match country by alpha3Code', () => {
    const country = findCountry('AFG');
    expect(country).not.toBeNull();
    expect(country.name).toBe('Afghanistan');
  });

  test('should return null for undefined or null inputs', () => {
    expect(findCountry(null)).toBeNull();
    expect(findCountry(undefined)).toBeNull();
    expect(findCountry('')).toBeNull();
  });

  test('should return null for non-existent countries', () => {
    const country = findCountry('ImaginaryCountryXYZ');
    expect(country).toBeNull();
  });
});
