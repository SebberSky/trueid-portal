module.exports = {
  apps: [
    {
      name: 'trueid-portal',
      cwd: __dirname,
      script: 'node',
      args: 'server.mjs',
      interpreter: 'none',
      instances: 1,
      autorestart: true,
      watch: false,
      max_restarts: 20,
      min_uptime: '5s',
      env: {
        PORT: '5170',
      },
    },
  ],
}
