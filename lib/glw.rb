#!/usr/bin/env ruby

# file: glw.rb


require 'geocoder'
require 'geodesic'
require 'recordx_sqlite'



class Glw

  def initialize(dbfile='glw.db', timeout: 3)
    
    Geocoder.configure(:timeout => timeout)
    
    @coordinates = RecordxSqlite.new(dbfile, 
      table: {coordinates: {coordinates: '', place_id: ''}})

    fields = %i(place_id address city coordinates country postal_code route
          street_number types)
    h = fields.inject({}) {|r, x| r.merge(x => '') }
    @places = RecordxSqlite.new(dbfile, table: {places: h})    
    
  end

  def locate(lat, lon)

    loc = search lat, lon

    p1 = Geodesic::Position.new(lat, lon)
    place = Geodesic::Position.new(*loc.coordinates)

    d = Geodesic::dist_haversine(place.lat, place.lon, p1.lat, p1.lon).round(3)
    b = Geodesic::bearing(place.lat, place.lon, p1.lat, p1.lon).round

    fields = %i(address city coordinates country postal_code route
       street_number types)

    h = fields.inject({}) {|hash, x| hash.merge(x => loc.method(x).call) }
    OpenStruct.new h.merge({relative_distance: d, relative_bearing: b}).freeze

  end
  
  private
  
  def search(lat, lon)

    # search the database using the coordinates

    lat_lon =  "%s, %s" % [lat.round(5), lon.round(5)]

    sql = "SELECT * 
FROM places INNER JOIN coordinates ON coordinates.place_id = places.place_id
WHERE coordinates.coordinates like '#{lat_lon}'"

    found = @coordinates.query sql

    if found.any? then

      r = OpenStruct.new(found.first.to_h)
      r.coordinates = r.coordinates.split(', ').map(&:to_f)
      r.types = r.types.split
      r.freeze

    else

      r = Geocoder.search "%s, %s" % [lat, lon]  

      # Add the place_id and place details in the *place* table if the 
      # place_id isn't already in the table.
      
      place = @places.find r[0].place_id            
      
      if !place then
        
        fields = %i(place_id address city country postal_code route
          street_number )

        h = fields.inject({}) {|hash, x| hash.merge(x => r[0].method(x).call) }
        h.merge!({coordinates: r[0].coordinates.join(', ')})
        h.merge!({types: r[0].types.join(' ')})

        @places.create  h
        place = OpenStruct.new(h).freeze

      end

      # If the entry isn't found, add the coordinates and the place_id
      # into the *coordinates* table. 
      
      @coordinates.create coordinates: lat_lon, place_id: place.place_id
      r[0]

    end
  end  
end


if __FILE__ == $0 then

  glw = Glw.new
  puts glw.locate(*ARGV).inspect

end