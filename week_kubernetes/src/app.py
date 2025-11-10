from flask import Flask, jsonify, request

app = Flask(__name__)

# Fake in-memory DB
tasks = {
    1: {"id": 1, "title": "Deploy app to Kubernetes", "done": False},
    2: {"id": 2, "title": "Add readinessProbe", "done": False}
}

@app.route("/")
def home():
    return "🚀 Welcome to Task Manager API running inside Kubernetes!"

@app.route("/healthz")
def health_check():
    return jsonify({"status": "ok"})

@app.route("/tasks", methods=["GET"])
def get_tasks():
    return jsonify(list(tasks.values()))

@app.route("/tasks/<int:task_id>", methods=["GET"])
def get_task(task_id):
    task = tasks.get(task_id)
    if not task:
        return jsonify({"error": "Task not found"}), 404
    return jsonify(task)

@app.route("/tasks", methods=["POST"])
def create_task():
    data = request.json
    if not data or "title" not in data:
        return jsonify({"error": "Title is required"}), 400
    new_id = max(tasks.keys()) + 1
    tasks[new_id] = {"id": new_id, "title": data["title"], "done": False}
    return jsonify(tasks[new_id]), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

