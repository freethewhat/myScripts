$group = get-DistributionGroup

for($i=0;$i -le $group.length;$i++)
{
write-host $group[$i-1]
get-distributiongroupmember -identity $group[$i-1]
}
