#!/usr/bin/perl -w

# force sync time on node master
print "Sync time on node master...\n";
`chronyc -a makestep` or die "Error: Cannot sync time on node master!\n";

# get time on node master
$time_set = `date "+%Y-%m-%d %H:%M:%S"`;
chomp $time_set;
$time_master = `date`;
chomp $time_master;
print "master: $time_master\n";

# set time on other nodes according to node master
print "Setting time on other nodes...\n";
$res = `pdsh 'date -s \"$time_set\"'` or die "Error: Cannot set time on other nodes!\n";
print $res;

# write time to hardware clock
print "Write time to hardware clocks...\n";
print "master...";
`hwclock -w`;
print "Done!\n";
print "other nodes...";
`pdsh 'hwclock -w'`;
print "Done!\n";

# Done!
$time_finish = `date`;
print "\nTime sync on all cluster nodes done at $time_finish";

