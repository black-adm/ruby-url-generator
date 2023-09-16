require 'sinatra'
require 'json'
require_relative 'generate' 

get '/' do
  erb :index
end

post '/' do
  url = JSON.parse(request.body.read)['url']

  if CodeGenerator.url_code.key?(url)
    code = CodeGenerator.url_code[url]
  else
    code = CodeGenerator.generate_unique_code
    CodeGenerator.url_code[url] = code
    CodeGenerator.code_url[code] = url
  end

  if request.accept? 'text/html'
    erb :result
  else
    content_type :json
    { code: code }.to_json
  end
end

get '/:code' do
  code = params[:code]

  if CodeGenerator.code_url.key?(code)
    original_url = CodeGenerator.code_url[code]
    redirect original_url, 302
  else
    status 404
    erb :not_found
  end
end
