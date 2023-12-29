require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# erb{:layout => false } allows you to change the layout of one or more of your erb files
# Remember, when fetching params you're fetching the name of the dynamic route ex 
# get(/:choices)
# params.fetch("choices")
# 
# create a method called currencies
# inside the currencires mehtod i want to 
# set the raw data variable
# parsed_data variable
# and currency_keys variable
# then return the currency_keys variable

def currencies
  puts ENV
  api_key = ENV.fetch("EXCHANGE_RATE_KEY")
  api_url = "http://api.exchangerate.host/list?access_key=#{api_key}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  currency_keys = parsed_data.fetch("currencies").keys
  return currency_keys
end


# define a route
get("/") do


  # build the API url, including the API key in the query string
  # api_key = ENV.fetch("EXCHANGE_RATE_KEY")
  
  # api_url = "http://api.exchangerate.host/list?access_key=#{api_key}"

  # use HTTP.get to retrieve the API information
  # raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  # raw_data_string = raw_data.to_s

  # convert the string to JSON
  # parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = currencies

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do

  @orignal_currency = params.fetch("from_currency")

  # api_key = ENV.fetch("EXCHANGE_RATE_KEY")
  
  # api_url = "http://api.exchangerate.host/list?access_key=#{api_key}"

  # raw_data = HTTP.get(api_url)

  # raw_data_string = raw_data.to_s

  # parsed_data = JSON.parse(raw_data_string)

  @symbols = currencies


  erb(:starting_currency)
end


get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_key = ENV.fetch("EXCHANGE_RATE_KEY")

  api_url = "http://api.exchangerate.host/convert?access_key=#{api_key}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  raw_data = HTTP.get(api_url)

  raw_data_string = raw_data.to_s

  parsed_data = JSON.parse(raw_data_string)

  @rate = parsed_data.fetch("result")
  
  erb(:destination_currency)
end






























# def currencies
#   raw_data= HTTP.get("https://api.exchangerate.host/symbols")
#   parsed_data = JSON.parse(raw_data)
#   currency_keys = parsed_data.fetch("symbols").keys

#   return currency_keys

# end

# get("/") do
#   @symbols = currencies
  
#   # erb(:home)
#   erb(:homepage)
# end

# get("/:symbol") do
#   @symbol = params.fetch("symbol") 

#   @symbols = currencies

#   erb(:second_step)
# end

# get("/:symbol/:conversion") do
#   @symbol = params.fetch("symbol")
#   @conversion = params.fetch("conversion")

#   raw_conversion = HTTP.get("https://api.exchangerate.host/convert?from=#{@symbol}&to=#{@conversion}")
#   parsed_conversion = JSON.parse(raw_conversion)
#   @rate = parsed_conversion.fetch("result")

#   erb(:third_step)
# end
