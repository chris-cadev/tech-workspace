from flask import Flask, request, render_template
import pysolr

app = Flask(__name__)
solr = pysolr.Solr(
    'http://localhost:8983/solr/subscriptions', always_commit=True)


def main():
    app.run(debug=True)


@app.route("/", methods=["GET", "POST"])
def search():
    query = request.form.get(
        "query", "") if request.method == "POST" else request.args.get("query", "")
    page = int(request.form.get("page", 1)) if request.method == "POST" else int(
        request.args.get("page", 1))
    results_per_page = 10  # Adjust this as needed
    results = []

    if query:
        start = (page - 1) * results_per_page
        search_results = solr.search(
            f"title:*{query}* OR description:*{query}*",
            **{
                "fl": "id,title,sourceUserEmail,sourceChannelTitle,description,thumbnail",
                "start": start,
                "rows": results_per_page
            }
        )
        results = [{key: value[0] if key != 'id' else value for key, value in doc.items()}
                   for doc in search_results]

    # Assuming this part is already present in your search function
    total_results = solr.search(
        f"title:*{query}* OR description:*{query}*",
        **{
            "fl": "id"
        }
    ).hits
    total_pages = (total_results + results_per_page -
                   1) // results_per_page  # Ceiling division

    # Pass all necessary variables to the template
    return render_template("search.html", results=results, current_page=page, total_pages=total_pages, query=query)


if __name__ == "__main__":
    app.run(debug=True)
