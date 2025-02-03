# AutoDarts Setup Script

This script is used to setup the AutoDarts detection service, along with the browser display. It is designed for the Raspberry Pi 5, but may work on other Raspberry Pis.

## Installation

1. Install Raspberry Pi OS Desktop 64-bit on your Raspberry Pi using Raspberry Pi Imager, with the username set to `autodarts`.
2. Run the following command in the terminal to run the script:

```bash
bash <(curl -s https://raw.githubusercontent.com/hwalker928/autodarts-setup/master/setup.sh)
```
3. Follow the on-screen instructions, some steps are not completed by this script, and will be shown in the terminal.

## What does this script do?

This script will:
- Check if the script is run as the correct user.
- Verify the existence of required directories and files.
- Ensure necessary commands are available.
- Update and upgrade the system packages.
- Install required packages.
- Enable VNC Server.
- Expand the root filesystem.
- Copy assets and configuration files to appropriate locations.
- Set the desktop wallpaper and splash screen.
- Install the AutoDarts service.
- Enable linger for `rpi-connect`.
- Hide unnecessary desktop icons.
- Disable Bluetooth.
- Authenticate with `rpi-connect`.
- Schedule automatic shutdown and updates.
- Provide remaining manual tasks for the user.