FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy files
COPY upload.py .
COPY courses.csv .
COPY students.csv .
COPY assessments.csv .

# Install required library
RUN pip install azure-storage-file-datalake azure-identity

# Run script
CMD ["python", "upload.py"]
