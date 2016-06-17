#!/usr/bin/perl

use Text::BibTeX;

##############################################################################
$bibname = shift || die "USAGE: $0 <bibfile.bib>\n";

## Thematic categories: They should be stored in a "theme" BibTeX tag,
## separated by | if there are several:
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
while ($entry = new Text::BibTeX::Entry $bibfile)
{
    next unless $entry->parse_ok;
    # ignoriere IEEE Style Konfiguration
    next unless $entry->type ne ieeetranbstctl;
    next unless $entry->metatype eq BTE_REGULAR;
    push @entry, $entry;
}

# sort entries with decending years
@entry = reverse sort {$a->get('year') cmp $b->get('year')} @entry;
print "Type;;Author;;Title;;Pages;;Month;;Year;;Publisher;;PubAt;;Location;;Keywords;;Abstract;;URL;;ISBN\n";
foreach $entry (@entry) {
    $type = $entry->type;
    # convert to lowercase
    $type = lc($type);
    $author = join(', ', $entry->split('author'));
    $editor = join(', ', $entry->split('editor'));
    if ($author eq '') {
        $author = $editor
    }
    $title = $entry->get('title');
    $title =~ s/[\{,\}]//g;
    $publisher = $entry->get('publisher');
    $pages = $entry->get('pages');
    chomp($pages);
    if (length($pages) > 0) {
        @pp = split(/-/, $pages);
        $pages = $pp[-1]-$pp[0]+1;
    }
    $numpages = $entry->get('numpages');
    if (length($numpages) > 0) {
        $pages = $numpages;
    }
    $month = month_long_de($entry->get('month'));
    $year = $entry->get('year');
    $urltmp = $entry->get('url');
    chomp($urltmp);
    $url = "";
    if (length($urltmp) > 0) {
        $url = "\\url{$urltmp}";
    }
    $abstract = $entry->get('abstract');
    $isbn = $entry->get('isbn');
    $theme = $entry->get('theme');
    $ttt = "";
    $theme =~ s/\s+/ /g; $theme =~ s/\s*\|\s*/\|/g;
    @the = split(/\|/, $theme);
    foreach $themetmp (@the) {
        if (length($ttt) > 1) { $ttt .= ", "; }
        $ttt .= $types{$themetmp};
    }
    $theme = $ttt;
    $location = $entry->get('location');
    if (length($location) > 0) { $location .= ", "; } else { $location = ""; }
    $pubat = "";
    if($type eq "techreport" && $entry->exists('type')) {
      $type = $entry->get('type');
      $pubat = $entry->get('institution');
    }
    elsif($type eq "inproceedings") {
        $type = "Konferenzbeitrag";
        $pubat = $entry->get('booktitle');
    }
    elsif($type eq "incollection") {
        $type = "Buchkapitel";
        $pubat = $entry->get('booktitle');
    }
    elsif($type eq "article") {
        $type = "Journalbeitrag";
        $pubat = $entry->get('journal');
    }
    elsif($type eq "proceedings") {
        $type = "Konferenzband";
        $pubat = $entry->get('booktitle');
        if (length($pubat) < 1) { $pubat = $entry->get('institution'); }
    }
    elsif($type eq "misc") { $type = "Konferenzbeitrag"; }
    elsif($type eq "phdthesis") { $type = "Doktorarbeit"; }
    print "$type;;$author;;$title;;$pages;;$month;;$year;;$publisher;;$pubat;;$location;;$theme;;$abstract;;$url;;$isbn\n";
}

# function to translate month into german long names
sub month_long_de {
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

# function to translate month into english long names
sub month_long_en {
    my $m = $_[0];
    if ($m =~ /jan/i) { return "January"; }
    elsif ($m =~ /feb/i) {return "February"; }
    elsif ($m =~ /mar/i) {return "March"; }
    elsif ($m =~ /apr/i) {return "April"; }
    elsif ($m =~ /may/i) {return "May"; }
    elsif ($m =~ /jun/i) {return "June"; }
    elsif ($m =~ /jul/i) {return "Juli"; }
    elsif ($m =~ /aug/i) {return "August"; }
    elsif ($m =~ /sep/i) {return "September"; }
    elsif ($m =~ /oct/i || $m =~ /okt/i ) {return "October"; }
    elsif ($m =~ /nov/i) {return "November"; }
    elsif ($m =~ /dec/i || $m =~ /dez/i) {return "December"; }
    return $m;
}
