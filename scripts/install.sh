#!/usr/bin/env bash

set -e

echo "⚔️ Onchain Workstation Installer for Kali Linux"
echo "------------------------------------------------"

echo "📦 Updating package index..."
sudo apt update

echo "🛠️ Installing system dependencies..."
sudo apt install -y \
  curl \
  build-essential \
  pkg-config \
  libudev-dev \
  llvm \
  libclang-dev \
  protobuf-compiler \
  libssl-dev \
  git \
  ca-certificates

echo "🐳 Checking for conflicting Docker sources..."

if [ -f /etc/apt/sources.list.d/docker.sources ]; then
  echo "Removing docker.sources..."
  sudo rm /etc/apt/sources.list.d/docker.sources
fi

if [ -f /etc/apt/sources.list.d/docker.list ]; then
  echo "Removing docker.list..."
  sudo rm /etc/apt/sources.list.d/docker.list
fi

echo "🦀 Installing Rust if missing..."

if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "Rust is already installed."
fi

echo "📦 Installing Corepack/Yarn..."

if ! command -v corepack >/dev/null 2>&1; then
  sudo npm install -g corepack
fi

corepack enable
corepack prepare yarn@stable --activate

echo "⚙️ Installing Solana development tools with Mucho..."
npx mucho install

echo "🧪 Verifying installations..."
echo "Rust:"
rustc --version || true

echo "Cargo:"
cargo --version || true

echo "Solana:"
solana --version || true

echo "Anchor:"
anchor --version || true

echo "Yarn:"
yarn -v || true

echo "✅ Setup complete."
echo "Run this to test your local Solana validator:"
echo "solana-test-validator"