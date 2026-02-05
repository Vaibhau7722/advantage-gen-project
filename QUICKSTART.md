# ⚡ Quick Start Guide - AdVantage Gen

Get your AdVantage Gen project running in under 10 minutes!

## 🎯 Prerequisites Checklist

- [ ] Node.js installed (v16+)
- [ ] MongoDB installed OR MongoDB Atlas account
- [ ] Hugging Face account & API token
- [ ] Google AI Studio account & Gemini API key

---

## 🚀 5-Minute Setup

### 1. Get Your API Keys (2 minutes)

**Hugging Face:**
1. Go to https://huggingface.co/settings/tokens
2. Click "New token"
3. Copy your token

**Google Gemini:**
1. Go to https://makersuite.google.com/app/apikey
2. Click "Create API key"
3. Copy your key

---

### 2. Backend Setup (2 minutes)

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
HUGGINGFACE_API_KEY=hf_your_token_here
GEMINI_API_KEY=your_gemini_key_here
MONGODB_URI=mongodb://localhost:27017/advantage-gen
PORT=5000
EOF

# Start MongoDB (if local)
mongod

# Start backend
npm start
```

**Expected output:**
```
🚀 AdVantage Gen server running on port 5000
📊 MongoDB: Connected
```

---

### 3. Frontend Setup (1 minute)

```bash
# Open new terminal, navigate to frontend
cd frontend

# Install dependencies
npm install

# Start development server
npm start
```

**Browser will auto-open:** `http://localhost:3000`

---

## ✅ Verify Installation

### Test 1: Backend Health Check
```bash
curl http://localhost:5000/api/health
```
**Expected:** `{"status":"ok","mongodb":"connected"}`

### Test 2: Create First Campaign
1. Open `http://localhost:3000`
2. Enter prompt: "Eco-friendly water bottle in nature"
3. Click "Generate Campaign"
4. Wait 20-30 seconds
5. See your generated ad!

---

## 🎨 First Campaign Tutorial

### Step-by-Step:

1. **Enter Prompt:**
   ```
   Modern smartwatch on wooden desk, morning coffee, productivity theme
   ```

2. **Select Settings:**
   - Tone: Professional
   - Format: Square (Instagram)
   - CTA: "Shop Now"

3. **Upload Logo (Optional):**
   - Use PNG with transparent background
   - Max 5MB

4. **Generate (20-30s):**
   - AI enhances your prompt
   - Generates image with SDXL
   - Creates caption & hashtags
   - Composites logo & CTA

5. **Edit & Download:**
   - Drag CTA to reposition
   - Edit caption/hashtags
   - Click "Download"

---

## 🔧 Common Issues & Fixes

### ❌ "Cannot connect to MongoDB"
**Fix:**
```bash
# Start MongoDB
sudo systemctl start mongod

# OR use Atlas
# Update MONGODB_URI in .env with Atlas connection string
```

### ❌ "API key invalid"
**Fix:**
- Verify keys in `.env` have no spaces
- Ensure Hugging Face token starts with `hf_`
- Check Gemini key is from correct project

### ❌ "Image generation timeout"
**Fix:**
- First request can take 60s (model warmup)
- Try again - subsequent requests are faster
- Check Hugging Face quota: https://huggingface.co/settings/billing

### ❌ "Port 5000 already in use"
**Fix:**
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# OR change port in backend/.env
PORT=5001
```

---

## 📝 Environment Variables Reference

```env
# Required
HUGGINGFACE_API_KEY=hf_xxxxxxxxxxxxxxxxxxxxx
GEMINI_API_KEY=AIzaSyxxxxxxxxxxxxxxxxxxxxx

# Database (choose one)
MONGODB_URI=mongodb://localhost:27017/advantage-gen
# OR
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/advantage-gen

# Optional
PORT=5000
```

---

## 🎯 Testing Checklist

After setup, verify each feature:

- [ ] Generate campaign with text prompt
- [ ] Upload and composite brand logo
- [ ] Try all 4 brand voices
- [ ] Test all 3 aspect ratios
- [ ] Edit caption in editor
- [ ] Drag CTA button to reposition
- [ ] Download final image
- [ ] View campaign in history
- [ ] Create a remix
- [ ] Check MongoDB has saved data

---

## 🌐 MongoDB Atlas Setup (Alternative)

If you don't have local MongoDB:

1. Go to https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Add database user
4. Whitelist IP (0.0.0.0/0 for development)
5. Get connection string
6. Update `MONGODB_URI` in `.env`

---

## 📊 Project Status Check

```bash
# Check all services running
curl http://localhost:5000/api/health     # Backend health
curl http://localhost:3000                # Frontend loaded

# Check MongoDB
mongo
> show dbs
> use advantage-gen
> db.campaigns.count()
```

---

## 🚀 Next Steps

Once everything works:

1. **Customize:** Change colors in CSS files
2. **Add Features:** Extend API endpoints
3. **Deploy:** Use Render/Vercel for production
4. **Optimize:** Add caching, CDN for images
5. **Scale:** Add user authentication

---

## 💡 Pro Tips

1. **First generation is slow:** Model needs to warm up (60s)
2. **Use descriptive prompts:** More details = better images
3. **PNG logos work best:** With transparency
4. **Test offline mode:** Save API calls during development
5. **Monitor quota:** Check Hugging Face usage regularly

---

## 🆘 Still Stuck?

Check the full README.md for:
- Detailed troubleshooting
- API documentation
- Deployment guides
- Architecture details

---

**You're all set! Start creating amazing campaigns! 🎉**
