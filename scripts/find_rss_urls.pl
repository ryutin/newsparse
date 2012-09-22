#!/usr/bin/perl -w
use strict;

use Module::Extract qw(convert_url_to_text);
use LWP::UserAgent;
use HTML::LinkExtor;
use URI::URL;
use List::Uniq qw(:all);

#my $url = "http://www.perl.org/";  #
#my $url = 'http://www.baltimoresun.com/about/blogs/bal-rss,0,3462819.htmlpage';
my $url = 'http://feeds.washingtonpost.com/rss/local';

my $ua = LWP::UserAgent->new;

# Set up a callback that collect image links
my @nurls = ();

my @urls = ($url);


# Make the parser.  Unfortunately, we don't know the base yet
# (it might be different from $url)
my $p = HTML::LinkExtor->new(\&callback);
my $rss_urls = ();

foreach my $url (@urls) {

    my ($content_type) = check_for_rss($url);
    print "content-type:$content_type\n";

    my (@new_urls) = extract_urls($url);
    convert_url_to_text($new_urls[0]);
}

sub check_for_rss() {
    my ($url) = @_;
    my $res  =  $ua->request(HTTP::Request->new(HEAD => $url));
    my $content_type = $res->header('Content-type');
#    print "Content-type:$content_type\n";   
    ($content_type);
}
    
sub callback {
    my($tag, %attr) = @_;
    return if $tag ne 'a';  # we only look closer at <img ...>
    push(@nurls, values %attr);
}

#sub uniq { $a<=>$b }

sub extract_urls() {
    my ($url) = @_;

    #print "URL:$url\n";
    # Request document and parse it as it arrives
    my $p = HTML::LinkExtor->new(\&callback);
    my $res = $ua->request(HTTP::Request->new(GET => $url), sub {$p->parse($_[0])} ); 
    
    my $base = $res->base; 
    # print "URL:$url\n";
    my @new_urls = map { $_ = url($_, $base)->abs . "\n"; } grep {/rss_local$/} sort uniq @nurls;
    @nurls = ();
    
    (@new_urls);
}  
