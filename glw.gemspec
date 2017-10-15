Gem::Specification.new do |s|
  s.name = 'glw'
  s.version = '0.2.2'
  s.summary = 'A wrapper for the geocoder gem to return the place name ' + 
      'and more for a given longitude and latitude. #gps #geolocation'
  s.authors = ['James Robertson']
  s.files = Dir['lib/glw.rb']
  s.add_runtime_dependency('geocoder', '~> 1.4', '>=1.4.4')
  s.add_runtime_dependency('geodesic', '~> 1.0', '>=1.0.1')
  s.add_runtime_dependency('recordx_sqlite', '~> 0.2', '>=0.2.2')
  s.signing_key = '../privatekeys/glw.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/glw'
end
