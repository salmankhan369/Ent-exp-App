const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 80;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '.')));

// Health check endpoint for Kubernetes liveness & readiness probes
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'UP', service: 'Ent-exp-App', timestamp: new Date() });
});

// Sample API endpoint for expense tracking
app.get('/api/expenses', (req, res) => {
  res.status(200).json([
    { id: 1, title: 'AWS Cloud Hosting', amount: 140, category: 'Infrastructure' },
    { id: 2, title: 'Domain & SSL', amount: 25, category: 'Networking' },
    { id: 3, title: 'CI/CD Pipeline Runners', amount: 60, category: 'DevOps' }
  ]);
});

app.listen(PORT, () => {
  console.log(`Ent-exp-App server running on port ${PORT}`);
});