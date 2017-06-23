#!/usr/bin/env ruby

# file: geolocate.rb


require 'geocoder'
require 'geodesic'


class Geolocate

  def initialize()
    Geocoder.configure(:timeout => 3)
  end

  def locate(lat, lon)

    s = "%s, %s" % [lat, lon]
    r = Geocoder.search s

    p1 = Geodesic::Position.new(lat, lon)
    place = Geodesic::Position.new(*r[0].coordinates)

    d = Geodesic::dist_haversine(place.lat, place.lon, p1.lat, p1.lon).round(3)
    b = Geodesic::bearing(place.lat, place.lon, p1.lat, p1.lon).round

    fields = %i(address city coordinates country postal_code route
       street_number types)

    h = fields.inject({}) do |hash, x|
      hash.merge(x => r[0].method(x).call)
    end

    h.merge({relative_distance: d, relative_bearing: b})
  end
end


if __FILE__ == $0 then

  gl = Geolocate.new
  puts gl.locate(*ARGV).inspect

end
