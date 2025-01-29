# Log Archive Tool

The following `bash` script compresses logs into a `.tar.gz` file in a directory of choice. This is an implementation of the [DevOps sh roadmap exercise](https://roadmap.sh/projects/log-archive-tool)

## Table of contents
- [Requirements](#requirements)
- [Usage](#usage)
- [To-Dos](#todos)

## Requirements
You can run this script on any Linux/Unix device. In my case I am running on a `Ubuntu 20.04` system.

## Usage
To run this project, use the following command:
```bash
bash log-archive <log-directory>
```

## To-Dos
- The tool could send some updates regarding the file on the archive to the user's email.
- The `.tar` compressed log archive could be sent to a remote server or cloud storage.
