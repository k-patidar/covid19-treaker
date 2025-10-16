import requests
import time
from flask import Flask, jsonify, request
from flask_caching import Cache
from prometheus_client import generate_latest, Counter, Gauge

app = Flask(__name__)
app.config['CACHE_TYPE'] = 'SimpleCache'
app.config['CACHE_DEFAULT_TIMEOUT'] = 60
cache = Cache(app)

REQUEST_COUNT = Counter('covid_api_requests_total', 'Total API requests')
COUNTRY_STATS = Gauge('covid_country_stats', 'Country COVID stats', ['country'])

COVID_API_URL = 'https://disease.sh/v3/covid-19/countries'

@app.route('/api/countries')
@cache.cached()
def get_countries():
    REQUEST_COUNT.inc()
    try:
        resp = requests.get(COVID_API_URL, timeout=10)
        resp.raise_for_status()
        data = resp.json()
        countries = [
            {
                'country': c['country'],
                'cases': c['cases'],
                'deaths': c['deaths'],
                'recovered': c['recovered'],
                'flag': c['countryInfo']['flag']
            } for c in data
        ]
        for c in countries:
            COUNTRY_STATS.labels(country=c['country']).set(c['cases'])
        return jsonify(countries)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/country/<country>')
@cache.cached()
def get_country(country):
    REQUEST_COUNT.inc()
    try:
        resp = requests.get(f"{COVID_API_URL}/{country}", timeout=10)
        resp.raise_for_status()
        c = resp.json()
        COUNTRY_STATS.labels(country=c['country']).set(c['cases'])
        return jsonify({
            'country': c['country'],
            'cases': c['cases'],
            'deaths': c['deaths'],
            'recovered': c['recovered'],
            'flag': c['countryInfo']['flag']
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain; charset=utf-8'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
