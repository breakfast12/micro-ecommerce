# Use the official Python image from the Docker Hub
FROM python:3.12.4-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential python3-dev python3-setuptools libpq-dev gcc make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file first to leverage Docker cache
COPY ./src/requirements.txt /app/requirements.txt

# Create a virtual environment and install Python dependencies
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python3 -m pip install --upgrade pip && \
    /opt/venv/bin/python3 -m pip install -r /app/requirements.txt

# Copy the application code to the working directory
COPY ./src/ /app/

# Ensure entrypoint script is properly placed and executable
COPY ./src/config/entrypoint.sh /app/config/entrypoint.sh
RUN chmod +x /app/config/entrypoint.sh

# Copy and set permissions for media content
COPY local-cdn/media /app/local-cdn/media
COPY local-cdn/protected /app/local-cdn/protected

# Collect static files
RUN /opt/venv/bin/python3 /app/manage.py collectstatic --noinput

# Define the entrypoint script as the default command
CMD ["/app/config/entrypoint.sh"]
