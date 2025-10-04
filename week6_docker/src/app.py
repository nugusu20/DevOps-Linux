import logging
from flask import Flask, request, g
import time

app = Flask(__name__)
app.logger.setLevel(logging.INFO)

@app.before_request
def start_timer():
    g.start = time.time()

@app.after_request
def log_request(response):
    # method, path, status, duration(ms)
    duration_ms = int((time.time() - g.get("start", time.time())) * 1000)
    app.logger.info("%s %s -> %s (%dms)",
                    request.method, request.path, response.status_code, duration_ms)
    return response

@app.route("/")
def home():
    return "Hello from Docker"

if __name__ == "__main__":
    # להאזין על כל הכתובות בתוך הקונטיינר, על פורט 5000
    app.run(host="0.0.0.0", port=5000)
