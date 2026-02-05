#!/bin/bash

# AdVantage Gen - Automated Setup Script
# This script automates the installation process

echo "🚀 AdVantage Gen Setup Script"
echo "=============================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "Please install Node.js v16 or higher from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✓${NC} Node.js detected: $NODE_VERSION"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo -e "${GREEN}✓${NC} npm detected: $NPM_VERSION"
echo ""

# Setup Backend
echo "📦 Setting up backend..."
cd backend

if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ backend/package.json not found${NC}"
    exit 1
fi

echo "Installing backend dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend installation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Backend dependencies installed"

# Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    echo ""
    echo -e "${YELLOW}⚠ .env file not found. Creating from template...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓${NC} .env file created"
    echo ""
    echo -e "${YELLOW}⚠ IMPORTANT: Please edit backend/.env and add your API keys:${NC}"
    echo "  - HUGGINGFACE_API_KEY"
    echo "  - GEMINI_API_KEY"
    echo "  - MONGODB_URI (if using Atlas)"
    echo ""
fi

# Create outputs directory
mkdir -p outputs
mkdir -p uploads

cd ..

# Setup Frontend
echo "📦 Setting up frontend..."
cd frontend

if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ frontend/package.json not found${NC}"
    exit 1
fi

echo "Installing frontend dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Frontend installation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Frontend dependencies installed"

cd ..

# Check MongoDB
echo ""
echo "🗄️  Checking MongoDB..."

if command -v mongod &> /dev/null; then
    echo -e "${GREEN}✓${NC} MongoDB detected"
    
    # Try to check if MongoDB is running
    if pgrep -x "mongod" > /dev/null; then
        echo -e "${GREEN}✓${NC} MongoDB is running"
    else
        echo -e "${YELLOW}⚠${NC} MongoDB is installed but not running"
        echo "  Start it with: sudo systemctl start mongod"
        echo "  OR: mongod"
    fi
else
    echo -e "${YELLOW}⚠${NC} MongoDB not detected locally"
    echo "  Options:"
    echo "  1. Install MongoDB locally"
    echo "  2. Use MongoDB Atlas (cloud) - Update MONGODB_URI in backend/.env"
fi

echo ""
echo "=============================="
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "=============================="
echo ""
echo "📝 Next Steps:"
echo ""
echo "1. Add your API keys to backend/.env:"
echo "   - Get Hugging Face key: https://huggingface.co/settings/tokens"
echo "   - Get Gemini key: https://makersuite.google.com/app/apikey"
echo ""
echo "2. Make sure MongoDB is running:"
echo "   Local: sudo systemctl start mongod"
echo "   OR use MongoDB Atlas (update MONGODB_URI in .env)"
echo ""
echo "3. Start the backend:"
echo "   cd backend && npm start"
echo ""
echo "4. Start the frontend (new terminal):"
echo "   cd frontend && npm start"
echo ""
echo "5. Open http://localhost:3000 in your browser"
echo ""
echo "📖 For detailed instructions, see:"
echo "   - README.md (full documentation)"
echo "   - QUICKSTART.md (quick start guide)"
echo ""
echo "🧪 To test the API:"
echo "   ./test-api.sh"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
