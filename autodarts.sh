if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root."
    exit 1
fi

if [ "$(whoami)" != "autodarts" ]; then
    echo "This script must be run as the user 'autodarts'. You are currently logged in as '$(whoami)'."
    exit 1
fi

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install the necessary packages
sudo apt install curl rpi-connect -y

# Copy the assets folder
sudo cp -r assets/ ~/.assets/

# TODO: change the path to the wallpaper
pcmanfm --set-wallpaper=~/.assets/wallpaper.jpg

# Set the splash screen background
sudo cp assets/splash.png /usr/share/plymouth/themes/pix/splash.png
sudo plymouth-set-default-theme -R pix

# Copy the autodarts logo to the Raspberry Pi artwork directory
sudo cp assets/autodarts_logo.png /usr/share/raspberrypi-artwork/autodarts_logo.png

# Copy the login configuration file
sudo cp configs/pi-greeter.conf /etc/lightdm/pi-greeter.conf

# Copy the scripts and set the permissions
sudo cp -r scripts/ ~/.scripts/
sudo chmod +x ~/.scripts/*.sh

# Copy the autodarts.desktop file to the autostart directory
sudo cp configs/autodarts.desktop ~/.config/autostart/autodarts.desktop

# Install AutoDarts service
bash <(curl -sL get.autodarts.io)

loginctl enable-linger

rpi-connect signin
rpi-connect on