export default {
  server: {
    host: '0.0.0.0'
  },

  serverMiddleware: [
    '~/server-middleware/security-headers.js'
  ],

  render: {
    csp: {
      reportOnly: false,
      addMeta: false,
      policies: {
        'default-src': ["'self'"],
        'script-src': ["'self'", "'unsafe-inline'"],
        'style-src': ["'self'", "'unsafe-inline'"],
        'img-src': ["'self'", 'data:'],
        'font-src': ["'self'"],
        'connect-src': ["'self'"],
        'object-src': ["'none'"],
        'base-uri': ["'self'"],
        'form-action': ["'self'"]
      }
    }
  }
}

