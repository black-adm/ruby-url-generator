require 'sinatra'
require 'json'
require_relative 'generate' 

set :public_folder, 'public'

get '/' do
  erb :index
end

post '/' do
  url = params['url']
  CodeGenerator.url_code ||= {}

  if CodeGenerator.url_code.key?(url)
    code = CodeGenerator.url_code[url]
  else
    code = CodeGenerator.generate_unique_code
    CodeGenerator.url_code[url] = code
    CodeGenerator.code_url[code] = url
  end

  if request.accept?('text/html')
    erb :result, locals: { code: code, original_url: url }
  else
    content_type :json
    { code: code }.to_json
  end

  redirect "/result/#{code}"
end

get '/result/:code' do
  code = params[:code]

  if CodeGenerator.code_url.key?(code)
    original_url = CodeGenerator.code_url[code]
    erb :result, locals: { code: code, original_url: original_url }
  else
    status 404
    erb :not_found
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

