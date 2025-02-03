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

commands=("curl" "rpi-connect" "pcmanfm" "plymouth-set-default-theme" "loginctl" "sed" "rpi-connect")

for cmd in "${commands[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo "The command '$cmd' could not be found. Please install it before running this script."
        exit 1
    fi
done

# Update and upgrade the system
echo "Upgrading packages"
sudo apt update
sudo apt upgrade -y

# Install the necessary packages
echo "Installing required packages"
sudo apt install curl rpi-connect -y

# Enable VNC Server
echo "Enabling VNC Server"
sudo raspi-config nonint do_vnc 1

# Expand Root Filesystem
echo "Expanding the filesystem"
sudo raspi-config nonint do_expand_rootfs

# Copy the assets folder
echo "Copying assets folder"
sudo cp -r assets/ ~/.assets/

# Set the wallpaper
echo "Setting the wallpaper"
pcmanfm --set-wallpaper ~/.assets/wallpaper.jpg

# Set the splash screen background
echo "Setting the splash screen"
sudo cp assets/splash.png /usr/share/plymouth/themes/pix/splash.png
sudo plymouth-set-default-theme -R pix

# Copy the autodarts logo to the Raspberry Pi artwork directory
echo "Copying user logo"
sudo cp assets/logo.png /usr/share/raspberrypi-artwork/autodarts_logo.png

# Copy the login configuration file
echo "Copying login configuration"
sudo cp configs/pi-greeter.conf /etc/lightdm/pi-greeter.conf

# Copy the scripts and set the permissions
echo "Copying scripts"
sudo cp -r scripts/ ~/.scripts/
sudo chmod +x ~/.scripts/*.sh

# Create the autostart folder
echo "Creating autostart folder"
mkdir -p ~/.config/autostart

# Copy the autodarts.desktop file to the autostart directory
echo "Copying autostart file"
sudo cp configs/autodarts.desktop ~/.config/autostart/autodarts.desktop

# Install AutoDarts service
echo "Installing AutoDarts"
bash <(curl -sL get.autodarts.io)

# Enable linger to allow rpi-connect to function
echo "Enabling linger for rpi-connect"
loginctl enable-linger

# Hide the trashcan from the desktop
echo "Hiding desktop icons"
sed -i 's/show_trash=1/show_trash=0/' ~/.config/pcmanfm/LXDE-pi/desktop-items-*.conf
sed -i 's/show_mounts=1/show_mounts=0/' ~/.config/pcmanfm/LXDE-pi/desktop-items-*.conf
sed -i 's/show_documents=1/show_documents=0/' ~/.config/pcmanfm/LXDE-pi/desktop-items-*.conf

# Remove bluetooth since it's not needed
echo "Disabling bluetooth"
sudo systemctl stop bluetooth
sudo systemctl disable bluetooth

# Authenticate with rpi-connect
rpi-connect on
rpi-connect signin

# Add automatic shutdown at 5am
echo "00 05 * * * root /sbin/shutdown -h now" | sudo tee -a /etc/crontab > /dev/null

# Add automatic updates at 4:30am
echo "30 04 * * * root apt update && apt upgrade -y" | sudo tee -a /etc/crontab > /dev/null

echo "Remaining tasks:"
echo "1. Reboot the Raspberry Pi"
echo "2. Disable Wastebasket and External Disks on the desktop"
echo "3. Enable Desktop Autologin"
echo "4. Set a static IP address"
echo "5. Link the board to the account"
echo "6. Configure the cameras"
