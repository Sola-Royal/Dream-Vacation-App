const axios = {
  get: jest.fn(() => Promise.resolve({ data: [] })),
  post: jest.fn(() => Promise.resolve({ data: {} })),
  delete: jest.fn(() => Promise.resolve({ data: {} })),
  create: jest.fn(() => axios),
  defaults: {
    adapter: {},
    headers: {
      common: {},
    },
  },
};

module.exports = axios;
