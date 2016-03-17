#!/usr/bin/perl

use Text::BibTeX;

##############################################################################
$bibname = shift || die "USAGE: $0 <bibfile.bib>\n";

##### The thematic categories: They should be stored in a "type" BibTeX tag,
##### separated by | if there are several:
#mw: changed "type" to theme in bib-file
$types{'mipv6'} = 'Mobile IPv6';
$types{'mmcast'} = 'Mobile Multicast';
$types{'nmgmt'} = 'Network Management';
$types{'vcoip'} = 'Video Conferencing over IP';
$types{'p2p'} = 'Peer-to-Peer Networking';
$types{'el'} = 'E-Learning';
$types{'hp'} = 'Hypermedia';
$types{'qp'} = 'Quantum Physics';
$types{'cw'} = 'Collaborative Environments';
$types{'nsec'} = 'Network Security';
$types{'mint'} = 'Internet Measurement and Analysis';
$types{'icn'} = 'Information-Centric Networking';
$types{'iot'} = 'Internet of Things';
$types{'rtether'} = 'Real-time Ethernet';
$types{'sg'} = 'Smart Grid';

##### start parsing the bibtex file:
$bibfile = new Text::BibTeX::File $bibname;
$bibfile->set_structure ('Bib');
#mw: enhancement to sort all entries to year, e.g. for the all.html
#
while ($entry = new Text::BibTeX::Entry $bibfile)
{
    next unless $entry->parse_ok;
    #mw: ignoriere IEEE Style Konfiguration
    next unless $entry->type ne ieeetranbstctl;
    next unless $entry->metatype eq BTE_REGULAR;
    #mw:
    push @entry, $entry;
}

@entry = reverse sort {$a->get('year') cmp $b->get('year')} @entry;
print "Type;Author;Title;Pages;Month;Year;Publisher;Keywords;Abstract;URL;ISBN\n";
foreach $entry (@entry) {
    $type = $entry->type; 
    $author = join(', ', $entry->split('author'));
    $editor = join(', ', $entry->split('editor'));
    if ($author eq '') {
        $author = $editor
    }
    $author = deluml($author);
    $title = $entry->get('title');
    $title = deluml($title);
    $title =~ s/[\{,\}]//g;
    $publisher = $entry->get('publisher');
    $publisher = deluml($publisher);
    $pp = $entry->get('pages');
    # sm: translate english and/or abbreviated month names 
    $month = de_month($entry->get('month'));
    $year = $entry->get('year');
    $url = $entry->get('url');
    $abstract = $entry->get('abstract');
    $abstract = deluml($abstract);
    $isbn = $entry->get('isbn');
    $theme = $entry->get('theme'); $ttt = "";
    $theme =~ s/\s+/ /g; $theme =~ s/\s*\|\s*/\|/g;
    @the = split(/\|/, $theme);
    foreach $themetmp (@the) {
        if (length($ttt) > 1) { $ttt .= ", "; }
        $ttt .= $types{$themetmp};
    }
    $theme = $ttt;

    if($type eq "techreport" && $entry->exists('type')) {
      $type = $entry->get('type');
    }
    elsif($type eq "inproceedings") { $type = "Konferenzbeitrag"; }
    elsif($type eq "incollection") { $type = "Buchkapitel"; }
    elsif($type eq "article") { $type = "Journalbeitrag"; }
    elsif($type eq "proceedings") { $type = "Konferenzband"; }
    elsif($type eq "misc") { $type = "Konferenzbeitrag"; }
    print "$type;$author;$title;$pp;$month;$year;$publisher;$theme;$abstract;$url;$isbn\n";
}

# translate LaTeX commands for special chars
sub deluml {
    my $txt = $_[0];
    $txt =~ s/(\{\\"a\})/ä/g;
    $txt =~ s/(\{\\"u\})/ü/g;
    $txt =~ s/(\{\\"o\})/ö/g;
    $txt =~ s/(\\"o)/ö/g;
    $txt =~ s/(\\"a)/ä/g;
    $txt =~ s/(\\"u)/ü/g;
    $txt =~ s/(\{\\"A\})/Ä/g;
    $txt =~ s/(\{\\"U\})/Ü/g;
    $txt =~ s/(\{\\"O\})/Ö/g;
    $txt =~ s/(\\"O)/Ö/g;
    $txt =~ s/(\\"A)/Ä/g;
    $txt =~ s/(\\"U)/Ü/g;
    $txt =~ s/(\\')//g;
    $txt =~ s/(\\%)/%/g;
    $txt =~ s/(\\&)/&/g;
    return $txt;
}

# function to translate month into german long names
sub de_month {
    my $m = $_[0];
    if ($m =~ /jan/i) { return "Januar"; }
    elsif ($m =~ /feb/i) {return "Februar"; }
    elsif ($m =~ /mar/i) {return "März"; }
    elsif ($m =~ /apr/i) {return "April"; }
    elsif ($m =~ /may/i) {return "Mai"; }
    elsif ($m =~ /jun/i) {return "Juni"; }
    elsif ($m =~ /jul/i) {return "Juli"; }
    elsif ($m =~ /aug/i) {return "August"; }
    elsif ($m =~ /sep/i) {return "September"; }
    elsif ($m =~ /oct/i || $m =~ /okt/i ) {return "Oktober"; }
    elsif ($m =~ /nov/i) {return "November"; }
    elsif ($m =~ /dec/i || $m =~ /dez/i) {return "Dezember"; }
    return $m;
}
