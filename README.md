# 🚀 AdVantage Gen - Automated Social Media Campaign Studio

**A complete 4-week internship project for automated social media campaign generation using AI**

## 📋 Project Overview

AdVantage Gen is a full-stack web application that automates the creation of social media ad campaigns by:
- 🎨 Generating AI images from text prompts (Hugging Face SDXL)
- ✍️ Writing optimized ad copy with customizable brand voices (Google Gemini)
- 🎯 Compositing brand logos and CTAs onto generated images
- 📝 Providing an interactive editor for fine-tuning campaigns
- 💾 Storing campaign history with MongoDB
- 🎭 Creating campaign remixes with variations

---

## 🏗️ Architecture

### Tech Stack

**Backend:**
- Node.js + Express.js
- MongoDB (Database)
- Sharp (Image processing)
- Multer (File uploads)
- Axios (API requests)

**Frontend:**
- React.js
- CSS3 (Custom styling)
- Responsive design

**APIs:**
- Hugging Face Inference API (Stable Diffusion XL)
- Google Gemini API (Text generation)

---

## 📦 Installation & Setup

### Prerequisites

1. **Node.js** (v16 or higher)
2. **MongoDB** (Local or Atlas)
3. **API Keys:**
   - Hugging Face API Key ([Get it here](https://huggingface.co/settings/tokens))
   - Google Gemini API Key ([Get it here](https://makersuite.google.com/app/apikey))

### Step 1: Clone the Project

```bash
# Create project directory
mkdir advantage-gen
cd advantage-gen
```

### Step 2: Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env
```

**Edit `.env` file:**
```env
HUGGINGFACE_API_KEY=your_huggingface_token_here
GEMINI_API_KEY=your_gemini_api_key_here
MONGODB_URI=mongodb://localhost:27017/advantage-gen
PORT=5000
```

### Step 3: Frontend Setup

```bash
# Navigate to frontend (from project root)
cd ../frontend

# Install dependencies
npm install
```

### Step 4: Start MongoDB

**Option A - Local MongoDB:**
```bash
mongod
```

**Option B - MongoDB Atlas:**
Update `MONGODB_URI` in `.env` with your Atlas connection string.

### Step 5: Run the Application

**Terminal 1 - Backend:**
```bash
cd backend
npm start
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm start
```

The app will open at `http://localhost:3000`

---

## 📅 4-Week Implementation Roadmap

### ✅ Week 1: Image Generation Engine

**Features Implemented:**
- ✅ Hugging Face SDXL integration
- ✅ Prompt enhancement using Gemini LLM
- ✅ Image generation API endpoint
- ✅ Error handling & rate limiting

**Files:**
- `backend/server.js` - `enhancePrompt()`, `generateImage()`
- Test endpoint: `POST /api/generate-image`

**Success Metrics:** Generate 10+ high-quality images from varied prompts

---

### ✅ Week 2: Copywriting & Branding

**Features Implemented:**
- ✅ Brand voice tuning (Witty, Professional, Urgent, Inspirational)
- ✅ Caption + hashtag generation
- ✅ Logo upload & compositing with Sharp
- ✅ CTA button overlay
- ✅ Platform-specific aspect ratios

**Files:**
- `backend/server.js` - `generateCopy()`, `compositeImage()`
- `frontend/src/components/CampaignGenerator.js`

**Success Metrics:** Logo correctly positioned across all aspect ratios

---

### ✅ Week 3: Studio UI & Editor

**Features Implemented:**
- ✅ React-based campaign generator form
- ✅ Visual preview with draggable CTA positioning
- ✅ Caption/hashtag editor
- ✅ Copy-to-clipboard functionality
- ✅ Download finished campaigns

**Files:**
- `frontend/src/components/CampaignEditor.js`
- `frontend/src/components/CampaignEditor.css`

**Success Metrics:** Complete UX flow: Prompt → Generate → Edit → Download

---

### ✅ Week 4: Scaling & History

**Features Implemented:**
- ✅ MongoDB persistence for all campaigns
- ✅ Campaign history view with grid layout
- ✅ Remix feature (generate variations)
- ✅ Rate limit handling & error reporting
- ✅ Campaign metadata tracking

**Files:**
- `backend/server.js` - Campaign Schema, history endpoints
- `frontend/src/components/CampaignHistory.js`

**Success Metrics:** Robust error handling, working remix system

---

## 🎯 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/generate-image` | Generate image from prompt |
| POST | `/api/generate-campaign` | Full campaign generation |
| GET | `/api/campaigns` | Get campaign history |
| GET | `/api/campaigns/:id` | Get single campaign |
| PUT | `/api/campaigns/:id` | Update campaign |
| POST | `/api/campaigns/:id/remix` | Create campaign variant |
| GET | `/api/health` | Health check |

---

## 🎨 Features Breakdown

### 1. Multi-Modal Generation
- **Parallel Processing:** Image and text generation run concurrently
- **Smart Prompt Enhancement:** LLM rewrites user prompts for better image results
- **Timeout Handling:** 60-second timeout for image generation

### 2. Template Overlay System
- **Sharp-based compositing:** Professional image manipulation
- **Dynamic positioning:** Logo in bottom-right with opacity control
- **CTA badges:** Customizable call-to-action buttons

### 3. Brand Voice Engine
- **4 Tone Presets:** Each with distinct personality
- **Context-aware hashtags:** Platform-appropriate suggestions
- **Structured output parsing:** Reliable caption extraction

### 4. Interactive Editor
- **Drag-and-drop:** Reposition CTA elements visually
- **Live preview:** See changes in real-time
- **Copy editing:** Modify captions and hashtags

### 5. Campaign Management
- **Full CRUD operations:** Create, Read, Update campaigns
- **Rich metadata:** Track tone, aspect ratio, timestamps
- **Remix system:** Generate variations with minor prompt tweaks

---

## 🧪 Testing the Application

### 1. Test Basic Image Generation

```bash
curl -X POST http://localhost:5000/api/generate-image \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Modern coffee shop interior with natural lighting"}'
```

### 2. Test Full Campaign Generation

Use the UI or:
```bash
curl -X POST http://localhost:5000/api/generate-campaign \
  -F "prompt=Eco-friendly water bottle in mountain setting" \
  -F "tone=Inspirational" \
  -F "ctaText=Shop Now" \
  -F "aspectRatio=square"
```

### 3. Test Campaign History

```bash
curl http://localhost:5000/api/campaigns
```

---

## 🎓 Usage Guide

### Creating Your First Campaign

1. **Navigate to Generate Tab**
2. **Enter a descriptive prompt:**
   - Good: "Eco-friendly coffee cup on wooden table, morning sunlight, minimalist aesthetic"
   - Bad: "coffee cup"
3. **Select brand voice** (Professional, Witty, Urgent, Inspirational)
4. **Choose platform format** (Instagram, Story, LinkedIn)
5. **Upload brand logo** (optional, PNG recommended)
6. **Click "Generate Campaign"**
7. **Wait 20-30 seconds** for AI processing

### Editing Your Campaign

1. **Review the generated image & copy**
2. **Drag the CTA button** to reposition
3. **Edit caption and hashtags** in the right panel
4. **Click "Save Changes"**
5. **Download final asset**

### Creating Remixes

1. **Go to History tab**
2. **Find a campaign you like**
3. **Click "Remix"**
4. **Enter variation** (e.g., "with sunset lighting")
5. **Wait for new version to generate**

---

## 🔧 Troubleshooting

### Issue: Images not generating

**Solutions:**
- Check Hugging Face API key in `.env`
- Verify API key has sufficient quota
- Check if model is warming up (first request can take 60s)

### Issue: Copy generation fails

**Solutions:**
- Verify Gemini API key
- Check API quota limits
- Ensure proper JSON parsing in response

### Issue: Logo not appearing

**Solutions:**
- Use PNG format with transparency
- Check file size (< 5MB)
- Verify upload path permissions

### Issue: MongoDB connection error

**Solutions:**
- Ensure MongoDB is running: `sudo systemctl status mongod`
- Check connection string in `.env`
- Verify network access for Atlas

---

## 📊 Database Schema

```javascript
Campaign {
  userId: String,
  prompt: String,
  enhancedPrompt: String,
  tone: String,
  caption: String,
  hashtags: [String],
  imageUrl: String,
  finalImageUrl: String,
  brandLogoUrl: String,
  ctaText: String,
  createdAt: Date,
  metadata: {
    aspectRatio: String,
    platform: String
  }
}
```

---

## 🚀 Deployment

### Backend Deployment (Render/Railway)

1. Push code to GitHub
2. Create new Web Service
3. Add environment variables
4. Connect MongoDB Atlas
5. Deploy

### Frontend Deployment (Vercel/Netlify)

1. Run `npm run build` in frontend directory
2. Deploy `build` folder
3. Update API base URL to production backend

---

## 📝 Project Structure

```
advantage-gen/
├── backend/
│   ├── server.js              # Main Express server
│   ├── package.json
│   ├── .env.example
│   ├── outputs/               # Generated images (auto-created)
│   └── uploads/               # Temporary uploads (auto-created)
│
├── frontend/
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── components/
│   │   │   ├── CampaignGenerator.js
│   │   │   ├── CampaignGenerator.css
│   │   │   ├── CampaignEditor.js
│   │   │   ├── CampaignEditor.css
│   │   │   ├── CampaignHistory.js
│   │   │   └── CampaignHistory.css
│   │   ├── App.js
│   │   ├── App.css
│   │   ├── index.js
│   │   └── index.css
│   └── package.json
│
└── README.md
```

---

## 🎯 Key Learning Outcomes

By completing this project, you will have learned:

1. **Full-Stack Development:** React + Node.js + MongoDB
2. **AI Integration:** Working with LLM and image generation APIs
3. **Image Processing:** Sharp library for compositing
4. **Async Programming:** Promises, async/await, parallel processing
5. **RESTful APIs:** Designing and implementing REST endpoints
6. **State Management:** React hooks and component communication
7. **Error Handling:** Rate limiting, timeouts, user feedback
8. **UI/UX Design:** Responsive design, drag-and-drop interfaces

---

## 🔐 Security Best Practices

- ✅ API keys stored in `.env` (never commit)
- ✅ File upload validation (size, type)
- ✅ Rate limiting on API endpoints
- ✅ Input sanitization
- ✅ CORS configuration
- ✅ Error messages don't expose internals

---

## 🆘 Support & Resources

- **Hugging Face Docs:** https://huggingface.co/docs/api-inference
- **Gemini API Docs:** https://ai.google.dev/docs
- **Sharp Docs:** https://sharp.pixelplumbing.com/
- **MongoDB Docs:** https://docs.mongodb.com/
- **React Docs:** https://react.dev/

---

## 📜 License

This project is for educational purposes as part of an internship program.

---

## 👨‍💻 Author

**Your Name**
- Internship Project: Automated Social Media Campaign Studio
- Duration: 4 Weeks
- Status: ✅ Complete

---

## 🎉 Acknowledgments

- Hugging Face for Stable Diffusion models
- Google for Gemini API
- MongoDB for database solutions
- React team for frontend framework

---

**Happy Coding! 🚀**
