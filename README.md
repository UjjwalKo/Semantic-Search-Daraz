# Daraz Semantic Search

Daraz Semantic Search is a Django-based web application that implements semantic search for Daraz e-commerce laptop products. The application uses SentenceTransformers and precomputed embeddings to deliver highly relevant search results. It includes semantic similarity models, efficient search mechanisms, and an intuitive interface.

---

## Features

- **Semantic Search**: Finds products based on semantic meaning rather than simple keyword matching.
- **Precomputed Embeddings**: Optimized for fast search using precomputed embeddings.
- **Efficient Model**: Utilizes the LaBSE model from SentenceTransformers for multilingual and high-quality embeddings.
- **User-Friendly Interface**: Intuitive UI for querying and displaying product results.
- **Search Metrics**: Measures and displays search time performance.

---

## Requirements

To install the required dependencies, run:
```bash
pip install -r requirements.txt
```

Sample `requirements.txt`:
```
asgiref==3.8.1
certifi==2024.12.14
charset-normalizer==3.4.0
colorama==0.4.6
Django==5.1.4
filelock==3.16.1
fsspec==2024.10.0
huggingface-hub==0.26.5
idna==3.10
Jinja2==3.1.4
joblib==1.4.2
MarkupSafe==3.0.2
mpmath==1.3.0
networkx==3.4.2
numpy==2.2.0
packaging==24.2
pillow==11.0.0
PyYAML==6.0.2
regex==2024.11.6
requests==2.32.3
safetensors==0.4.5
scikit-learn==1.6.0
scipy==1.14.1
sentence-transformers==3.3.1
setuptools==75.6.0
sqlparse==0.5.3
sympy==1.13.1
threadpoolctl==3.5.0
tokenizers==0.21.0
torch==2.5.1
tqdm==4.67.1
transformers==4.47.0
typing_extensions==4.12.2
tzdata==2024.2
urllib3==2.2.3
```

---

## Installation

### Clone the Repository
```bash
git clone <repository-url>
cd Daraz_Semantic
```

### Prepare Precomputed Embeddings
Ensure the file `embeddings/product_data_embeddings.joblib` is available in the root directory of your project. This file should contain:
- `titles`: List of product titles
- `prices`: List of product prices
- `ratings`: List of product ratings
- `colors`: List of product colors
- `links`: List of product links
- `embeddings`: Precomputed embeddings of product data

### Set Up Django Project
1. Navigate to the project directory.
2. Run the following command to migrate the database:
    ```bash
    python manage.py migrate
    ```
3. Start the development server:
    ```bash
    python manage.py runserver
    ```

---

## Project Structure

```plaintext
Daraz_Semantic/
    manage.py                # Django management script
    Daraz_Semantic/          # Project directory
        settings.py          # Django settings
        urls.py              # Project URL configuration
    search_app/              # Main application
        views.py             # Core semantic search logic
        urls.py              # Application URL configuration
        templates/           # HTML templates
            index/home.html  # Search interface template
    embeddings/              # Precomputed embeddings directory
        product_data_embeddings.joblib
    product_semantic.ipynb   # Jupyter notebook for analysis
```

---

## Usage

### Running the Application
1. Start the Django development server:
    ```bash
    python manage.py runserver
    ```
2. Open a browser and navigate to `http://127.0.0.1:8000/`.
3. Enter a search query in the search bar and view the top product results based on semantic similarity.

### Code Highlights

#### Core Search Logic (`views.py`)
The `search_product` function performs the semantic search:
```python
def search_product(query, threshold=0.3):
    query_embedding = model.encode(query, convert_to_tensor=True)
    hits = util.semantic_search(query_embedding, embeddings)[0]
    hits = sorted(hits, key=lambda x: x['score'], reverse=True)
    top_hits = [hit for hit in hits if hit['score'] >= threshold]
    return top_hits
```
The `index` view handles the search request and passes results to the template:
```python
def index(request):
    results = []
    query = None

    if request.method == 'POST':
        query = request.POST.get('query', '')
        if query:
            start_time = time.time()
            hits = search_product(query)
            end_time = time.time()

            results = [
                {
                    'title': titles[hit['corpus_id']],
                    'price': prices[hit['corpus_id']],
                    'rating': ratings[hit['corpus_id']],
                    'color': colors[hit['corpus_id']],
                    'link': links[hit['corpus_id']],
                    'score': hit['score']
                }
                for hit in hits[:4]  # Display top 4 results
            ]
            elapsed_time = end_time - start_time
            print(f"Search completed in {elapsed_time:.3f} seconds!")

    return render(request, 'index/home.html', {'results': results, 'query': query})
```

---
