# FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.28
FROM docker.elastic.co/elasticsearch/elasticsearch:8.18.2
# FROM docker.elastic.co/elasticsearch/elasticsearch:9.0.2

# Installe le plugin nécessaire pour le tokenizer ICU
RUN elasticsearch-plugin install --batch analysis-icu
