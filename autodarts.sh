if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root."
    exit 1
fi

if [ "$(whoami)" != "autodarts" ]; then
    echo "This script must be run as the user 'autodarts'. You are currently logged in as '$(whoami)'."
    exit 1
fi

if [ ! -d "assets" ]; then
    echo "The assets folder does not exist. Please make sure it is present in the current directory."
    exit 1
fi

if [ ! -d "configs" ]; then
    echo "The configs folder does not exist. Please make sure it is present in the current directory."
    exit 1
fi

if [ ! -d "scripts" ]; then
    echo "The scripts folder does not exist. Please make sure it is present in the current directory."
    exit 1
fi

if [ ! -f "/etc/lightdm/pi-greeter.conf" ]; then
    echo "The file /etc/lightdm/pi-greeter.conf does not exist."
    exit 1
fi

if [ ! -f "/usr/share/plymouth/themes/pix/splash.png" ]; then
    echo "The file /usr/share/plymouth/themes/pix/splash.png does not exist."
    exit 1
fi

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install the necessary packages
sudo apt install curl rpi-connect -y

# Enable VNC Server
sudo raspi-config nonint do_vnc 1

# Expand Root Filesystem
sudo raspi-config nonint do_expand_rootfs

# Copy the assets folder
sudo cp -r assets/ ~/.assets/

# Set the wallpaper
pcmanfm --set-wallpaper=~/.assets/wallpaper.jpg

# Set the splash screen background
sudo cp assets/splash.png /usr/share/plymouth/themes/pix/splash.png
sudo plymouth-set-default-theme -R pix

# Copy the autodarts logo to the Raspberry Pi artwork directory
sudo cp assets/logo.png /usr/share/raspberrypi-artwork/autodarts_logo.png

# Copy the login configuration file
sudo cp configs/pi-greeter.conf /etc/lightdm/pi-greeter.conf

# Copy the scripts and set the permissions
sudo cp -r scripts/ ~/.scripts/
sudo chmod +x ~/.scripts/*.sh

mkdir -p ~/.config/autostart

# Copy the autodarts.desktop file to the autostart directory
sudo cp configs/autodarts.desktop ~/.config/autostart/autodarts.desktop

# Install AutoDarts service
bash <(curl -sL get.autodarts.io)

loginctl enable-linger

rpi-connect signin
rpi-connect on

echo "Remaining tasks:"
echo "1. Reboot the Raspberry Pi"
echo "2. Disable Wastebasket and External Disks on the desktop"
echo "3. Enable Desktop Autologin"
echo "4. Set a static IP address"
echo "5. Link the board to the account"
echo "6. Configure the cameras"