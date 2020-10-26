### Glass fire was taken place in Napa and Sonoma from Sep 27, 2020 to Oct 20, 2020
### Lake county is included to provide a betteer view
### https://www.fire.ca.gov/incidents/2020/9/27/glass-fire/

#  set prjection
projection='EPSG:3310'

#  this is the url that links to the GeoTIFF file of Glass fire but without date
url='https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&&CRS=EPSG:4326&WRAP=DAY&LAYERS=MODIS_Aqua_CorrectedReflectance_TrueColor&FORMAT=image/tiff&HEIGHT=2276&WIDTH=2276&BBOX=37,-125,42,-120&TIME='

#  put the dates Glass fire took place in variable image_date
#  We can use image_date to extract GeoTIFF file on that day and name the file
image_date='2020-09-27 2020-09-28 2020-09-29 2020-09-30 2020-10-01 2020-10-02 2020-10-03 2020-10-04 2020-10-05 2020-10-06 2020-10-07
            2020-10-08 2020-10-09 2020-10-10 2020-10-11 2020-10-12 2020-10-13 2020-10-14 2020-10-15 2020-10-16 2020-10-17 2020-10-18
            2020-10-19 2020-10-20'

#  county outline
input_county_outline='tl_2018_us_county/tl_2018_us_county.shp'
output_county_outline='napa_sonoma_lake_county'

#  make a directory to store output shapefile of county outline
mkdir $output_county_outline

# extract the county outline of Nape and Sonoma
ogr2ogr \
    -overwrite \
    -where "(NAME='Napa' OR NAME='Sonoma' OR NAME='Lake') AND STATEFP='06'" \
    -t_srs $projection \
    $output_county_outline  \
    $input_county_outline

#  make a directory to store output images
mkdir output_image

#  download image from the URL at given date, then extract over the outline. this works because date is embedded in the original URL
for date in $image_date
do
  gdalwarp \
      -t_srs $projection \
      -cutline $output_county_outline \
      -crop_to_cutline \
      -dstalpha \
      $url$date \
      output_image/$date.tif
done
