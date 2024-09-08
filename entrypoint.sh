#!/bin/bash

echo "Starting entrypoint script..."

# Create upload folder if it doesn't exist (redundant with Dockerfile, but kept for safety)
mkdir -p /app/app/static/uploads

# Start the Flask application
echo "Starting Flask application..."
flask run --host=0.0.0.0