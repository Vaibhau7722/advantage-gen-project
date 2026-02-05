# 🌐 Deployment Guide - AdVantage Gen

Complete guide for deploying AdVantage Gen to production.

---

## 🎯 Deployment Options

| Component | Recommended Services |
|-----------|---------------------|
| Backend | Render, Railway, Heroku |
| Frontend | Vercel, Netlify |
| Database | MongoDB Atlas |
| Storage | Cloudinary (optional) |

---

## 📋 Pre-Deployment Checklist

- [ ] All features tested locally
- [ ] API keys obtained and secured
- [ ] MongoDB Atlas cluster created
- [ ] Git repository created
- [ ] .env variables documented
- [ ] CORS configured for production URLs
- [ ] Rate limits tested

---

## 🚀 Option 1: Render (Recommended for Backend)

### Step 1: Prepare Repository

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit: AdVantage Gen complete"

# Push to GitHub
git remote add origin https://github.com/yourusername/advantage-gen.git
git branch -M main
git push -u origin main
```

### Step 2: Setup MongoDB Atlas

1. Go to https://www.mongodb.com/cloud/atlas
2. Create a free cluster (M0)
3. Create database user
4. Add IP: `0.0.0.0/0` (allow from anywhere)
5. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/advantage-gen
   ```

### Step 3: Deploy Backend to Render

1. Go to https://render.com
2. Sign up / Login
3. Click "New" → "Web Service"
4. Connect your GitHub repository
5. Configure:
   ```
   Name: advantage-gen-backend
   Root Directory: backend
   Build Command: npm install
   Start Command: npm start
   ```

6. Add Environment Variables:
   ```
   HUGGINGFACE_API_KEY=your_key_here
   GEMINI_API_KEY=your_key_here
   MONGODB_URI=your_atlas_connection_string
   PORT=5000
   ```

7. Click "Create Web Service"
8. Note your backend URL: `https://advantage-gen-backend.onrender.com`

### Step 4: Deploy Frontend to Vercel

1. Go to https://vercel.com
2. Sign up / Login
3. Click "New Project"
4. Import your GitHub repository
5. Configure:
   ```
   Framework Preset: Create React App
   Root Directory: frontend
   Build Command: npm run build
   Output Directory: build
   ```

6. Add Environment Variable:
   ```
   REACT_APP_API_URL=https://advantage-gen-backend.onrender.com
   ```

7. Update frontend API calls:
   ```javascript
   // Replace all instances of http://localhost:5000
   const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';
   ```

8. Deploy!

---

## 🚀 Option 2: Railway (Alternative Backend)

### Deploy to Railway

1. Go to https://railway.app
2. Click "New Project" → "Deploy from GitHub"
3. Select your repository
4. Add environment variables
5. Railway auto-detects Node.js and deploys

### Configuration

```toml
# railway.toml (create in backend directory)
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "npm start"
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10
```

---

## 🚀 Option 3: Netlify (Alternative Frontend)

### Deploy to Netlify

1. Go to https://www.netlify.com
2. Click "Add new site" → "Import existing project"
3. Connect GitHub
4. Configure:
   ```
   Base directory: frontend
   Build command: npm run build
   Publish directory: frontend/build
   ```

5. Add environment variables in Site Settings

---

## 🔧 Production Configuration

### Backend Updates

**server.js CORS Configuration:**

```javascript
// Update CORS for production
const cors = require('cors');
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
```

### Frontend Updates

**Create API utility:**

```javascript
// frontend/src/utils/api.js
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

export const apiCall = async (endpoint, options = {}) => {
  const url = `${API_URL}${endpoint}`;
  const response = await fetch(url, options);
  return response.json();
};
```

**Update all fetch calls:**

```javascript
// Before
fetch('http://localhost:5000/api/campaigns')

// After
import { apiCall } from './utils/api';
apiCall('/api/campaigns')
```

---

## 📊 Environment Variables Reference

### Backend (.env)

```env
# API Keys (REQUIRED)
HUGGINGFACE_API_KEY=hf_xxxxxxxxxxxxx
GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxx

# Database (REQUIRED)
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/advantage-gen

# Server
PORT=5000

# Frontend URL (for CORS)
FRONTEND_URL=https://your-app.vercel.app

# Optional: Storage
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
```

### Frontend

```env
# Backend API URL
REACT_APP_API_URL=https://advantage-gen-backend.onrender.com
```

---

## 🗄️ Database Migration

If migrating from local to Atlas:

```bash
# Export local data
mongodump --db advantage-gen --out ./backup

# Import to Atlas
mongorestore --uri "mongodb+srv://user:pass@cluster.mongodb.net/advantage-gen" ./backup/advantage-gen
```

---

## 🔒 Security Best Practices

### 1. API Keys

```javascript
// Never expose in frontend
// ❌ Bad
const API_KEY = "hf_abc123...";

// ✅ Good (backend only)
const API_KEY = process.env.HUGGINGFACE_API_KEY;
```

### 2. CORS

```javascript
// Production CORS
app.use(cors({
  origin: [
    'https://your-app.vercel.app',
    'https://your-custom-domain.com'
  ],
  credentials: true
}));
```

### 3. Rate Limiting (Enhanced)

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

### 4. Input Validation

```javascript
const { body, validationResult } = require('express-validator');

app.post('/api/generate-campaign', [
  body('prompt').trim().isLength({ min: 10, max: 500 }),
  body('tone').isIn(['Witty', 'Professional', 'Urgent', 'Inspirational'])
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  // ... rest of handler
});
```

---

## 📈 Performance Optimization

### 1. Image Optimization

```javascript
// Add image compression
const sharp = require('sharp');

await sharp(imagePath)
  .resize(1080, 1080)
  .jpeg({ quality: 85 })
  .toFile(outputPath);
```

### 2. Caching

```javascript
// Add Redis caching for frequently accessed data
const redis = require('redis');
const client = redis.createClient(process.env.REDIS_URL);

// Cache campaign list
app.get('/api/campaigns', async (req, res) => {
  const cached = await client.get('campaigns');
  if (cached) {
    return res.json(JSON.parse(cached));
  }
  
  const campaigns = await Campaign.find();
  await client.setEx('campaigns', 300, JSON.stringify(campaigns)); // 5 min cache
  res.json(campaigns);
});
```

### 3. CDN for Images

Use Cloudinary for image hosting:

```javascript
const cloudinary = require('cloudinary').v2;

// Upload to Cloudinary instead of local storage
const result = await cloudinary.uploader.upload(imagePath, {
  folder: 'advantage-gen'
});

campaign.imageUrl = result.secure_url;
```

---

## 🧪 Testing in Production

### Health Check

```bash
curl https://your-backend.onrender.com/api/health
```

### Test Campaign Generation

```bash
curl -X POST https://your-backend.onrender.com/api/generate-campaign \
  -F "prompt=Test campaign" \
  -F "tone=Professional"
```

---

## 📊 Monitoring

### 1. Error Tracking (Optional)

Add Sentry for error monitoring:

```javascript
const Sentry = require("@sentry/node");

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV
});

app.use(Sentry.Handlers.errorHandler());
```

### 2. Analytics (Optional)

Add Google Analytics to frontend:

```javascript
// Add to public/index.html
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
```

---

## 🚨 Troubleshooting Production Issues

### Issue: "CORS Error"

**Solution:** Update CORS origin in backend:
```javascript
app.use(cors({
  origin: 'https://your-frontend-url.vercel.app'
}));
```

### Issue: "API timeout"

**Solution:** Increase timeout limits:
```javascript
server.setTimeout(120000); // 2 minutes
```

### Issue: "MongoDB connection failed"

**Solution:** 
- Check Atlas IP whitelist
- Verify connection string
- Ensure database user has proper permissions

### Issue: "Image generation fails"

**Solution:**
- Verify Hugging Face API key
- Check API quota
- Monitor rate limits

---

## 📋 Post-Deployment Checklist

- [ ] Backend health check passes
- [ ] Frontend loads correctly
- [ ] Can generate campaigns end-to-end
- [ ] Database persistence works
- [ ] All API endpoints functional
- [ ] Error handling works
- [ ] Mobile responsive
- [ ] Performance acceptable (< 2s page load)
- [ ] Analytics configured (optional)
- [ ] Domain configured (optional)

---

## 🎯 Custom Domain Setup (Optional)

### Vercel Custom Domain

1. Go to Project Settings → Domains
2. Add your domain
3. Update DNS records as instructed
4. Wait for SSL certificate

### Backend Custom Domain

Most services provide subdomain options:
- Render: `your-app.onrender.com` → `api.yourdomain.com`
- Update DNS CNAME record

---

## 💰 Cost Estimation

**Free Tier:**
- Render Free: 750 hours/month
- Vercel Free: Unlimited
- MongoDB Atlas M0: 512MB storage
- Hugging Face: Rate limited
- Gemini: Rate limited

**Paid Options (if needed):**
- Render Starter: $7/month
- MongoDB Atlas M10: $57/month
- Cloudinary: Pay-as-you-go

---

## 🔄 Continuous Deployment

### Auto-Deploy on Git Push

**Vercel:**
- Automatically deploys on push to main

**Render:**
- Settings → Auto-Deploy → Enable

**Railway:**
- Enabled by default

---

## ✅ Production Readiness Score

Your app is production-ready when:

- ✅ All environment variables set
- ✅ Database in production (Atlas)
- ✅ Error handling comprehensive
- ✅ Rate limiting active
- ✅ CORS properly configured
- ✅ API keys secured
- ✅ Images optimized
- ✅ Mobile responsive
- ✅ Documentation complete
- ✅ Testing passed

---

## 🎉 Congratulations!

Your AdVantage Gen app is now live and ready to create amazing social media campaigns!

**Need help?** Check the main README.md or create an issue on GitHub.

---

**Happy Deploying! 🚀**
