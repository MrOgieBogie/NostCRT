#!/usr/bin/env bash

echo "🛠️ Applying Intel iGPU optimizations for Bazzite on LattePanda 3 Delta..."

# Step 1: Environment Variables for Mesa and Vulkan
echo "🔧 Setting environment variables..."
ENV_FILE="/etc/environment"
sudo sed -i '/MESA_GL_VERSION_OVERRIDE/d' "$ENV_FILE"
sudo sed -i '/MESA_GLSL_VERSION_OVERRIDE/d' "$ENV_FILE"
sudo sed -i '/vblank_mode/d' "$ENV_FILE"
sudo sed -i '/mesa_glthread/d' "$ENV_FILE"
echo 'MESA_GL_VERSION_OVERRIDE=4.6' | sudo tee -a "$ENV_FILE"
echo 'MESA_GLSL_VERSION_OVERRIDE=460' | sudo tee -a "$ENV_FILE"
echo 'vblank_mode=0' | sudo tee -a "$ENV_FILE"
echo 'mesa_glthread=true' | sudo tee -a "$ENV_FILE"

# Step 2: Install Vulkan tools and performance monitoring
echo "📦 Installing Vulkan tools and htop..."
sudo dnf install -y vulkan-tools gamemode htop nvtop power-profiles-daemon

# Step 3: Set power mode to 'performance'
echo "⚡ Setting power profile to performance..."
sudo powerprofilesctl set performance

# Step 4: Disable KDE animations for smoother GPU performance
echo "🎨 Disabling KDE desktop effects..."
kwriteconfig5 --file kwinrc --group Compositing --key Enabled false
qdbus org.kde.KWin /KWin reconfigure

# Step 5: ProtonUp-Qt (for managing Proton GE)
echo "🚀 Installing ProtonUp-Qt..."
flatpak install -y flathub net.davidotek.pupgui2

# Step 6: Clean up & Reminder
echo "✅ Optimization complete! Please reboot to apply environment changes."

# Optional: Display Vulkan GPU info
echo "🧪 Checking Vulkan GPU support:"
vulkaninfo | grep "deviceName"

exit 0
