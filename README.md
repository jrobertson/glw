# Introducing the Glw gem

    require 'glw'

    glw = Glw.new
    r3 = glw.locate 55.91918833, -3.17699833

The Glw gem uses Google's geolocation API service via the the Geocoder gem. 

Output:

<pre>
{
  :address=&gt;"16 Blackford Glen Rd, Edinburgh EH16, UK", 
  :city=&gt;"Edinburgh", :coordinates=&gt;[55.9191027, -3.1769954], 
  :country=&gt;"United Kingdom", :postal_code=&gt;"EH16", 
  :route=&gt;"Blackford Glen Road", :street_number=&gt;"16", 
  :types=&gt;["street_address"], :relative_distance=&gt;0.01, :relative_bearing=&gt;359
}
</pre>

## Resources

* glw https://rubygems.org/gems/glw

glw gem gps coordinates location
