
use strict;

use Net::Calais;


my $calais = Net::Calais->new(apikey => 'fah367gvunepumpf3ztwh47h');

print $calais->enlighten($text, contentType=>'text/txt',outputFormat=>'Text/Simple');
#print $calais->enlighten($text, contentType=>'text/txt',outputFormat=>'XML/RDF');
#print $calais->enlighten($text, contentType=>'text/txt',outputFormat=>'Text/Microformats');

1;
