# ARKAA AI Security Range — single-container lab host.
# Built on LLMVault (MIT) by Sunil Tripathy. See ../ATTRIBUTION.md.
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

COPY . .

# Progress is a JSON file, not a database. Mount a volume here to keep it.
RUN mkdir -p /app/data
VOLUME ["/app/data"]

EXPOSE 5000

# Single worker on purpose: the scoreboard is in-process state.
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "--timeout", "300", "app:app"]
