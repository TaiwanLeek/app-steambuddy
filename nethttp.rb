# frozen_string_literal: true

# Reference: https://www.twilio.com/blog/5-ways-make-http-requests-ruby



require 'httparty'

response = HTTParty.get('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY')
#puts response.body if response.code == 200

response = HTTParty.get('https://openapi.taifex.com.tw/v1/Daily_FUT')
#puts response.body


url = "https://api.finmindtrade.com/api/v4/data"
parameter = { 
     "dataset": "TaiwanExchangeRate",
     "data_id": "USD",
     "start_date": "2006-01-01",
}

response = HTTParty.get(url, parameter)
puts response.body