FROM python:3.12-slim

WORKDIR /app

# כלים בסיסיים שנצטרך גם ל-HEALTHCHECK
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# מתקינים תלותים לפי רשימה (שומר cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# קוד האפליקציה
COPY src/ /app/

# האפליקציה מאזינה בפנים על 5000
EXPOSE 5000

# ✅ HEALTHCHECK אמיתי שמוודא 200 מהאפליקציה
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -fsS http://127.0.0.1:5000/ || exit 1

# הפעלה
CMD ["python", "app.py"]
