# SSH Remote Server Setup

Setting up remote Linux server as a DigitalOcean Droplet and configuring it to allow SSH connections. This is my implementation of [roadmap.sh](https://roadmap.sh/projects/ssh-remote-server-setup)

## Table of contents
- [Requirements](#Requirements)
- [Usage](#Usage)

## Requirements
The following code assumes that you are using a Ubuntu/Debian device and anyserver (a proprietary one of yours, or a public cloud server). In my case I created a [DigitalOcean Droplet](https://www.digitalocean.com/products/droplets) since at the time of writing this you get a 200$ free credit for 2 months when signing up.

## Usage
Once you have a server running and connectivity to it from your device (client), if you do not have SSH keys, you should first you must generate SSH keys for it. The next command will do so:
```bash
ssh-keygen -t ed25519
```

This will create (if it did not exist before) a `~/.ssh` directory and generate two files:
- *Private key*: `~/.ssh/id_ed25519`
- *Public key*: `~/.ssh/id_ed25519.pub`
Also the command will prompt you for a file location and passphrase to access the keys.

Next, it is time to configure establish SSH connectivity to the server. To do so, run the following code snippet.
```bash
ssh -i <path-to-private-key> user@server-ip
```

After running the above code, you should be prompted for the login credentials. If you created a DigitalOcean Droplet you should receive those credentials in the email. Once logged in to the server, you must add the public SSH key of the client to the `~/.ssh/authorized_keys` file, to do execute the next code:
```bash
mkdir -p ~/.ssh
echo "<your-public-key>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

Lastly, you can create a `~/.ssh/config` file in your computer (client) to connect to the server more easily by creating an alias for the server. This repository contains a template of the `~/.ssh/config` which you can use.
```bash
nano ~/.ssh/config   # to create the file
ssh alias-server     # to connect to the server
```
