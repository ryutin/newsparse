package Module::Extract;

##!/usr/bin/perl -w
use strict;

use HTML::ExtractContent;
use HTML::FormatText::Html2text;
use LWP::UserAgent;
use FileHandle;
use Encode;

use vars qw(@ISA @EXPORT_OK);
use Exporter;

@ISA = ('Exporter');
@EXPORT_OK = qw(convert_url_to_text);

sub extract_text_content($); #{}
sub get_raw_content($$);
sub init_ua();

#my ($url) = @ARGV;


sub convert_url_to_text($) {
    my ($url) = @_;

    my ($ua) = init_ua();

    my ($raw_content) = get_raw_content($ua,$url);
    my ($text_content) = extract_text_content($raw_content);
    binmode STDOUT, ":encoding(UTF-8)";
    print "URL:$url\n";
    print "$text_content\n";
}

sub extract_text_content($) {
    my ($raw_content) = @_;
    my $extractor = HTML::ExtractContent->new;
    my $text_content =  $extractor->extract(decode_utf8($raw_content))->as_text;
    $text_content=decode_utf8($text_content);
    ($text_content);
}

sub get_raw_content($$) {
    my ($ua, $url) = @_;
    my $response = $ua->get($url);
    my $raw_content = '';

    if ($response->is_success) {
	$raw_content = $response->decoded_content;  # or whatever;
    }
    else {
	die $response->status_line;
    }
    ($raw_content);
}

sub init_ua() {
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    ($ua);
}

1;
