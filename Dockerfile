FROM python:3.12.1
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY daraz_semantic_search/requirements.txt .
RUN pip install -r requirements.txt
COPY daraz_semantic_search/ . 
