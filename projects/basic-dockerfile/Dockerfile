ARG IMG_VERSION=latest
FROM alpine:${IMG_VERSION}

# Pass YOUR_NAME as an environment variable
ENV YOUR_NAME="Fulano"

# Use JSON array for CMD to prevent shell signal issues
CMD ["sh", "-c", "echo \"Hello, Captain $YOUR_NAME!\""]
