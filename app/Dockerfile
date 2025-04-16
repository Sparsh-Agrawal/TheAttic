# Use official Python image as base
FROM python:3.11-slim

# Create a non-root user
RUN useradd -m particle

# working dir
WORKDIR /app

# Copy file
COPY main.py .

# Install Flask
RUN pip install --no-cache-dir Flask

# Change ownership
RUN chown -R particle:particle /app

# Switch to non-root user
USER particle

# Expose the port the app runs on
EXPOSE 7000

# Run the application
CMD ["python", "main.py"]