#!/usr/bin/perl -w
use strict;

BEGIN {  push(@INC, qw{/home/emery/project}); }

use Fetch::Extract qw(fetch_text_from_url);
use Fetch::URLs qw(fetch_links_from_url);
use Meta::Distill qw(distill_meta_from_text);

use XML::Twig;

#my $url = "http://www.perl.org/";  #
#my $url = 'http://www.baltimoresun.com/about/blogs/bal-rss,0,3462819.htmlpage';
my $url = 'http://feeds.washingtonpost.com/rss/local';

my @urls = ($url);

my $match_string = 'rss_local';

foreach my $url (@urls) {

    my (@extracted_urls) = fetch_links_from_url($url,$match_string);

#    print map {"$_\n"} @extracted_urls;
#    die;

    my ($text) = fetch_text_from_url($extracted_urls[1]);
    my ($meta_xml) = distill_meta_from_text($text); 
#    $meta_xml=qq{<?xml version="1.0" encoding="UTF-8"?>$meta_xml};
    binmode STDOUT, ":encoding(UTF-8)";
    print "URL:$url\n";
    print "TEXT:$text\n";
#    print "META:$meta_xml\n";

    my $twig= XML::Twig->new();
    $twig->safe_parse($meta_xml);
    $twig->set_pretty_print('indented');
#    $twig->nparse_ppe(pretty_print=>'indented', $meta_xml);
    if ($@) {
	die "failed xml parse:$@";
    }
    my $meta_xml_print = $twig->sprint();

    print "META:$meta_xml_print\n";
}

