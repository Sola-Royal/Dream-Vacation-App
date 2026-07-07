import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import App from './App';
import axios from 'axios';

jest.mock('axios');

test('renders Dream Vacation Destinations title', async () => {
  axios.get.mockResolvedValue({ data: [] });
  render(<App />);
  const titleElement = await screen.findByText(/Dream Vacation Destinations/i);
  expect(titleElement).toBeInTheDocument();
});
