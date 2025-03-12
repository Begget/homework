class HealthRoutes < Sinatra::Base
  before do
    auth_header = request.env['HTTP_AUTHORIZATION']
    token = auth_header.split(' ').last
    decoded = Base64.decode64(token)
    username, password = decoded.split(':')
    if auth_header && username == 'applicant' && password == 'pass'
      request.env['AUTHED'] = true
    else
      request.env['AUTHED'] = false
    end
  end
  
  get('/') do
    if request.env['AUTHED'] == true
      'App working OK'
    else
      status 403
    end
  end
end
