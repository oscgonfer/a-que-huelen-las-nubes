import flask

app = flask.Flask(__name__)

@app.route("/")
def home():
  return flask.send_file("static/index.html")

@app.route("/<path:path>")
def static_file(path):
  return flask.send_from_directory("static", path)
  
if __name__ == "__main__":
  app.run("localhost", 5000)